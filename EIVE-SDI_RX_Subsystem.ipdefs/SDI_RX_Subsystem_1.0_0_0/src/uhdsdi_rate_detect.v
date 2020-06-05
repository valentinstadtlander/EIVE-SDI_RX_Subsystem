// (c) Copyright 2001 - 2013 Xilinx, Inc. All rights reserved.
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
//  This module implements two counters. One driven by the reference clock and
//  other driven by the recovered clock. The two counters help in automatic 
//  recognition of the two SDI bit rates. 
//  
//  This module also looks for the clock frequency change and generates a reset
//  signal whenever there is asynchronous clock switching due to rate change or
//  any other reason. It also indicates whenever a drift is seen in the recovered
//  clock beyond a threshold value. This module validates the changes number of 
//  times before generating the reset or clock drift status signals. 
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

module uhdsdi_rate_detect # (
    parameter   REFCLK_FREQ     =   33333333)   // Reference clock in Hz
(
    input  wire refclk,     // reference clock
    input  wire recvclk,    // recovered clock
    input  wire [2:0] rx_mode,
    input  wire enable,     // Use to hold the module when driven by improper clock
    input  wire enable_drpclk_sync,
    output wire rate
);  

localparam MAX_COUNT_REF = REFCLK_FREQ/1000;            // Reference value for 1 millisec
localparam MAX_COUNT_RXREC = 74250;                     // Reference count value for 74.25 MHz clock for

localparam TEST_VAL_RXREC = MAX_COUNT_RXREC - 38;       // Reference value used to decide whether HD rate has
                                                        // changed or not
 reg  [17:0]         count_ref = 0;                   // Counts the reference clock
 reg  [17:0]         count_recv = 0;                  // Counts the recovered clock

//----------------Internal Signals----------------------------------------------
 wire                count_ref_tc;
 reg  [2:0]          tc_reg = 0;
 reg tc_reg_pls;
(* shreg_extract = "NO" *)  
reg  [3:0]          capture_reg = 0;
wire                capture;
reg                 toggle = 0;
reg                 toggle1 = 0;
reg                 capture_dly = 0;

// control logic signals

(* shreg_extract = "NO" *)  
reg  [ 2:0]         enable_reg = 0;  // Register definition for synchronisation to reference clk domain
(* shreg_extract = "NO" *)  
reg  [ 2:0]         enable_rec = 0;  // Register definition for synchronisation to recovered clk domain
reg                 rate_int = 0;
reg                 rate_int_d1 = 0;
reg [2:0] rx_mode_d1;
reg rx_mode_hd;
reg rx_mode_3g6g;

    (* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg tc_reg_pls_out_d1_cdc_to = 1'b0;
    (* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg tc_reg_pls_out_d2 = 1'b0;
    (* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg tc_reg_pls_out_d3 = 1'b0;

    (* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg rate_int_d1_cdc_to = 1'b0;
    (* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg rate_int_d2 = 1'b0;
    (* ASYNC_REG = "true" *) (* shift_extract = "{no}" *) reg rate_int_d3 = 1'b0;

always @ (posedge recvclk) begin
    enable_rec <= {enable_rec[1:0] , enable};
    rx_mode_d1 <= rx_mode;
    if(rx_mode_d1 == 3'b101 || rx_mode_d1 == 3'b110) begin 
       rx_mode_3g6g <= 1'b0;
       rx_mode_hd <= 1'b0;
    //hd
    end else if (rx_mode_d1 == 3'b000) begin
       rx_mode_3g6g <= 1'b0;
       rx_mode_hd <= 1'b1;
    //3g6g
    end else begin
       rx_mode_3g6g <= 1'b1;
       rx_mode_hd <= 1'b0;
    end
end
//-------------------------------------------------------------------

// This is a counter that counts the event on the reference clock for
// comparing that with the recovered clock. The counter gets reset after
// 1 millisec. This design compares the recovered clock with the reference
// clock every 1 millisec to compute HD rate change or clock drift 

always @ (posedge refclk)
begin
    if (count_ref_tc | (~enable_drpclk_sync))
        count_ref <= MAX_COUNT_REF;
    else  
        count_ref <= count_ref - 1;
end

assign count_ref_tc = (count_ref == 1) ;      // Goes high every 1 millisec.

// This logic extends the pulse to ensure that it is not missed when sampled by a
// slower clock

always @ (posedge refclk) begin
    tc_reg <= {tc_reg[1:0], count_ref_tc};
    tc_reg_pls <= |tc_reg; //extended pulse for clock domain sync: 3 refclk cycle wide
end

//CDC from refclk to recvclk
  always @ (posedge recvclk) 
begin
  tc_reg_pls_out_d1_cdc_to  <=  tc_reg_pls;
  tc_reg_pls_out_d2         <=  tc_reg_pls_out_d1_cdc_to;
  //tc_reg_pls_out_d3         <=  tc_reg_pls_out_d2;
end

// Synchronisation to recovered clock domain 

always @ (posedge recvclk)
    capture_reg <= {capture_reg[2:0], tc_reg_pls_out_d2};

assign capture = ~capture_reg[3] & capture_reg[2];

// This implements a counter for counting the events on the recovered clock.
// The count reading is compared to a predefined value at a fixed interval of
// time to compute the clock rate or any drift in the recovered clock. The 
// counter counts every clock event when the std input is '0' else counts
// every alternate event when it is set to '1'. This is done to support
// both HD-SDI and 3G-SDI protocols.

always @ (posedge recvclk)
begin
    if (capture | (~enable_rec[2]))
    begin
        count_recv <= 0;
        toggle     <= 0;
        toggle1     <= 0;
    end
    else
    begin
        //hd
        if (rx_mode_hd) begin
            toggle     <= 0;
            count_recv <= count_recv + 1;
        //3g6g
        end else if (rx_mode_3g6g) begin
            toggle  <= ~toggle;
            if (toggle) begin
                count_recv <= count_recv + 1;
            end
        //12g
        end else begin
            toggle  <= ~toggle;
            if(toggle) begin
               toggle1 <= ~toggle1;
            end
            if(toggle & toggle1) begin
               count_recv <= count_recv + 1;
            end
        end  
    end
end 
// This process looks for clock drift from its mean position on one
// direction indicating that the rate of input data rate has changed
//   

always @ (posedge recvclk) begin
    if (capture) begin
        rate_int <= (count_recv < TEST_VAL_RXREC);
        rate_int_d1 <= rate_int;
    end
end

  always @ (posedge refclk) 
  begin
    rate_int_d1_cdc_to  <=  rate_int_d1;
    rate_int_d2         <=  rate_int_d1_cdc_to;
    rate_int_d3         <=  rate_int_d2;
  end
  
assign rate = rate_int_d3;  



endmodule
