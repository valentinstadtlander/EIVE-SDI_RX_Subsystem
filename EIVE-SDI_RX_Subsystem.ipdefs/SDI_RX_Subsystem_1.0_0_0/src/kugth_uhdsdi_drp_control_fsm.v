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
//  This module provides direct access to GTH DRP ports for reading and
//  writing into DRP registers. 
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

`timescale 1ns / 1ps


module kugth_uhdsdi_drp_control_fsm
#(
    parameter WR_VERIFY_BYPASS  = 1,   // bypass write verification
    parameter RETRY_CNTR_MAX    = 8    // max upto 255 only        
)
(
    // Control Signals
    input  wire         rst_in, 
    input  wire         wr_in, 
    input  wire         rd_in, 
    input  wire  [8:0]  drp_addr_in, 
    input  wire [15:0]  drp_wr_data_in, 
    input  wire [15:0]  drp_wr_data_mask_in, 
    output reg  [15:0]  drp_rd_data_out, 
    output reg          drp_done_out, 
    output reg          drp_wr_fail_out, 
    output reg   [7:0]  drp_wr_fail_cnt_out, 

    //DRP Interface
    input  wire         drpclk_in, 
    output wire  [8:0]  drpaddr_out, 
    output reg  [15:0]  drpadi_out, 
    output wire         drpen_out, 
    output wire         drpwe_out, 
    input  wire [15:0]  drpado_in, 
    input  wire         drprdy_in 
);
    

     reg          den = 1'b0;
     reg          dwe = 1'b0;
     reg [11:0]   timer_cntr;
     reg          time_en;
     reg          drprdy_in_r;
     reg          time_out;
  
  
    //DRP FSM
    localparam DRP_WAIT           = 0;
    localparam DRP_READ           = 1;
    localparam DRP_READ_ACK       = 2;
    localparam DRP_MODIFY         = 3;
    localparam DRP_WRITE          = 4;
    localparam DRP_WRITE_ACK      = 5;
    localparam DRP_READ2          = 6;
    localparam DRP_READ2_ACK      = 7;
    localparam DRP_WRITE_VERIFY   = 8;
    localparam DRP_FAIL           = 9;
    localparam DRP_DONE           = 10;

    reg [3:0] drp_ctrl_st = DRP_WAIT; 

    assign drpaddr_out = drp_addr_in;
    assign drpen_out   = den;
    assign drpwe_out   = dwe;
   
    always @(posedge drpclk_in)
    begin
      drprdy_in_r  <=  drprdy_in;
    end

//Modelling this FSM such that it has synchronous reset to avoid any glitches
//on "rst_in" due to the state transitions/optimization 
    always @(posedge drpclk_in) begin
      if (rst_in) begin
        den                 <= 1'b0;
        dwe                 <= 1'b0;
        drpadi_out          <= 16'h0000;
        drp_ctrl_st         <= DRP_WAIT;
        drp_rd_data_out     <= 16'h0000;
        drp_wr_fail_out     <= 1'b0;
        drp_wr_fail_cnt_out <= 8'b0;
        time_en             <= 1'b0;

      end
      else begin
        time_en <= 1'b0;
        case (drp_ctrl_st) 
            DRP_WAIT:
                begin
                  if (wr_in | rd_in) drp_ctrl_st <= DRP_READ;
                  else               drp_ctrl_st <= DRP_WAIT;
                end
            DRP_READ:
                begin
                  den <= 1'b1;
                  drp_ctrl_st <= DRP_READ_ACK;
                end
            DRP_READ_ACK:
                begin
                  den     <= 1'b0;
                  time_en <= 1'b1;
                  if (drprdy_in_r == 1'b1) begin
                    if (rd_in) drp_ctrl_st   <= DRP_DONE;
                    else       drp_ctrl_st <= DRP_MODIFY;
                    drp_rd_data_out <= drpado_in; 
                  end
                  else if (time_out == 1'b1)
                    drp_ctrl_st <= DRP_READ;
                  else      drp_ctrl_st <= DRP_READ_ACK;
                end
            DRP_MODIFY:
                begin
                  drpadi_out <= (drp_wr_data_in & drp_wr_data_mask_in) | (drpado_in & ~drp_wr_data_mask_in);
                  drp_ctrl_st <= DRP_WRITE;
                end
            DRP_WRITE:
                begin
                  den <= 1'b1;
                  dwe <= 1'b1;
                  drp_ctrl_st <= DRP_WRITE_ACK;
                end
            DRP_WRITE_ACK:
                begin
                  den <= 1'b0;
                  dwe <= 1'b0;
                  time_en <= 1'b1;
                 if(drprdy_in_r == 1'b1) begin
                   if (WR_VERIFY_BYPASS == 1) 
                     drp_ctrl_st  <= DRP_DONE;
                   else 
                     drp_ctrl_st <= DRP_READ2;
                 end
                 else if (time_out == 1'b1)
                   drp_ctrl_st <= DRP_WRITE;
                 else 
                   drp_ctrl_st <= DRP_WRITE_ACK;
                end
            DRP_READ2:
                begin
                  den <= 1'b1;
                  drp_ctrl_st <= DRP_READ2_ACK;
                end
            DRP_READ2_ACK:
                begin
                  den     <= 1'b0;
                  time_en <= 1'b1;
                  if (drprdy_in_r == 1'b1) begin
                    drp_ctrl_st <= DRP_WRITE_VERIFY;
                    drp_rd_data_out <= drpado_in; 
                  end
                  else if (time_out == 1'b1)
                    drp_ctrl_st <= DRP_READ2;
                  else      
                    drp_ctrl_st <= DRP_READ2_ACK;
                end
            DRP_WRITE_VERIFY:
                begin
                  if ((drp_wr_data_in & drp_wr_data_mask_in) == (drp_rd_data_out & drp_wr_data_mask_in))
                    drp_ctrl_st <= DRP_DONE;
                  else
                    drp_ctrl_st <= DRP_FAIL;
                end
            DRP_FAIL:
                begin
                  if(drp_wr_fail_cnt_out != (RETRY_CNTR_MAX-1)) 
                  begin
                    drp_wr_fail_cnt_out <= drp_wr_fail_cnt_out + 1;
                    drp_ctrl_st <= DRP_MODIFY;
                  end
                  else 
                  begin
                    drp_wr_fail_out     <= 1'b1;
                    drp_ctrl_st <= DRP_DONE; 
                  end
       
                end
            DRP_DONE:
                begin
                  drp_ctrl_st <= DRP_WAIT;
                end

       //coverage off
            default : 
                drp_ctrl_st  <= DRP_WAIT;
       //coverage on

        endcase
      end
    end
  
    always @(posedge drpclk_in) 
    begin
        drp_done_out <= (drp_ctrl_st == DRP_DONE);
    end
        
        //Retry Timer
        always @ (posedge drpclk_in)
        begin
          if (~time_en)
          begin
            timer_cntr <= 12'd0;
            time_out   <= 1'b0;
          end
          else
          begin   
            if (&timer_cntr)
              time_out <= 1'b1;
            else  
              timer_cntr <= timer_cntr + 12'd1;
          end
        end

endmodule
