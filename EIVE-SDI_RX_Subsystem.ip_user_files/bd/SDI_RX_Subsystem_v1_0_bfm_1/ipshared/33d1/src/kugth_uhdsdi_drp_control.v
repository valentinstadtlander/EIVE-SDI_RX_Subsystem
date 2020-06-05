// (c) Copyright 2006 - 2013 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
//------------------------------------------------------------------------------
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     
//  \   \         
//  /   /         
// /___/   /\     
// \   \  /  \
//  \___\/\___\
//
// Description:
//  This module reads and modifies GTH DRP register values according to the 
//  arguments provided to it. It also arbitrates DRP accesses between TX and RX 
//  GTH controller modules with TX having the higher priority.
//------------------------------------------------------------------------------
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.

`timescale 1 ns / 1 ns

module kugth_uhdsdi_drp_control 
#(
    parameter DRP_WR_VERIFY_BYPASS = 1,                                // Bypass DRP write data verificaftion
    parameter DRP_TIMEOUT_MSB      = 10,                               // MSB of DRP timeout counter
    parameter DRP_RETRY_CNTR_MAX   = 8)                                // If serial clock is from QPLL, set this parameter to 1, from CPLL, set to 0
(
    input  wire         rst,                       // Module Reset
    
    //DRP Interface
    input  wire         drpclk_in,                 // DRP DCLK
    output wire  [8:0]  drpaddr_out,               // GT DRPADDR
    output wire [15:0]  drpadi_out,                // GT DRPDI
    output wire         drpen_out,                 // GT DRPEN
    output wire         drpwe_out,                 // GT DRPWE
    input  wire [15:0]  drpado_in,                 // GT DRPDO
    input  wire         drprdy_in,                 // GT DRPRDY
                                                   
    //CMN DRP CTRL Interface                       
    output wire [15:0]  drp_rd_data_out,           // Data read from DRP address
    output wire         drp_done_out,              // DRP access done
    output wire         drp_wr_fail_out,           // DRP wr access fail
    output wire  [7:0]  drp_wr_fail_cnt_out,       // DRP access fail count
	                                               
	//TX DRP CTRL Interface                        
    input  wire  [8:0]  drp_tx_addr_in,            // DRP address to access
    input  wire [15:0]  drp_tx_wr_data_in,         // Write data
    input  wire [15:0]  drp_tx_wr_data_mask_in,    // Mask to indicate bits to be written; 0->no change; 1->write
    input  wire         drp_tx_change_req_in,      // TX DRP control change request
    input  wire         drp_tx_change_req_done_in, // TX DRP control change done
    output reg          drp_tx_change_grant_out,   // TX DRP control change grant
	
	//RX DRP CTRL Interface
    input  wire  [8:0]  drp_rx_addr_in,            // DRP address to access
    input  wire [15:0]  drp_rx_wr_data_in,         // Write data
    input  wire [15:0]  drp_rx_wr_data_mask_in,    // Mask to indicate bits to be written; 0->no change; 1->write
    input  wire         drp_rx_change_req_in,      // RX DRP control change request
    input  wire         drp_rx_change_req_done_in, // RX DRP control change done
    output reg          drp_rx_change_grant_out    // RX DRP control change grant
	
);

localparam MSTR_STATE_WIDTH = 5;
localparam MSTR_STATE_MSB   = MSTR_STATE_WIDTH - 1;

localparam [MSTR_STATE_MSB:0]
    MSTR_IDLE                  = 5'h00,
    MSTR_TX_REQUEST            = 5'h01,
    MSTR_TX_NEXT_REQUEST_WAIT  = 5'h02,
    MSTR_RX_REQUEST            = 5'h03,
    MSTR_RX_NEXT_REQUEST_WAIT  = 5'h04,
    MSTR_FAIL                  = 5'h05;

 reg  [MSTR_STATE_MSB:0] mstr_current_state = MSTR_IDLE;     // master FSM current state
 reg  [MSTR_STATE_MSB:0] mstr_next_state;                    // master FSM next state

 reg          tx_cycle  = 1'b0;  
 reg          rx_cycle  = 1'b0;  
 reg          tx_grant  = 1'b0;  
 reg          rx_grant  = 1'b0;  
 reg          drp_rst   = 1'b0;  
 reg          drp_wr_en = 1'b0;  
 wire  [8:0]  drp_addr_in;
 wire [15:0]  drp_wr_data_in;  
 wire [15:0]  drp_wr_data_mask_in;  

reg [1:0] last_serve = 2'b00; //simple arbitration: 00-no body; 01-served TX; 10-served RX;
reg set_serve_tx;
reg set_serve_rx;

//------------------------------------------------------------------------------        
// Master state machine
//
// The master FSM examines the rx_change_req register and then initiates 
// DRP write cycles to modify the target GT attribute 
//
// The actual DRP write cycles are handled by a separate module, the gt_drp_ctlr_fsm. 
// The master FSM provides a DRP address and new data word to the DRP FSM and 
// asserts a drp_go signal. The DRP FSM does the actual write cycle and responds
// with a drp_done signal when the cycle is complete.
//

//
// Current state register
// 
always @ (posedge drpclk_in or posedge rst)
    if (rst)
        mstr_current_state <= MSTR_IDLE;
    else
        mstr_current_state <= mstr_next_state;

always @ (posedge drpclk_in or posedge rst)
    if (rst)
       last_serve <= 2'b00;
    else if (set_serve_tx) 
       last_serve <= 2'b01;
    else if (set_serve_rx) 
       last_serve <= 2'b10;
    else
       last_serve <= last_serve;
//
// Next state logic
//
always @ (*)
begin
    case(mstr_current_state)
        MSTR_IDLE:       
            //if tx/rx come at same time, depends on who get served last time
            if(drp_tx_change_req_in == 1'b1 && drp_rx_change_req_in == 1'b1) begin
                //if no body or rx get served last time, let's serve tx now
                if(last_serve == 2'b00 || last_serve == 2'b10) begin
		           mstr_next_state = MSTR_TX_REQUEST;
                //othewise, it means tx get served last time, let's serve rx this time
                end else begin 
		           mstr_next_state = MSTR_RX_REQUEST;
                end
            end else if(drp_tx_change_req_in)
		        mstr_next_state = MSTR_TX_REQUEST;
		    else if (drp_rx_change_req_in)
		        mstr_next_state = MSTR_RX_REQUEST;
		    else
		        mstr_next_state = MSTR_IDLE;
				
        MSTR_TX_REQUEST:
		    if(drp_done_out)
		        mstr_next_state = MSTR_TX_NEXT_REQUEST_WAIT;
		    else
		        mstr_next_state = MSTR_TX_REQUEST;
			
		MSTR_TX_NEXT_REQUEST_WAIT:
            if(drp_tx_change_req_in)
		        mstr_next_state = MSTR_TX_REQUEST;
		    else if (drp_tx_change_req_done_in)
		        mstr_next_state = MSTR_IDLE;
		    else
		        mstr_next_state = MSTR_TX_NEXT_REQUEST_WAIT;

        MSTR_RX_REQUEST:
		    if(drp_done_out)
		        mstr_next_state = MSTR_RX_NEXT_REQUEST_WAIT;
		    else
		        mstr_next_state = MSTR_RX_REQUEST;
			
		MSTR_RX_NEXT_REQUEST_WAIT:
            if(drp_rx_change_req_in)
		        mstr_next_state = MSTR_RX_REQUEST;
		    else if (drp_rx_change_req_done_in)
		        mstr_next_state = MSTR_IDLE;
		    else
		        mstr_next_state = MSTR_RX_NEXT_REQUEST_WAIT;
        MSTR_FAIL:
            mstr_next_state = MSTR_IDLE;
        default:
            mstr_next_state = MSTR_FAIL;
    endcase				
end

//
// Output logic
//
always @ (*)
begin
    tx_cycle            = 1'b0;
	rx_cycle            = 1'b0;
    tx_grant            = 1'b0;
	rx_grant            = 1'b0;
	drp_rst             = 1'b0;
	drp_wr_en           = 1'b0;
    set_serve_tx        = 1'b0;
    set_serve_rx        = 1'b0;
	
    case(mstr_current_state)
        MSTR_IDLE:
		begin
            drp_rst = 1'b0;
		end

        MSTR_TX_REQUEST:
		begin
            tx_cycle  = 1'b1;
			tx_grant  = 1'b1;
			drp_wr_en = 1'b1;
            set_serve_tx = 1'b1;
		end

		MSTR_TX_NEXT_REQUEST_WAIT:
            tx_cycle = 1'b1;
 
        MSTR_RX_REQUEST:
		begin
            rx_cycle  = 1'b1;
			rx_grant  = 1'b1;
			drp_wr_en = 1'b1;
            set_serve_rx = 1'b1;
		end

		MSTR_RX_NEXT_REQUEST_WAIT:
            rx_cycle = 1'b1;
 
        MSTR_FAIL:
		begin
            drp_rst = 1'b1;
        end

        default:;
    endcase
end

//Assign output grant values
always @ (posedge drpclk_in)
begin
    drp_tx_change_grant_out <= tx_grant;
    drp_rx_change_grant_out <= rx_grant;
end
  
//Assign address, data & mask according to granted cycle
assign drp_addr_in         = (tx_cycle == 1'b1) ? drp_tx_addr_in         : drp_rx_addr_in;
assign drp_wr_data_in      = (tx_cycle == 1'b1) ? drp_tx_wr_data_in      : drp_rx_wr_data_in;
assign drp_wr_data_mask_in = (tx_cycle == 1'b1) ? drp_tx_wr_data_mask_in : drp_rx_wr_data_mask_in;


kugth_uhdsdi_drp_control_fsm #(
    .WR_VERIFY_BYPASS        (DRP_WR_VERIFY_BYPASS),
	.RETRY_CNTR_MAX          (DRP_RETRY_CNTR_MAX)
)
DRP_CTRL (
    .rst_in                 (drp_rst),
    .wr_in                  (drp_wr_en),
    .rd_in                  (1'b0),
    .drp_addr_in            (drp_addr_in),
    .drp_wr_data_in         (drp_wr_data_in),
    .drp_wr_data_mask_in    (drp_wr_data_mask_in),
    .drp_rd_data_out        (drp_rd_data_out),
    .drp_done_out           (drp_done_out),
    .drp_wr_fail_out        (drp_wr_fail_out),
    .drp_wr_fail_cnt_out    (drp_wr_fail_cnt_out),
                            
    .drpclk_in              (drpclk_in),
    .drpaddr_out            (drpaddr_out),
    .drpadi_out             (drpadi_out),
    .drpen_out              (drpen_out),
    .drpwe_out              (drpwe_out),
    .drpado_in              (drpado_in),
    .drprdy_in              (drprdy_in)
);	 


endmodule
