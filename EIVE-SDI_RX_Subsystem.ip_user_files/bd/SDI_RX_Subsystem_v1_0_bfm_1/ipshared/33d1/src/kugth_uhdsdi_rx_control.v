// (c) Copyright 2006 - 2015 Xilinx, Inc. All rights reserved.
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
//  This module modifies attributes in the GTH transceiver in response to 
//  changes in the RX SDI mode and bit rate. This module is specifically designed 
//  to support SDI interfaces implemented in the GTH. It changes the RXPLLCLKSEL, 
//  RXCDR_CFG, RXOUT_DIV, RX_DATA_WIDTH, RX_INT_DATA_WIDTH attributes when the 
//  rx_mode and rx_m input changes.
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

module kugth_uhdsdi_rx_control 
#(
    parameter RX_INPUT_SETTLE_BITWIDTH  = 5,           // RX Settle Time MSB
    parameter RX_GT_RESET_TIMEOUT_MSB   = 10,          // MSB of GT RX DRP timeout counter
    parameter RX_RETRY_CNTR_MSB         = 8,           // MSB of RX retry counter
    parameter RXPLLCLKSEL_RX_M_0        = 2'b11,       // Value to output on RXPLLCLKSEL when rx_m is 0
    parameter RXPLLCLKSEL_RX_M_1        = 2'b10,       // Value to output on RXPLLCLKSEL when rx_m is 1
    parameter RX_M_0_QPLL               = 1'b1,        // PLL clock source for rx_m=0 QPLL (1) or CPLL (0) -- Default to QPLL
    parameter RX_M_1_QPLL               = 1'b1,        // PLL clock source for rx_m=1 QPLL (1) or CPLL (0) -- Default to QPLL
    parameter EN_HOT_PLUG_LOGIC         = 0            // Enable hot-plug logic
)                                
(
  input wire qpll0reset_in, 
  input wire qpll0lock_in, 
  input wire qpll1reset_in, 
  input wire qpll1lock_in, 
  input wire cpllreset_in, 
  input wire cplllock_in, 

    input   wire        rst_in,                        // Connect to same reset that drives RST_IN of inner GTH wrapper_gt (usually RX PLLRESET)
    input   wire        drpclk_in,                     // DRP DCLK
                                                       
    //SDI Interface
    input   wire        rxusrclk_in,                   // RXUSRCLK used for generation of rst output only
    input   wire        rx_mode_locked_in,             // rx_mode locked indication (rxusrclk)
    input   wire        rx_trs_in,                     // RX TRS (rxusrclk)
    input    wire [2:0]  rx_mode_in,                    // RX mode select                                           
    input    wire        rx_m_in,                       // RX_M select                                              
    output     wire        rx_fabric_rst_out,             // SDI RX fabric reset

    //GT DRP Control Interface
 	input    wire        drp_done_in,                   // DRP CTRL done                                            
    output   reg   [8:0] drp_addr_out,                  // DRP address to access                                    
    output  reg  [15:0] drp_wr_data_out,               // Write data                                               
    output  reg  [15:0] drp_wr_data_mask_out,          // Mask to indicate bits to be written                      
    input   wire        drp_wr_fail_in,                // DRP write fail                                           
    output  reg         drp_change_req_out,            // DRP change request                                       
    input    wire        drp_change_grant_in,           // DRP change grant                                         
    output   reg         drp_change_req_done_out,       // DRP change done                                          

	//GT Interface
 	output   reg  [1:0]	gt_rx_pllclksel_out,           // RXPLLCLKSEL output
    output  reg         gt_rx_cdrhold_out,             // GTH RXCDRHOLD                                            
    output    reg         gt_rx_datapath_reset_out,      // GT RX datapath reset output                              
    input    wire        gt_rx_reset_done_in,           // GT RX reset done input                                   
	
    output   wire         done_out,              		   // Sequence done output 
    output   reg         fail_out,                      // 1 = sequence failure
    output   reg [4:0]  rx_state,
    output  reg  [2:0]  fail_code_out                  // sequence failure code
);

//UHD-SDI MODES 
localparam MODE_SD		  = 3'b001;
localparam MODE_HD		  = 3'b000;
localparam MODE_3G		  = 3'b010;
localparam MODE_6G		  = 3'b100;
localparam MODE_12G_0	  = 3'b101;
localparam MODE_12G_1	  = 3'b110;  

//GT DRP Settings Params             
localparam RXCDR_CFG2_DRP_ADDR           =  9'h010;     // GT RXCDR_CFG2 DRP Address
localparam RXCDR_CFG2_DRP_WR_MASK        = 16'hFFFF;    // GT RXCDR_CFG2 write mask --> 1:write bit 0:no change
localparam RXCDR_CFG2_DIV1               = 16'h07E6;    // GT RXCDR_CFG2 DRP register value for divide by 1
localparam RXCDR_CFG2_DIV2               = 16'h07D4;    // GT RXCDR_CFG2 DRP register value for divide by 2
localparam RXCDR_CFG2_DIV4               = 16'h07C4;    // GT RXCDR_CFG2 DRP register value for divide by 4
localparam RXCDR_CFG2_DIV8               = 16'h07B4;    // GT RXCDR_CFG2 DRP register value for divide by 8
                                         
localparam RXOUT_DIV_DRP_ADDR            =  9'h063;     // GT RXOUT_DIV DRP Address
localparam RXOUT_DIV_DRP_WR_MASK         = 16'h0007;    // GT RXOUT_DIV write mask --> 1:write bit 0:no change
localparam RXOUT_DIV1                    = 16'h0000;    // GT RXOUT_DIV DRP register value for divide by 1
localparam RXOUT_DIV2                    = 16'h0001;    // GT RXOUT_DIV DRP register value for divide by 2
localparam RXOUT_DIV4                    = 16'h0002;    // GT RXOUT_DIV DRP register value for divide by 4
localparam RXOUT_DIV8                    = 16'h0003;    // GT RXOUT_DIV DRP register value for divide by 8
                                         
localparam RXDATA_WIDTH_DRP_ADDR         =  9'h003;     // GT RX_DATA_WIDTH DRP Address
localparam RXDATA_WIDTH_DRP_WR_MASK      = 16'h01E0;    // GT RX_DATA_WIDTH write mask --> 1:write bit 0:no change
localparam RXDATA_WIDTH20                = 16'h0060;    // GT RX_DATA_WIDTH DRP register value for 20 bits
localparam RXDATA_WIDTH40                = 16'h00A0;    // GT RX_DATA_WIDTH DRP register value for 40 bits
localparam RXDATA_WIDTH80                = 16'h00E0;    // GT RX_DATA_WIDTH DRP register value for 80 bits

localparam RXINT_DATAWIDTH_DRP_ADDR      =  9'h066;     // GT RX_INT_DATA_WIDTH DRP Address
localparam RXINT_DATAWIDTH_DRP_WR_MASK   = 16'h0003;    // GT RX_INT_DATA_WIDTH write mask --> 1:write bit 0:no change
localparam RXINT_DATAWIDTH_2_BYTES       = 16'h0000;    // GT RX_INT_DATA_WIDTH DRP register value for 2 bytes
localparam RXINT_DATAWIDTH_4_BYTES       = 16'h0001;    // GT RX_INT_DATA_WIDTH DRP register value for 4 bytes

//
// This group of constants defines the states of the master state machine.
// 
localparam MSTR_STATE_WIDTH   = 5;
localparam MSTR_STATE_MSB     = MSTR_STATE_WIDTH - 1;

localparam [MSTR_STATE_MSB:0]
    READY_STATE                  = 5'h00,
    SETTLE_STATE                 = 5'h01,
    FREEZE_STATE                 = 5'h02,
    RXDATA_WIDTH_WRITE_STATE     = 5'h03,
    RXDATA_WIDTH_WAIT_STATE      = 5'h04,
    RXDATA_WIDTH_ERR_STATE       = 5'h05,
    RXINT_DATAWIDTH_WRITE_STATE  = 5'h06,
    RXINT_DATAWIDTH_WAIT_STATE   = 5'h07,
    RXINT_DATAWIDTH_ERR_STATE    = 5'h08,
    RXMODE_CHECK_STATE           = 5'h09,
    CDRCFG_WRITE_STATE           = 5'h0A,
    CDRCFG_WAIT_STATE            = 5'h0B,
    CDRCFG_ERR_STATE             = 5'h0C,
    RXMODE_SD_STATE		         = 5'h0D,
    RXDIV_WRITE_STATE	         = 5'h0E,
    RXDIV_WAIT_STATE	         = 5'h0F,
    RXDIV_ERR_STATE		         = 5'h10,
    RXPLLCLKSEL1_STATE	         = 5'h11,
    RXPLLCLKSEL2_STATE		     = 5'h12,
    GT_RESET_STATE		         = 5'h13,
    GT_RESET_WAIT_STATE	         = 5'h14,
    GT_RESET_DONE_STATE          = 5'h15,
    GT_RESET_TO_STATE	         = 5'h16,
    PLL_WAIT_LOCK1_STATE          = 5'h17,
    PLL_WAIT_LOCK2_STATE          = 5'h18,
    FAIL_STATE			         = 5'h19;

reg  [MSTR_STATE_MSB:0] current_state = READY_STATE;   // master FSM current state
reg  [MSTR_STATE_MSB:0] next_state;                    // master FSM next state
reg  [RX_INPUT_SETTLE_BITWIDTH-1:0]	settle_cntr = 0;
reg                         		clr_settle_cntr;
reg									freeze_inputs = 1'b0;	
wire								freeze_inputs_ds;	
reg									set_freeze;
reg									clr_freeze;	
wire								settle_tc;

reg  [15:0]	pllcnt;
reg clr_pllcnt;
wire pllcnt_tc;

//
// Local signal declarations
//
reg  [23:0]                  hot_plug_cnt                = 24'd0;
reg                          hot_plug_rst_r              = 1'b0;
reg  [15:0]                  rx_trs_capture              = 16'd0;
reg                          rx_trs_extn                 = 1'b0;
reg                          rx_trs_extn_reg             = 1'b0;
(* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg  rx_trs_extn_sync1_cdc_to = 1'b0;
(* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg  rx_trs_extn_sync2_reg = 1'b0;
(* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg  rx_trs_extn_last_reg = 1'b0;
reg  [2:0]                   rx_mode_in_reg              = 3'b000;
(* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg [2:0] rx_mode_sync1_cdc_to = 3'b000;
(* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg [2:0] rx_mode_sync2_reg = 3'b000;
(* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg [2:0] rx_mode_last_reg = 3'b000;
reg                          rx_m_in_reg                 = 1'b0;
(* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg rx_m_sync1_cdc_to = 1'b0;
(* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg rx_m_sync2_reg = 1'b0;
(* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg rx_m_last_reg = 1'b0;
reg                          rx_change_req               = 1'b1;
reg                          clr_rx_change_req;
                             
reg						     rxout_div_cycle;
reg  [15:0]				     rxout_div_reg;

reg						     rxdata_width_cycle;
reg  [15:0]				     rxdata_width_reg;

reg						     rxint_datawidth_cycle;
reg  [15:0]				     rxint_datawidth_reg;

(* dont_touch = "true" *) reg						     rxpllclksel_cycle;
(* dont_touch = "true" *) reg  [1:0]				     rxpllclksel_reg = RXPLLCLKSEL_RX_M_1;

reg 				         gt_rx_datapath_reset_reg;
reg 				         gt_rx_cdrhold_reg;
reg 				         drp_change_req_reg;
reg 				         drp_change_req_done_reg;
reg   [8:0]                  drp_addr_reg;
reg  [15:0]                  drp_wr_data_reg;
reg  [15:0]                  drp_wr_data_mask_reg;
reg  [15:0]                  rxcdr_cfg2_reg = RX_M_0_QPLL ? RXCDR_CFG2_DIV4 : RXCDR_CFG2_DIV2;
reg 				         done_reg;
reg 				         fail_reg;
reg  [2:0]  		         fail_code_reg;
   
reg                          clr_fail;
reg                          assert_fail;
reg [RX_GT_RESET_TIMEOUT_MSB:0] to_counter = 0;
reg                          m_clr_to;
wire                         timeout;
reg                          clr_retries;
reg                          inc_retries;
reg  [RX_RETRY_CNTR_MSB:0]   retry_counter;

wire                         max_retries;
wire                         start_retries;
reg						     clr_fabric_reset;
reg						     assert_fabric_reset;
reg                          rx_fabric_rst_int = 1'b1;
reg                          set_fail_code_1;
reg                          set_fail_code_2;
reg                          set_fail_code_3;
reg                          set_fail_code_4;
reg                          set_fail_code_5;
reg						     set_rxcdrhold;
reg						     clr_rxcdrhold;
reg						     set_sd_mode;
reg						     clr_sd_mode;
reg						     sd_mode_reg;
reg                          rx_ctrl_reset = 1'b1;

reg                          assert_fabric_reset_ff;
reg                          clr_fabric_reset_ff;
reg                          done_out_int;

    (* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg rx_fabric_rst_out_d1_cdc_to = 1'b1;
    (* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg rx_fabric_rst_out_d2 = 1'b1;
    (* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg rx_fabric_rst_out_d3 = 1'b1;

wire pllreset_m0;
wire plllock_m0;
wire pllreset_m1;
wire plllock_m1;
reg pll_change;
reg pll_change_done;
assign pllreset_m0 = (RXPLLCLKSEL_RX_M_0 == 2'b00) ? cpllreset_in : ((RXPLLCLKSEL_RX_M_0 == 2'b11) ? qpll0reset_in : qpll1reset_in);
assign plllock_m0 = (RXPLLCLKSEL_RX_M_0 == 2'b00) ? cplllock_in : ((RXPLLCLKSEL_RX_M_0 == 2'b11) ? qpll0lock_in : qpll1lock_in);
assign pllreset_m1 = (RXPLLCLKSEL_RX_M_1 == 2'b00) ? cpllreset_in : ((RXPLLCLKSEL_RX_M_1 == 2'b11) ? qpll0reset_in : qpll1reset_in);
assign plllock_m1 = (RXPLLCLKSEL_RX_M_1 == 2'b00) ? cplllock_in : ((RXPLLCLKSEL_RX_M_1 == 2'b11) ? qpll0lock_in : qpll1lock_in);
//qpll reset high trigger FSM to wait for pll lock then issue GT reset 
always @ (posedge drpclk_in) begin
   if(pllreset_m0 | pllreset_m1) begin
      pll_change <= 1'b1;
   end
   if(pll_change_done) begin
      pll_change <= 1'b0;
   end
end
//------------------------------------------------------------------------------
// RX Control Module Reset
//
//
always @ (posedge drpclk_in)
    if (rst_in)
	    rx_ctrl_reset = 1'b1;
	else
	    rx_ctrl_reset = 1'b0;
//
//  Extend rx_trs_in to 16 clock cycles
//
always @ (posedge rxusrclk_in) 
begin
  if(rx_mode_locked_in) begin   
    rx_trs_capture    <= {rx_trs_capture[14:0], rx_trs_in};  
    rx_trs_extn       <= (|rx_trs_capture); 
  end else begin
    rx_trs_capture    <= 0;  
    rx_trs_extn       <= 1'b0; 
  end
end

//
// Input register & unary bit encoding for rxmode
//
always @ (posedge rxusrclk_in) 
	if (~freeze_inputs_ds) begin
	  rx_trs_extn_reg          <= rx_trs_extn;
	  rx_mode_in_reg           <= rx_mode_in;
	  rx_m_in_reg              <= rx_m_in;
	end

//
//  Hot-Plug Logic
//
// Synchronize the rx_trs_extn_reg signal to the DRP clock
always @ (posedge drpclk_in)
begin
    rx_trs_extn_sync1_cdc_to <= rx_trs_extn_reg;
    rx_trs_extn_sync2_reg    <= rx_trs_extn_sync1_cdc_to;
    rx_trs_extn_last_reg     <= rx_trs_extn_sync2_reg;
end

generate if(EN_HOT_PLUG_LOGIC) begin: gen_hot_plug_rst

always @ (posedge drpclk_in)
begin   
  if (rx_ctrl_reset || rx_trs_extn_last_reg) begin
    hot_plug_cnt    <=  0;
    hot_plug_rst_r  <=  0;
  end else begin
     if(&hot_plug_cnt) begin
       hot_plug_cnt    <=  0;
       hot_plug_rst_r  <=  1'b1;
     end else begin
       hot_plug_cnt    <=  hot_plug_cnt + 1'b1;
       hot_plug_rst_r  <=  1'b0;
     end
  end
end 

  end else begin

    always @ (*)
    begin
      hot_plug_cnt    <=  0;
      hot_plug_rst_r  <=  0;
    end

end
endgenerate

//
// Sync signals to the rxusrclk domain
//
sync_block SYNC_FRZ_INPUT (
	.clk	(rxusrclk_in),
	.din	(freeze_inputs),
	.dout	(freeze_inputs_ds));

sync_block SYNC_DONE_OUT (
	.clk	(rxusrclk_in),
	.din	(done_out_int),
	.dout	(done_out));

//------------------------------------------------------------------------------
//  change detectors
//

//------------------------------------------------------------------------------
// rx_mode change detectors
//
// Synchronize the rx_mode signal to the clock
always @ (posedge drpclk_in)
begin
    rx_mode_sync1_cdc_to <= rx_mode_in_reg;
    rx_mode_sync2_reg    <= rx_mode_sync1_cdc_to;
    rx_mode_last_reg     <= rx_mode_sync2_reg;
end

//------------------------------------------------------------------------------
// rx_m change detectors
//
// Synchronize the rx_mode signal to the clock
always @ (posedge drpclk_in)
begin
    rx_m_sync1_cdc_to <= rx_m_in_reg;
    rx_m_sync2_reg <= rx_m_sync1_cdc_to;
    rx_m_last_reg  <= rx_m_sync2_reg;
end

always @ (posedge drpclk_in)
    if (rx_ctrl_reset | clr_rx_change_req)
        rx_change_req <= 1'b0;
    else if ((rx_mode_sync2_reg != rx_mode_last_reg) || (rx_m_sync2_reg != rx_m_last_reg) ||
              hot_plug_rst_r)
        rx_change_req <= 1'b1;

//
// Assert rxcdrhold if mode changes to SD-SDI mode
//
always @ (posedge drpclk_in)
    if (set_sd_mode)
        sd_mode_reg <= 1'b1;
	else if (clr_sd_mode)
		sd_mode_reg <= 1'b0;
		
always @ (posedge drpclk_in)
    if (set_rxcdrhold & sd_mode_reg)
        gt_rx_cdrhold_reg <= 1'b1;
	else if (clr_rxcdrhold)
		gt_rx_cdrhold_reg <= 1'b0;
        
//
// Determine the RXPLLCLKSEL Value
//
always @ (posedge drpclk_in)
    if (rxpllclksel_cycle)
	begin
        if (rx_mode_last_reg == MODE_12G_1) 
		    rxpllclksel_reg <= RXPLLCLKSEL_RX_M_1;
		else
		    rxpllclksel_reg <= RXPLLCLKSEL_RX_M_0;
	end

//
// Determine the correct RXCDR_CFG attribute to write through the DRP
//
always @ *
	// QPLL selected	
	if (((rx_m_last_reg == 1'b0) && (RX_M_0_QPLL == 1'b1)) || ((rx_m_last_reg == 1'b1) && (RX_M_1_QPLL == 1'b1)))
    	case(rx_mode_last_reg)
        	MODE_3G:      rxcdr_cfg2_reg = RXCDR_CFG2_DIV4;	// 3G-SDI
        	MODE_6G:      rxcdr_cfg2_reg = RXCDR_CFG2_DIV2;	// 6G-SDI
        	MODE_12G_0:   rxcdr_cfg2_reg = RXCDR_CFG2_DIV1;	// 12G-SDI 0PPM    
        	MODE_12G_1:   rxcdr_cfg2_reg = RXCDR_CFG2_DIV1;	// 12G-SDI 1000PPM 
        	default:      rxcdr_cfg2_reg = RXCDR_CFG2_DIV8;	// HD-SDI
    	endcase
	else // CPLL selected
    	case(rx_mode_last_reg)
        	MODE_3G:      rxcdr_cfg2_reg = RXCDR_CFG2_DIV2;	// 3G-SDI
        	MODE_6G:      rxcdr_cfg2_reg = RXCDR_CFG2_DIV1;	// 6G-SDI
       		//NOTE: GTH CPLL can't be used for 12G line rate
        	//MODE_12G_0: rxcdr_cfg2_reg = RXCDR_CFG2_DIV1;	// 12G-SDI 0PPM    
        	//MODE_12G_1: rxcdr_cfg2_reg = RXCDR_CFG2_DIV1;	// 12G-SDI 1000PPM 
        	default:      rxcdr_cfg2_reg = RXCDR_CFG2_DIV4;	// HD-SDI
    	endcase

//
// Calculate rxout_div_reg
//
always @ (*)
	// QPLL selected	
	if (((rx_m_last_reg == 1'b0) && (RX_M_0_QPLL == 1'b1)) || ((rx_m_last_reg == 1'b1) && (RX_M_1_QPLL == 1'b1)))
        case(rx_mode_last_reg)     // When using QPLL as RX serial clock source
            MODE_SD:      rxout_div_reg = RXOUT_DIV4;   // SD-SDI RXOUT_DIV  = /4
            MODE_3G:      rxout_div_reg = RXOUT_DIV4;   // 3G-SDI RXOUT_DIV  = /4
            MODE_6G:      rxout_div_reg = RXOUT_DIV2;   // 6G-SDI RXOUT_DIV  = /2
            MODE_12G_0:   rxout_div_reg = RXOUT_DIV1;   // 12G-SDI RXOUT_DIV = /1 
            MODE_12G_1:   rxout_div_reg = RXOUT_DIV1;   // 12G-SDI RXOUT_DIV = /1 
            default:  	  rxout_div_reg = RXOUT_DIV8;   // HD-SDI RXOUT_DIV  = /8
        endcase
    else // CPLL selected
        case(rx_mode_last_reg)     // When using CPLL as RX serial clock source
            MODE_SD:      rxout_div_reg = RXOUT_DIV2;   // SD-SDI RXOUT_DIV  = /2
            MODE_3G:      rxout_div_reg = RXOUT_DIV2;   // 3G-SDI RXOUT_DIV  = /2
            MODE_6G:      rxout_div_reg = RXOUT_DIV1;   // 6G-SDI RXOUT_DIV  = /1
            //NOTE: GTH CPLL can't be used for 12G line rate 
            //MODE_12G_0: rxout_div_reg = RXOUT_DIV1;   // 12G-SDI RXOUT_DIV = /1 
            //MODE_12G_1: rxout_div_reg = RXOUT_DIV1;   // 12G-SDI RXOUT_DIV = /1 
            default:      rxout_div_reg = RXOUT_DIV4;   // HD-SDI RXOUT_DIV  = /4
        endcase

//
// Calculate rxdata_width_reg and rxint_datawidth_reg
//
always @ (*)
	if ((rx_mode_last_reg == MODE_6G) || (rx_mode_last_reg == MODE_12G_0) || (rx_mode_last_reg == MODE_12G_1))
		begin                                                                              
			rxdata_width_reg    = RXDATA_WIDTH40;          
			rxint_datawidth_reg = RXINT_DATAWIDTH_4_BYTES; 
		end                                                                                
	else  //SD, HD, 3G                                                                         
		begin                                                                              
			rxdata_width_reg    = RXDATA_WIDTH20;          
			rxint_datawidth_reg = RXINT_DATAWIDTH_2_BYTES; 
		end

//
// This logic creates the correct DRP address and data values.
//
always @ (*)
    if (rxdata_width_cycle)
		begin
			drp_addr_reg         = RXDATA_WIDTH_DRP_ADDR;
			drp_wr_data_mask_reg = RXDATA_WIDTH_DRP_WR_MASK;
			drp_wr_data_reg      = rxdata_width_reg;
		end 
    else if (rxint_datawidth_cycle)
		begin
			drp_addr_reg         = RXINT_DATAWIDTH_DRP_ADDR;
			drp_wr_data_mask_reg = RXINT_DATAWIDTH_DRP_WR_MASK;
			drp_wr_data_reg      = rxint_datawidth_reg;
		end 
    else if (rxout_div_cycle)
		begin
			drp_addr_reg         = RXOUT_DIV_DRP_ADDR;
			drp_wr_data_mask_reg = RXOUT_DIV_DRP_WR_MASK;
			drp_wr_data_reg      = rxout_div_reg;
		end 
	else //drp_rxcdr_cycle
		begin
			drp_addr_reg         = RXCDR_CFG2_DRP_ADDR;
			drp_wr_data_mask_reg = RXCDR_CFG2_DRP_WR_MASK;
			drp_wr_data_reg      = rxcdr_cfg2_reg;
		end

//
// Output Register
//

  always @ (posedge rxusrclk_in) 
  begin
    rx_fabric_rst_out_d1_cdc_to  <=  rx_fabric_rst_int;
    rx_fabric_rst_out_d2         <=  rx_fabric_rst_out_d1_cdc_to;
    rx_fabric_rst_out_d3         <=  rx_fabric_rst_out_d2;
  end

assign rx_fabric_rst_out         = rx_fabric_rst_out_d3;

always @ (posedge drpclk_in)
begin
    done_out_int              <= done_reg;
    drp_addr_out              <= drp_addr_reg;
    drp_wr_data_out           <= drp_wr_data_reg;
    drp_wr_data_mask_out      <= drp_wr_data_mask_reg;
    drp_change_req_out        <= drp_change_req_reg;
    drp_change_req_done_out   <= drp_change_req_done_reg;
    gt_rx_pllclksel_out       <= rxpllclksel_reg;
    gt_rx_cdrhold_out         <= gt_rx_cdrhold_reg;
    gt_rx_datapath_reset_out  <= gt_rx_datapath_reset_reg;
    fail_out                  <= fail_reg;
    fail_code_out             <= fail_code_reg;
end   

//
// Input register freeze control FF
//
always @ (posedge drpclk_in)
	if (set_freeze)
		freeze_inputs <= 1'b1;
	else if (clr_freeze)
		freeze_inputs <= 1'b0;

//
// Settle counter
//
always @ (posedge drpclk_in)
	if (clr_settle_cntr)
		settle_cntr <= 0;
	else
		settle_cntr <= settle_cntr + 1;

assign settle_tc = &settle_cntr;
//
// pll counter
//
always @ (posedge drpclk_in)
	if (clr_pllcnt)
		pllcnt <= 0;
	else
		pllcnt <= pllcnt + 1;
assign pllcnt_tc = &pllcnt;
		
//------------------------------------------------------------------------------        
// Master state machine
//
// The master FSM examines the rx_change_req register and then initiates multiple
// DRP write cycles to modify the RXCDR_CFG attribute and the RXOUT_DIV value.
//
// The actual DRP write cycles are handled by a separate FSM, the DRP FSM. The
// master FSM provides a DRP address and new data word to the DRP FSM and 
// asserts a drp_go signal. The DRP FSM does the actual write cycle and responds
// with a drp_done_in signal when the cycle is complete.
//

//
// Current state register
// 
always @ (posedge drpclk_in)
    if (rx_ctrl_reset)
        current_state <= READY_STATE;
    else
        current_state <= next_state;

always @ (posedge drpclk_in)
  rx_state <= current_state;

//
// Next state logic
//
always @ (*)
begin
    case(current_state)
        READY_STATE:
            //if pll chnage detected 
            if (pll_change)
                next_state = PLL_WAIT_LOCK1_STATE;
            else if (plllock_m0 & plllock_m1 & gt_rx_reset_done_in & rx_change_req)
                next_state = SETTLE_STATE;
            else
                next_state = READY_STATE;

        SETTLE_STATE:
            if (~settle_tc)
                next_state = SETTLE_STATE;
			else
				next_state = FREEZE_STATE;

		FREEZE_STATE:
			next_state = RXDATA_WIDTH_WRITE_STATE;

        RXDATA_WIDTH_WRITE_STATE:
            if (drp_change_grant_in)
				next_state = RXDATA_WIDTH_WAIT_STATE;
			else
                next_state = RXDATA_WIDTH_WRITE_STATE;

        RXDATA_WIDTH_WAIT_STATE:
            if (drp_done_in)
                next_state = RXINT_DATAWIDTH_WRITE_STATE;
            else if (drp_wr_fail_in)
                next_state = RXDATA_WIDTH_ERR_STATE;
            else
                next_state = RXDATA_WIDTH_WAIT_STATE;

        RXDATA_WIDTH_ERR_STATE:
            if (max_retries)
                next_state = FAIL_STATE;
            else
                next_state = RXDATA_WIDTH_WRITE_STATE;

        RXINT_DATAWIDTH_WRITE_STATE:
            if (drp_change_grant_in)
				next_state = RXINT_DATAWIDTH_WAIT_STATE;
			else
                next_state = RXINT_DATAWIDTH_WRITE_STATE;

        RXINT_DATAWIDTH_WAIT_STATE:
            if (drp_done_in)
                next_state = RXMODE_CHECK_STATE;
            else if (drp_wr_fail_in)
                next_state = RXINT_DATAWIDTH_ERR_STATE;
            else
                next_state = RXINT_DATAWIDTH_WAIT_STATE;

        RXINT_DATAWIDTH_ERR_STATE:
            if (max_retries)
                next_state = FAIL_STATE;
            else
                next_state = RXINT_DATAWIDTH_WRITE_STATE;

        RXMODE_CHECK_STATE:
            begin
                if (rx_mode_last_reg == MODE_SD)
                    next_state = RXMODE_SD_STATE;
                else
                    next_state = CDRCFG_WRITE_STATE;
            end

        CDRCFG_WRITE_STATE:
            if (drp_change_grant_in)
				next_state = CDRCFG_WAIT_STATE;
			else
                next_state = CDRCFG_WRITE_STATE;

        CDRCFG_WAIT_STATE:
            if (drp_done_in)
                next_state = RXDIV_WRITE_STATE;
            else if (drp_wr_fail_in)
                next_state = CDRCFG_ERR_STATE;
            else
                next_state = CDRCFG_WAIT_STATE;

        CDRCFG_ERR_STATE:
            if (max_retries)
                next_state = FAIL_STATE;
            else
                next_state = CDRCFG_WRITE_STATE;

        RXMODE_SD_STATE:
            next_state = RXDIV_WRITE_STATE;

		RXDIV_WRITE_STATE:
			next_state = RXDIV_WAIT_STATE;

		RXDIV_WAIT_STATE:
			if (drp_done_in)
				next_state = RXPLLCLKSEL1_STATE;
			else if (drp_wr_fail_in)
				next_state = RXDIV_ERR_STATE;
			else
				next_state = RXDIV_WAIT_STATE;

		RXDIV_ERR_STATE:
			if (max_retries)
				next_state = FAIL_STATE;
			else
				next_state = RXDIV_WAIT_STATE;

        RXPLLCLKSEL1_STATE:
		    next_state = RXPLLCLKSEL2_STATE;
			
		RXPLLCLKSEL2_STATE:
		    if (settle_tc) 
                next_state = GT_RESET_STATE;
			else
				next_state = RXPLLCLKSEL2_STATE;
		
		GT_RESET_STATE:
            next_state = GT_RESET_WAIT_STATE;
			
        GT_RESET_WAIT_STATE:
            if (~gt_rx_reset_done_in)
                next_state = GT_RESET_DONE_STATE;
            else
                next_state = GT_RESET_WAIT_STATE;

        GT_RESET_DONE_STATE:
            //if (timeout)
                //next_state = GT_RESET_TO_STATE;
            if (gt_rx_reset_done_in)
                next_state = READY_STATE;
            else
                next_state = GT_RESET_DONE_STATE;

		GT_RESET_TO_STATE:
            if (max_retries)
                next_state = FAIL_STATE;
            else
                next_state = GT_RESET_STATE;
        PLL_WAIT_LOCK1_STATE:
            if (plllock_m0 & plllock_m1)
                next_state = PLL_WAIT_LOCK2_STATE; 
            else 
                next_state = PLL_WAIT_LOCK1_STATE; 
        PLL_WAIT_LOCK2_STATE:
            //issue gt reset when both pll are locked
            if (plllock_m0 & plllock_m1) begin
                if (pllcnt_tc) begin
                    next_state = SETTLE_STATE;
                end else begin
                    next_state = PLL_WAIT_LOCK2_STATE; 
                end
            end else begin
                next_state = PLL_WAIT_LOCK1_STATE; 
            end
        FAIL_STATE:
            //if (~gt_rx_reset_done_in)
                //next_state = FAIL_STATE;
            //else
                next_state = READY_STATE;

        default:
            next_state = READY_STATE;
    endcase
end

//
// Output logic
//
always @ (*)
begin
    pll_change_done = 1'b0;
    clr_pllcnt = 1'b0;
    clr_settle_cntr          = 1'b0; 
    rxout_div_cycle          = 1'b0; 
    rxdata_width_cycle       = 1'b0; 
    rxint_datawidth_cycle    = 1'b0; 
    rxpllclksel_cycle        = 1'b0; 
	set_freeze				 = 1'b0;
	clr_freeze				 = 1'b0;
    done_reg                 = 1'b0; 
    clr_fail                 = 1'b0;
    assert_fail              = 1'b0;
    drp_change_req_reg       = 1'b0;
	drp_change_req_done_reg  = 1'b0;
	gt_rx_datapath_reset_reg = 1'b0;
    clr_rx_change_req        = 1'b0;
    m_clr_to                 = 1'b0;
    inc_retries              = 1'b0;
    clr_retries              = 1'b0;
    set_fail_code_1          = 1'b0;
    set_fail_code_2          = 1'b0;
    set_fail_code_3          = 1'b0;
    set_fail_code_4          = 1'b0;
    set_fail_code_5          = 1'b0;
	clr_fabric_reset         = 1'b0;
	assert_fabric_reset      = 1'b0;
	clr_rxcdrhold            = 1'b0;
	set_rxcdrhold            = 1'b0;
	clr_sd_mode              = 1'b0;
	set_sd_mode              = 1'b0;
	
    case(current_state)
        READY_STATE:
			begin
                clr_pllcnt = 1'b1;
				clr_settle_cntr    = 1'b1;
				clr_freeze         = 1'b1;
				done_reg           = 1'b1;
				clr_fail           = gt_rx_reset_done_in; //clear fail code only when resetdone issued.
				m_clr_to           = 1'b1;
				clr_retries        = 1'b1;
				set_rxcdrhold      = 1'b1;
				clr_fabric_reset   = 1'b1;
			end

		FREEZE_STATE:
			set_freeze = 1'b1;

		RXDATA_WIDTH_WRITE_STATE:
			begin
				drp_change_req_reg = 1'b1;
				rxdata_width_cycle = 1'b1;
			end
        
		RXDATA_WIDTH_WAIT_STATE:
            begin
			   rxdata_width_cycle = 1'b1;
               if (drp_done_in)
				 clr_retries        = 1'b1;
            end
		
		RXDATA_WIDTH_ERR_STATE:
			begin
				rxdata_width_cycle = 1'b1;
				inc_retries        = 1'b1;
				m_clr_to           = 1'b1;
				if (max_retries)
					set_fail_code_4 = 1'b1;
			end

		RXINT_DATAWIDTH_WRITE_STATE:
			begin
				drp_change_req_reg    = 1'b1;
				rxint_datawidth_cycle = 1'b1;
			end
        
		RXINT_DATAWIDTH_WAIT_STATE:
            begin
			   rxint_datawidth_cycle = 1'b1;
               if (drp_done_in)
				 clr_retries        = 1'b1;
            end
		
		RXINT_DATAWIDTH_ERR_STATE:
			begin
				rxint_datawidth_cycle = 1'b1;
				inc_retries           = 1'b1;
				m_clr_to              = 1'b1;
				if (max_retries)
					set_fail_code_5 = 1'b1;
			end

        CDRCFG_WRITE_STATE:
			begin
				clr_rxcdrhold      = 1'b1; 
				clr_sd_mode        = 1'b1;
				drp_change_req_reg = 1'b1;
			end

        CDRCFG_WAIT_STATE:
            begin
               if (drp_done_in)
				 clr_retries        = 1'b1;
            end
        CDRCFG_ERR_STATE:   
        begin
            inc_retries = 1'b1;
            m_clr_to    = 1'b1;
            if (max_retries)
                set_fail_code_1 = 1'b1;
        end

        RXMODE_SD_STATE:
            set_sd_mode = 1'b1;

		RXDIV_WRITE_STATE:
			begin
				drp_change_req_reg = 1'b1;
				rxout_div_cycle    = 1'b1;
			end
        
		RXDIV_WAIT_STATE:
            begin
			  rxout_div_cycle = 1'b1;
                 if (drp_done_in)
				    clr_retries        = 1'b1;
            end
		
		RXDIV_ERR_STATE:
			begin
				rxout_div_cycle = 1'b1;
				inc_retries     = 1'b1;
				m_clr_to        = 1'b1;
				if (max_retries)
					set_fail_code_2 = 1'b1;
			end

		RXPLLCLKSEL1_STATE:
		    begin
			    rxpllclksel_cycle = 1'b1;
			    clr_settle_cntr   = 1'b1;
			end
			
        GT_RESET_STATE:
			begin
                clr_pllcnt = 1'b1;
				drp_change_req_done_reg  = 1'b1;	
				gt_rx_datapath_reset_reg = 1'b1;
                m_clr_to            = 1'b1; //reset timeout counter
			end

        GT_RESET_DONE_STATE:
        begin
            if(pll_change == 1'b1) begin
                  pll_change_done = ~start_retries; //assert done once 1st time enter this mode.
            end else begin
                  clr_rx_change_req   = ~start_retries; //clr rx change req once 1st time enter this mode.
            end
            assert_fabric_reset = gt_rx_reset_done_in;
        end

        GT_RESET_TO_STATE:
        begin
            inc_retries = 1'b1;
            m_clr_to    = 1'b1;
            if (max_retries)
                set_fail_code_3 = 1'b1;
        end

        PLL_WAIT_LOCK1_STATE:
        begin
           clr_pllcnt = 1'b1;
           clr_retries         = 1'b1;
           m_clr_to    = 1'b1;
        end

        PLL_WAIT_LOCK2_STATE:
        begin
           clr_settle_cntr          = 1'b1; 
           clr_retries         = 1'b1;
           m_clr_to    = 1'b1;
        end

        FAIL_STATE:
			begin
                pll_change_done = 1'b1;
                clr_rx_change_req   = 1'b1;
                clr_retries         = 1'b1;
				assert_fail              = 1'b1;	
				drp_change_req_done_reg  = 1'b1;	
				//gt_rx_datapath_reset_reg = 1'b1;
				assert_fabric_reset      = 1'b1;
			end

        default:;
    endcase
end

//FAIL out
always @ (posedge drpclk_in)
    if (rx_ctrl_reset | clr_fail)
        fail_reg <= 1'b0;
    else if (assert_fail)
        fail_reg <= 1'b1;
//Retry Counter
always @ (posedge drpclk_in)
    if (rx_ctrl_reset | clr_retries)
        retry_counter <= 0;
    else if (inc_retries)
        retry_counter <= retry_counter + 1;

assign max_retries = &retry_counter;
assign start_retries = |retry_counter;

//
// A timeout counter for GT reset. If the timeout counter reaches its
// terminal count, the state machine aborts/restarts the transfer.
//
always @ (posedge drpclk_in)
    if (m_clr_to)
        to_counter <= 0;
    else if (~timeout)
        to_counter <= to_counter + 1;

assign timeout = to_counter[RX_GT_RESET_TIMEOUT_MSB];

//
// rx_fabric_rst output
//
// This output is asserted as the FPGA comes out of config and after assertion
// of rx_ctrl_reset. It is intended to be used to keep the SDI core RX section in reset
// when RXRATE must be 3'b000 at initialization time.  This signal goes low only
// after the first RXRATE change cycle has completed.
//

// Flop the reset control logic to remove glitches.
always @ (posedge drpclk_in)
begin
   assert_fabric_reset_ff <= assert_fabric_reset;
   clr_fabric_reset_ff    <= clr_fabric_reset;
end

always @ (posedge drpclk_in)
begin
    if (rx_ctrl_reset | assert_fabric_reset_ff)
        rx_fabric_rst_int <= 1'b1;
    else if (clr_fabric_reset_ff)
        rx_fabric_rst_int <= 1'b0;
end

//
// Fail code register
//
always @ (posedge drpclk_in)
    if (rx_ctrl_reset | clr_fail)
		fail_code_reg <= 3'b000;
	else if (set_fail_code_1)
		fail_code_reg <= 3'b001;
	else if (set_fail_code_2)
		fail_code_reg <= 3'b010;
	else if (set_fail_code_3)
		fail_code_reg <= 3'b011;
	else if (set_fail_code_4)
		fail_code_reg <= 3'b100;
	else if (set_fail_code_5)
		fail_code_reg <= 3'b101;

endmodule
