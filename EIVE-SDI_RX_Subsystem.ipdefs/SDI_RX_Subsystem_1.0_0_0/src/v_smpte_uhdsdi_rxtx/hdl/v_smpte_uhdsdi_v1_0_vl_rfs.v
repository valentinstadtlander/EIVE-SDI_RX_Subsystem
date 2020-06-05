// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/*
Module Description:

This module does an 18-bit CRC calculation.

The calculation is the SDI CRC18 calculation with a polynomial of 
x^18 + x^5 + x^4 + 1. The function considers the LSB of the video data as the 
first bit shifted into the CRC generator, although the implementation given here
is a fully parallel CRC, calculating all 18 CRC bits from the 10-bit video data
in one clock cycle.  

The clr input must be asserted coincident with the first input data word of
a new CRC calculation. The clr input forces the old CRC value stored in the
module's crc_reg to be discarded and a new calculation begins as if the old CRC
value had been cleared to zero.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_crc2 (
    input  wire         clk,    // clock input
    input  wire         ce,     // clock enable
    input  wire         en,     // 1 = enable CRC calculation
    input  wire         rst,    // sync reset input
    input  wire         clr,    // forces the old CRC value to zero to start new calculation
    input  wire [9:0]   d,      // input data word
    output wire [17:0]  crc_out // new calculated CRC value
);

//-----------------------------------------------------------------------------
// Signal definitions
//
wire                    x10;
wire                    x9;
wire                    x8;
wire                    x7;
wire                    x6;
wire                    x5;
wire                    x4;
wire                    x3;
wire                    x2;
wire                    x1;
wire    [17:0]          newcrc;     // input to CRC register            
wire    [17:0]          crc;        // output of crc_reg, unless clr is asserted
reg     [17:0]          crc_reg = 0;// internal CRC register


//
// The previous CRC value is represented by the variable crc. This value is
// combined with the new data word to form the new CRC value. Normally, crc is
// equal to the contents of the crc_reg. However, if the clr input is asserted,
// the crc value is cleared to all zeros.
//
assign crc = clr ? 0 : crc_reg;

//
// The x variables are intermediate terms used in the new CRC calculation.
//                             
assign x10 = d[9] ^ crc[9];
assign x9  = d[8] ^ crc[8];
assign x8  = d[7] ^ crc[7];
assign x7  = d[6] ^ crc[6];
assign x6  = d[5] ^ crc[5];
assign x5  = d[4] ^ crc[4];
assign x4  = d[3] ^ crc[3];
assign x3  = d[2] ^ crc[2];
assign x2  = d[1] ^ crc[1];
assign x1  = d[0] ^ crc[0];

//
// These assignments generate the new CRC value.
//
assign newcrc[0]  = crc[10];
assign newcrc[1]  = crc[11];
assign newcrc[2]  = crc[12];
assign newcrc[3]  = x1  ^ crc[13];
assign newcrc[4]  = x2  ^ x1 ^ crc[14];
assign newcrc[5]  = x3  ^ x2 ^ crc[15];
assign newcrc[6]  = x4  ^ x3 ^ crc[16];
assign newcrc[7]  = x5  ^ x4 ^ crc[17];
assign newcrc[8]  = x6  ^ x5 ^ x1;
assign newcrc[9]  = x7  ^ x6 ^ x2;
assign newcrc[10] = x8  ^ x7 ^ x3;
assign newcrc[11] = x9  ^ x8 ^ x4;
assign newcrc[12] = x10 ^ x9 ^ x5;
assign newcrc[13] = x10 ^ x6;
assign newcrc[14] = x7;
assign newcrc[15] = x8;
assign newcrc[16] = x9;
assign newcrc[17] = x10;

//
// This is the crc_reg. On each clock cycle when ce is asserted, it loads the
// newcrc value. The module's crc_out vector is always assigned to the contents
// of the crc_reg.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            crc_reg <= 0;
        else if (en)
            crc_reg <= newcrc;
    end

assign crc_out = crc_reg;

endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/* 
This module checks the parity bits and checksums of all ANC packets (except EDH
packets) on the video stream.. If any errors are detected in ANC packets during
a field, the module will assert the anc_edh_local signal. This signal is used 
by the edh_gen module to assert the edh flag in the ANC flag set of the next 
EDH packet it generates. The anc_edh_local signal remains asserted until the
EDH packet has been sent (as indicated the edh_packet input being asserted then
negated).

The module will not do any checking after reset until the video decoder's locked
signal is asserted for the first time.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_edh_anc_rx (
    input  wire         clk,                    // clock input
    input  wire         ce,                     // clock enable
    input  wire         rst,                    // sync reset input
    input  wire         locked,                 // video decoder locked signal
    input  wire         rx_anc_next,            // indicates the next word is the first word of a received ANC packet
    input  wire         rx_edh_next,            // indicates the next word is the first word of a received EDH packet
    input  wire         edh_packet,             // indicates an EDH packet is being generated
    input  wire [9:0]   vid_in,                 // video data
    output reg          anc_edh_local = 1'b0    // ANC edh flag
);


//-----------------------------------------------------------------------------
// Parameter definitions
//      

//
// This group of parameters defines the states of the EDH processor state
// machine.
//
localparam STATE_WIDTH   = 4;
localparam STATE_MSB     = STATE_WIDTH - 1;

localparam [STATE_WIDTH-1:0]
    S_WAIT   = 0,
    S_ADF1   = 1,
    S_ADF2   = 2,
    S_ADF3   = 3,
    S_DID    = 4,
    S_DBN    = 5,
    S_DC     = 6,
    S_UDW    = 7,
    S_CHK    = 8,
    S_EDH1   = 9,
    S_EDH2   = 10,
    S_EDH3   = 11;

//-----------------------------------------------------------------------------
// Signal definitions
//
reg     [STATE_MSB:0]   current_state = S_WAIT; // FSM current state
reg     [STATE_MSB:0]   next_state;             // FSM next state
wire                    parity;                 // used to generate parity_err signal
wire                    parity_err;             // asserted on parity error
reg                     check_parity;           // asserted when parity should be checked
reg     [8:0]           checksum = 9'b0;        // checksum generator for ANC packet
reg                     clr_checksum;           // asserted to clear the checksum
reg                     check_checksum;         // asserted when checksum is to be tested
reg                     clr_edh_flag;           // asserted to clear the edh flag
reg                     checksum_err;           // asserted when checksum error in EDH packet is detected
reg     [7:0]           udw_cntr = 8'b0;        // user data word counter
reg                     udwcntr_eq_0;           // asserted when output of UDW in MUX is zero
wire    [7:0]           udw_mux;                // UDW counter input MUX
reg                     ld_udw_cntr;            // loads the UDW counter when asserted
reg                     enable = 1'b0;          // generated from locked input

//
// enable signal
//
// This signal enables checking of the parity and checksum. It is negated on
// reset and remains negated until locked is asserted for the first time.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            enable <= 1'b0;
        else if (locked)
            enable <= 1'b1;
    end
                           
//
// FSM: current_state register
//
// This code implements the current state register. 
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            current_state <= S_WAIT;
        else
            current_state <= next_state;
    end

//
// FSM: next_state logic
//
// This case statement generates the next_state value for the FSM based on
// the current_state and the various FSM inputs.
//
always @ (*)
    case(current_state)
        S_WAIT:     if (~enable)
                        next_state = S_WAIT;
                    else if (rx_anc_next & ~rx_edh_next)
                        next_state = S_ADF1;
                    else if (edh_packet)
                        next_state = S_EDH1;
                    else
                        next_state = S_WAIT;
                
        S_ADF1:     next_state = S_ADF2;

        S_ADF2:     next_state = S_ADF3;

        S_ADF3:     next_state = S_DID;

        S_DID:      if (parity_err)
                        next_state = S_WAIT;
                    else
                        next_state = S_DBN;

        S_DBN:      if (parity_err)
                        next_state = S_WAIT;
                    else
                        next_state = S_DC;

        S_DC:       if (parity_err)
                        next_state = S_WAIT;
                    else if (udwcntr_eq_0)
                        next_state = S_CHK;
                    else
                        next_state = S_UDW;

        S_UDW:      if (udwcntr_eq_0)
                        next_state = S_CHK;
                    else
                        next_state = S_UDW;

        S_CHK:      next_state = S_WAIT;

        S_EDH1:     if (~edh_packet)
                        next_state = S_EDH1;
                    else
                        next_state = S_EDH2;

        S_EDH2:     if (edh_packet)
                        next_state = S_EDH2;
                    else
                        next_state = S_EDH3;

        S_EDH3:     next_state = S_WAIT;

        default:    next_state = S_WAIT;

    endcase
        
//
// FSM: outputs
//
// This block decodes the current state to generate the various outputs of the
// FSM.
//
always @ (*)
begin
    // Unless specifically assigned in the case statement, all FSM outputs
    // default to the values given here.
    clr_checksum    = 1'b0;
    clr_edh_flag    = 1'b0;
    check_parity    = 1'b0;
    ld_udw_cntr     = 1'b0;
    check_checksum  = 1'b0;
                            
    case(current_state)     
        S_EDH3:     clr_edh_flag = 1'b1;

        S_ADF3:     clr_checksum = 1'b1;

        S_DID:      check_parity = 1'b1;

        S_DBN:      check_parity = 1'b1;

        S_DC:       begin
                        ld_udw_cntr = 1'b1;
                        check_parity = 1'b1;
                    end

        S_CHK:      check_checksum = 1'b1;

    endcase
end

//
// parity error detection
//
// This code calculates the parity of bits 7:0 of the video word. The calculated
// parity bit is compared to bit 8 and the complement of bit 9 to determine if
// a parity error has occured. If a parity error is detected, the parity_err
// signal is asserted. Parity is only valid on the payload portion of the
// EDH packet (user data words).
//
assign parity = vid_in[7] ^ vid_in[6] ^ vid_in[5] ^ vid_in[4] ^
                vid_in[3] ^ vid_in[2] ^ vid_in[1] ^ vid_in[0];

assign parity_err = (parity ^ vid_in[8]) | (parity ^ ~vid_in[9]);


//
// checksum calculator
//
// This code generates a checksum for the EDH packet. The checksum is cleared
// to zero prior to beginning the checksum calculation by the FSM asserting the
// clr_checksum signal. The vid_in word is added to the current checksum when
// the FSM asserts the do_checksum signal. The checksum is a 9-bit value and
// is computed by summing all but the MSB of the vid_in word with the current
// checksum value and ignoring any carry bits.
//
always @ (posedge clk)
    if (ce)
        begin
            if (rst | clr_checksum)
                checksum <= 0;
            else
                checksum <= checksum + vid_in[8:0];
        end

//
// checksum tester
//
// This logic asserts the checksum_err signal if the calculated and received
// checksum are not the same.
//
always @ (*)
    if (checksum == vid_in[8:0] && checksum[8] == ~vid_in[9])
        checksum_err = 1'b0;
    else
        checksum_err = 1'b1;

//
// UDW counter, input MUX, and comparator
//
// The UDW counter is designed to count the number of user data words in the
// ANC packet so that the FSM knows when the payload portion of the ANC
// packet is over.
//
// The ld_udw_cntr signal controls a MUX. When this signal is asserted, the
// MUX outputs the vid_in data word. Otherwise, the MUX outputs the contents of
// the UDW counter. The output of the MUX is decremented by one and loaded into
// the UDW counter. The output of the MUX is also tested to see if it equals
// zero and the udwcntr_eq_0 signal is asserted if so.
//
assign udw_mux = ld_udw_cntr ? vid_in[7:0] : udw_cntr;

always @ (*)
    if (udw_mux == 8'b00000000)
        udwcntr_eq_0 = 1'b1;
    else
        udwcntr_eq_0 = 1'b0;
        
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            udw_cntr <= 0;
        else
            udw_cntr <= udw_mux - 1;
    end
        
//
// anc_edh_local flag
//
// This flag is reset whenever an EDH packet is generated. The flag is set
// if a parity error or checksum error is detected during a field.
//
always @ (posedge clk)
    if (ce)
        begin
            if (rst | clr_edh_flag)
                anc_edh_local <= 1'b0;
            else if (parity_err & check_parity)
                anc_edh_local <= 1'b1;
            else if (checksum_err & check_checksum)
                anc_edh_local <= 1'b1;
        end
                            
endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/*
This module examines a digital video stream and determines which of six
supported video standards matches the video stream. The supported video 
standards are:

Video Format                            Corresponding Standards
------------------------------------------------------------------------------
NTSC 4:2:2 component video              SMPTE 125M, ITU-R BT.601, ITU-R BT.656
NTSC 4:2:2 16x9 component video         SMPTE 267M
NTSC 4:4:4 component 13.5MHz sample     SMPTE RP 174
PAL 4:2:2 component video               ITU-R BT.656
PAL 4:2:2 16x9 component video          ITU-R BT.601
PAL 4:4:4 component 13.5MHz sample      ITU-R BT.799    

The autodetect module is a finite state machine (FSM) that looks for TRS
symbols and measures the number of samples per line of video based on the
positions of the TRS symbols.

The FSM executes two main loops, the ACQUIRE loop and the LOCKED loop. In the 
ACQUIRE loop, the FSM attempts to find eight consecutive lines with the same
number of samples. Once it does this, the FSM then compares the number of
samples per video line to that of each of the six known standards. If a
a matching standard is found, the FSM sets the locked output and also outputs
a 3-bit code representing the video standard on the std output port then
it advances to the LOCKED loop.

In the LOCKED loop, the FSM continuously compares the number of samples of each
received video line to the correct number for the current video standard. If
the number of consecutive lines with the incorrect number of samples exceeds
the MAX_ERR_CNT value, then the locked output is negated and the FSM returns
to the ACQUIRE loop.

The autodetect module has the following inputs:

clk: Input clock running at the video word rate.

ce: Clock enable input.

rst: Synchronous reset input.

reacquire: Forces the autodetect unit to redetect the video format when
asserted high. This is essentially a synchronous reset to the FSM. The FSM
will not start the reacquire loop until the reacquire input goes low.

vid_in: This is the video data input port. If eight bit video is being used, the
LS 2-bits of the vid_in input port should be grounded.

rx_trs: This input must be asserted on the first word of every TRS symbol
present in the input video stream.

rx_xyz: This input must be asserted during the XYZ word of every TRS symbol
present in the input video stream.

rx_xyz_err: This input must be asserted during when the XYZ word contains an
error according to the 4:2:2 format.

rx_xyz_err_4444: This input identifies errors in XYZ words for the 4:4:4:4 
formats.

The autodetect module has the following outputs.

std: A 3-bit output port that indicates which standard has been detected. This
code is not valid unless the locked output is asserted. The std code values
are:

000:    NTSC 4:2:2 component video
001:    invalid
010:    NTSC 4:2:2 16x9 component video
011:    NTSC 4:4:4 13.5MHz component video
100:    PAL 4:2:2 component video
101:    invalid
110:    PAL 4:2:2 16x9 component video
111:    PAL 4:4:4 13.5MHz component video

locked: Asserted high when the autodetect unit is locked to the incoming video
standard.

xyz_err: This signal indicates the detection of an XYZ word error. This output
is generated by multiplexing the rx_xyz_err and rx_xyz_err_4444 inputs
together and using the detected video standard as the control for the MUX.

s4444: For the 4444 component video standards, this signal reflects the S bits
in the TRS word. The S bit is 1 for YCbCr and 0 for RGB.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_edh_autodetect #(
    parameter HCNT_WIDTH        = 12,   // # of bits in horizontal counter
    parameter ERRCNT_WIDTH      = 4,    // # of bits in error counter -- must be enough to count to MAX_ERR_CNT
    parameter MAX_ERR_CNT       = 8)    // Max consectuive error allowed before FSM begins to reaquire format
(
    input  wire         clk,            // clock input
    input  wire         ce,             // clock enable
    input  wire         rst,            // sync reset input
    input  wire         reacquire,      // forces state machine to reacquire when asserted
    input  wire [9:0]   vid_in,         // video data input
    input  wire         rx_trs,         // must be high on first word of TRS (0x3ff)
    input  wire         rx_xyz,         // must be high during the TRS XYZ word
    input  wire         rx_xyz_err,     // XYZ word error input, for all standards except 4444
    input  wire         rx_xyz_err_4444,// XYZ word error input, for 4444 standards
    output reg  [2:0]   vid_std = 3'b0, // video standard code
    output reg          locked = 1'b0,  // output asserted when synced to input data
    output wire         xyz_err,        // asserted when the XYZ word contains an error
    output reg          s4444 = 1'b0    // reflects the status of the S bit in 4444 format
);

//-----------------------------------------------------------------------------
// Parameter definitions
//

localparam HCNT_MSB      = HCNT_WIDTH - 1;       // MS bit # of hcnt
localparam ERRCNT_MSB    = ERRCNT_WIDTH - 1;     // MS bit # of errcnt

//
// This group of parameters defines the total number of clocks per line 
// for the various supported video standards.
//
localparam CNT_NTSC_422          = 1716;
localparam CNT_NTSC_422_WIDE     = 2288;
localparam CNT_NTSC_4444         = 3432;
localparam CNT_PAL_422           = 1728;
localparam CNT_PAL_422_WIDE      = 2304;
localparam CNT_PAL_4444          = 3456;

//
// This group of parameters defines the encoding for the video standards output
// code.
//
localparam [2:0]
    NTSC_422        = 3'b000,
    NTSC_INVALID    = 3'b001,
    NTSC_422_WIDE   = 3'b010,
    NTSC_4444       = 3'b011,
    PAL_422         = 3'b100,
    PAL_INVALID     = 3'b101,
    PAL_422_WIDE    = 3'b110,
    PAL_4444        = 3'b111;

//
// This group of parameters defines the states of the FSM.
//                                              
localparam STATE_WIDTH   = 4;
localparam STATE_MSB     = STATE_WIDTH - 1;

localparam [STATE_WIDTH-1:0]
    ACQ0 = 0,
    ACQ1 = 1,
    ACQ2 = 2,
    ACQ3 = 3,
    ACQ4 = 4,
    ACQ5 = 5,
    ACQ6 = 6,
    ACQ7 = 7,
    LCK0 = 8,
    LCK1 = 9,
    LCK2 = 10,
    LCK3 = 11,
    ERR0 = 12,
    ERR1 = 13,
    ERR2 = 14;
     
//-----------------------------------------------------------------------------
// Signal definitions
//

// counters and registers
reg     [HCNT_MSB:0]    hcnt = 1;               // horizontal counter
reg     [HCNT_MSB:0]    saved_hcnt = 0;         // saves the hcnt value of a line
reg     [STATE_MSB:0]   current_state = ACQ0;   // FSM current state
reg     [STATE_MSB:0]   next_state;             // FSM next state
reg     [2:0]           loops = 3'b0;           // iteration counter
reg     [ERRCNT_MSB:0]  errcnt = 0;             // error counter
reg     [2:0]           std = 3'b0;             // internal vid_std register
 
// FSM inputs
wire                    composite;              // 1=composite video
wire                    eav;                    // asserted when EAV received
wire                    sav;                    // asserted when SAV received
wire                    loops_eq_0;             // asserted when loops == 0
wire                    loops_eq_7;             // asserted when loops == 7
wire                    loops_eq_1;             // asserted when loops == 1
wire                    match;                  // comparator output
wire                    int_xyz_err;            // error in XYZ parity
wire                    max_errs;               // asserted when errcnt reaches max

// FSM outputs
reg                     clr_loops;              // clears loops counter
reg                     inc_loops;              // increments loops counter
reg                     clr_errcnt;             // clears the error counter
reg                     inc_errcnt;             // increments the error counter
reg                     clr_locked;             // clears the locked output
reg                     set_locked;             // sets the locked output
reg                     clr_hcnt;               // clears the hcnt counter
reg     [1:0]           match_code;             // comparator control bits
reg                     ld_std;                 // loads the video std output register
reg                     ld_saved_hcnt;          // loads the saved_hcnt register
reg                     ld_s4444;               // loads the s4444 flip-flop

// other signals
wire    [HCNT_MSB:0]    cmp_a;                  // A input to comparator
wire    [HCNT_MSB:0]    cmp_b;                  // B input to comparator
wire    [2:0]           samples_adr;            // address inputs for samples ROM
reg     [HCNT_MSB:0]    samples;                // ROM storing the sample counts for 
                                                //   various supported video standards


//
// hcnt: horizontal counter
//
// The horizontal counter increments every clock cycle to keep track of the
// current horizontal position. If clr_hcnt is asserted by the FSM, hcnt is
// reloaded with a value of 1. A value of 1 is used because of the latency
// involved in detected the TRS symbol and deciding whether to clear hcnt or
// not.
//
always @ (posedge clk)
    if (ce)
        begin
            if (rst | clr_hcnt)
                hcnt <= 1;
            else
                hcnt <= hcnt + 1;
        end

//
// saved_hcnt
//
// This register loads the current value of the hcnt counter when ld_saved_hcnt
// is asserted.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            saved_hcnt <= 0;
        else if (ld_saved_hcnt)
            saved_hcnt <= hcnt;
    end

//
// error counter
//
// This counter increments when inc_errcnt is asserted by the FSM. It clears
// when the FSM asserts clr_errcnt. When the error counter reaches the 
// MAX_ERR_CNT value, max_errs is asserted.
//
always @ (posedge clk)
    if (ce)
        begin
            if (rst | clr_errcnt)
                errcnt <= 0;
            else if (inc_errcnt)
                errcnt <= errcnt + 1;
        end

assign max_errs = (errcnt == MAX_ERR_CNT);

//
// loops
//
// This iteration counter is used by the FSM for two purposes. First, it is
// used to count the number of consecutive times that the SAV occurs at the 
// same hcnt value. Second, it is used to index through the samples ROM to 
// search for a matching video standard.
//
always @ (posedge clk)
    if (ce)
        begin
            if (rst | clr_loops)
                loops <= 0;
            else if (inc_loops)
                loops <= loops + 1;
        end

//
// std
//
// This register holds the code representing the video standard found by the
// FSM. If the FSM asserted ld_std, the register loads the current value of the
// loops iteration counter.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            std <= NTSC_422;
        else if (ld_std)
            std <= loops;
    end

//-----------------------------------------------------------------------------
// FSM
//
// The finite state machine is implemented in three processes, one for the
// current_state register, one to generate the next_state value, and the
// third to decode the current_state to generate the outputs.
 
//
// FSM: current_state register
//
// This code implements the current state register. It loads with the ACQ0
// state on reset and the next_state value with each rising clock edge.
//
always @ (posedge clk)
    if (ce)
        begin
            if (rst | reacquire)
                current_state <= ACQ0;
            else
                current_state <= next_state;
        end

//
// FSM: next_state logic
//
// This case statement generates the next_state value for the FSM based on
// the current_state and the various FSM inputs.
//
always @ (*)
    case(current_state)
        ACQ0:   next_state = ACQ1;

        ACQ1:   if (rx_trs)
                    next_state = ACQ2;
                else
                    next_state = ACQ1;

        ACQ2:   if (eav | (sav & composite))
                    next_state = ACQ1;
                else if (~sav)
                    next_state = ACQ2;
                else
                    begin
                        if (loops_eq_0)
                            next_state = ACQ3;
                        else if (loops_eq_1)
                            next_state = ACQ4;
                        else if (loops_eq_7)
                            next_state = ACQ5;
                        else
                            next_state = ACQ7;
                    end                     
                        
        ACQ3:   next_state = ACQ1;

        ACQ4:   next_state = ACQ1;

        ACQ5:   if (match)
                    next_state = ACQ6;
                else
                    next_state = ACQ0;

        ACQ6:   if (match)
                    next_state = LCK0;
                else if (loops_eq_7)
                    next_state = ACQ0;
                else
                    next_state = ACQ6;

        ACQ7:   if (match)
                    next_state = ACQ1;
                else
                    next_state = ACQ0;

        LCK0:   if (rx_trs)
                    next_state = LCK1;
                else
                    next_state = LCK0;

        LCK1:   if (eav)
                    next_state = LCK0;
                else if (sav & int_xyz_err)
                    next_state = ERR0;
                else if (sav & ~int_xyz_err)
                    next_state = LCK2;
                else
                    next_state = LCK1;

        LCK2:   if (match)
                    next_state = LCK3;
                else
                    next_state = ERR1;

        LCK3:   next_state = LCK0;
                
        ERR0:   next_state = ERR1;

        ERR1:   next_state = ERR2;

        ERR2:   if (max_errs)
                    next_state = ACQ0;
                else
                    next_state = LCK0;

        default: next_state = ACQ0;
    endcase

        
//
// FSM: outputs
//
// This block decodes the current state to generate the various outputs of the
// FSM.
//
always @ (*)
begin
    // Unless specifically assigned in the case statement, all FSM outputs
    // are low.
    clr_loops     = 1'b0;
    inc_loops     = 1'b0;
    clr_errcnt    = 1'b0;
    inc_errcnt    = 1'b0;
    clr_locked    = 1'b0;
    set_locked    = 1'b0;
    clr_hcnt      = 1'b0;
    ld_saved_hcnt = 1'b0;
    match_code    = 2'b00;
    ld_std        = 1'b0;
    ld_s4444      = 1'b0;
            
    case(current_state)     
        ACQ0:   begin
                    clr_locked = 1'b1;
                    clr_errcnt = 1'b1;
                    clr_loops = 1'b1;
                end

        ACQ2:   if (rx_xyz)
                    ld_s4444 = 1'b1;
                else
                    ld_s4444 = 1'b0;

        ACQ3:   begin
                    inc_loops = 1'b1;
                    clr_hcnt = 1'b1;
                end

        ACQ4:   begin
                    ld_saved_hcnt = 1'b1;
                    clr_hcnt = 1'b1;
                    inc_loops = 1'b1;
                end

        ACQ5:   begin
                    match_code = 2'b00;
                    inc_loops = 1'b1;
                    clr_hcnt = 1'b1;
                end

        ACQ6:   begin
                    inc_loops = 1'b1;
                    ld_std = 1'b1;
                    match_code = 2'b01;
                end

        ACQ7:   begin
                    match_code = 2'b00;
                    clr_hcnt = 1'b1;
                    inc_loops = 1'b1;
                end

        LCK0:   set_locked = 1'b1;

        LCK1:   if (rx_xyz & (std == PAL_4444 || std == NTSC_4444))
                    ld_s4444 = 1'b1;
                else
                    ld_s4444 = 1'b0;

        LCK2:   begin
                    match_code = 2'b10;
                    clr_hcnt = 1'b1;
                end

        LCK3:   clr_errcnt = 1'b1;

        ERR0:   clr_hcnt = 1'b1;

        ERR1:   inc_errcnt = 1'b1;
    endcase
end

//
// locked flip-flop
//
// The locked signal is generated by the FSM to indicate when it is properly
// synchronized with the incoming video stream. This flip-flop is set when the
// set_locked signal is asserted by the FSM and cleared when the clr_locked
// signal is asserted by the FSM.
//
always @ (posedge clk)
    if (ce)
        begin
            if (rst | clr_locked)
                locked <= 1'b0;
            else if (set_locked)
                locked <= 1'b1;
        end

//
// These statements generate the composite, eav, sav, and int_xyz_err sigals.
//
assign composite = ~vid_in[9];
assign eav = vid_in[6] & rx_xyz;
assign sav = ~vid_in[6] & rx_xyz;
assign int_xyz_err = (std == NTSC_4444 || std == PAL_4444) ? 
                      rx_xyz_err_4444 : rx_xyz_err;

//
// These statements decode the loops interation counter.
//
assign loops_eq_0 = (loops == 3'b000);
assign loops_eq_1 = (loops == 3'b001);
assign loops_eq_7 = (loops == 3'b111);

//
// This is the samples ROM. It contains the total number of samples on a video
// line for each of the eight supported video standards.
//
always @ (*)
    case(samples_adr)
        NTSC_422:       samples = CNT_NTSC_422;
        NTSC_422_WIDE:  samples = CNT_NTSC_422_WIDE;
        NTSC_4444:      samples = CNT_NTSC_4444;
        PAL_422:        samples = CNT_PAL_422;
        PAL_422_WIDE:   samples = CNT_PAL_422_WIDE;
        PAL_4444:       samples = CNT_PAL_4444;
    default:            samples = 0;
endcase

//
// This code implements a MUX to generate the address into the samples counter.
// This address can come from either the loops counter or the std register
// depending on the MSB of the match_code from the FSM.
//
assign samples_adr = match_code[1] ? std : loops;

//
// This code implements the comparator that generates the match input to the
// FSM. It can compare hcnt to saved_hcnt, hcnt to the output of the samples
// ROM, or saved_hcnt to the output of the samples ROM depending the match_code
// value.
//
assign cmp_a = match_code[0] ? samples : hcnt;
assign cmp_b = match_code[1] ? samples : saved_hcnt;
assign match = cmp_a == cmp_b;

 
//
// Output register for s4444 signal
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            s4444 <= 1'b1;
        else if (ld_s4444 & ~int_xyz_err)
            s4444 <= vid_in[5];
    end

//
// vid_std output register
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            vid_std <= 3'b000;
        else if (set_locked)
            vid_std <= std;
    end

assign xyz_err = int_xyz_err;

endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/*
This module does a 16-bit CRC calculation.

The calculation is a standard CRC16 calculation with a polynomial of x^16 + x^12
+ x^5 + 1. The function considers the LSB of the video data as the first bit
shifted into the CRC generator, although the implementation given here is a
fully parallel CRC, calculating all 16 CRC bits from the 10-bit video data in
one clock cycle.  

The assignment statements have all be optimized to use 4-input XOR gates
wherever possible to fit efficiently in the Xilinx FPGA architecture.

There are two input ports: c and d. The 16-bit c port must be connected to the
CRC "accumulation" register hold the last calculated CRC value. The 10-bit d
port is connected to the video stream.

The output port, crc, must be connected to the input of CRC "accumulation"
register.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_edh_crc16 (
    input  wire [15:0]      c,      // current CRC value
    input  wire [9:0]       d,      // input data word
    output wire [15:0]      crc     // new calculated CRC value
);

//-----------------------------------------------------------------------------
// Signal definitions
//
wire t1;  // intermediate product term used several times


assign t1 = d[4] ^ c[4] ^ d[0] ^ c[0];

assign crc[0]  = c[10] ^ crc[12];
assign crc[1]  = c[11] ^ d[0] ^ c[0] ^ crc[13];
assign crc[2]  = c[12] ^ d[1] ^ c[1] ^ crc[14];
assign crc[3]  = c[13] ^ d[2] ^ c[2] ^ crc[15];
assign crc[4]  = c[14] ^ d[3] ^ c[3];
assign crc[5]  = c[15] ^ t1;
assign crc[6]  = d[0] ^ c[0] ^ crc[11];
assign crc[7]  = d[1] ^ c[1] ^ crc[12];
assign crc[8]  = d[2] ^ c[2] ^ crc[13];
assign crc[9]  = d[3] ^ c[3] ^ crc[14];
assign crc[10] = t1 ^ crc[15];
assign crc[11] = d[5] ^ c[5] ^ d[1] ^ c[1];
assign crc[12] = d[6] ^ c[6] ^ d[2] ^ c[2];
assign crc[13] = d[7] ^ c[7] ^ d[3] ^ c[3];
assign crc[14] = d[8] ^ c[8] ^ t1;
assign crc[15] = d[9] ^ c[9] ^ crc[11];

endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/* 
This module calculates the active picture and full-frame CRC values. The ITU-R
BT.1304 and SMPTE RP 165-1994 standards define how the two CRC values are to be
calculated.

The module uses the vertical line count (vcnt) input, the field bit (f), the
horizontal blanking interval bit (h), and the eav_next, sav_next, and xyz_word
inputs to determine which samples to include in the two CRC calculations.

The calculation is a standard CRC16 calculation with a polynomial of x^16 + x^12
+ x^5 + 1. The function considers the LSB of the video data as the first bit
shifted into the CRC generator, although the implementation given here is a
fully parallel CRC, calculating all 16 CRC bits from the 10-bit video data in
one clock cycle.  The CRC calculation is done is the edh_crc16 module. It is 
instanced twice, once for the full-frame calculation and once for the active-
picture calculation.    

For each CRC calculation, a valid bit is also generated. After reset the valid
bits will be negated until the locked input from the video decoder is asserted.
The valid bits remain asserted even if locked is negated. However, the valid
bits will be negated for one filed if the locked signal rises during a CRC
calculation, indicating that the video decoder has re-synchronized.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_edh_crc #(
    parameter VCNT_WIDTH    = 10)
(
    input  wire                     clk,            // clock input
    input  wire                     ce,             // clock enable
    input  wire                     rst,            // sync reset input
    input  wire                     f,              // field bit
    input  wire                     h,              // horizontal blanking bit
    input  wire                     eav_next,       // asserted when next sample begins EAV symbol
    input  wire                     xyz_word,       // asserted when current word is the XYZ word of a TRS
    input  wire [9:0]               vid_in,         // video data
    input  wire [VCNT_WIDTH-1:0]    vcnt,           // vertical line count
    input  wire [2:0]               std,            // indicates the video standard
    input  wire                     locked,         // asserted when flywheel is locked
    output wire [15:0]              ap_crc,         // calculated active picture CRC
    output wire                     ap_crc_valid,   // asserted when CRC is valid
    output wire [15:0]              ff_crc,         // calculated full-frame CRC
    output wire                     ff_crc_valid    // asserted when CRC is valid
);


//-----------------------------------------------------------------------------
// Parameter definitions
//
localparam VCNT_MSB      = VCNT_WIDTH - 1;       // MS bit # of vcnt

//
// This group of parameters defines the encoding for the video standards output
// code.
//
localparam [2:0]
    NTSC_422        = 3'b000,
    NTSC_INVALID    = 3'b001,
    NTSC_422_WIDE   = 3'b010,
    NTSC_4444       = 3'b011,
    PAL_422         = 3'b100,
    PAL_INVALID     = 3'b101,
    PAL_422_WIDE    = 3'b110,
    PAL_4444        = 3'b111;

//
// This group of parameters defines the line numbers that begin and end the
// two CRC intervals. Values are given for both fields and for both NTSC and
// PAL.
//
localparam NTSC_FLD1_AP_FIRST    =  21;
localparam NTSC_FLD1_AP_LAST     = 262;
localparam NTSC_FLD1_FF_FIRST    =  12;
localparam NTSC_FLD1_FF_LAST     = 271;
    
localparam NTSC_FLD2_AP_FIRST    = 284;
localparam NTSC_FLD2_AP_LAST     = 525;
localparam NTSC_FLD2_FF_FIRST    = 275;
localparam NTSC_FLD2_FF_LAST     =   8;

localparam PAL_FLD1_AP_FIRST     =  24;
localparam PAL_FLD1_AP_LAST      = 310;
localparam PAL_FLD1_FF_FIRST     =   8;
localparam PAL_FLD1_FF_LAST      = 317;

localparam PAL_FLD2_AP_FIRST     = 336;
localparam PAL_FLD2_AP_LAST      = 622;
localparam PAL_FLD2_FF_FIRST     = 321;
localparam PAL_FLD2_FF_LAST      =   4;
    
//-----------------------------------------------------------------------------
// Signal defintions
//
wire                    ntsc;                   // 1 = NTSC, 0 = PAL
reg     [15:0]          ap_crc_reg = 16'b0;     // active picture CRC register
reg     [15:0]          ff_crc_reg = 16'b0;     // full field cRC register
wire    [15:0]          ap_crc16;               // active picture CRC calc output
wire    [15:0]          ff_crc16;               // full field CRC calc output
reg                     ap_region = 1'b0;       // asserted during active picture CRC interval
reg                     ff_region = 1'b0;       // asserted during full field CRC interval
reg     [VCNT_MSB:0]    ap_start_line;          // active picture interval start line
reg     [VCNT_MSB:0]    ap_end_line;            // active picture interval end line
reg     [VCNT_MSB:0]    ff_start_line;          // full field interval start line
reg     [VCNT_MSB:0]    ff_end_line;            // full field interval end line
wire                    ap_start;               // result of comparing ap_start_line with vcnt
wire                    ap_end;                 // result of comparing ap_end_line with vcnt
wire                    ff_start;               // result of comparing ff_start_line with vcnt
wire                    ff_end;                 // result of comparing ff_end_line with vcnt
wire                    sav;                    // asserted during XYZ word of SAV symbol
wire                    eav;                    // asserted during XYZ word of EAV symbol
wire                    ap_crc_clr;             // clears the active picture CRC register
wire                    ff_crc_clr;             // clears the full field CRC register
reg     [9:0]           clipped_vid;            // output of video clipper function
reg                     ap_valid = 1'b0;        // ap_crc_valid internal signal
reg                     ff_valid = 1'b0;        // ff_crc_valid internal signal
reg                     prev_locked = 1'b0;     // locked input signal delayed once clock
wire                    locked_rise;            // asserted on rising edge of locked

//
// video clipper
//
// The SMPTE and ITU specifications require that the video data values used
// by the CRC calculation have the 2 LSBs both be ones if the 8 MSBs are all
// ones.
//
always @ (*)
    begin
        clipped_vid[9:2] = vid_in[9:2];
        if (&vid_in[9:2])
            clipped_vid[1:0] = 2'b11;
        else
            clipped_vid[1:0] = vid_in[1:0];
    end

//
// decoding
//
// These assignments generate the ntsc, eav, and sav signals.
//
assign ntsc = (std == NTSC_422) || (std == NTSC_INVALID) ||
              (std == NTSC_422_WIDE) || (std == NTSC_4444);
assign sav = ~vid_in[6] & xyz_word;
assign eav = vid_in[6] & xyz_word;

//
// ap_region and ff_region generation
// 
// This code determines when the current video signal is within the active
// picture and full field CRC regions. Note that since the F bit changes before
// the end of the EDH full-field time period, the ff_end_line value is set
// to the opposite field value in the assignments below. That is, if F is low,
// normally indicating Field 1, the ff_end_line is assigned to xxx_FLD2_FF_LAST,
// not xxx_FLD1_FF_LAST as might be expected.
//

// This section looks up the starting and ending line numbers of the two CRC
// regions based on the current field and video standard.
always @ (*)
    if (ntsc)
        begin
            if (~f)
                begin
                    ap_start_line = NTSC_FLD1_AP_FIRST;
                    ap_end_line =   NTSC_FLD1_AP_LAST;
                    ff_start_line = NTSC_FLD1_FF_FIRST;
                    ff_end_line =   NTSC_FLD2_FF_LAST;
                end
            else
                begin
                    ap_start_line = NTSC_FLD2_AP_FIRST;
                    ap_end_line =   NTSC_FLD2_AP_LAST;
                    ff_start_line = NTSC_FLD2_FF_FIRST;
                    ff_end_line =   NTSC_FLD1_FF_LAST;
                end
        end
    else
        begin
            if (~f)
                begin
                    ap_start_line = PAL_FLD1_AP_FIRST;
                    ap_end_line =   PAL_FLD1_AP_LAST;
                    ff_start_line = PAL_FLD1_FF_FIRST;
                    ff_end_line =   PAL_FLD2_FF_LAST;
                end
            else
                begin
                    ap_start_line = PAL_FLD2_AP_FIRST;
                    ap_end_line =   PAL_FLD2_AP_LAST;
                    ff_start_line = PAL_FLD2_FF_FIRST;
                    ff_end_line =   PAL_FLD1_FF_LAST;
                end
        end

// These four statements compare the current vcnt value to the starting and
// ending line numbers of the two CRC regions.          
assign ap_start = vcnt == ap_start_line;
assign ap_end =   vcnt == ap_end_line;
assign ff_start = vcnt == ff_start_line;
assign ff_end =   vcnt == ff_end_line;

// This code block generates the ap_region signal indicating when the current
// position is in the active-picture CRC region.
assign ap_crc_clr = ap_start & xyz_word & sav;

always @ (posedge clk)
    if (ce)
        begin
            if (rst)
                ap_region <= 1'b0;
            else if (ap_crc_clr)
                ap_region <= 1'b1;
            else if (ap_end & eav_next)
                ap_region <= 1'b0;
        end


// This code block generates teh ff_region signal indicating when the current
// position is in the full-field CRC region.
assign ff_crc_clr = ff_start & xyz_word & eav;

always @ (posedge clk)
    if (ce)
        begin
            if (rst)
                ff_region <= 1'b0;
            else if (ff_crc_clr)
                ff_region <= 1'b1;
            else if (ff_end & eav_next)
                ff_region <= 1'b0;
        end

//
// Valid bit generation
//
// This code generates the two CRC valid bits.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            prev_locked <= 1'b0;
        else
            prev_locked <= locked;
    end

assign locked_rise = ~prev_locked & locked;

always @ (posedge clk)
    if (ce)
        begin
            if (rst | locked_rise)
                ap_valid <= 1'b0;
            else if (locked & ap_crc_clr)
                ap_valid <= 1'b1;
        end

always @ (posedge clk)
    if (ce)
        begin
            if (rst | locked_rise)
                ff_valid <= 1'b0;
            else if (locked & ff_crc_clr)
                ff_valid <= 1'b1;
        end

//
// CRC calculations and registers
//
// Each CRC is calculated separately by an edh_crc16 module. Associted with
// each is a register. The register acts as an accumulation register and is
// fed back into the edh_crc16 module to be combined with the next video
// word. Enable logic for the registers determines which words are accumulated
// into the CRC value by controlling the load enables to the two registers.
//

// Active-picture CRC calculator
v_smpte_uhdsdi_v1_0_5_edh_crc16 apcrc16 (
    .c      (ap_crc_reg),
    .d      (clipped_vid),
    .crc    (ap_crc16)
);

// Active-picture CRC register
always @ (posedge clk)
    if (ce)
        begin
            if (rst | ap_crc_clr)
                ap_crc_reg <= 0;
            else if (ap_region & ~h)
                ap_crc_reg <= ap_crc16;
        end
        
// Full-field CRC calculator
v_smpte_uhdsdi_v1_0_5_edh_crc16 ffcrc16 (
    .c      (ff_crc_reg),
    .d      (clipped_vid),
    .crc    (ff_crc16)
);

// Full-field CRC register
always @ (posedge clk)
    if (ce)
        begin
            if (rst | ff_crc_clr)
                ff_crc_reg <= 0;
            else if (ff_region)
                ff_crc_reg <= ff_crc16;
        end
        
//
// Output assignments
//
assign ap_crc = ap_crc_reg;
assign ap_crc_valid = ap_valid;
assign ff_crc = ff_crc_reg;
assign ff_crc_valid = ff_valid;
                        
endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/* 
This module keeps a running count of the number of video fields that contain
an EDH error. By default, the counter is a 24-bit counter, but the counter
width can be modified by changing the ERROR_COUNT_WIDTH parameter.

A 16-bit wide error flag input vector, flags, allows up to sixteen different 
error flags to be monitored by the error counter. Each of the 16 error flags
has an associated flag_enable signal. If a flag_enable signal is low, the
corresponding error flag is ignored by the counter. If any enabled error flag
is asserted at the next EDH packet (edh_next asserted), the error counter is
incremented. There is no latching mechanism on the error flags -- they must
remain asserted until edh_next is asserted in order to increment the counter.

The error counter will saturate and will not roll over when it reaches the
maximum count. The counter is cleared on reset and when clr_errcnt is asserted.

A count enable input, count_en, is also provided to enable and disable the
error counter. This can be used to disable the counter when the video decoder
is not synchronized to the video stream. 
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_edh_errcnt #(
    parameter ERROR_COUNT_WIDTH = 24,
    parameter FLAGS_WIDTH       = 16)
(
    input  wire                         clk,            // clock input
    input  wire                         ce,             // clock enable
    input  wire                         rst,            // sync reset input
    input  wire                         clr_errcnt,     // clears the error counter
    input  wire                         count_en,       // enables error counter when high
    input  wire [FLAGS_WIDTH-1:0]       flag_enables,   // specifies which error flags cause the counter to increment
    input  wire [FLAGS_WIDTH-1:0]       flags,          // error flag inputs
    input  wire                         edh_next,       // counter increments on edh_next asserted
    output wire [ERROR_COUNT_WIDTH-1:0] errcnt          // error counter
);


//-----------------------------------------------------------------------------
// Parameter definitions
//

parameter ERRFLD_MSB    = ERROR_COUNT_WIDTH - 1;     // MS bit # of error counter
parameter FLAGS_MSB     = FLAGS_WIDTH - 1;      // MS bit # of error flag field
    
//-----------------------------------------------------------------------------
// Signal definitions
//
wire    [FLAGS_MSB:0]   enabled_flags;  // error flags after ANDing with enables
wire                    err_in_field;   // OR of all enabled error flags
wire                    errcnt_tc;      // asserted when errcnt reaches terminal count
wire    [ERRFLD_MSB:0]  next_count;     // current error count + 1
reg     [ERRFLD_MSB:0]  cntr = 0;       // actual error counter

//
// flag enabling logic
//
assign enabled_flags = flags & flag_enables;
assign err_in_field = |enabled_flags;

//
// error counter
//
assign next_count = cntr + 1;
assign errcnt_tc = next_count == 0;
    
always @ (posedge clk)
    if (ce)
        begin
            if (rst | clr_errcnt)
                cntr <= 0;
            else if (edh_next & ~errcnt_tc & err_in_field & count_en)
                cntr <= next_count;
        end
        
//
// output assignment
//
assign errcnt = cntr;
             
endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/* 
This module calculates new values for the EDH flags to be inserted into the
next generated EDH packet.

The flags captured from the received EDH packet are combined with the error 
flags generated by other modules and by internal EDH flags generated by
comparing the received CRC checkwords with the CRC values calculated by the
edh_crc module. 

The new flag values are calculated as the edh_gen module generates a new EDH
packet. The edh_flags module supplies the EDH flags to the edh_gen module over
a flag bus. The edh_gen module requests which set of EDH flags (ap, ff, or 
anc) is supplied over the flag bus with the ap_flag_word, ff_flag_word, and
anc_flag_word signals. The three flag sets are also captured and remain valid
on the ap_flags, ff_flags, and anc_flags output ports through the following
field.

edh flag (error detected here)

The edh flag for the ap and ff flag sets is asserted when the received and
calculated CRC values do not match. The edh flag will not be asserted if 
either CRC value is not valid or if an error was detected with the received 
EDH packet. A packet error is considered to have occurred if the EDH packet is 
missing or if the EDH packet contained a format or parity error. The checksum 
of the EDH packet is not checked soon enough to allow its consideration in 
this flag calculation.

The edh flag for the anc flag set is supplied as an input (anc_edh_local) to
this module. This normally comes from the edh_rx module and is asserted if any
ANC packet in the previous field had a parity or checksum error.

eda flag (error detected already)

The eda flag of each of the three flag sets is asserted if either the eda or 
the edh flag from the received EDH packet is asserted.

ues flag (unknown error status)

The ues flag for the ap and ff flag set is asserted if the ues flag in the
received EDH packet is asserted, if an error is detected in the EDH packet, or
if the corresponding CRC valid bit is not asserted.

The ues flag for the anc flag set is asserted if the ues flag in the anc flag
set of the received EDH packet is asserted, if an error is detected in the
received EDH packet, or if the anc_ues_local input signal is asserted.

idh flag (internal error detected here)

The idh flag for each flag set is set if the corresponding input signal
(ap_idh_local, ff_idh_local, and anc_idh_local), is asserted.

ida flag (internal error detected already)

The ida flag for each flag set is set if the either the idh or ida flags from
the received EDH packet are set.

The module has an input signal called receive_mode. If this signal is not
asserted, then the way the flags are generated is modified. The module assumes
that no EDH packets are being received by the processor (for example, if this
module is at the head end of a video chain). This input effectively disables
received packet errors from causing any of the flags to be asserted.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_edh_flags (
    input  wire                 clk,                // clock input
    input  wire                 ce,                 // clock enable input
    input  wire                 rst,                // reset input
    input  wire                 receive_mode,       // asserted if receiver is active
    input  wire                 ap_flag_word,       // asserted to select AP flag word on flag_bus
    input  wire                 ff_flag_word,       // asserted to select FF flag word on flag_bus
    input  wire                 anc_flag_word,      // asserted to select ANC flag word on flag_bus
    input  wire                 edh_missing,        // EDH packet missing from data stream
    input  wire                 edh_parity_err,     // EDH packet parity error
    input  wire                 edh_format_err,     // EDH packet format error
    input  wire                 rx_ap_crc_valid,    // received AP CRC valid bit
    input  wire [15:0]          rx_ap_crc,          // received AP CRC
    input  wire                 rx_ff_crc_valid,    // received FF CRC valid bit
    input  wire [15:0]          rx_ff_crc,          // received FF CRC
    input  wire [4:0]           rx_ap_flags,        // received AP flags
    input  wire [4:0]           rx_ff_flags,        // received FF flags
    input  wire [4:0]           rx_anc_flags,       // received ANC flags
    input  wire                 anc_edh_local,      // local ANC EDH flag input
    input  wire                 anc_idh_local,      // local ANC IDH flag input
    input  wire                 anc_ues_local,      // local ANC UES flag input
    input  wire                 ap_idh_local,       // local AP IDH flag input
    input  wire                 ff_idh_local,       // local FF IDH flag input
    input  wire                 calc_ap_crc_valid,  // calculated AP CRC valid bit
    input  wire [15:0]          calc_ap_crc,        // calculated AP CRC
    input  wire                 calc_ff_crc_valid,  // calculated FF CRC valid bit
    input  wire [15:0]          calc_ff_crc,        // calculated FF CRC
    output wire [4:0]           flags,              // flag output bus
    output reg  [4:0]           ap_flags = 0,       // holds AP flags from last EDH packet sent
    output reg  [4:0]           ff_flags = 0,       // holds FF flags from last EDH packet sent
    output reg  [4:0]           anc_flags           // holds ANC flags from last EDH packet sent
);


//-----------------------------------------------------------------------------
// Parameter definitions
//
// This set of parameters defines the bit positions of the five flags in each
// flag set.
//
localparam  EDH_BIT = 0;
localparam  EDA_BIT = 1;
localparam  IDH_BIT = 2;
localparam  IDA_BIT = 3;
localparam  UES_BIT = 4;

//-----------------------------------------------------------------------------
// Signal definitions
//
wire        ap_edh;     // internally generated ap_edh flag
wire        ap_ues;     // internally generated ap_ues flag
wire        ff_edh;     // internally generated ff_edh flag
wire        ff_ues;     // internally generated ff_uew flag
wire        packet_err; // asserted on a received EDH packet error

//
// EDH packet error detection
//
assign packet_err = (edh_missing | edh_parity_err | edh_format_err) & receive_mode;

//
// AP flag generation
//
assign ap_edh = ~packet_err & calc_ap_crc_valid & rx_ap_crc_valid & 
                (calc_ap_crc != rx_ap_crc);
assign ap_ues = ~rx_ap_crc_valid & receive_mode;

//
// FF flag generation
//
assign ff_edh = ~packet_err & calc_ff_crc_valid & rx_ff_crc_valid & 
                (calc_ff_crc != rx_ff_crc);
assign ff_ues = ~rx_ff_crc_valid & receive_mode;

//
// flags bus generation
//
assign flags[EDH_BIT] = (ap_flag_word & ap_edh) |
                        (ff_flag_word & ff_edh) |
                        (anc_flag_word & anc_edh_local);

assign flags[EDA_BIT] = ~packet_err & (
                        (ap_flag_word & (rx_ap_flags[EDH_BIT] | rx_ap_flags[EDA_BIT])) |
                        (ff_flag_word & (rx_ff_flags[EDH_BIT] | rx_ff_flags[EDA_BIT])) |
                        (anc_flag_word & (rx_anc_flags[EDH_BIT] | rx_anc_flags[EDA_BIT])));
                        

assign flags[IDH_BIT] = (ap_flag_word & ap_idh_local) |
                        (ff_flag_word & ff_idh_local) |
                        (anc_flag_word & anc_idh_local);

assign flags[IDA_BIT] = ~packet_err & ( 
                        (ap_flag_word & (rx_ap_flags[IDH_BIT] | rx_ap_flags[IDA_BIT])) |
                        (ff_flag_word & (rx_ff_flags[IDH_BIT] | rx_ff_flags[IDA_BIT])) |
                        (anc_flag_word & (rx_anc_flags[IDH_BIT] | rx_anc_flags[IDA_BIT])));
  
assign flags[UES_BIT] = packet_err |
                        (ap_flag_word & (ap_ues | (receive_mode & rx_ap_flags[UES_BIT]))) | 
                        (ff_flag_word & (ff_ues | (receive_mode & rx_ff_flags[UES_BIT]))) |
                        (anc_flag_word & (anc_ues_local | (receive_mode & rx_anc_flags[UES_BIT])));

//
// flag registers
//
// These register capture the three flag sets as the EDH packet is being
// generated and retain the error flag values until the next EDH packet is
// generated. This allows the error flag values to be observed by some other
// module or processor.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            ap_flags <= 0;
        else if (ap_flag_word)
            ap_flags <= flags;
    end

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            ff_flags <= 0;
        else if (ff_flag_word)
            ff_flags <= flags;
    end

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            anc_flags <= 0;
        else if (anc_flag_word)
            anc_flags <= flags;
    end

endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/*
Module description:

This module implements the field related functions for the video flywheel.
There are two main field related functions included in this module. The first
is the F bit. This bit indicates the field that is currently active. The other
function is the received field transition detector. This function determines
when the received video transition from one field to the next.

The inputs to this module are:

clk: clock input

rst: synchronous reset input

ce: clock enable

ld_f: When this input is asserted, the F flip-flop is loaded with the 
current field value.

inc_f: When this input is asserted the F flip-flop is toggled.

eav_next: Must be asserted the clock cycle before the first word of an EAV 
symbol is processed by the flywheel.

rx_field: This is the F bit from the XYZ word of the input video stream. This
input is only valied when rx_xyz is asserted.

rx_xyz: Asserted when the flywheel is processing the XYZ word of a TRS symbol.

The outputs of this module are:

f: Current field bit

new_rx_field: Asserted for when a field transition is detected. This signal
will be asserted for the entire duration of the first line of a new field.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_edh_fly_field (
    input  wire             clk,            // clock input
    input  wire             rst,            // sync reset input
    input  wire             ce,             // clock enable
    input  wire             ld_f,           // loads the F bit
    input  wire             inc_f,          // toggles the F bit
    input  wire             eav_next,       // asserted when next word is first word of EAV
    input  wire             rx_field,       // F bit from received XYZ word
    input  wire             rx_xyz,         // asserted during XYZ word of received TRS symbol
    output reg              f = 1'b0,       // field bit
    output wire             new_rx_field    // asserted when received field changes
);

//-----------------------------------------------------------------------------
// Signal definitions
//

reg rx_f_now = 1'b0;    // holds F bit from most recent XYZ word
reg rx_f_prev = 1'b0;   // holds F bit from previous XYZ word

//
// field bit
//                                  
// The field bit keep track of the current field (even or odd). It loads from
// the rx_f_now value when ld_f is asserted during the time the flywheel is
// synchronizing with the incoming video. Otherwise, it toggles at the
// beginning of each field.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            f <= 1'b0;
        else
        begin
            if (ld_f) 
                f <= rx_f_now;
            else if (eav_next & inc_f)
                f <= ~f;
        end
    end
                    

//
// received video new field detection
//
// The rx_f_now register holds the field value for the current field.
// The rx_f_prev register holds the field value from the previous field. If
// there is a difference between these two registers, the new_rx_field signal
// is asserted. This informs the FSM that the received video has transitioned
// from one field to the next.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
        begin
            rx_f_now  <= 1'b0;
            rx_f_prev <= 1'b0;
        end
        else if (rx_xyz)
        begin
            rx_f_now  <= rx_field;
            rx_f_prev <= rx_f_now;
        end
    end

assign new_rx_field = rx_f_now ^ rx_f_prev;

endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/*
Module description:

This module implement the finite state machine for the video flywheel. The FSM
synchronizes to the received video stream in two steps. 

First, the FSM syncs horizontally by waiting for a received SAV symbol. This
causes the FSM to reset the horizontal counter in the fly_hcnt module. After
receiving a SAV, the FSM checks the results by comparing the position of the
next received SAV with the expected location. If they match, then the FSM
assumes it is synchronized horizontally.

Next, the FSM syncs vertically. This is done by waiting for the received video
to change fields, as indicated by the F bit in the received TRS symbols. When
a field transition occurs, the vertical line counter in the fly_vcnt module
is updated to the correct count and the FSM asserts the lock signal to indicate
that it is synchronized with the video.

Once locked, the error detection logic continually compares the position and
contents of the received TRS symbols with the flywheel generated TRS symbols.
When the number of lines containing mismatched TRS symbols exceeds the MAX_ERRS
value over the observation window (defaults to 8 lines), the resync signal is
asserted. This causes the state machine to negate the lock signal and go
through the synchronization process again.

The FSM is designed to accomodate synchronous switching as defined by SMPTE
RP 168. This recommended practice defines one line per field in the vertical
blanking interval when it is allowed to switch the video stream between two
synchronous video sources. The video sources must be synchronized but minor
displacements of the EAV symbol on these switching lines is tolerated since the
switch sometimes induces minor errors on the line. During the switching
interval lines, errors in the position of the EAV symbol cause the FSM to
update the horizontal counter value immediately without going through the
normal synchronization process.

The FSM normally verifies that the received TRS symbol matches the flywheel 
generated TRS symbol by comparing the F, V, and H bits. However, previous
versions of the NTSC digital component video standards allowed the V bit to
fall early, anywhere between line 10 and line 20 for field 1 and lines
273 to 283 for the second field. These standards now specify that the V bit
must fall one lines 20 and 283, but also recommend that new equipment be
tolerant of the signal falling early. The FSM ignores the V bit transitioning
early.

The inputs to this module are:

clk: clock input

ce: clock enable

rst: synchronous reset

vid_f: Input video bit that carries the F signal during XYZ words.

vid_v: Input video bit that carries the V signal during XYZ words.

vid_h: Input video bit that carries the H signal during XYZ words.

rx_xyz: Asserted when the XYZ word is being processed by the flywheel.

fly_eav: Asserted when the XYZ word of an EAV is being generated by the flywheel.

fly_sav: Asserted when the XYZ word of an SAV is being generated by the flywheel.

fly_eav_next: Asserted the clock cycle before it is time for the flywheel to
generated an EAV symbol.

rx_eav: Asserted when the flywheel is receiving the XYZ word of an EAV.

rx_sav: Asserted when the flywheel is receiving the XYZ word of an SAV.

rx_eav_first: Asserted when the flywheel is receiving the first word of an EAV.

new_rx_field: From the new field detector in fly_field module. Asserted for the
duration of the first line of a new field.

xyz_err: Asserted when an error is detected in the received XYZ word.

std_locked: Asserted when autodetect module is locked to input video stream's
standard.

switch_interval: Asserted when the current video line is a synchronous
switching line.

xyz_f: F bit from flywheel generated XYZ word.

xyz_v: V bit from flywheel generated XYZ word.

xyz_h: H bit from flywheel generated XYZ word.

sloppy_v: Asserted one those lines when the status of the V bit is ambiguous.

The outputs of this module are:

lock: Asserted when the flywheel is locked to the input video stream.

ld_vcnt: Asserted during resync cycle to cause the vertical counter to load
with a new value at the start of a new field.

inc_vcnt: Asserted to cause the vertical counter to increment.

clr_hcnt: Asserted to cause the horizontal counter to reset.

resync_hcnt: Asserted during synchronous switching to cause the the horizontal
counter to update to the position of the new input video stream.

ld_std: Loads the flywheel's int_std register with the current video standard
code.

ld_f: Asserted during resynchronization to load the F bit.

clr_switch: This output clears the flywheel's switching_interval signal.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_edh_fly_fsm (
    input  wire         clk,            // clock input
    input  wire         ce,             // clock enable
    input  wire         rst,            // sync reset input
    input  wire         vid_f,          // video data F bit
    input  wire         vid_v,          // video data V bit
    input  wire         vid_h,          // video data H bit
    input  wire         rx_xyz,         // asserted during the XYZ word of a TRS symbol
    input  wire         fly_eav,        // asserted on XYZ word of flywheel generated EAV
    input  wire         fly_sav,        // asserted on XYZ word of flywheel generated SAV
    input  wire         fly_eav_next,   // asserted when flywheel will generate EAV starting with next word
    input  wire         fly_sav_next,   // asserted when flywheel will generate SAV starting with next word
    input  wire         rx_eav,         // asserted on XYZ word of received EAV
    input  wire         rx_sav,         // asserted on XYZ word of received SAV
    input  wire         rx_eav_first,   // asserted during the first word of a received EAV
    input  wire         new_rx_field,   // asserted when received field changes
    input  wire         xyz_err,        // asserted on parity error in XYZ word
    input  wire         std_locked,     // asserted by the autodetect unit when locked to video std
    input  wire         switch_interval,// asserted when in the synchronous switching interval
    input  wire         xyz_f,          // flywheel generated XYZ word F bit
    input  wire         xyz_v,          // flywheel generated XYZ word V bit
    input  wire         xyz_h,          // flywheel generated XYZ word H bit
    input  wire         sloppy_v,       // ignore V bit on XYZ comparison when asserted
    output reg          lock = 1'b0,    // asserted when flywheel is synchronized to video
    output reg          ld_vcnt,        // causes vcnt to load
    output reg          inc_vcnt,       // forces vcnt to increment during failed sync switch
    output reg          clr_hcnt,       // causes hcnt to clear
    output reg          resync_hcnt,    // reloads hcnt to SAV position during sync switch
    output reg          ld_std,         // loads the int_std register
    output reg          ld_f,           // loads the F bit
    output reg          clr_switch      // clears the switching_interval signal
);

//-----------------------------------------------------------------------------
// Parameter definitions
//

//
// This group of parameters defines the bit widths of various fields in the
// module.
//
// The ERRCNT_WIDTH must be big enough to generate a counter wide enough
// to accomodate error counts up to the MAX_ERRS value. It is recommended that
// one or two additional counts be available in the error counter above the
// MAX_ERRS value to prevent wrap around errors.
//
// The LSHIFT_WIDTH value dictates the number of lines in the error window. The
// default value of 32 provides a window of 32 lines over which the resync logic
// examines lines containing TRS errors. If the number of lines with errors
// exceeds MAX_ERRS over the error window, the FSM will be forced to
// resynchronize. It is recommended that the error window be larger than the
// vertical blanking interval and that the MAX_ERRS value never be set larger
// than 2, otherwise the flywheel will fail to resynchronize to a video stream
// that is offset by just a few lines from the current flywheel position.
//
//
parameter ERRCNT_WIDTH  = 3;                   // Width of errcnt
parameter LSHIFT_WIDTH  = 32;                  // Errored line shifter
 
localparam ERRCNT_MSB   = ERRCNT_WIDTH - 1;    // MS bit # of errcnt
localparam LSHIFT_MSB   = LSHIFT_WIDTH - 1;    // MS bit # of errored line shifter

parameter MAX_ERRS      = 2;                   // Max number of TRS errors allowed in window


//
// This group of parameters defines the states of the FSM.
//                                              
localparam STATE_WIDTH   = 4;
localparam STATE_MSB     = STATE_WIDTH - 1;

localparam [STATE_WIDTH-1:0]
    LOCK    = 0,
    HSYNC1  = 1,
    HSYNC2  = 2,
    FSYNC1  = 3,
    FSYNC2  = 4,
    FSYNC3  = 5,
    UNLOCK  = 6,
    SWITCH1 = 7,
    SWITCH2 = 8,
    SWITCH3 = 9,
    SWITCH4 = 10,
    SWITCH5 = 11,
    SWITCH6 = 12;

         
//-----------------------------------------------------------------------------
// Signal definitions
//

reg     [STATE_MSB:0]   current_state = UNLOCK;     // FSM current state
reg     [STATE_MSB:0]   next_state;                 // FSM next state
wire                    resync;                     // asserted to cause flywheel to resync
reg                     clr_resync;                 // reset resync logic
reg     [ERRCNT_MSB:0]  errcnt = 0;                 // resync error counter
reg     [LSHIFT_MSB:0]  lerr_shifter = 0;           // errored line shift register
reg                     line_err = 1'b0;            // SR flip-flop indicating error in this line
wire                    trs_err;                    // sets the line_err flip-flop
wire                    xyz_match;                  // asserted if flywheel XYZ word matches received data
reg                     set_lock;                   // sets the lock flip-flop
reg                     clr_lock;                   // clears the lock flip-flop
wire                    fly_xyz;                    // asserted when flywheel generates XYZ

//
// fly_xyz
//
// fly_xyz is asserted on the flywheel generated XYZ word
//
assign fly_xyz = fly_sav | fly_eav;

//
// lock
//
// This is the lock flip-flop. It is set and cleared by the state machine to
// indicate whether the flywheel is synchronized to the incoming video or not.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            lock <= 1'b0;
        else if (set_lock)
            lock <= 1'b1;
        else if (clr_lock)
            lock <= 1'b0;
    end

//
// resync logic
//
// The resync logic determines when it is time to resynchronize the flywheel.
// An SR flip-flop is set if a TRS error is detected on the current line. At
// the end of the line, when fly_eav_next is asserted, the contents of the SR
// flip-flop are shifted into the lerr_shifter and the flip-flop is cleared.
// 
// The lerr_shifter contains one bit for each line in the "window" over which
// the resync mechanism operates. The shifter shifts one bit position at the 
// end of each line. The output bit of the shifter will cause the errcnt to 
// decrement if it is asserted because a line with an error has moved out of
// the error window.
//
// The errcnt is a counter that increments at the end of every line in which
// a TRS error is detected (when the line_err SR flip-flop is asserted). It
// decrements if the output bit of the shifter is asserted. In this way,
// it keeps track of the number of lines in the current window that had TRS
// errors. If the errcnt value exceeds the maximum number of allowed errors in
// the window, the resync signal is asserted.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst | fly_eav_next | clr_resync)
            line_err <= 1'b0;
        else if (trs_err)
            line_err <= 1'b1;
    end
        
always @ (posedge clk)
    if (ce)
    begin
        if (rst | clr_resync)
            lerr_shifter <= 0;
        else if (fly_eav_next)
            lerr_shifter <= {lerr_shifter[LSHIFT_MSB - 1:0], line_err};
    end
        
always @ (posedge clk)
    if (ce)
    begin
        if (rst | clr_resync)
            errcnt <= 0;
        else if (fly_eav_next)
            begin
                if (line_err & !lerr_shifter[LSHIFT_MSB])
                    errcnt <= errcnt + 1;
                else if (!line_err & lerr_shifter[LSHIFT_MSB])
                    errcnt <= errcnt - 1;
            end
    end
        
assign resync = (errcnt >= MAX_ERRS);

//
// trs_err
//
// This signal is asserted when the received word is misplaced relative to the
// flywheel's TRS location or if the received TRS XYZ word doesn't match
// the flywheel's generated values. This signal tells resync logic than an
// error occurred.
//
assign trs_err = (~fly_xyz & rx_xyz) | 
                 (fly_xyz & rx_xyz & (~xyz_match | xyz_err));

//
// xyz_match logic
// 
// This logic compares the received XYZ word with the flywheel generated XYZ
// word to determine if they match. Only the F, V, and H bits of these words
// are compared. If the sloppy_v signal is asserted, then the V bit is ignored.
//

assign xyz_match = ~( vid_f ^ xyz_f |                   // F bit compare
                    ((vid_v ^ xyz_v) & ~sloppy_v) |     // V bit compare
                      vid_h ^ xyz_h);                   // H bit compare  

// FSM
//
// The finite state machine is implemented in three processes, one for the
// current_state register, one to generate the next_state value, and the
// third to decode the current_state to generate the outputs.
 
//
// FSM: current_state register
//
// This code implements the current state register. It loads with the HSYNC1
// state on reset and the next_state value with each rising clock edge.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            current_state <= UNLOCK;
        else
            current_state <= next_state;
    end

//
// FSM: next_state logic
//
// This case statement generates the next_state value for the FSM based on
// the current_state and the various FSM inputs.
//
always @ (*)
    case(current_state)
        LOCK:   if (~std_locked)
                    next_state = UNLOCK;
                else if (resync)
                    next_state = HSYNC1;
                else if (switch_interval)
                    next_state = SWITCH1;
                else
                    next_state = LOCK;
                

        HSYNC1: if (~rx_sav)
                    next_state = HSYNC1;
                else if (fly_sav)
                    next_state = FSYNC1;
                else
                    next_state = HSYNC2;

        HSYNC2: next_state = HSYNC1;

        FSYNC1: if (~fly_eav)
                    next_state = FSYNC1;
                else if (~rx_eav)
                    next_state = HSYNC1;
                else if (xyz_err)
                    next_state = FSYNC1;
                else
                    next_state = FSYNC2;

        FSYNC2: if (new_rx_field)
                    next_state = FSYNC3;
                else
                    next_state = FSYNC1;

        FSYNC3: next_state = LOCK;

        UNLOCK: if (~std_locked)
                    next_state = UNLOCK;
                else
                    next_state = HSYNC1;

        SWITCH1: if (~std_locked)
                    next_state = UNLOCK;
                 else if (rx_eav_first)
                    next_state = SWITCH2;
                 else if (fly_eav_next)
                    next_state = SWITCH5;
                 else
                    next_state = SWITCH1;

        SWITCH2: next_state = SWITCH3;

        SWITCH3: next_state = SWITCH4;

        SWITCH4: next_state = LOCK;

        SWITCH5: if (rx_eav_first)
                    next_state = LOCK;
                 else
                    next_state = SWITCH6;

        SWITCH6: if (rx_eav_first)
                    next_state = SWITCH2;
                 else if (fly_sav_next)
                    next_state = UNLOCK;
                 else
                    next_state = SWITCH6;
                    
        default: next_state = HSYNC1;
    endcase

        
//
// FSM: outputs
//
// This block decodes the current state to generate the various outputs of the
// FSM.
//
always @ (*)
begin
    // Unless specifically assigned in the case statement, all FSM outputs
    // are low.
    clr_resync      = 1'b0;
    ld_vcnt         = 1'b0;
    clr_hcnt        = 1'b0;
    resync_hcnt     = 1'b0;
    ld_vcnt         = 1'b0;
    set_lock        = 1'b0;
    clr_lock        = 1'b0;
    ld_std          = 1'b0;
    ld_f            = 1'b0;
    clr_switch      = 1'b0;
    inc_vcnt        = 1'b0;
                            
    case(current_state)     
        LOCK:   set_lock = 1'b1;

        HSYNC1: begin
                    clr_lock = 1'b1;
                    ld_std   = 1'b1;
                end

        HSYNC2: clr_hcnt  = 1'b1;

        FSYNC3: begin
                    ld_vcnt    = 1'b1;
                    ld_f       = 1'b1;
                    clr_resync = 1'b1;
                end

        UNLOCK: begin
                    clr_lock = 1'b1;
                    clr_switch = 1'b1;
                end

        SWITCH2: resync_hcnt = 1'b1;
                 
        SWITCH4: clr_switch = 1'b1;

        SWITCH6: if (fly_sav_next)
                    begin
                        clr_switch = 1'b1;
                        inc_vcnt   = 1'b1;
                    end
                else
                    begin
                        clr_switch = 1'b0;
                        inc_vcnt   = 1'b0;
                    end

    endcase
end

endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/* 
This module implements the horizontal logic for the video flywheel.

The module contains the horizontal counter. This counter keeps track of the
current horizontal position of the video. The module also generates the H 
signal. The H signal is asserted during the inactive portion of each scan line.

This module has the following inputs:

clk: clock input

rst: synchronous reset

ce: clock enable

clr_hcnt: When this input is asserted, the horizontal counter is cleared.

resync_hcnt: When this input is asserted, the horizontal counter is reloaded
with the position of the EAV symbol. This happens during synchronous switches.

std: The video standard input code.

The module generates the following outputs:

hcnt: This is the value of the horizontal counter and indicates the current
horizontal positon of the video.

eav_next: Asserted the clock cycle before it is time for the flywheel to
generate the first word of an EAV symbol.

sav_next: Asserted the clock cycle before it is time for the flywheel to 
generate the first word of an SAV symbol.

h: This is the horizontal blanking bit.

trs_word: A 2-bit code indicating which word of the TRS symbol should be
generated by the flywheel.

fly_trs: Asserted during the first word of a flywheel generated TRS symbol.

fly_eav: Asserted during the XYZ word of a flywheel generated EAV symbol.

fly_sav: Asserted during the XYZ word of a flywheel generated SAV symbol.
*/

`timescale 1ns / 1ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_edh_fly_horz #(
    parameter HCNT_WIDTH = 12)
(
    input  wire                     clk,            // clock input
    input  wire                     rst,            // sync reset input
    input  wire                     ce,             // clock enable
    input  wire                     clr_hcnt,       // clears the horizontal counter
    input  wire                     resync_hcnt,    // resynchronized horizontal counter during sync switch
    input  wire [2:0]               std,            // indicates current video standard
    output wire [HCNT_WIDTH-1:0]    hcnt,           // horizontal count
    output wire                     eav_next,       // asserted when next word is first word of EAV symbol
    output wire                     sav_next,       // asserted when next word is first word of SAV symbol
    output reg                      h = 1'b0,       // horizontal blanking bit
    output reg  [1:0]               trs_word = 0,   // indicates which word of the TRS symbol is being generated
    output wire                     fly_trs,        // asserted during first word of a flywheel generated TRS
    output wire                     fly_eav,        // asserted during xyz word of a flywheel generated EAV
    output wire                     fly_sav         // asserted during xyz word of a flywheel generated SAV
);

//-----------------------------------------------------------------------------
// Parameter definitions
//

localparam HCNT_MSB = HCNT_WIDTH - 1;

//
// This group of parameters defines the starting position of the EAV symbol
// for the various supported video standards.
//
localparam EAV_LOC_NTSC_422          = 1440;
localparam EAV_LOC_NTSC_COMPOSITE    = 790;
localparam EAV_LOC_NTSC_422_WIDE     = 1920;
localparam EAV_LOC_NTSC_4444         = 2880;
localparam EAV_LOC_PAL_422           = 1440;
localparam EAV_LOC_PAL_COMPOSITE     = 972;
localparam EAV_LOC_PAL_422_WIDE      = 1920;
localparam EAV_LOC_PAL_4444          = 2880;

//
// This group of parameters defines the starting position of the SAV symbol
// for the various supported video standards.
//
localparam SAV_LOC_NTSC_422          = 1712;
localparam SAV_LOC_NTSC_COMPOSITE    = 790;
localparam SAV_LOC_NTSC_422_WIDE     = 2284;
localparam SAV_LOC_NTSC_4444         = 3428;
localparam SAV_LOC_PAL_422           = 1724;
localparam SAV_LOC_PAL_COMPOSITE     = 972;
localparam SAV_LOC_PAL_422_WIDE      = 2300;
localparam SAV_LOC_PAL_4444          = 3452;

//
// This group of parameters defines the encoding for the video standards output
// code.
//
localparam [2:0]
    NTSC_422        = 3'b000,
    NTSC_INVALID    = 3'b001,
    NTSC_422_WIDE   = 3'b010,
    NTSC_4444       = 3'b011,
    PAL_422         = 3'b100,
    PAL_INVALID     = 3'b101,
    PAL_422_WIDE    = 3'b110,
    PAL_4444        = 3'b111;

//-----------------------------------------------------------------------------
// Signal definitions
//
reg     [HCNT_MSB:0]    hcount = 1;     // horizontal counter
wire                    trs_next;       // TRS symbol starts on next count
reg                     trs = 1'b0;     // internal version of fly_trs signal
reg                     fly_xyz = 1'b0; // asserted during flywheel generated XYZ word
reg     [HCNT_MSB:0]    eav_loc;        // EAV location
reg     [HCNT_MSB:0]    sav_loc;        // SAV location
reg     [HCNT_MSB:0]    resync_val;     // value to load on resync_hcnt

//
// hcount: horizontal counter
//
// The horizontal counter increments every clock cycle to keep track of the
// current horizontal position. If clr_hcnt is asserted by the FSM, hcnt is
// reloaded with a value of 1. A value of 1 is used because of the latency
// involved in detected the TRS symbol and deciding whether to clear hcnt or
// not. If resync_hcnt is asserted, the horizontal coutner is loaded with
// resync_val, a value derived from the EAV position. This happens during
// synchronous switches. 
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            hcount <= 1;
        else if (resync_hcnt)
            hcount <= resync_val;
        else if (clr_hcnt)
            hcount <= 1;
        else if (fly_sav)
            hcount <= 0;
        else
            hcount <= hcount + 1;
    end

//
// TRS word counter
//
// The TRS word counter is used to count out the words of a TRS symbol. A
// TRS symbol for component video is four words long.
//
// During the TRS symbol the trs signal is asserted. During the XYZ word of
// a component video signal fly_xyz is asserted and one of fly_sav or fly_eav.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst | trs_next)
            trs_word <= 0;
        else
            trs_word <= trs_word + 1;
    end

always @ (posedge clk)
    if (ce)
    begin
        if (rst | clr_hcnt | fly_xyz | resync_hcnt)
            trs <= 1'b0;
        else if (trs_next)
            trs <= 1'b1;
    end
        
always @ (posedge clk)
    if (ce)
    begin
        if (rst | clr_hcnt)
            fly_xyz <= 1'b0;
        else if (trs && (trs_word == 2'b10))
            fly_xyz <= 1'b1;
        else
            fly_xyz <= 1'b0;
    end
        
assign fly_eav = fly_xyz & h;
assign fly_sav = fly_xyz & ~h;

//
// TRS location detection
//
// This block of code generates the eav_next and sav_next signals. These signals
// are asserted the state before the flywheel will generate the first word of
// the EAV or SAV TRS symbols.
//
always @ (*)
    case (std)
        NTSC_422:
            begin
                eav_loc = EAV_LOC_NTSC_422 - 1;
                sav_loc = SAV_LOC_NTSC_422 - 1;
                resync_val = EAV_LOC_NTSC_422 + 2;
            end

        NTSC_422_WIDE:
            begin
                eav_loc = EAV_LOC_NTSC_422_WIDE - 1;
                sav_loc = SAV_LOC_NTSC_422_WIDE - 1;
                resync_val = EAV_LOC_NTSC_422_WIDE + 2;
            end

        NTSC_4444:
            begin
                eav_loc = EAV_LOC_NTSC_4444 - 1;
                sav_loc = SAV_LOC_NTSC_4444 - 1;
                resync_val = EAV_LOC_NTSC_4444 + 2;
            end

        PAL_422:
            begin
                eav_loc = EAV_LOC_PAL_422 - 1;
                sav_loc = SAV_LOC_PAL_422 - 1;
                resync_val = EAV_LOC_PAL_422 + 2;
            end

        PAL_422_WIDE:
            begin
                eav_loc = EAV_LOC_PAL_422_WIDE - 1;
                sav_loc = SAV_LOC_PAL_422_WIDE - 1;
                resync_val = EAV_LOC_PAL_422_WIDE + 2;
            end

        PAL_4444:
            begin
                eav_loc = EAV_LOC_PAL_4444 - 1;
                sav_loc = SAV_LOC_PAL_4444 - 1;
                resync_val = EAV_LOC_PAL_4444 + 2;
            end

        default:
            begin
                eav_loc = EAV_LOC_NTSC_422 - 1;
                sav_loc = SAV_LOC_NTSC_422 - 1;
                resync_val = EAV_LOC_NTSC_422 + 2;
            end

    endcase

assign eav_next = (hcount == eav_loc);
assign sav_next = (hcount == sav_loc);
assign trs_next = eav_next | sav_next;

//
// h
//
// This logic generates the H bit for the TRS XYZ word. The H bit becomes
// asserted at the start of EAV and is negated at the start of SAV. Note that
// the h_blank output from the flywheel module is similar to the H bit, but 
// remains asserted until after the last word of the SAV.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            h <= 1'b0;
        else if (eav_next | resync_hcnt)
            h <= 1'b1;
        else if (sav_next| clr_hcnt)
            h <= 1'b0;
    end

//
// output assignments
//
assign fly_trs = trs;
assign hcnt = hcount;

endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/* 
This module implements the vertical functions of the video flywheel.

This module contains the vertical counter. This counter keeps track of the
current video scan line. The module also generates the V signal. This signal
is asserted during the vertical blanking interval of each field.

This module has the following inputs:

clk: clock input

rst: synchronous reset input

ce: clock enable

ntsc: Asserted when the input video stream is NTSC.

ld_vcnt: This input causes the vertical counter to load the value of the first
line of the current field.

fsm_inc_vcnt: This input is asserted by the FSM to force the vertical counter
to increment during a failed synchronous switch.

eav_next: Asserted the clock cycle before the first word of a flywheel generated
EAV symbol.

clr_switch: Causes the switch_interval output to be negated.

rx_f: This signal carries the F bit from the input video stream during XYZ 
words.

f: This is the flywheel generated F bit.

fly_sav: Asserted during the XYZ word of a flywheel generated SAV.

fly_eav: Asserted during the XYZ word of a flywheel generated EAV.

rx_eav_first: Asserted during the first word of an EAV in the input video 
stream.

lock: Asserted when the flywheel is locked.

This module generates the following outputs:

vcnt: This is the value of the vertical counter indicating the current video
line number.

v: This is the vertical blanking bit asserted during the vertical blanking
interval.

sloppy_v: This signal is asserted on those lines where the V bit may fall early.

inc_f: Toggles the F bit when asserted.

switch_interval: Asserted when the current line contains the synchronous
switching interval.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_edh_fly_vert #(
    parameter VCNT_WIDTH = 10)
(
    input  wire                     clk,                    // clock input
    input  wire                     rst,                    // sync reset input
    input  wire                     ce,                     // clock enable input
    input  wire                     ntsc,                   // 1 = NTSC, 0 = PAL
    input  wire                     ld_vcnt,                // causes vert counter to load
    input  wire                     fsm_inc_vcnt,           // forces vert counter to increment during failed sync switch
    input  wire                     eav_next,               // asserted when next word is first word of a flywheel EAV
    input  wire                     clr_switch,             // clears the switch_interval signal
    input  wire                     rx_f,                   // received F bit
    input  wire                     f,                      // flywheel generated field bit
    input  wire                     fly_sav,                // asserted during first word of flywheel generated SAV
    input  wire                     fly_eav,                // asserted during first word of flywheel generated EAV
    input  wire                     rx_eav_first,           // asserted during first word of received EAV
    input  wire                     lock,                   // asserted when flywheel is locked
    output wire [VCNT_WIDTH-1:0]    vcnt,                   // vertical counter
    output reg                      v = 1'b0,               // vertical blanking bit indicator
    output reg                      sloppy_v = 1'b0,        // asserted when FSM should ignore V bit in XYZ comparison
    output wire                     inc_f,                  // toggles the F bit when asserted
    output reg                      switch_interval = 1'b0  // asserted when current line is a sync switching line
);

//-----------------------------------------------------------------------------
// Parameter definitions
//
localparam VCNT_MSB      = VCNT_WIDTH - 1;       // MS bit # of vcnt

//
// This group of parameters defines the synchronous switching interval lines.
//
localparam NTSC_FLD1_SWITCH          = 10;
localparam NTSC_FLD2_SWITCH          = 273;
localparam PAL_FLD1_SWITCH           = 6;
localparam PAL_FLD2_SWITCH           = 319;
    
//
// This group of parameters defines the ending positions of the fields for
// NTSC and PAL.
//
localparam NTSC_FLD1_END             = 265;
localparam NTSC_FLD2_END             = 3;
localparam PAL_FLD1_END              = 312;
localparam PAL_FLD2_END              = 625;
localparam NTSC_V_TOTAL              = 525;
localparam PAL_V_TOTAL               = 625;
    
//
// This group of parameters defines the starting and ending active portions of
// of the fields.
//
localparam NTSC_FLD1_ACT_START       = 20;
localparam NTSC_FLD1_ACT_END         = 263;
localparam NTSC_FLD2_ACT_START       = 283;
localparam NTSC_FLD2_ACT_END         = 525;
localparam PAL_FLD1_ACT_START        = 23;
localparam PAL_FLD1_ACT_END          = 310;
localparam PAL_FLD2_ACT_START        = 336;
localparam PAL_FLD2_ACT_END          = 623;
         
//
// This group of parameters defines the starting lines on which it is possible
// for the V bit to change early. This is due to previous versions of the
// specifications that allowed for an early transition from 1 to 0 on the V
// bit. This only occurs in the NTSC specifications. The period of ambiguity
// on the V bit ends with the first active video line of each field as
// defined above.
//
localparam SLOPPY_V_START_FLD1       = 10;
localparam SLOPPY_V_START_FLD2       = 273;


//-----------------------------------------------------------------------------
// Signal definitions
//
reg     [VCNT_MSB:0]    vcount = 1;     // vertical counter
wire                    clr_vcnt;       // clears the vertical counter
reg     [VCNT_MSB:0]    new_vcnt;       // new value to load into vcount                
reg     [VCNT_MSB:0]    fld1_switch;    // synchronous switching line for field 1
reg     [VCNT_MSB:0]    fld2_switch;    // synchronous switching line for field 2
wire    [VCNT_MSB:0]    fld_switch;     // synchronous switching line for current field
wire                    switch_line;    // asserted when vcnt == fld_switch
wire    [VCNT_MSB:0]    v_total;        // total vertical lines for this video standard
reg     [VCNT_MSB:0]    fld1_act_start; // starting line of active video in field 1
reg     [VCNT_MSB:0]    fld1_act_end;   // ending line of active video in field 1
reg     [VCNT_MSB:0]    fld2_act_start; // starting line of active video in field 2
reg     [VCNT_MSB:0]    fld2_act_end;   // ending line of active video in field 2
wire    [VCNT_MSB:0]    fld_act_start;  // starting line of active video in current field
wire    [VCNT_MSB:0]    fld_act_end;    // ending line of active video in current field
wire                    act_start;      // result of comparing vcnt and fld_act_start
reg     [VCNT_MSB:0]    fld1_end;       // line count for end of field 1
reg     [VCNT_MSB:0]    fld2_end;       // line count for end of field 2
wire    [VCNT_MSB:0]    fld_end;        // line count for end of current field
wire    [VCNT_MSB:0]    sloppy_start;   // starting position of V bit ambiguity period

//
// vcnt: vertical counter
//
// The vertical counter increments once per line to keep track of the current
// vertical position. If clr_vcnt is asserted, vcnt is loaded with a value of
// 1. If ld_vcnt is asserted, the new_vcnt value is loaded into vcnt. If the
// state machine asserts the fsm_inc_vcnt signal indicating a synchronous
// switch event, then the vcnt must be forced to increment since the received
// EAV came before the flywheel's generated EAV, causing the hcnt to be updated
// to a position after the EAV and thus skipping the normal inc_vcnt signal
// that comes with the flywheel's EAV.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            vcount <= 1;
        else if (ld_vcnt)
            vcount <= new_vcnt;
        else if (fsm_inc_vcnt | ((lock & switch_interval) ? rx_eav_first : eav_next))
        begin
            if (clr_vcnt)
                vcount <= 1;
            else
                vcount <= vcount + 1;
        end
    end

assign v_total = ntsc ? NTSC_V_TOTAL : PAL_V_TOTAL;
assign clr_vcnt = (vcount == v_total);
assign vcnt = vcount;

always @ (*)
    if (ntsc)
    begin
        if (rx_f)
            new_vcnt = NTSC_FLD1_END + 1;
        else
            new_vcnt = NTSC_FLD2_END + 1;
    end
    else
    begin
        if (rx_f)
            new_vcnt = PAL_FLD1_END + 1;
        else
            new_vcnt = 1;
    end


//
// synchronous switching line detector
//
// This code determines when the current line is a line during which
// it is permitted to switch between synchronous video sources. These sources
// may have a small amount of offset. The flywheel will immediately 
// resynchronize to the new signal on the synchronous switching lines without
// the usual flywheel induced delay.
//
always @ (*)
    if (ntsc)
    begin
        fld1_switch <= NTSC_FLD1_SWITCH;
        fld2_switch <= NTSC_FLD2_SWITCH;
    end
    else
    begin
        fld1_switch <= PAL_FLD1_SWITCH;
        fld2_switch <= PAL_FLD2_SWITCH;
    end

assign fld_switch = f ? fld2_switch : fld1_switch;

assign switch_line = (vcount == fld_switch);

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            switch_interval <= 1'b0;
        else if (switch_interval ? clr_switch : fly_eav)
            switch_interval <= 1'b0;
        else if (fly_sav)
            switch_interval <= switch_line;
    end

//
// v
//
// This logic generates the V bit for the TRS XYZ word. The V bit is asserted
// in the TRS symbols of all lines in the vertical blanking interval. It is
// generated by comparing the vcnt starting and ending positions of the
// current field at the beginning of the EAV symbol. Whenever the state 
// machine reloads the field counter by asserted ld_f, the v flag should be
// set because the field counter is only reloaded in the vertical blanking
// interval.
//
always @ (*)
    if (ntsc)
    begin
        fld1_act_start = NTSC_FLD1_ACT_START - 1;
        fld1_act_end   = NTSC_FLD1_ACT_END;
        fld2_act_start = NTSC_FLD2_ACT_START - 1;
        fld2_act_end   = NTSC_FLD2_ACT_END;
    end
    else
    begin
        fld1_act_start = PAL_FLD1_ACT_START - 1;
        fld1_act_end   = PAL_FLD1_ACT_END;
        fld2_act_start = PAL_FLD2_ACT_START - 1;
        fld2_act_end   = PAL_FLD2_ACT_END;
    end

assign fld_act_start = f ? fld2_act_start : fld1_act_start;
assign fld_act_end   = f ? fld2_act_end   : fld1_act_end;
assign act_start = vcnt == fld_act_start;

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            v <= 1'b0;
        else if (ld_vcnt)
            v <= 1'b1;
        else if (eav_next)
            begin
                if (vcnt == fld_act_start)
                    v <= 1'b0;
                else if (vcnt == fld_act_end)
                    v <= 1'b1;
            end
    end

//
// inc_f
//
// This logic determines when to toggle the F bit.
//
always @ (*)
    if (ntsc)
    begin
        fld1_end = NTSC_FLD1_END;
        fld2_end = NTSC_FLD2_END;
    end
    else
    begin
        fld1_end = PAL_FLD1_END;
        fld2_end = PAL_FLD2_END;
    end

assign fld_end = f ? fld2_end : fld1_end;
assign inc_f = (vcnt == fld_end);

//
// sloppy_v
//
// This signal is asserted during the interval when the V bit should be
// ignored in XYZ comparisons due to ambiguity in earlier versions of the
// NTSC digital video specifications.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst | ld_vcnt | ~ntsc)
            sloppy_v <= 1'b0;
        else
        begin
            if (vcnt == sloppy_start)
                sloppy_v <= 1'b1;
            else if (eav_next & act_start)
                sloppy_v <= 1'b0;
        end
    end

assign sloppy_start = f ? SLOPPY_V_START_FLD2 : SLOPPY_V_START_FLD1;

endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/* 
This module implements a video flywheel. Video flywheels are used to add
immunity to noise introduced into a video stream.

The flywheel synchronizes to the incoming video by examining the TRS symbols. It
then maintains internal horizontal and vertical counters to keep track of the
current position. The flywheel generates its own TRS symbols and compares them
to the incoming video. If the position or contents of the TRS symbols in the
incoming video doesn't match the flywheel's generated TRS symbols for a certain
period of time, the flywheel will resynchronize to the incoming video.

This module has the following inputs:

clk: clock input

ce: clock enable input

rst: synchronous reset input

rx_xyz_in: Asserted when rx_vid_in contains the XYZ word of a TRS symbol.

rx_trs_in: Asserted when rx_vid_in contains the first word of a TRS symbol.

rx_eav_first_in: Asserted when rx_vid_in contains the first word of an EAV.

rx_f_in: This is the latched F bit from the trs_detect module

rx_h_in: This is the latched H bit from the trs_detect module.

std_locked: When this signal is asserted the std_in code is assumed to be valid.

std_in: A three bit code indicating the video standard of the input video 
stream.

rx_xyz_err_in: This input indicates an error in the XYZ word. It is only
considered to be valid when rx_xyz_in is asserted.

rx_vid_in: This is the input port for the input video stream.

rx_s4444_in: This input is the S bit from the XYZ word of a 4:4:4:4 video 
stream.

rx_anc_in:  Asserted when rx_vid_in contains the first word of an ANC packet.

rx_edh_in: Asserted when rx_vid_in contains the first word of an EDH packet.

en_sync_switch: When this input is asserted, the flywheel will allow
synchronous switching.

en_trs_blank: When this input is asserted, the TRS blanking feature is enabled.
When this is enabled, TRS symbols from the input video stream are replaced with
black level video values if that TRS symbol does not occur when the flywheel
expects a TRS to occur.

This module has the following outputs:

trs: Asserted during all four words of a TRS symbol.

vid_out: This is the output video port.

field: This is the field indicator bit.

v_blank: Vertical blanking interval indicator.

h_blank: Horizontal blanking interval indicator.

horz_count: Current horizontal position of the video stream.

vert_count: Current vertical position of the video stream.

sync_switch: Asserted on lines when synchronous switching is allowed. This 
output should be used to disable TRS filtering in the framer of an SDI receiver
during the synchronous switching lines.

locked: This output is asserted when the flywheel is locked to the incoming
video stream.

eav_next: This output is asserted the clock cycle before the first word of an
EAV appears on vid_out.

sav_next: This output is asserted the clock cycle before the first word of an
SAV appears on vid_out.

xyz_word: This output is asserted clock cycle when vid_out contains the XYZ
word of a TRS symbol.

anc_next: This output is asserted the clock cycle before the first word of an
ancillary data packet appears on vid_out.

edh_next: This output is asserted the clock cycle before the first word of an
EDH packet appears on vid_out.

*/

`timescale 1ns / 1ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_edh_flywheel #(
    parameter HCNT_WIDTH = 12,
    parameter VCNT_WIDTH = 10)
(
    input  wire                 clk,                // clock input
    input  wire                 ce,                 // clock enable
    input  wire                 rst,                // sync reset input
    input  wire                 rx_xyz_in,          // input asserted during the XYZ word of a TRS symbol
    input  wire                 rx_trs_in,          // input asserted during first word of received TRS symbol
    input  wire                 rx_eav_first_in,    // input asserted during first word of received EAV symbol
    input  wire                 rx_f_in,            // decoded F bit from received video
    input  wire                 rx_v_in,            // decoded V bit from received video
    input  wire                 rx_h_in,            // decoded H bit from received video
    input  wire                 std_locked,         // asserted by the autodetect unit when locked to video std
    input  wire [2:0]           std_in,             // input code for the current video standard
    input  wire                 rx_xyz_err_in,      // input asserted on parity error in XYZ word
    input  wire [9:0]           rx_vid_in,          // input video word
    input  wire                 rx_s4444_in,        // S bit for 4444 video
    input  wire                 rx_anc_in,          // asserted on first word of received ANC
    input  wire                 rx_edh_in,          // asserted on first word of received EDH
    input  wire                 en_sync_switch,     // enables synchronous switching when asserted
    input  wire                 en_trs_blank,       // enables TRS blanking when asserted
    output reg                  trs = 1'b0,         // asserted during TRS symbol
    output reg [9:0]            vid_out = 0,        // video stream out
    output reg                  field = 1'b0,       // field indicator
    output reg                  v_blank = 1'b0,     // vertical blanking bit
    output reg                  h_blank = 1'b0,     // horizontal blanking bit
    output reg [HCNT_WIDTH-1:0] horz_count = 0,     // current horizontal count
    output reg [VCNT_WIDTH-1:0] vert_count = 0,     // current vertical count
    output reg                  sync_switch = 1'b0, // asserted on lines where synchronous switching is allowed
    output reg                  locked = 1'b0,      // asserted when flywheel is synchronized to video
    output reg                  eav_next = 1'b0,    // next word is first word of EAV
    output reg                  sav_next = 1'b0,    // next word is first word of SAV
    output reg                  xyz_word = 1'b0,    // current word is the XYZ word of a TRS
    output wire                 anc_next,           // next word is first word of a received ANC
    output wire                 edh_next            // next word is first word of a received EDH
);


//-----------------------------------------------------------------------------
// Parameter definitions
//
parameter HCNT_MSB      = HCNT_WIDTH - 1;       // MS bit # of hcnt
parameter VCNT_MSB      = VCNT_WIDTH - 1;       // MS bit # of vcnt


//
// This group of parameters defines the encoding for the video standards output
// code.
//
parameter [2:0]
    NTSC_422        = 3'b000,
    NTSC_INVALID    = 3'b001,
    NTSC_422_WIDE   = 3'b010,
    NTSC_4444       = 3'b011,
    PAL_422         = 3'b100,
    PAL_INVALID     = 3'b101,
    PAL_422_WIDE    = 3'b110,
    PAL_4444        = 3'b111;


//
// This group of parameters defines the component video values that will be
// used to blank TRS symbols when TRS blanking.
//
parameter YCBCR_4444_BLANK_Y    = 10'h040;
parameter YCBCR_4444_BLANK_CB   = 10'h200;
parameter YCBCR_4444_BLANK_CR   = 10'h200;
parameter YCBCR_4444_BLANK_A    = 10'h040;

parameter RGB_4444_BLANK_R      = 10'h040;
parameter RGB_4444_BLANK_G      = 10'h040;
parameter RGB_4444_BLANK_B      = 10'h040;
parameter RGB_4444_BLANK_A      = 10'h040;

parameter YCBCR_422_BLANK_Y     = 10'h040;
parameter YCBCR_422_BLANK_C     = 10'h200;
         
//-----------------------------------------------------------------------------
// Signal definitions
//
reg                     rx_xyz = 1'b0;          // input register for rx_xyz_in
reg                     rx_trs = 1'b0;          // input register for rx_trs_in
reg                     rx_eav_first = 1'b0;    // input register for rx_eav_first_in
reg                     rx_xyz_err = 1'b0;      // input register for rx_xyz_err_in
reg                     rx_s4444 = 1'b0;        // input register for rx_s4444_in
reg     [9:0]           rx_vid = 1'b0;          // input register for rx_vid_in
reg                     rx_f = 1'b0;            // input register for rx_f_in
reg                     rx_v = 1'b0;            // input register for rx_v
reg                     rx_h = 1'b0;            // input register for rx_h_in
reg                     rx_anc = 1'b0;          // input register for rx_anc_in
reg                     rx_edh = 1'b0;          // input register for rx_edh_in
wire    [HCNT_MSB:0]    hcnt;                   // horizontal counter
wire    [VCNT_MSB:0]    vcnt;                   // vertical counter
wire                    fly_eav_next;           // EAV symbol starts on next count
wire                    fly_sav_next;           // SAV symbol starts on next count
wire    [1:0]           trs_word;               // counts length of TRS symbol
wire                    fly_trs;                // asserted during all words of flywheel TRS
wire                    trs_d;                  // input to trs output flip-flop
wire                    v_blank_d;              // input to v_blank output flip-flop
wire                    h_blank_d;              // input to h_blank output flip-flop
wire                    fly_eav;                // asserted on XYZ word of flywheel generated EAV
wire                    fly_sav;                // asserted on XYZ word of flywheel generated SAV
wire                    rx_eav;                 // asserted on XYZ word of received EAV
wire                    rx_sav;                 // asserted on XYZ word of received SAV
wire                    f;                      // field bit
wire                    v;                      // vertical blanking bit
wire                    h;                      // horizontal blanking bit
reg     [9:0]           xyz;                    // flywheel generated TRS XYZ word
wire                    new_rx_field;           // asserted when received field changes
wire                    ld_vcnt;                // loads vcnt
wire                    inc_vcnt;               // forces vertical counter to increment
wire                    clr_hcnt;               // reloads hcnt 
wire                    resync_hcnt;            // resynchronized hcnt during sync switch
wire                    ld_f;                   // loads field bit
wire                    inc_f;                  // toggles field bit
reg                     ntsc;                   // 1 = NTSC, 0 = PAL
wire                    lock;                   // internal version of locked output
reg     [2:0]           std = NTSC_422;         // register for the std_in inputs
wire                    ld_std;                 // loads the std register
wire                    switch_interval;        // asserted from SAV to EAV of switch line
wire                    sw_int;                 // qualified version of switch_interval
reg     [9:0]           fly_vid;                // flywheel video
wire                    clr_switch;             // clears the switch_interval signal
reg     [2:0]           rx_trs_delay = 3'b0;    // used to generate rx_trs_all4
wire                    rx_trs_all4;            // extended rx_trs, asserted for all 4 words
wire                    rx_field;               // the F bit from the received XYZ word
wire                    use_rx;                 // use decoded RX video info when asserted
wire                    use_fly;                // use flywheel generated video when asserted
wire                    sloppy_v;               // when asserted, V bit is ignored in XYZ comparisons
wire                    xyz_word_d;             // used to create the xyz output
wire                    is_ntsc;
wire                    is_422;

//
// input register for signals from trs_detect
//
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
        begin
            rx_xyz <= 0;
            rx_trs <= 0;
            rx_eav_first <= 0;
            rx_xyz_err <= 0;
            rx_s4444 <= 0;
            rx_vid <= 0;
            rx_f <= 0;
            rx_v <= 0;
            rx_h <= 0;
            rx_anc <= 0;
            rx_edh <= 0;
        end
        else
        begin
            rx_xyz <= rx_xyz_in;
            rx_trs <= rx_trs_in;
            rx_eav_first <= rx_eav_first_in;
            rx_xyz_err <= rx_xyz_err_in;
            rx_s4444 <= rx_s4444_in;
            rx_vid <= rx_vid_in;
            rx_f <= rx_f_in;
            rx_v <= rx_v_in;
            rx_h <= rx_h_in;
            rx_anc <= rx_anc_in;
            rx_edh <= rx_edh_in;
        end
    end


// 
// fly_horz instantiation
//
// The fly_horz module contains the horizontal functions of the flywheel. It
// generates the horizontal count and the H bit.It also generates several
// TRS related signals indicating when a TRS is to be generated by the flywheel
// and what type of TRS is to be generated.
//
v_smpte_uhdsdi_v1_0_5_edh_fly_horz #(
    .HCNT_WIDTH         (HCNT_WIDTH))
horz (
    .clk                (clk),
    .rst                (rst),
    .ce                 (ce),
    .clr_hcnt           (clr_hcnt),
    .resync_hcnt        (resync_hcnt),
    .std                (std),
    .hcnt               (hcnt),
    .eav_next           (fly_eav_next),
    .sav_next           (fly_sav_next),
    .h                  (h),
    .trs_word           (trs_word),
    .fly_trs            (fly_trs),
    .fly_eav            (fly_eav),
    .fly_sav            (fly_sav)
);

//
// fly_vert instantiation
//
// The fly_vert module contains the vertical functions of the flywheel. It
// generates the vertical line count and the V bit. It generates the inc_f
// signal indicating when it is time to advance to the next field. It also
// generates the switch_interval signal indicating when the current line is
// a line when switching between two synchronous video sources is permitted.
//
v_smpte_uhdsdi_v1_0_5_edh_fly_vert #(
    .VCNT_WIDTH         (VCNT_WIDTH))
vert (
    .clk                (clk),
    .rst                (rst),
    .ce                 (ce),
    .ntsc               (ntsc),
    .ld_vcnt            (ld_vcnt),
    .fsm_inc_vcnt       (inc_vcnt),
    .eav_next           (fly_eav_next),
    .clr_switch         (clr_switch),
    .rx_f               (rx_f),
    .f                  (f),
    .fly_sav            (fly_sav),
    .fly_eav            (fly_eav),
    .rx_eav_first       (rx_eav_first),
    .lock               (lock),
    .vcnt               (vcnt),
    .v                  (v),
    .sloppy_v           (sloppy_v),
    .inc_f              (inc_f),
    .switch_interval    (switch_interval)
);

assign sw_int = switch_interval & en_sync_switch;

//
// fly_fsm instantiation
//
// The fly_fsm module contains the finite state machine that controls the
// operation of the flywheel.
//
v_smpte_uhdsdi_v1_0_5_edh_fly_fsm fsm (
    .clk                (clk),
    .ce                 (ce),
    .rst                (rst),
    .vid_f              (rx_vid[8]),
    .vid_v              (rx_vid[7]),
    .vid_h              (rx_vid[6]),
    .rx_xyz             (rx_xyz),
    .fly_eav            (fly_eav),
    .fly_sav            (fly_sav),
    .fly_eav_next       (fly_eav_next),
    .fly_sav_next       (fly_sav_next),
    .rx_eav             (rx_eav),
    .rx_sav             (rx_sav),
    .rx_eav_first       (rx_eav_first),
    .new_rx_field       (new_rx_field),
    .xyz_err            (rx_xyz_err),
    .std_locked         (std_locked),
    .switch_interval    (sw_int),
    .xyz_f              (xyz[8]),
    .xyz_v              (xyz[7]),
    .xyz_h              (xyz[6]),
    .sloppy_v           (sloppy_v),
    .lock               (lock),
    .ld_vcnt            (ld_vcnt),
    .inc_vcnt           (inc_vcnt),
    .clr_hcnt           (clr_hcnt),
    .resync_hcnt        (resync_hcnt),
    .ld_std             (ld_std),
    .ld_f               (ld_f),
    .clr_switch         (clr_switch)
);

//
// fly_field instantiation
//
// The fly_field module contains the field related functions of the flywheel.
// It generates the F bit and also contains a logic to determine when the
// received field changes.
//
v_smpte_uhdsdi_v1_0_5_edh_fly_field fld (
    .clk                (clk),
    .rst                (rst),
    .ce                 (ce),
    .ld_f               (ld_f),
    .inc_f              (inc_f),
    .eav_next           (fly_eav_next),
    .rx_field           (rx_field),
    .rx_xyz             (rx_xyz),
    .f                  (f),
    .new_rx_field       (new_rx_field)
);

assign rx_field = rx_vid[8];

//
// rx_eav and rx_sav
//
// This code decodes the H bit from the received video to generate the rx_eav
// and rx_sav signals. These two signals are asserted during the XYZ word only
// of a received TRS symbol to indicate whether a SAV or an EAV symbol has
// been received.
//
assign rx_eav = rx_xyz & rx_vid[6];
assign rx_sav = rx_xyz & ~rx_vid[6];

//
// rx_trs_delay and rx_trs_all4 generation
//
// The trs_detect module only asserts the rx_trs signal during the first
// word of a received TRS symbol. This code stretches that signal so that
// it is asserted for all four words of the TRS symbol. The extended signal
// is called rx_trs_all4.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            rx_trs_delay <= 0;
        else
            rx_trs_delay <= {rx_trs_delay[1:0], rx_trs};
    end

assign rx_trs_all4 = |{rx_trs_delay,rx_trs};
        

//
// std register
//
// This register holds the current video standard code being used by the
// flywheel. It loads from the std inputs whenever the state machine begins
// the synchronization process.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            std <= NTSC_422;
        else if (ld_std)
            std <= std_in;
    end

//
// ntsc
//
// This signal is asserted when the code in the std register indicates a
// NTSC standard and is negated for PAL standards.
//
assign is_ntsc = std == NTSC_422 || std == NTSC_INVALID || std == NTSC_422_WIDE || std == NTSC_4444;

always @ (*)
    if (is_ntsc)
        ntsc = 1'b1;
    else
        ntsc = 1'b0;

//
// xyz generator
//
// This logic generates the TRS XYZ word. The XYZ word is constructed
// differently for the 4:4:4:4 standards than for the 4:2:2 standards.
//
assign is_422 = std == NTSC_422 || std == NTSC_422_WIDE || std == PAL_422  || std == PAL_422_WIDE;

always @ (*)
begin
    xyz[9] <= 1'b1;
    xyz[8] <= f;
    xyz[7] <= v;
    xyz[6] <= h;
    xyz[0] <= 1'b0;

    if (std == NTSC_4444 || std == PAL_4444)
        begin
            xyz[5] <= rx_s4444;
            xyz[4] <= f ^ v ^ h;
            xyz[3] <= f ^ v ^ rx_s4444;
            xyz[2] <= v ^ h ^ rx_s4444;
            xyz[1] <= f ^ h ^ rx_s4444;
        end
    else if (is_422)
        begin
            xyz[5] <= v ^ h;
            xyz[4] <= f ^ h;
            xyz[3] <= f ^ v;
            xyz[2] <= f ^ v ^ h;
            xyz[1] <= 1'b0;
        end
    else
        xyz <= 0;
end

//
// fly_vid generator
//
// This code generates the flywheel TRS symbol. The first three words of the
// TRS symbol are 0x3ff, 0x000, 0x000. The fourth word is the XYZ word. If
// a TRS symbol is not begin generated, the fly_vid value is assigned to
// the blank level value appropriate to the component being generated.
//
always @ (*)
    if (trs_d)
        case(trs_word)
            2'b00: fly_vid <= 10'h3ff;
            2'b01: fly_vid <= 10'h000;
            2'b10: fly_vid <= 10'h000;
            2'b11: fly_vid <= xyz;
        endcase
    else if (std == NTSC_4444 || std == PAL_4444)
        begin
            if (rx_s4444)
                case (hcnt[1:0])
                    2'b00: fly_vid <= YCBCR_4444_BLANK_CB;
                    2'b01: fly_vid <= YCBCR_4444_BLANK_Y;
                    2'b10: fly_vid <= YCBCR_4444_BLANK_CR;
                    2'b11: fly_vid <= YCBCR_4444_BLANK_A;
                endcase
            else
                case (hcnt[1:0])
                    2'b00: fly_vid <= RGB_4444_BLANK_B;
                    2'b01: fly_vid <= RGB_4444_BLANK_G;
                    2'b10: fly_vid <= RGB_4444_BLANK_R;
                    2'b11: fly_vid <= RGB_4444_BLANK_A;
                endcase
        end
    else
        begin
            if (hcnt[0])
                fly_vid <= YCBCR_422_BLANK_Y;
            else
                fly_vid <= YCBCR_422_BLANK_C;
        end 

//
// output register
//
// This is the output register for all the flywheel's output signals. The
// signals that can be derived internally or from the received video (trs,
// vid_out, and h_blank) use the use_rx signal to determine whether the flywheel
// generated signals or the signals decoded from the received video should be 
// used. The v_blank and field outputs are not affected by use_rx.
//
// Normally the output video stream (vid_out) is equal to the input video
// stream (vid_in). However, when the flywheel generates a TRS symbol, this
// internally generated TRS symbol is output instead of the input video
// stream. If the input video stream contains a TRS that does not line up
// with the flywheel's TRS symbol, then the TRS symbol in the input video
// stream is blanked by the flywheel. However, on the synchronous switching
// lines, the SAV symbol in the input video stream is always output and the 
// flywheel's SAV symbol is suppressed.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
        begin
            trs <= 1'b0;
            field <= 1'b0;
            v_blank <= 1'b0;
            h_blank <= 1'b0;
            horz_count <= 0;
            vert_count <= 1;
            locked <= 0;
            sync_switch <= 0;
            vid_out <= 0;
            eav_next <= 0;
            sav_next <= 0;
            xyz_word <= 0;
        end
        else
        begin
            trs <= trs_d;
            field <= f;
            v_blank <= v_blank_d;
            h_blank <= h_blank_d;
            horz_count <= hcnt;
            vert_count <= vcnt;
            locked <= lock;
            sync_switch <= sw_int;
            vid_out <= use_fly ? fly_vid : rx_vid;
            eav_next <= fly_eav_next;
            sav_next <= fly_sav_next;
            xyz_word <= xyz_word_d;
        end
    end

assign use_rx = lock & (sw_int | sloppy_v);
assign use_fly = (trs_d & ~use_rx) | ((~trs_d & rx_trs_all4) & en_trs_blank);
assign trs_d = use_rx ? rx_trs_all4 : fly_trs;
assign h_blank_d = use_rx ? (rx_h | rx_trs_all4) : (h | trs_d);
assign v_blank_d = use_rx ? rx_v : v;
assign xyz_word_d = trs_d & trs_word[1] & trs_word[0];
assign anc_next = rx_anc;
assign edh_next = rx_edh;
     
endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/* 
This module examines the vcnt and hcnt values to determine when it is time for
an EDH packet to appear in the video stream. The signal edh_next is asserted
during the sample before the first location of the first ADF word of the
EDH packet.

The output of this module is used to determine if EDH packets are missing from
the input video stream and to determine when to insert EDH packets into the
output video stream.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_edh_loc #(
    parameter HCNT_WIDTH = 12,  // # of bits in horizontal sample counter
    parameter VCNT_WIDTH = 10)  // # of bits in vertical line counter
(
    input  wire                     clk,            // clock input
    input  wire                     ce,             // clock enable
    input  wire                     rst,            // sync reset input
    input  wire                     f,              // field bit
    input  wire [VCNT_WIDTH-1:0]    vcnt,           // vertical line count
    input  wire [HCNT_WIDTH-1:0]    hcnt,           // horizontal sample count
    input  wire [2:0]               std,            // indicates the video standard
    output reg                      edh_next = 1'b0 // EDH packet should begin on next sample
);


//-----------------------------------------------------------------------------
// Parameter definitions
//
localparam HCNT_MSB      = HCNT_WIDTH - 1;       // MS bit # of hcnt
localparam VCNT_MSB      = VCNT_WIDTH - 1;       // MS bit # of vcnt


//
// This group of parameters defines the encoding for the video standards output
// code.
//
localparam [2:0]
    NTSC_422        = 3'b000,
    NTSC_INVALID    = 3'b001,
    NTSC_422_WIDE   = 3'b010,
    NTSC_4444       = 3'b011,
    PAL_422         = 3'b100,
    PAL_INVALID     = 3'b101,
    PAL_422_WIDE    = 3'b110,
    PAL_4444        = 3'b111;


//
// This group of parameters defines the line numbers where the EDH packet is
// located.
//
localparam NTSC_FLD1_EDH_LINE = 272;
localparam NTSC_FLD2_EDH_LINE =   9;
localparam PAL_FLD1_EDH_LINE  = 318;
localparam PAL_FLD2_EDH_LINE  =   5;
         
//
// This group of parameters defines the word count two words before the
// start of the EDH packet for each different supported video standard. First,
// the position of the SAV is defined, then the EDH packet position is defined
// relative to the SAV. A point two words counts before the start of the EDH
// packet is used because the edh_next must be asserted the count before the
// EDH plus there is one cycle of clock latency.
//

localparam SAV_NTSC_422      = 1712;
localparam SAV_NTSC_422_WIDE = 2284;
localparam SAV_NTSC_4444     = 3428;
localparam SAV_PAL_422       = 1724;
localparam SAV_PAL_422_WIDE  = 2300;
localparam SAV_PAL_4444      = 3452;

localparam EDH_PACKET_LENGTH = 23;

localparam EDH_NTSC_422      = SAV_NTSC_422 - EDH_PACKET_LENGTH - 2;
localparam EDH_NTSC_422_WIDE = SAV_NTSC_422_WIDE - EDH_PACKET_LENGTH - 2;
localparam EDH_NTSC_4444     = SAV_NTSC_4444 - EDH_PACKET_LENGTH - 2;
localparam EDH_PAL_422       = SAV_PAL_422 - EDH_PACKET_LENGTH - 2;
localparam EDH_PAL_422_WIDE  = SAV_PAL_422_WIDE - EDH_PACKET_LENGTH - 2;
localparam EDH_PAL_4444      = SAV_PAL_4444 - EDH_PACKET_LENGTH - 2;
        
//-----------------------------------------------------------------------------
// Signal definitions
//
wire                    ntsc;           // 1 = NTSC, 0 = PAL
reg     [VCNT_MSB:0]    edh_line_num;   // EDH occurs on this line number
wire                    edh_line;       // asserted when vcnt == edh_line_num
reg     [HCNT_MSB:0]    edh_hcnt;       // EDH begins sample after this value
wire                    edh_next_d;     // asserted when next sample begins EDH

//
// EDH vertical position detector
// 
// The following code determines when the current video line number (vcnt)
// matches the line where the next EDH packet location occurs. The line numbers
// for the EDH packets are different for NTSC and PAL video standards. Also,
// there is one EDH per field, so the field bit (f) is used to determine the
// line number of the next EDH packet.
//
assign ntsc = (std == NTSC_422) || (std == NTSC_INVALID) ||
              (std == NTSC_422_WIDE) || (std == NTSC_4444);

always @ (*)
    if (ntsc)
        begin
            if (~f)
                edh_line_num = NTSC_FLD2_EDH_LINE;
            else
                edh_line_num = NTSC_FLD1_EDH_LINE;
        end
    else
        begin
            if (~f)
                edh_line_num = PAL_FLD2_EDH_LINE;
            else
                edh_line_num = PAL_FLD1_EDH_LINE;
        end
            
assign edh_line = vcnt == edh_line_num;

//
// EDH horizontal position detector
//
// This code matches the current horizontal count (hcnt) with the word count
// of the next EDH location. The location of the EDH packet is immediately 
// before the SAV. edh_next_d is asserted when both the vcnt and hcnt match
// the EDH packet location.
//
always @ (*)
    case(std)
        NTSC_422:       edh_hcnt = EDH_NTSC_422;
        NTSC_422_WIDE:  edh_hcnt = EDH_NTSC_422_WIDE;
        NTSC_4444:      edh_hcnt = EDH_NTSC_4444;
        PAL_422:        edh_hcnt = EDH_PAL_422;
        PAL_422_WIDE:   edh_hcnt = EDH_PAL_422_WIDE;
        PAL_4444:       edh_hcnt = EDH_PAL_4444;
        default:        edh_hcnt = EDH_NTSC_422;
    endcase

assign edh_next_d = edh_line & (edh_hcnt == hcnt);

//
// output register
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            edh_next <= 1'b0;
        else
            edh_next <= edh_next_d;
    end
                    
endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/* 
This module instances and interconnects the various modules that make up the
error detection and handling (EDH) packet processor. This processor includes
an ANC packet checksum checker, but does not include any ANC packet mux or
demux functions.

EDH packets for digital component video are defined by the standards 
ITU-R BT.1304 and SMPTE RP 165-1994. The documents define a standard method
of generating and inserting checkwords into the video stream. These checkwords
are not used for error correction. They are used to determine if the video
data is being corrupted somewhere in the chain of video equipment processing
the data. The nature of the EDH packets allows the malfunctioning piece of
equipment to be quickly located.

Two checkwords are defined, one for the field of active picture (AP) video data
words and the other for the full field (FF) of video data. Three sets of flags
are defined to feed forward information regarding detected errors. One of flags
is associated with the AP checkword, one set with the FF checkword. The third
set of flags identify errors detected in the ancillary data checksums within
the field. Implementation of this third set is optional in the standards.

The two checkwords and three sets of flags for each field are combined into an
ancillary data packet, commonly called the EDH packet. The EDH packet occurs
at a fixed location, always immediately before the SAV symbol on the line before
the synchronous switching line. The synchronous switching lines for NTSC are
lines 10 and 273. For 625-line PAL they are lines 6 and 319.

Three sets of error flags outputs are provided. One set consists of the 12
error flags received in the last EDH packet in the input video stream. The
second set consists of the twelve flags sent in the last EDH packet in the
output video stream. A third set contains error flags related to the processing
of the received EDH packet such as packet_missing errors.

*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_edh_processor #(
    parameter ERROR_COUNT_WIDTH = 24,   // # of bits in errored fields counter
    parameter HCNT_WIDTH        = 12,   // # of bits in horizontal word counter
    parameter VCNT_WIDTH        = 10,   // # of bits in vertical line counter
    parameter FLAGS_WIDTH       = 16)   // # of bits in error flag enable field
(
    input  wire                         clk,                // clock input
    input  wire                         ce,                 // clock enable
    input  wire                         rst,                // sync reset input
    input  wire [9:0]                   vid_in,             // input video
    input  wire                         reacquire,          // forces autodetect to reacquire the video standard
    input  wire                         en_sync_switch,     // enables synchronous switching
    input  wire                         en_trs_blank,       // enables TRS blanking when asserted
    input  wire                         anc_idh_local,      // ANC IDH flag input
    input  wire                         anc_ues_local,      // ANC UES flag input
    input  wire                         ap_idh_local,       // AP IDH flag input
    input  wire                         ff_idh_local,       // FF IDH flag input
    input  wire [FLAGS_WIDTH-1:0]       errcnt_flg_en,      // selects which error flags increment the error counter
    input  wire                         clr_errcnt,         // clears the error counter
    input  wire                         receive_mode,       // 1 enables receiver, 0 for generate only
    output reg [9:0]                    vid_out = 10'b0,    // output video stream with EDH packets inserted
    output reg [2:0]                    std = 3'b0,         // video standard code
    output reg                          std_locked = 1'b0,  // video standard detector is locked
    output reg                          trs = 1'b0,         // asserted during flywheel generated TRS symbol
    output reg                          field = 1'b0,       // field indicator
    output reg                          v_blank = 1'b0,     // vertical blanking indicator
    output reg                          h_blank = 1'b0,     // horizontal blanking indicator
    output reg [HCNT_WIDTH-1:0]         horz_count = 0,     // horizontal position
    output reg [VCNT_WIDTH-1:0]         vert_count = 0,     // vertical position
    output reg                          sync_switch = 1'b0, // asserted on lines where synchronous switching is allowed
    output reg                          locked = 1'b0,      // asserted when flywheel is synchronized to video
    output reg                          eav_next = 1'b0,    // next word is first word of EAV
    output reg                          sav_next = 1'b0,    // next word is first word of SAV
    output reg                          xyz_word = 1'b0,    // current word is the XYZ word of a TRS
    output reg                          anc_next = 1'b0,    // next word is first word of a received ANC packet
    output reg                          edh_next = 1'b0,    // next word is first word of a received EDH packet
    output wire [4:0]                   rx_ap_flags,        // received AP error flags from last EDH packet
    output wire [4:0]                   rx_ff_flags,        // received FF error flags from last EDH packet
    output wire [4:0]                   rx_anc_flags,       // received ANC error flags from last EDH packet
    output wire [4:0]                   ap_flags,           // AP error flags from last field
    output wire [4:0]                   ff_flags,           // FF error flags from last field
    output wire [4:0]                   anc_flags,          // ANC error flags from last field
    output wire [3:0]                   packet_flags,       // error flags related to the received packet processing
    output wire [ERROR_COUNT_WIDTH-1:0] errcnt,             // errored fields counter
    output reg                          edh_packet = 1'b0   // asserted during all words of a generated EDH packet
);

//-----------------------------------------------------------------------------
// Parameter definitions
//

//
// This group of parameters defines the bit widths of various fields in the
// module. 
//
localparam HCNT_MSB      = HCNT_WIDTH - 1;       // MS bit # of hcnt
localparam VCNT_MSB      = VCNT_WIDTH - 1;       // MS bit # of vcnt
localparam ERRFLD_MSB    = ERROR_COUNT_WIDTH - 1;// MS bit of errcnt
localparam FLAGS_MSB     = FLAGS_WIDTH - 1;      // MS bit of flag enable field

//
// This group of parameters defines the encoding for the video standards output
// code.
//
localparam [2:0]
    NTSC_422        = 3'b000,
    NTSC_INVALID    = 3'b001,
    NTSC_422_WIDE   = 3'b010,
    NTSC_4444       = 3'b011,
    PAL_422         = 3'b100,
    PAL_INVALID     = 3'b101,
    PAL_422_WIDE    = 3'b110,
    PAL_4444        = 3'b111;

//-----------------------------------------------------------------------------
// Signal definitions
//
wire    [2:0]           dec_std;            // video_decode std output
wire                    dec_std_locked;     // video_decode std locked output
wire    [9:0]           dec_vid;            // video_decode video output
wire                    dec_trs;            // video_decode trs output
wire                    dec_f;              // video_decode field output
wire                    dec_v;              // video_decode v_blank output
wire                    dec_h;              // video_decode h_blank output
wire    [HCNT_MSB:0]    dec_hcnt;           // video_decode horz_count output
wire    [VCNT_MSB:0]    dec_vcnt;           // video_decode vert_count output
wire                    dec_sync_switch;    // video_decode sync_switch output
wire                    dec_locked;         // video_decode locked output
wire                    dec_eav_next;       // video_decode eav_next output
wire                    dec_sav_next;       // video_decode sav_next output
wire                    dec_xyz_word;       // video_decode xyz_word output
wire                    dec_anc_next;       // video_decode anc_next output
wire                    dec_edh_next;       // video_decode edh_next output
wire    [15:0]          ap_crc;             // calculated active pic CRC
wire                    ap_crc_valid;       // calculated active pic CRC valid signal
wire    [15:0]          ff_crc;             // calculated full field CRC
wire                    ff_crc_valid;       // calculated full field CRC valid signal
wire                    edh_missing;        // EDH packet missing error flag
wire                    edh_parity_err;     // EDH packet parity error flag
wire                    edh_chksum_err;     // EDH packet checksum error flag
wire                    edh_format_err;     // EDH packet format error flag
wire                    tx_edh_next;        // generated EDH packet begins on next word
wire    [4:0]           flag_bus;           // flag bus between EDH_FLAGS and EDH_TX
wire                    ap_flag_word;       // selects AP flags for flag bus
wire                    ff_flag_word;       // selects FF flags for flag bus
wire                    anc_flag_word;      // selects ANC flags for flag bus
wire                    rx_ap_crc_valid;    // received active pic CRC valid signal
wire    [15:0]          rx_ap_crc;          // received active pic CRC
wire                    rx_ff_crc_valid;    // received full field CRC valid signal
wire    [15:0]          rx_ff_crc;          // received full field CRC
wire    [4:0]           in_ap_flags;        // received active pic flags to edh_flags
wire    [4:0]           in_ff_flags;        // received full field flags to edh_flags
wire    [4:0]           in_anc_flags;       // received ANC flags to edh_flags
reg                     errcnt_en = 1'b0;   // enables error counter
wire                    anc_edh_local;      // ANC EDH signal
wire    [9:0]           tx_vid_out;         // video out of edh_tx
wire                    tx_edh_packet;      // asserted when edh packet is to be generated


//
// Video decoder module
//
v_smpte_uhdsdi_v1_0_5_edh_video_decode #(
    .VCNT_WIDTH     (VCNT_WIDTH),
    .HCNT_WIDTH     (HCNT_WIDTH))
DEC (
    .clk            (clk),
    .ce             (ce),
    .rst            (rst),
    .vid_in         (vid_in),
    .reacquire      (reacquire),
    .en_sync_switch (en_sync_switch),
    .en_trs_blank   (en_trs_blank),
    .std            (dec_std),
    .std_locked     (dec_std_locked),
    .trs            (dec_trs),
    .vid_out        (dec_vid),
    .field          (dec_f),
    .v_blank        (dec_v),
    .h_blank        (dec_h),
    .horz_count     (dec_hcnt),
    .vert_count     (dec_vcnt),
    .sync_switch    (dec_sync_switch),
    .locked         (dec_locked),
    .eav_next       (dec_eav_next),
    .sav_next       (dec_sav_next),
    .xyz_word       (dec_xyz_word),
    .anc_next       (dec_anc_next),
    .edh_next       (dec_edh_next)
);

//
// edh_crc module
//
// This module computes the CRC values for the incoming video stream, vid_in.
// Also, the module generates valid signals for both CRC values based on the
// locked signal. If locked rises during a field, the CRC is considered to be
// invalid.
v_smpte_uhdsdi_v1_0_5_edh_crc #(
    .VCNT_WIDTH     (VCNT_WIDTH))
EDH_CRC (
    .clk            (clk),
    .ce             (ce),
    .rst            (rst),
    .f              (dec_f),
    .h              (dec_h),
    .eav_next       (dec_eav_next),
    .xyz_word       (dec_xyz_word),
    .vid_in         (dec_vid),
    .vcnt           (dec_vcnt),
    .std            (dec_std),
    .locked         (dec_locked),
    .ap_crc         (ap_crc),
    .ap_crc_valid   (ap_crc_valid),
    .ff_crc         (ff_crc),
    .ff_crc_valid   (ff_crc_valid)
);

//
// edh_rx module
//
// This module processes EDH packets found in the incoming video stream. The
// CRC words and valid flags are captured from the packet. Various error flags
// related to errors found in the packet are generated.
//
v_smpte_uhdsdi_v1_0_5_edh_rx EDH_RX (
    .clk            (clk),
    .ce             (ce),
    .rst            (rst),
    .rx_edh_next    (dec_edh_next),
    .vid_in         (dec_vid),
    .edh_next       (tx_edh_next),
    .reg_flags      (1'b0),
    .ap_crc_valid   (rx_ap_crc_valid),
    .ap_crc         (rx_ap_crc),
    .ff_crc_valid   (rx_ff_crc_valid),
    .ff_crc         (rx_ff_crc),
    .edh_missing    (edh_missing),
    .edh_parity_err (edh_parity_err),
    .edh_chksum_err (edh_chksum_err),
    .edh_format_err (edh_format_err),
    .in_ap_flags    (in_ap_flags),
    .in_ff_flags    (in_ff_flags),
    .in_anc_flags   (in_anc_flags),
    .rx_ap_flags    (rx_ap_flags),
    .rx_ff_flags    (rx_ff_flags),
    .rx_anc_flags   (rx_anc_flags)
);

//
// edh_loc module
//
// This module locates the beginning of an EDH packet in the incoming video
// stream. It asserts the tx_edh_next siganl the sample before the EDH packet
// begins on vid_in.
//
v_smpte_uhdsdi_v1_0_5_edh_loc #(
    .HCNT_WIDTH     (HCNT_WIDTH),
    .VCNT_WIDTH     (VCNT_WIDTH))
EDH_LOC (
    .clk            (clk),
    .ce             (ce),
    .rst            (rst),
    .f              (dec_f),
    .vcnt           (dec_vcnt),
    .hcnt           (dec_hcnt),
    .std            (dec_std),
    .edh_next       (tx_edh_next)
);

//
// anc_rx module
//
// This module calculates checksums for every ANC packet in the input video
// stream and compares the calculated checksums against the CS word of each
// packet. It also checks the parity bits of all parity protected words in the
// ANC packets. An error in any ANC packet will assert the anc_edh_local signal.
// This output will remain asserted until after the next EDH packet is sent in
// the output video stream.
//
v_smpte_uhdsdi_v1_0_5_edh_anc_rx ANC_RC (
    .clk            (clk),
    .ce             (ce),
    .rst            (rst),
    .locked         (dec_locked),
    .rx_anc_next    (dec_anc_next),
    .rx_edh_next    (dec_edh_next),
    .edh_packet     (tx_edh_packet),
    .vid_in         (dec_vid),
    .anc_edh_local  (anc_edh_local)
);

//
// edh_tx module
//
// This module generates a new EDH packet based on the calculated CRC words
// and the incoming and local flags.
//
v_smpte_uhdsdi_v1_0_5_edh_tx EDH_TX (
    .clk            (clk),
    .ce             (ce),
    .rst            (rst),
    .vid_in         (dec_vid),
    .edh_next       (tx_edh_next),
    .edh_missing    (edh_missing),
    .ap_crc_valid   (ap_crc_valid),
    .ap_crc         (ap_crc),
    .ff_crc_valid   (ff_crc_valid),
    .ff_crc         (ff_crc),
    .flags_in       (flag_bus),
    .ap_flag_word   (ap_flag_word),
    .ff_flag_word   (ff_flag_word),
    .anc_flag_word  (anc_flag_word),
    .edh_packet     (tx_edh_packet),
    .edh_vid        (tx_vid_out)
);

//
// edh_flags module
//
// This module creates the error flags that are included in the new
// EDH packet created by the GEN module. It also captures those flags until the
// next EDH packet and provides them as outputs.
//
v_smpte_uhdsdi_v1_0_5_edh_flags EDH_FLAGS (
    .clk                (clk),
    .ce                 (ce),
    .rst                (rst),
    .receive_mode       (receive_mode),
    .ap_flag_word       (ap_flag_word),
    .ff_flag_word       (ff_flag_word),
    .anc_flag_word      (anc_flag_word),
    .edh_missing        (edh_missing),
    .edh_parity_err     (edh_parity_err),
    .edh_format_err     (edh_format_err),
    .rx_ap_crc_valid    (rx_ap_crc_valid),
    .rx_ap_crc          (rx_ap_crc),
    .rx_ff_crc_valid    (rx_ff_crc_valid),
    .rx_ff_crc          (rx_ff_crc),
    .rx_ap_flags        (in_ap_flags),
    .rx_ff_flags        (in_ff_flags),
    .rx_anc_flags       (in_anc_flags),
    .anc_edh_local      (anc_edh_local),
    .anc_idh_local      (anc_idh_local),
    .anc_ues_local      (anc_ues_local),
    .ap_idh_local       (ap_idh_local),
    .ff_idh_local       (ff_idh_local),
    .calc_ap_crc_valid  (ap_crc_valid),
    .calc_ap_crc        (ap_crc),
    .calc_ff_crc_valid  (ff_crc_valid),
    .calc_ff_crc        (ff_crc),
    .flags              (flag_bus),
    .ap_flags           (ap_flags),
    .ff_flags           (ff_flags),
    .anc_flags          (anc_flags)
);

//
// edh_errcnt module
//
// This counter increments once for every field that contains an enabled error.
// The error counter is disabled until after the video decoder is locked to the
// video stream for the first time and the first EDH packet has been received.
//
v_smpte_uhdsdi_v1_0_5_edh_errcnt # (
    .ERROR_COUNT_WIDTH  (ERROR_COUNT_WIDTH),
    .FLAGS_WIDTH        (FLAGS_WIDTH))
EDH_ERRCNT (
    .clk                (clk),
    .ce                 (ce),
    .rst                (rst),
    .clr_errcnt         (clr_errcnt),
    .count_en           (errcnt_en),
    .flag_enables       (errcnt_flg_en),
    .flags              ({edh_chksum_err, ap_flags, ff_flags, anc_flags}),
    .edh_next           (tx_edh_next),
    .errcnt             (errcnt)
);

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            errcnt_en <= 1'b0;
        else if (locked & dec_edh_next)
            errcnt_en <= 1'b1;
    end

//
// packet_flags
//
// This statement combines the four EDH packet flags into a vector.
//
assign packet_flags = {edh_format_err, edh_chksum_err, edh_parity_err, edh_missing};

//
// output registers
//
// This code implements an output register for the video path and all video
// timing signals.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
        begin
            vid_out <= 0;
            std <= 0;
            std_locked <= 0;
            trs <= 0;
            field <= 0;
            v_blank <= 0;
            h_blank <= 0;
            horz_count <= 0;
            vert_count <= 0;
            sync_switch <= 0;
            locked <= 0;
            eav_next <= 0;
            sav_next <= 0;
            xyz_word <= 0;
            anc_next <= 0;
            edh_next <= 0;
            edh_packet <= 0;
        end
        else
        begin
            vid_out <= tx_vid_out;
            std <= dec_std;
            std_locked <= dec_std_locked;
            trs <= dec_trs;
            field <= dec_f;
            v_blank <= dec_v;
            h_blank <= dec_h;
            horz_count <= dec_hcnt;
            vert_count <= dec_vcnt;
            sync_switch <= dec_sync_switch;
            locked <= dec_locked;
            eav_next <= dec_eav_next;
            sav_next <= dec_sav_next;
            xyz_word <= dec_xyz_word;
            anc_next <= dec_anc_next;
            edh_next <= dec_edh_next;
            edh_packet <= tx_edh_packet;
        end
    end

endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/* 
This module processes a received EDH packet. It examines the vcnt and hcnt
values from the video flywheel to determine when an EDH packet should occur. If
there is no EDH packet then, the missing EDH packet flag is asserted. If an EDH
packet occurs somewhere other than where it is expected, the misplaced EDH
packet flag is asserted.

When an EDH packet at the expected location if found, it is checked to make
sure all the words of the packet are correct, that the parity of the payload
data words are correct, and that the checksum for the packet is correct.

The active picture and full field CRCs and flags are extracted and stored in
registers.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_edh_rx (
    input  wire             clk,                    // clock input
    input  wire             ce,                     // clock enable
    input  wire             rst,                    // sync reset input
    input  wire             rx_edh_next,            // indicates the next word is the first word of a received EDH packet
    input  wire [9:0]       vid_in,                 // video data
    input  wire             edh_next,               // EDH packet begins on next sample
    input  wire             reg_flags,              // 1 = register flag words, 0 = feed vid_in through
    output reg              ap_crc_valid = 1'b0,    // valid bit for active picture CRC
    output wire [15:0]      ap_crc,                 // active picture CRC
    output reg              ff_crc_valid = 1'b0,    // valid bit for full field CRC
    output wire [15:0]      ff_crc,                 // full field CRC
    output reg              edh_missing = 1'b0,     // asserted when last expected EDH packet was missing
    output reg              edh_parity_err = 1'b0,  // asserted when a parity error occurs in EDH packet
    output reg              edh_chksum_err = 1'b0,  // asserted when a checksum error occurs in EDH packet
    output reg              edh_format_err = 1'b0,  // asserted when a format error is found in EDH packet
    output wire [4:0]       in_ap_flags,            // received AP flag word to edh_flags module
    output wire [4:0]       in_ff_flags,            // received FF flag word to edh_flags module
    output wire [4:0]       in_anc_flags,           // received ANC flag word to edh_flags module
    output wire [4:0]       rx_ap_flags,            // received & registered AP flags for external inspection
    output wire [4:0]       rx_ff_flags,            // received & registered FF flags for external inspection
    output wire [4:0]       rx_anc_flags            // received & registered ANC flags for external inspection
);


//-----------------------------------------------------------------------------
// Parameter definitions
//      

//
// This group of parameters defines the fixed values of some of the words in
// the EDH packet.
//
localparam EDH_DID           = 10'h1f4;
localparam EDH_DBN           = 10'h200;
localparam EDH_DC            = 10'h110;


//
// This group of parameters defines the states of the EDH processor state
// machine.
//
localparam STATE_WIDTH   = 5;
localparam STATE_MSB     = STATE_WIDTH - 1;

localparam [STATE_WIDTH-1:0]
    S_WAIT   = 0,
    S_ADF1   = 1,
    S_ADF2   = 2,
    S_ADF3   = 3,
    S_DID    = 4,
    S_DBN    = 5,
    S_DC     = 6,
    S_AP1    = 7,
    S_AP2    = 8,
    S_AP3    = 9,
    S_FF1    = 10,
    S_FF2    = 11,
    S_FF3    = 12,
    S_ANCFLG = 13,
    S_APFLG  = 14,
    S_FFFLG  = 15,
    S_RSV1   = 16,
    S_RSV2   = 17,
    S_RSV3   = 18,
    S_RSV4   = 19,
    S_RSV5   = 20,
    S_RSV6   = 21,
    S_RSV7   = 22,
    S_CHK    = 23,
    S_ERRM   = 24,  // Missing EDH packet
    S_ERRF   = 25,  // Format error in EDH packet
    S_ERRC   = 26;  // Checksum error in EDH packet

//-----------------------------------------------------------------------------
// Signal definitions
//
reg     [STATE_MSB:0]   current_state = S_WAIT;     // FSM current state
reg     [STATE_MSB:0]   next_state;                 // FSM next state
wire                    parity_err;                 // detects parity errors on EDH words
wire                    parity;                     // used to generate parity_err
reg     [8:0]           checksum = 9'b0;            // checksum for EDH packet
reg                     ld_ap1;                     // loads bits 5:0 of active picture crc
reg                     ld_ap2;                     // loads bits 11:6 of active picture crc
reg                     ld_ap3;                     // loads bits 15:12 of active picture crc
reg                     ld_ff1;                     // loads bits 5:0 of full field crc
reg                     ld_ff2;                     // loads bits 11:6 of full field crc
reg                     ld_ff3;                     // loads bits 15:12 of full field crc
reg                     ld_ap_flags;                // loads the rx_ap_flags register
reg                     ld_ff_flags;                // loads the rx_ff_flags register
reg                     ld_anc_flags;               // loads the rx_anc_flags register
reg                     clr_checksum;               // asserted to clear the checksum
reg                     clr_errors;                 // asserted to clear the EDH packet errs
reg     [15:0]          ap_crc_reg = 15'b0;         // active picture CRC register
reg     [15:0]          ff_crc_reg = 15'b0;         // full field CRC register                  
reg                     missing_err;                // asserted when EDH packet is missing
reg                     format_err;                 // asserted when format error in EDH packet is detected
reg                     check_parity;               // asserted when parity error in EDH packet is detected
reg                     checksum_err;               // asserted when checksum error in EDH packet is detected
reg                     rx_edh = 1'b0;              // asserted when current word is first word of received EDH
reg     [4:0]           rx_ap_flg_reg = 5'b0;       // holds the received AP flags
reg     [4:0]           rx_ff_flg_reg = 5'b0;       // holds the received FF flags
reg     [4:0]           rx_anc_flg_reg = 5'b0;      // holds the received ANC flags

//
// delay flip-flop for rx_edh_next
//
// The resulting signal, rx_edh, is asserted during the first word of a
// received EDH packet.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            rx_edh <= 1'b0;
        else
            rx_edh <= rx_edh_next;
    end

//
// FSM: current_state register
//
// This code implements the current state register. 
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            current_state <= S_WAIT;
        else
            current_state <= next_state;
    end

//
// FSM: next_state logic
//
// This case statement generates the next_state value for the FSM based on
// the current_state and the various FSM inputs.
//
always @ (*)
    case(current_state)
        S_WAIT:     if (edh_next)
                        next_state = S_ADF1;
                    else
                        next_state = S_WAIT;
                
        S_ADF1:     if (rx_edh)
                        next_state = S_ADF2;
                    else
                        next_state = S_ERRM;

        S_ADF2:     next_state = S_ADF3;

        S_ADF3:     next_state = S_DID;

        S_DID:      next_state = S_DBN;

        S_DBN:      if (vid_in[9:2] == (EDH_DBN >> 2))
                        next_state = S_DC;
                    else
                        next_state = S_ERRF;

        S_DC:       if (vid_in[9:2] == (EDH_DC >> 2))
                        next_state = S_AP1;
                    else
                        next_state = S_ERRF;

        S_AP1:      next_state = S_AP2;

        S_AP2:      next_state = S_AP3;

        S_AP3:      next_state = S_FF1;

        S_FF1:      next_state = S_FF2;

        S_FF2:      next_state = S_FF3;

        S_FF3:      next_state = S_ANCFLG;

        S_ANCFLG:   next_state = S_APFLG;

        S_APFLG:    next_state = S_FFFLG;
                    
        S_FFFLG:    next_state = S_RSV1;

        S_RSV1:     next_state = S_RSV2;

        S_RSV2:     next_state = S_RSV3;

        S_RSV3:     next_state = S_RSV4;

        S_RSV4:     next_state = S_RSV5;

        S_RSV5:     next_state = S_RSV6;

        S_RSV6:     next_state = S_RSV7;

        S_RSV7:     next_state = S_CHK;

        S_CHK:      if (checksum == vid_in[8:0] && checksum[8] == ~vid_in[9])
                        next_state = S_WAIT;
                    else
                        next_state = S_ERRC;

        S_ERRM:     next_state = S_WAIT;

        S_ERRF:     next_state = S_WAIT;

        S_ERRC:     next_state = S_WAIT;

        default: next_state = S_WAIT;

    endcase
        
//
// FSM: outputs
//
// This block decodes the current state to generate the various outputs of the
// FSM.
//
always @ (*)
begin
    // Unless specifically assigned in the case statement, all FSM outputs
    // default to the values below.
    ld_ap1          = 1'b0;
    ld_ap2          = 1'b0;
    ld_ap3          = 1'b0;
    ld_ff1          = 1'b0;
    ld_ff2          = 1'b0;
    ld_ff3          = 1'b0;
    ld_ap_flags     = 1'b0;
    ld_ff_flags     = 1'b0;
    ld_anc_flags    = 1'b0;
    clr_checksum    = 1'b0;
    clr_errors      = 1'b0;
    missing_err     = 1'b0;
    format_err      = 1'b0;
    check_parity    = 1'b0;
    checksum_err    = 1'b0;
                        
    case(current_state)     
        S_ADF1:     clr_errors = 1'b1;

        S_ADF3:     clr_checksum = 1'b1;

        S_AP1:      begin
                        ld_ap1 = 1'b1;
                        check_parity = 1'b1;
                    end

        S_AP2:      begin
                        ld_ap2 = 1'b1;
                        check_parity = 1'b1;
                    end

        S_AP3:      begin
                        ld_ap3 = 1'b1;
                        check_parity = 1'b1;
                    end

        S_FF1:      begin
                        ld_ff1 = 1'b1;
                        check_parity = 1'b1;
                    end

        S_FF2:      begin
                        ld_ff2 = 1'b1;
                        check_parity = 1'b1;
                    end

        S_FF3:      begin
                        ld_ff3 = 1'b1;
                        check_parity = 1'b1;
                    end

        S_ANCFLG:   begin
                        ld_anc_flags = 1'b1;
                        check_parity = 1'b1;
                    end

        S_APFLG:    begin
                        ld_ap_flags = 1'b1;
                        check_parity = 1'b1;
                    end

        S_FFFLG:    begin
                        ld_ff_flags = 1'b1;
                        check_parity = 1'b1;
                    end

        S_ERRM:     missing_err = 1'b1;

        S_ERRF:     format_err = 1'b1;

        S_ERRC:     checksum_err = 1'b1;

    endcase
end

//
// parity error detection
//
// This code calculates the parity of bits 7:0 of the video word. The calculated
// parity bit is compared to bit 8 and the complement of bit 9 to determine if
// a parity error has occured. If a parity error is detected, the parity_err
// signal is asserted. Parity is only valid on the payload portion of the
// EDH packet (user data words).
//
assign parity = vid_in[7] ^ vid_in[6] ^ vid_in[5] ^ vid_in[4] ^
                vid_in[3] ^ vid_in[2] ^ vid_in[1] ^ vid_in[0];

assign parity_err = (parity ^ vid_in[8]) | (parity ^ ~vid_in[9]);


//
// checksum calculator
//
// This code generates a checksum for the EDH packet. The checksum is cleared
// to zero prior to beginning the checksum calculation by the FSM asserting the
// clr_checksum signal. The vid_in word is added to the current checksum when
// the FSM asserts the do_checksum signal. The checksum is a 9-bit value and
// is computed by summing all but the MSB of the vid_in word with the current
// checksum value and ignoring any carry bits.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst | clr_checksum)
            checksum <= 0;
        else
            checksum <= checksum + vid_in[8:0];
    end


//
// Active-picture CRC and valid bit register
//
// This code captures the AP CRC word and valid bit. The CRC word is carried
// in three different words in the EDH packet and is assembled into a complete
// 16-bit checkword plus a valid bit by this logic.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
        begin
            ap_crc_valid <= 1'b0;
            ap_crc_reg <= 0;
        end
        else
        begin
            if (ld_ap1)
                ap_crc_reg <= {ap_crc_reg[15:6], vid_in[7:2]};
            else if (ld_ap2)
                ap_crc_reg <= {ap_crc_reg[15:12], vid_in[7:2], ap_crc_reg[5:0]};
            else if (ld_ap3)
            begin
                ap_crc_reg <= {vid_in[5:2], ap_crc_reg[11:0]};
                ap_crc_valid <= vid_in[7];
            end
        end
    end

//
// Full-field CRC and valid bit register
//
// This code captures the FF CRC word and valid bit. The CRC word is carried
// in three different words in the EDH packet and is assembled into a complete
// 16-bit checkword plus a valid bit by this logic.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
        begin
            ff_crc_valid <= 1'b0;
            ff_crc_reg <= 0;
        end
        else
        begin
            if (ld_ff1)
                ff_crc_reg <= {ff_crc_reg[15:6], vid_in[7:2]};
            else if (ld_ff2)
                ff_crc_reg <= {ff_crc_reg[15:12], vid_in[7:2], ff_crc_reg[5:0]};
            else if (ld_ff3)
            begin
                ff_crc_reg <= {vid_in[5:2], ff_crc_reg[11:0]};
                ff_crc_valid <= vid_in[7];
            end
        end
    end

//
// EDH packet error flags
//
// This code implements registers for each of the four different EDH packet
// error flags. These flags are captured as an EDH packet is received and
// remain asserted until the start of the next EDH packet.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst | clr_errors)
        begin
            edh_missing <= 1'b0;
            edh_parity_err <= 1'b0;
            edh_chksum_err <= 1'b0;
            edh_format_err <= 1'b0;
        end
        else 
        begin
            if (missing_err)
                edh_missing <= 1'b1;
            if (format_err)
                edh_format_err <= 1'b1;
            if (checksum_err)
                edh_chksum_err <= 1'b1;
            if (check_parity & parity_err)
                edh_parity_err <= 1'b1;
        end
    end


//
// received flags registers
//
// These registers capture the three sets of error status flags (ap, ff, and
// anc) from the received EDH packet. These flags remain in the registers 
// until overwritten by the next EDH packet.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            rx_ap_flg_reg <= 0;
        else if (ld_ap_flags)
            rx_ap_flg_reg <= vid_in[6:2];
    end

assign in_ap_flags = reg_flags ? rx_ap_flg_reg : vid_in[6:2];

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            rx_ff_flg_reg <= 0;
        else if (ld_ff_flags)
            rx_ff_flg_reg <= vid_in[6:2];
    end

assign in_ff_flags = reg_flags ? rx_ff_flg_reg : vid_in[6:2];

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            rx_anc_flg_reg <= 0;
        else if (ld_anc_flags)
            rx_anc_flg_reg <= vid_in[6:2];
    end
                            
assign in_anc_flags = reg_flags ? rx_anc_flg_reg : vid_in[6:2];

//
// outputs assignments
//
assign ap_crc = ap_crc_reg;
assign ff_crc = ff_crc_reg;
    
assign rx_ap_flags = rx_ap_flg_reg;
assign rx_ff_flags = rx_ff_flg_reg;
assign rx_anc_flags = rx_anc_flg_reg;
                    
endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/* 
This module examines the input video stream for TRS symbols and ancillary data
packets. It does some decoding of the TRS symbols and ANC packets to generate
a variety of outputs.

This input video stream is passed through a four register pipeline, delaying the
video by four clock cycles. This allows the pipeline to contain the entire TRS
symbol or the ancillary data flag plus DID word to allow them to be decoded
before the video emerges from the module.

This module has the following inputs:

clk: clock input

ce: clock enable

rst: synchronous reset input

vid_in: input video stream port

This module generates the following outputs:

vid_out: This is the output video stream. It is identical to the input video
stream, but delayed by four clock cycles.

rx_trs: This output is asserted only when the first word of a TRS symbol is
present on vid_out.

rx_eav: This output is asserted only when the first word of an EAV symbol is
present on vid_out.

rx_sav: This output is asserted only when the first word of an SAV symbol is
present on vid_out.

rx_f: This is the field indicator bit F latched from the XYZ word of the last
received TRS symbol.

rx_v: This is the vertical blanking interval bit V latched from the XYZ word of
the last received TRS symbol.

rx_h: This is the horizontal blanking interval bit H latched from the XYZ word
of the last received TRS symbol.

rx_xyz: This outpuot is asserted when the XYZ word of a TRS symbol is present on
vid_out.

rx_xyz_err: This output is asserted when the received XYZ word contains an
error. It is only asserted when the XYZ word appears on vid_out. This signal is
only valid for the 4:2:2 video standards.

rx_xyz_err_4444: This output is asserted when the received XYZ word contains an
error. It is only asserted when the XYZ word appears on vid_out. This signals is
only valid for the 4:4:4:4 video standards.

rx_anc: This output is asserted when the first word of an ANC packet (the first
word of the ancillary data flag) is present on vid_out.

rx_edh: This output is asserted when the first word of an EDH packet (the first
word of the ancillary data flag) is present on vid_out.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_edh_trs_detect (
    input  wire             clk,            // clock input
    input  wire             ce,             // clock enable
    input  wire             rst,            // sync reset input
    input  wire [9:0]       vid_in,         // video input

    // outputs
    output wire [9:0]       vid_out,        // delayed and clipped video output
    output wire             rx_trs,         // asserted during first word of TRS symbol
    output wire             rx_eav,         // asserted during first word of an EAV symbol
    output wire             rx_sav,         // asserted during first word of an SAV symbol
    output wire             rx_f,           // field bit from last received TRS symbol
    output wire             rx_v,           // vertical blanking interval bit from last TRS symbol
    output wire             rx_h,           // horizontal blanking interval bit from last TRS symbol
    output wire             rx_xyz,         // asserted during TRS XYZ word
    output wire             rx_xyz_err,     // XYZ error flag for non-4444 standards
    output wire             rx_xyz_err_4444,// XYZ error flag for 4444 standards
    output wire             rx_anc,         // asserted during first word of ADF
    output wire             rx_edh          // asserted during first word of ADF if it is an EDH packet
);

         
//-----------------------------------------------------------------------------
// Signal definitions
//

reg     [9:0]   in_reg = 0;                     // input register
reg     [9:0]   pipe1_vid = 0;                  // first pipeline register
reg             pipe1_ones = 1'b0;              // asserted if pipe1_vid[9:2] is all 1s
reg             pipe1_zeros = 1'b0;             // asserted if pipe1_vid[9:2] is all 0s
reg     [9:0]   pipe2_vid = 0;                  // second pipeline register
reg             pipe2_ones = 1'b0;              // asserted if pipe2_vid[9:2] is all 1s 
reg             pipe2_zeros = 1'b0;             // asserted if pipe2_vid[9:2] is all 0s
reg     [9:0]   out_reg_vid = 0;                // output register - video stream
reg             out_reg_anc = 1'b0;             // output register - rx_anc signal
reg             out_reg_edh = 1'b0;             // output register - rx_edh signal
reg             out_reg_trs = 1'b0;             // output register - rx_trs signal
reg             out_reg_eav = 1'b0;             // output register - rx_eav signal
reg             out_reg_sav = 1'b0;             // output register - rx_sav signal
reg             out_reg_xyz = 1'b0;             // output register - rx_xyz signal
reg             out_reg_xyz_err = 1'b0;         // output register - rx_xyz_err signal
reg             out_reg_xyz_err_4444 = 1'b0;    // output register - rx_xyz_err_4444 signal
reg             out_reg_f = 1'b0;               // output register - rx_f signal
reg             out_reg_v = 1'b0;               // output register - rx_v signal
reg             out_reg_h = 1'b0;               // output register - rx_h signal
wire            xyz;                            // XYZ detect input to out_reg
wire            xyz_err;                        // XYZ error detect input to out_reg
wire            xyz_err_4444;                   // XYZ 4444 error detect input to out_reg
wire            anc;                            // anc input to out_reg
wire            trs;                            // trs input to out_reg
wire            eav;                            // eav input to out_reg
wire            sav;                            // sav input to out_reg
wire            edh_in;                         // asserted when in_reg = 0x1f4 (EDH DID)
wire            all_ones_in;                    // asserted when in_reg is all ones
wire            all_zeros_in;                   // asserted when in_reg is all zeros
reg     [1:0]   trs_delay = 2'b00;              // delay register used to assert xyz signal
wire            f;                              // internal version of rx_f
wire            v;                              // internal version of rx_v
wire            h;                              // internal version of rx_h

//
// in_reg
//
// The input register loads the value on the vid_in port.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            in_reg <= 0;
        else
            in_reg <= vid_in;
    end


//
// all ones and all zeros detectors
//
// This logic determines if the input video word is all ones or all zeros. To
// provide compatibility with 8-bit video equipment, the LS two bits are
// ignored.  
// 
assign all_ones_in = &in_reg[9:2];
assign all_zeros_in = ~|in_reg[9:2];


//
// DID detector decoder
//
// The edh_in signal is asserted if the in_reg contains a value of 0x1f4.
// This is the value of the DID word for an EDH packet. 
//
assign edh_in    = (vid_in == 10'h1f4);

//
// pipe1
//
// The pipe1 register holds the inut video and the outputs of the all zeros
// and all ones detectors.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
        begin
            pipe1_vid   <= 0;
            pipe1_ones  <= 1'b0;
            pipe1_zeros <= 1'b0;
        end
        else
        begin
            pipe1_vid   <= in_reg;
            pipe1_ones  <= all_ones_in;
            pipe1_zeros <= all_zeros_in;
        end
    end


//
// pipe2_reg
//
// The pipe2 register delays the contents of the pipe1 register for one more
// clock cycle.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
        begin
            pipe2_vid   <= 0;
            pipe2_ones  <= 1'b0;
            pipe2_zeros <= 1'b0;
        end
        else
        begin
            pipe2_vid   <= pipe1_vid;
            pipe2_ones  <= pipe1_ones;
            pipe2_zeros <= pipe1_zeros;
        end
    end


//
// TRS & ANC detector
//
// The trs signal when the sequence 3ff, 000, 000 is stored in the pipe2, pipe1,
// and in_reg registers, respectively. The anc signal is asserted when these
// same registers hold the sequence 000, 3ff, 3ff.
//
assign trs = all_zeros_in & pipe1_zeros & pipe2_ones;
assign anc = all_ones_in & pipe1_ones & pipe2_zeros;
assign eav = trs & vid_in[6];
assign sav = trs & ~vid_in[6];

//
// f, v, and h flag generation
//
assign f = trs ? vid_in[8] : out_reg_f;
assign v = trs ? vid_in[7] : out_reg_v;
assign h = trs ? vid_in[6] : out_reg_h;

//
// XYZ and XYZ error logic
//
// The xyz signal is asserted when the pipe2 register holds the XYZ word of a
// TRS symbol. The xyz_err signal is asserted if an error is detected in the
// format of the XYZ word stored in pipe2. This signal is not valid for the
// 4444 component digital video formats. The xyz_err_4444 signal is asserted
// for XYZ word format errors.
//
assign xyz = trs_delay[1];

assign xyz_err = 
    xyz & 
    ((pipe2_vid[5] ^ pipe2_vid[7] ^ pipe2_vid[6]) |                 // P3 = V ^ H
     (pipe2_vid[4] ^ pipe2_vid[8] ^ pipe2_vid[6]) |                 // P2 = F ^ H
     (pipe2_vid[3] ^ pipe2_vid[8] ^ pipe2_vid[7]) |                 // P1 = F ^ V
     (pipe2_vid[2] ^ pipe2_vid[8] ^ pipe2_vid[7] ^ pipe2_vid[6]) |  // P0 = F ^ V ^ H
     ~pipe2_vid[9]);

assign xyz_err_4444 = 
    xyz &
    ((pipe2_vid[4] ^ pipe2_vid[8] ^ pipe2_vid[7] ^ pipe2_vid[6]) |  // P4 = F ^ V ^ H
     (pipe2_vid[3] ^ pipe2_vid[8] ^ pipe2_vid[7] ^ pipe2_vid[5]) |  // P3 = F ^ V ^ S
     (pipe2_vid[2] ^ pipe2_vid[7] ^ pipe2_vid[6] ^ pipe2_vid[5]) |  // P2 = V ^ H ^ S
     (pipe2_vid[1] ^ pipe2_vid[8] ^ pipe2_vid[6] ^ pipe2_vid[5]) |  // P1 = F ^ H ^ S
     ~pipe2_vid[9]);

//
// output reg
//
// The output register holds the the output video data and various flags.
// 
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
        begin
            out_reg_vid <= 0;
            out_reg_trs <= 1'b0;
            out_reg_eav <= 1'b0;
            out_reg_sav <= 1'b0;
            out_reg_anc <= 1'b0;
            out_reg_edh <= 1'b0;
            out_reg_xyz <= 1'b0;
            out_reg_xyz_err <= 1'b0;
            out_reg_xyz_err_4444 <= 1'b0;
            out_reg_f <= 0;
            out_reg_v <= 0;
            out_reg_h <= 0;
        end
        else
        begin
            out_reg_vid <= pipe2_vid;
            out_reg_trs <= trs;
            out_reg_eav <= eav;
            out_reg_sav <= sav;
            out_reg_anc <= anc;
            out_reg_edh <= anc & edh_in;
            out_reg_xyz <= xyz;
            out_reg_xyz_err <= xyz_err;
            out_reg_xyz_err_4444 <= xyz_err_4444;
            out_reg_f <= f;
            out_reg_v <= v;
            out_reg_h <= h;
        end
    end

//
// trs_delay register
//
// Used to assert the xyz signal when pipe2 contains the XYZ word of a TRS
// symbol.
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            trs_delay <= 2'b00;
        else
            trs_delay <= {trs_delay[0], out_reg_trs};
    end

//
// assign the outputs
//
assign vid_out = out_reg_vid;
assign rx_trs = out_reg_trs;
assign rx_eav = out_reg_eav;
assign rx_sav = out_reg_sav;
assign rx_anc = out_reg_anc;
assign rx_xyz = out_reg_xyz;
assign rx_xyz_err = out_reg_xyz_err;
assign rx_xyz_err_4444 = out_reg_xyz_err_4444;
assign rx_edh = out_reg_edh;
assign rx_f = out_reg_f;
assign rx_v = out_reg_v;
assign rx_h = out_reg_h;
            
endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/* 
This module generates a new EDH packet and inserts it into the output video
stream.

The module is controlled by a finite state machine. The FSM waits for the
edh_next signal to be asserted by the edh_loc module. This signal indicates
that the next word is beginning of the area where an EDH packet should be
inserted.

The FSM then generates all the words of the EDH packet, assembling the payload
of the packet from the CRC and error flag inputs. The three sets of error flags
enter the module sequentially on the flags_in port. The module generates three
outputs (ap_flag_word, ff_flag_word, and anc_flag_word) to indicate which flag
set it needs on the flags_in port.

The module generates an output signal, edh_packet, that is asserted during all
the entire time that a generated EDH packet is being inserted into the video
stream. This signal is used by various other modules to determine when an EDH
packet has been sent.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_edh_tx (
    // inputs
    input  wire                 clk,                // clock input
    input  wire                 ce,                 // clock enable
    input  wire                 rst,                // sync reset input
    input  wire [9:0]           vid_in,             // input video data
    input  wire                 edh_next,           // asserted when next word begins generated EDH packet
    input  wire                 edh_missing,        // received EDH packet is missing
    input  wire                 ap_crc_valid,       // active picture CRC valid
    input  wire [15:0]          ap_crc,             // active picture CRC
    input  wire                 ff_crc_valid,       // full field CRC valid
    input  wire [15:0]          ff_crc,             // full field CRC
    input  wire [4:0]           flags_in,           // bus that carries AP, FF, and ANC flags
    output reg                  ap_flag_word,       // asserted during AP flag word in EDH packet
    output reg                  ff_flag_word,       // asserted during FF flag word in EDH packet
    output reg                  anc_flag_word,      // asserted during ANC flag word in EDH packet
    output reg                  edh_packet = 1'b0,  // asserted during all words of EDH packet
    output wire [9:0]           edh_vid             // generated EDH packet data
);


//-----------------------------------------------------------------------------
// Parameter definitions
//      

//
// This group of parameters defines the fixed values of some of the words in
// the EDH packet.
//
localparam EDH_ADF1          = 10'h000;
localparam EDH_ADF2          = 10'h3ff;
localparam EDH_ADF3          = 10'h3ff;
localparam EDH_DID           = 10'h1f4;
localparam EDH_DBN           = 10'h200;
localparam EDH_DC            = 10'h110;
localparam EDH_RSVD          = 10'h200;

//
// This group of parameters defines the states of the EDH generator state
// machine.
//
localparam STATE_WIDTH   = 5;
localparam STATE_MSB     = STATE_WIDTH - 1;

localparam [STATE_WIDTH-1:0]
    S_WAIT   = 0,
    S_ADF1   = 1,
    S_ADF2   = 2,
    S_ADF3   = 3,
    S_DID    = 4,
    S_DBN    = 5,
    S_DC     = 6,
    S_AP1    = 7,
    S_AP2    = 8,
    S_AP3    = 9,
    S_FF1    = 10,
    S_FF2    = 11,
    S_FF3    = 12,
    S_ANCFLG = 13,
    S_APFLG  = 14,
    S_FFFLG  = 15,
    S_RSV1   = 16,
    S_RSV2   = 17,
    S_RSV3   = 18,
    S_RSV4   = 19,
    S_RSV5   = 20,
    S_RSV6   = 21,
    S_RSV7   = 22,
    S_CHK    = 23;

//-----------------------------------------------------------------------------
// Signal definitions
//
reg     [STATE_MSB:0]   current_state = S_WAIT;     // FSM current state register
reg     [STATE_MSB:0]   next_state;                 // FSM next state value
wire                    parity;                     // used to generate parity bit for EDH packet words
reg     [8:0]           checksum = 9'b0;            // used to calculated EDH packet CS word
reg                     clr_checksum;               // clears the checksum register
reg     [9:0]           vid;                        // internal version of edh_vid output port
reg                     end_packet;                 // FSM output that clears the edh_packet signal


//
// FSM: current_state register
//
// This code implements the current state register. It loads with the HSYNC1
// state on reset and the next_state value with each rising clock edge.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            current_state <= S_WAIT;
        else
            current_state <= next_state;
    end

//
// FSM: next_state logic
//
// This case statement generates the next_state value for the FSM based on
// the current_state and the various FSM inputs.
//
always @ (*)
    case(current_state)
        S_WAIT:     if (edh_next)
                        next_state = S_ADF1;
                    else
                        next_state = S_WAIT;
                
        S_ADF1:     next_state = S_ADF2;

        S_ADF2:     next_state = S_ADF3;

        S_ADF3:     next_state = S_DID;

        S_DID:      next_state = S_DBN;

        S_DBN:      next_state = S_DC;

        S_DC:       next_state = S_AP1;

        S_AP1:      next_state = S_AP2;

        S_AP2:      next_state = S_AP3;

        S_AP3:      next_state = S_FF1;

        S_FF1:      next_state = S_FF2;

        S_FF2:      next_state = S_FF3;

        S_FF3:      next_state = S_ANCFLG;

        S_ANCFLG:   next_state = S_APFLG;

        S_APFLG:    next_state = S_FFFLG;
                    
        S_FFFLG:    next_state = S_RSV1;

        S_RSV1:     next_state = S_RSV2;

        S_RSV2:     next_state = S_RSV3;

        S_RSV3:     next_state = S_RSV4;

        S_RSV4:     next_state = S_RSV5;

        S_RSV5:     next_state = S_RSV6;

        S_RSV6:     next_state = S_RSV7;

        S_RSV7:     next_state = S_CHK;

        S_CHK:      next_state = S_WAIT;

        default: next_state = S_WAIT;

    endcase
        
//
// FSM: outputs
//
// This block decodes the current state to generate the various outputs of the
// FSM.
//
always @ (*)
begin
    // Unless specifically assigned in the case statement, all FSM outputs
    // default to the values below.
    vid             = vid_in;
    clr_checksum    = 1'b0;
    end_packet      = 1'b0;
    ap_flag_word    = 1'b0;
    ff_flag_word    = 1'b0;
    anc_flag_word   = 1'b0;
                                
    case(current_state)     
        S_ADF1:     vid = EDH_ADF1;

        S_ADF2:     vid = EDH_ADF2;

        S_ADF3:     begin
                        vid = EDH_ADF3;
                        clr_checksum = 1'b1;
                    end

        S_DID:      vid = EDH_DID;

        S_DBN:      vid = EDH_DBN;

        S_DC:       vid = EDH_DC;

        S_AP1:      vid = {~parity, parity, ap_crc[5:0], 2'b00};

        S_AP2:      vid = {~parity, parity, ap_crc[11:6], 2'b00};

        S_AP3:      vid = {~parity, parity, ap_crc_valid, 1'b0, 
                            ap_crc[15:12], 2'b00};

        S_FF1:      vid = {~parity, parity, ff_crc[5:0], 2'b00};

        S_FF2:      vid = {~parity, parity, ff_crc[11:6], 2'b00};

        S_FF3:      vid = {~parity, parity, ff_crc_valid, 1'b0, 
                            ff_crc[15:12], 2'b00};

        S_ANCFLG:   begin
                        vid = {~parity, parity, 1'b0, flags_in, 2'b00};
                        anc_flag_word = 1'b1;
                    end

        S_APFLG:    begin
                        vid = {~parity, parity, 1'b0, flags_in, 2'b00};
                        ap_flag_word = 1'b1;
                    end

        S_FFFLG:    begin
                        vid = {~parity, parity, 1'b0, flags_in, 2'b00};
                        ff_flag_word = 1'b1;
                    end

        S_RSV1:     vid = EDH_RSVD;

        S_RSV2:     vid = EDH_RSVD;

        S_RSV3:     vid = EDH_RSVD;

        S_RSV4:     vid = EDH_RSVD;

        S_RSV5:     vid = EDH_RSVD;

        S_RSV6:     vid = EDH_RSVD;

        S_RSV7:     vid = EDH_RSVD;

        S_CHK:      begin
                        vid = {~checksum[8], checksum};
                        end_packet = 1'b1;
                    end
    endcase
end

//
// parity bit generation
//
// This code calculates the parity of bits 7:0 of the video word. The parity
// bit is inserted into bit 8 of parity protected words of the EDH packet. The
// complement of the parity bit is inserted into bit 9 of those same words.
//
assign parity = vid[7] ^ vid[6] ^ vid[5] ^ vid[4] ^
                vid[3] ^ vid[2] ^ vid[1] ^ vid[0];


//
// checksum calculator
//
// This code generates a checksum for the EDH packet. The checksum is cleared
// to zero prior to beginning the checksum calculation by the FSM asserting the
// clr_checksum signal. The vid_in word is added to the current checksum when
// the FSM asserts the do_checksum signal. The checksum is a 9-bit value and
// is computed by summing all but the MSB of the vid_in word with the current
// checksum value and ignoring any carry bits.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst | clr_checksum)
            checksum <= 0;
        else 
            checksum <= checksum + vid[8:0];
    end

//
// edh_packet signal
//
// The edh_packet signal becomes asserted at the beginning of an EDH packet
// and remains asserted through the last word of the EDH packet.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            edh_packet <= 1'b0;
        else
        begin
            if (edh_next)
                edh_packet <= 1'b1;
            else if (end_packet)
                edh_packet <= 1'b0;
        end
    end

//
// output assignments
//
assign edh_vid = vid;

endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/* 
This module instances and interconnects the three modules that make up the
digital video decoder: the TRS Detector, the Automatic Video Standard Detector,
and the Video Flywheel.

Together, these three modules will examine a video stream and determine the
format of the video from one of the six supported video standards. The flywheel
then synchronizes to the video stream to provide horizontal and vertical
counts so other modules can determine the location of data that occurs in
regular fixed locations, like the EDH packets. The flywheel will also 
regenerate TRS symbols and insert them into the video stream so that the video
contains valid TRS symbols even if the input video is noisy or stops 
altogether.

This module has the following inputs:

clk: clock input

ce: clock enable

rst: synchronous reset input

vid_in: input video stream

reacquire: forces the autodetect unit to reacquire the video standard

en_sync_switch: enables support for synchronous video switching

en_trs_blank: enable TRS blanking

The module has the following outputs:

std: 3-bit video standard code from the autodetect module

std_locked: asserted when std is valid

trs: asserted during the four words when vid_out contains the TRS symbol words

vid_out: output video stream

field: indicates the current video field

v_blank: vertical blanking interval indicator

h_blank: horizontal blanking interval indicator

horz_count: the horizontal position of the word present on vid_out

vert_count: the vertical position of the word present on vid_out

sync_switch: asserted during the synchronous switching interval

locked: asserted when the flywheel is synchronized with the input video stream

eav_next: asserted the clock cycle before the first word of an EAV appears on
vid_out

sav_next: asserted the clock sycle before the first word of an SAV appears on 
vid_out

xyz_word: asserted when vid_out contains the XYZ word of a TRS symbol

anc_next: asserted the clock cycle before the first word of the ADF of an ANC
packet appears on vid_out

edh_next: asserted the clock cycle before the first word of the ADF of an EDH
packet appears on vid_out
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_edh_video_decode #(
    parameter HCNT_WIDTH = 12,                      // number of bits in horizontal sample counter
    parameter VCNT_WIDTH = 10)                      // number of bits in vertical line counter
(
    input  wire                     clk,            // clock input
    input  wire                     ce,             // clock enable
    input  wire                     rst,            // sync reset input
    input  wire [9:0]               vid_in,         // input video
    input  wire                     reacquire,      // forces autodetect to reacquire the video standard
    input  wire                     en_sync_switch, // enables synchronous switching
    input  wire                     en_trs_blank,   // enables TRS blanking when asserted
    output wire [2:0]               std,            // video standard code
    output wire                     std_locked,     // autodetect ciruit is locked when this output is asserted
    output wire                     trs,            // asserted during flywheel generated TRS symbol
    output wire [9:0]               vid_out,        // TRS symbol data
    output wire                     field,          // field indicator
    output wire                     v_blank,        // vertical blanking bit
    output wire                     h_blank,        // horizontal blanking bit
    output wire [HCNT_WIDTH-1:0]    horz_count,     // current horizontal count
    output wire [VCNT_WIDTH-1:0]    vert_count,     // current vertical count
    output wire                     sync_switch,    // asserted on lines where synchronous switching is allowed
    output wire                     locked,         // asserted when flywheel is synchronized to video
    output wire                     eav_next,       // next word is first word of EAV
    output wire                     sav_next,       // next word is first word of SAV
    output wire                     xyz_word,       // current word is the XYZ word of a TRS
    output wire                     anc_next,       // next word is first word of a received ANC
    output wire                     edh_next        // next word is first word of a received EDH
);

localparam HCNT_MSB      = HCNT_WIDTH - 1;       // MS bit # of hcnt
localparam VCNT_MSB      = VCNT_WIDTH - 1;       // MS bit # of vcnt

//-----------------------------------------------------------------------------
// Signal definitions
//
wire                    td_xyz_err;         // trs_detect rx_xyz_err output
wire                    td_xyz_err_4444;    // trs_detect rx_xyz_err_4444 output
wire    [9:0]           td_vid;             // video stream from trs_detect
wire                    td_trs;             // trs_detect rx_trs output
wire                    td_xyz;             // trs_detect rx_xyz output
wire                    td_f;               // trs_detect rx_f output
wire                    td_v;               // trs_detect rx_v output
wire                    td_h;               // trs_detect rx_h output
wire                    td_anc;             // trs_detect rx_anc output
wire                    td_edh;             // trs_detect rx_edh output
wire                    td_eav;             // trs_detect rx_eav output
wire                    ad_s4444;           // autodetect s4444 output
wire                    ad_xyz_err;         // autodetect xyz_err output

//
// Instantiate the TRS detector module
//
v_smpte_uhdsdi_v1_0_5_edh_trs_detect TD (
    .clk                (clk),
    .ce                 (ce),
    .rst                (rst),
    .vid_in             (vid_in),
    .vid_out            (td_vid),
    .rx_trs             (td_trs),
    .rx_eav             (td_eav),
    .rx_sav             (),
    .rx_f               (td_f),
    .rx_v               (td_v),
    .rx_h               (td_h),
    .rx_xyz             (td_xyz),
    .rx_xyz_err         (td_xyz_err),
    .rx_xyz_err_4444    (td_xyz_err_4444),
    .rx_anc             (td_anc),
    .rx_edh             (td_edh)
);

//
// Instantiate the video standard autodetect module
//
v_smpte_uhdsdi_v1_0_5_edh_autodetect #(
    .HCNT_WIDTH      (HCNT_WIDTH))
AD (
    .clk                (clk),
    .ce                 (ce),
    .rst                (rst),
    .reacquire          (reacquire),
    .vid_in             (td_vid),
    .rx_trs             (td_trs),
    .rx_xyz             (td_xyz),
    .rx_xyz_err         (td_xyz_err),
    .rx_xyz_err_4444    (td_xyz_err_4444),
    .vid_std            (std),
    .locked             (std_locked),
    .xyz_err            (ad_xyz_err),
    .s4444              (ad_s4444)
);


//
// Instantiate the flywheel module
//
v_smpte_uhdsdi_v1_0_5_edh_flywheel #(
    .VCNT_WIDTH     (VCNT_WIDTH),
    .HCNT_WIDTH     (HCNT_WIDTH))
FLY (
    .clk            (clk),
    .ce             (ce),
    .rst            (rst),
    .rx_xyz_in      (td_xyz),
    .rx_trs_in      (td_trs),
    .rx_eav_first_in(td_eav),
    .rx_f_in        (td_f),
    .rx_v_in        (td_v),
    .rx_h_in        (td_h),
    .std_locked     (std_locked),
    .std_in         (std),
    .rx_xyz_err_in  (ad_xyz_err),
    .rx_vid_in      (td_vid),
    .rx_s4444_in    (ad_s4444),
    .rx_anc_in      (td_anc),
    .rx_edh_in      (td_edh),
    .en_sync_switch (en_sync_switch),
    .en_trs_blank   (en_trs_blank),
    .trs            (trs),
    .vid_out        (vid_out),
    .field          (field),
    .v_blank        (v_blank),
    .h_blank        (h_blank),
    .horz_count     (horz_count),
    .vert_count     (vert_count),
    .sync_switch    (sync_switch),
    .locked         (locked),
    .eav_next       (eav_next),
    .sav_next       (sav_next),
    .xyz_word       (xyz_word),
    .anc_next       (anc_next),
    .edh_next       (edh_next)
);

endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/*
Module Description:

This module, controls a MGT RX operating mode so as to automatically detect 
SD-SDI, HD-SDI, 3G-SDI, 6G-SDI, or 12G-SDI on the incoming bit stream.

The user needs to balance error tolerance against reaction speed in this design.
Occasional errors, or even a burst of errors, should not cause the circuit to
toggle reference clock frequencies prematurely. On the other hand, in some
cases it is necessary to reacquire lock with the bitstream as quickly as
possible after the incoming bitstream changes frequencies.

This module uses missing or erroneous TRS symbols as the detection mechanism for 
determining when to toggle the operating mode. A missing SAV or an SAV 
with protection bit errors will cause the finite state machine to flag the line 
as containing an error. 

Each line that contains an error causes the error counter to increment. If a 
line is found that is error free, the error counter is cleared back to zero. 
When MAX_ERRS_LOCKED consecutive lines occur with errors, the state machine will 
change the mode output to cycle through SD-SDI, HD-SDI, and 3G-SDI until lock
is reacquired. MAX_ERRS_LOCKED is provided to the module as a parameter. The
width of the error counter, as specified by ERRCNT_WIDTH, must be sufficient to
count up to MAX_ERRS_LOCKED (and MAX_ERRS_UNLOCKED).

When the receiver is not locked, the MAX_ERRS_UNLOCKED parameter controls
the maximum number of consecutive lines with TRS errors that must occur before
the state machine moves on to the next operating mode. MAX_ERRS_UNLOCKED
effectively controls the scan rate of the locking process whereas 
MAX_ERRS_LOCKED controls how quickly the module responds to loss of lock (and
how sensitive it is to noise on the input signal).

The TRSCNT_WIDTH parameter determines the width of the counter used to determine
if an SAV was not received during a line. It should be wide enough to count
more than the number of samples in the longest possible video line. For 12G-SDI
with 16 streams interleaved, there may be over 30K words between SAVs so the
TRSCNT_WIDTH parameter is set to 16.

The rst input resets the module asynchronously. However, this signal must be
negated synchronously with the clk signal, otherwise the state machine may
go to an invalid state.

This controller also has an input called mode_enable that allows the supported
modes to be specified. Only those modes whose corresponding bit on the 
mode_enable input will be tried during the search to lock to the input 
bitstream.
--------------------------------------------------------------------------------
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_rx_autorate #(
    parameter ERRCNT_WIDTH      = 4,    // width of counter tracking lines with errors
    parameter TRSCNT_WIDTH      = 16,   // width of missing SAV timeout counter
    parameter MAX_ERRS_LOCKED   = 15,   // max number of consecutive lines with errors
    parameter MAX_ERRS_UNLOCKED = 2)    // max number of lines with errors during search
(
    input  wire         clk,            // rxusrclk input
    input  wire         ce,             // clock enable
    input  wire         rst,            // sync reset input
    input  wire [9:0]   ds1,            // more qualification on mode_lock 
    input  wire         eav,            // asserted during EAV symbols
    input  wire         sav,            // asserted during SAV symbols
    input  wire         trs_err,        // SAV validation signal
    input  wire         rx_ready,       // 1 = RX is ready, 0 = RX is being reset
    input  wire [5:0]   mode_enable,    // b0=HD, b1=SD, b2=3G, b3=6G, b4=12G/1, b5=12G/1.001
    output wire [2:0]   mode,           // 000=HD, 001=SD, 010=3G, 100=6G, 101=12GA, 110=12GB
    output wire         locked          // 1 = locked
);

//-----------------------------------------------------------------------------
// Parameter definitions
//
// Changing the ERRCNT_WIDTH parameter changes the width of the counter that is
// used to keep track of the number of consecutive lines that contained errors.
// By changing the counter width and changing the two MAX_ERRS parameters, the
// latency for refclksel switching can be changed. Making the MAX_ERRS values
// smaller will reduce the switching latency, but will also reduce the tolerance
// to errors and cause unintentional rate switching.
//
// There are two different MAX_ERRS parameters, one that is effective when the
// FSM is locked and and when it is unlocked. By making the MAX_ERRS_UNLOCKED
// value smaller, the scan process is more rapid. By making the MAX_ERRS_LOCKED
// parameter larger, the process is less sensitive to noise induced errors.
//
// The TRSCNT_WIDTH parameter determines the width of the missing SAV timeout
// counter. Increasing this counter's width causes the state machine to wait
// longer before determining that a SAV was missing. Note that the counter
// is actually implemented as one bit wider than the value given in TRSCNT_MSB
// allowing the MSB to be the timeout error flag.
//
localparam ERRCNT_MSB = ERRCNT_WIDTH - 1;    
localparam TRSCNT_MSB = TRSCNT_WIDTH;    

//
// This group of parameters defines the states of the FSM.
//                                              
localparam STATE_MSB = 2;

localparam [STATE_MSB:0]
    UNLOCK  = 0,
    LOCK1   = 1,
    LOCK2   = 2,
    LOCK3   = 3,
    ERR1    = 4,
    ERR2    = 5,
    CHANGE  = 6;
    
// 
// These parameters define the values used on the mode output
//      
localparam [2:0]
    MODE_HD  = 3'b000,
    MODE_SD  = 3'b001,
    MODE_3G  = 3'b010,
    MODE_X0  = 3'b011,
    MODE_6G  = 3'b100,
    MODE_12GA= 3'b101,
    MODE_12GB= 3'b110,
    MODE_X1  = 3'b111;

// 
// These parameters define the mode_enable input port bits.
//     
localparam
    VALID_BIT_HD  = 0,
    VALID_BIT_SD  = 1,
    VALID_BIT_3G  = 2,
    VALID_BIT_6G  = 3,
    VALID_BIT_12GA= 4,
    VALID_BIT_12GB= 5;

//-----------------------------------------------------------------------------
// Signal definitions
//

// internal signals
(* fsm_safe_state = "default_state" *)
reg     [STATE_MSB:0]   current_state = UNLOCK; // FSM current state
reg     [STATE_MSB:0]   next_state;             // FSM next state
reg     [ERRCNT_MSB:0]  errcnt = 0;             // error counter
reg     [TRSCNT_MSB:0]  trscnt = 0;             // TRS timeout counter
reg                     clr_errcnt;             // FSM output that clears errcnt
reg                     inc_errcnt;             // FSM output that increments errcnt
wire                    max_errcnt;             // asserted when errcnt = MAX_ERRS
wire                    trs_tc;                 // terminal count output from trscnt
wire                    sav_ok;                 // asserted during SAV if no protection errors
wire                    xyz_ok;                 // asserted during EAV if XYZ checking passing 
reg     [2:0]           mode_int = 3'b000;      // internal version of mode output
reg                     change_mode;            // FSM output that changes mode
reg                     set_locked;             // FSM output that sets locked_int
reg                     clr_locked;             // FSM output that clears locked_int
reg                     locked_int = 1'b0;      // internal version of locked signal
wire    [ERRCNT_MSB:0]  max_errs;               // max errcnt mux
reg     [2:0]           next_mode;
reg     [1:0]           rx_ready_ss = 2'b00;    // synchronizer for rx_ready input
wire                    rx_ready_s;             // synchronous version of rx_ready
 // video lock enhancement 
    wire  XYZ_chk            ;
    wire  xor_vh             ;
    wire  xor_fh             ;
    wire  xor_fv             ;
    wire  xor_fvh            ;

//
// Synchronize the rx_ready signal to the local clock
//
always @ (posedge clk)
    rx_ready_ss <= {rx_ready_ss[0], rx_ready};

assign rx_ready_s = rx_ready_ss[1];

//
// Error signals
//
// sav_ok is only asserted during the XYZ word of SAV symbols when there trs_err
// is not asserted.
//
assign sav_ok = sav & ~trs_err;

//video locked detection: try to fix the lock high but no video plug issue from sdi core
assign xor_vh = ds1[7] ^ ds1[6];
assign xor_fh = ds1[8] ^ ds1[6];
assign xor_fv = ds1[8] ^ ds1[7];
assign xor_fvh = ds1[8] ^ ds1[7] ^ ds1[6];
//when eav=1, do XYZ calculation
assign xyz_ok = (ds1[9] == 1'b1 && ds1[6] == 1'b1 && ds1[5] == xor_vh && ds1[4] == xor_fh && ds1[3] == xor_fv && ds1[2] == xor_fvh && ds1[1:0] == 2'b0) ? eav : 1'b0;

// 
// mode register
//
// The mode register changes when the change_mode signal from the FSM is 
// asserted.. The normal scan sequence is HD -> 3G -> 6G -> 12GA -> 12GB -> SD -> HD if 
// all 6 modes are enabled by the mode_enable port. Any modes that are not enabled are
// skipped. 
//
always @ (*)
    case(mode_int)
        MODE_HD:    if (mode_enable[VALID_BIT_3G])
                        next_mode = MODE_3G;
                    else if (mode_enable[VALID_BIT_6G])
                        next_mode = MODE_6G;
                    else if (mode_enable[VALID_BIT_12GA])
                        next_mode = MODE_12GA;
                    else if (mode_enable[VALID_BIT_12GB])
                        next_mode = MODE_12GB;
                    else if (mode_enable[VALID_BIT_SD])
                        next_mode = MODE_SD;
                    else
                        next_mode = MODE_HD;

        MODE_3G:    if (mode_enable[VALID_BIT_6G])
                        next_mode = MODE_6G;
                    else if (mode_enable[VALID_BIT_12GA])
                        next_mode = MODE_12GA;
                    else if (mode_enable[VALID_BIT_12GB])
                        next_mode = MODE_12GB;
                    else if (mode_enable[VALID_BIT_SD])
                        next_mode = MODE_SD;
                    else if (mode_enable[VALID_BIT_HD])
                        next_mode = MODE_HD;
                    else
                        next_mode = MODE_3G;

        MODE_6G:    if (mode_enable[VALID_BIT_12GA])
                        next_mode = MODE_12GA;
                    else if (mode_enable[VALID_BIT_12GB])
                        next_mode = MODE_12GB;
                    else if (mode_enable[VALID_BIT_SD])
                        next_mode = MODE_SD;
                    else if (mode_enable[VALID_BIT_HD])
                        next_mode = MODE_HD;
                    else if (mode_enable[VALID_BIT_3G])
                        next_mode = MODE_3G;
                    else
                        next_mode = MODE_6G;

        MODE_12GA:  if (mode_enable[VALID_BIT_12GB])
                        next_mode = MODE_12GB;
                    else if (mode_enable[VALID_BIT_SD])
                        next_mode = MODE_SD;
                    else if (mode_enable[VALID_BIT_HD])
                        next_mode = MODE_HD;
                    else if (mode_enable[VALID_BIT_3G])
                        next_mode = MODE_3G;
                    else if (mode_enable[VALID_BIT_6G])
                        next_mode = MODE_6G;
                    else
                        next_mode = MODE_12GA;

        MODE_12GB:  if (mode_enable[VALID_BIT_SD])
                        next_mode = MODE_SD;
                    else if (mode_enable[VALID_BIT_HD])
                        next_mode = MODE_HD;
                    else if (mode_enable[VALID_BIT_3G])
                        next_mode = MODE_3G;
                    else if (mode_enable[VALID_BIT_6G])
                        next_mode = MODE_6G;
                    else if (mode_enable[VALID_BIT_12GA])
                        next_mode = MODE_12GA;
                    else 
                        next_mode = MODE_12GB;

        MODE_SD:    if (mode_enable[VALID_BIT_HD])
                        next_mode = MODE_HD;
                    else if (mode_enable[VALID_BIT_3G])
                        next_mode = MODE_3G;
                    else if (mode_enable[VALID_BIT_6G])
                        next_mode = MODE_6G;
                    else if (mode_enable[VALID_BIT_12GA])
                        next_mode = MODE_12GA;
                    else if (mode_enable[VALID_BIT_12GB])
                        next_mode = MODE_12GB;
                    else
                        next_mode = MODE_SD;

        default:    next_mode = MODE_HD;
    endcase

always @ (posedge clk)
    if (ce & change_mode)
        mode_int <= next_mode;

assign mode = mode_int;

//
// locked signal
//
// This flip-flop generates the locked signal based on set and clr signals from
// the FSM.
//
always @ (posedge clk)
    if (rst)
        locked_int <= 1'b0;
    else if (ce)
    begin
        if (set_locked)
            locked_int <= 1'b1;
        else if (clr_locked)
            locked_int <= 1'b0;
    end

assign locked = locked_int;

//
// TRS timeout counter
//
// This counter is reset whenever a SAV signal is received, otherwise it
// increments. When it reaches its terminal count, the trs_tc signal is
// asserted and the the counter will roll over to zero on the next clock cycle.
//
always @ (posedge clk)
    if (ce)
        begin
            if (sav_ok | trs_tc)
                trscnt <= 0;
            else
                trscnt <= trscnt + 1;
        end

assign trs_tc = trscnt[TRSCNT_MSB];

//
// Error counter
//
// The error counter increments each time the inc_errcnt output from the FSM
// is asserted. It clears to zero when clr_errcnt is asserted. The max_errcnt
// output is asserted if the error counter equals max_errs. A MUX selects
// the correct MAX_ERRS parameter for the max_errs signal based on the locked
// signal from the FSM.
//
always @ (posedge clk)
    if (ce)
        begin
            if (inc_errcnt)
                errcnt <= errcnt + 1;
            else if (clr_errcnt)
                errcnt <= 0;
        end

assign max_errs = locked_int ? MAX_ERRS_LOCKED : MAX_ERRS_UNLOCKED;
assign max_errcnt = errcnt == max_errs;

// FSM
//
// The finite state machine is implemented in three processes, one for the
// current_state register, one to generate the next_state value, and the
// third to decode the current_state to generate the outputs.
 
//
// FSM: current_state register
//
// This code implements the current state register. It loads with the UNLOCK
// state on reset and the next_state value with each rising clock edge.
//
always @ (posedge clk)
    if (rst)
        current_state <= UNLOCK;
    else if (ce)
        current_state <= next_state;

//
// FSM: next_state logic
//
// This case statement generates the next_state value for the FSM based on
// the current_state and the various FSM inputs.
//
always @ (*)
    case(current_state)
        //
        // The FSM begins in the UNLOCK state and stays there until a SAV
        // symbol is found. In this state, if the TRS timeout counter reaches
        // its terminal count, the FSM moves to the ERR1 state to increment the
        // error counter.
        //
        UNLOCK: if (!rx_ready_s)
                    next_state = UNLOCK;
                else if (mode_int == MODE_X0 || mode_int == MODE_X1)
                    next_state = CHANGE;
                else if (sav_ok)
                    next_state = LOCK1;
                else if (trs_tc)
                    next_state = ERR1;
                else
                    next_state = UNLOCK;

        //
        // This is the main locked state LOCK1. Once a SAV has been found, the
        // FSM stays here until either another SAV is found or the TRS counter
        // times out.
        //
        LOCK1:  if (!rx_ready_s)
                    next_state = UNLOCK;
                else if (sav_ok)
                    next_state = LOCK2;
                else if (trs_tc)
                    next_state = ERR1;
                else
                    next_state = LOCK1;

        //
        // The FSM moves to LOCK2 from LOCK1 if a SAV is found. The error
        // counter is reset in LOCK2.
        //
        LOCK2:  if (!rx_ready_s)
                    next_state = UNLOCK;
                else if (xyz_ok)
                    next_state = LOCK3;
                else if (trs_tc)
                    next_state = ERR1;
                else
                    next_state = LOCK2;

        LOCK3:  next_state = LOCK1;

        //
        // The FSM moves to ERR1 from LOCK 1 if the TRS timeout counter reaches
        // its terminal count before a SAV is found. In this state, the error
        // counter is incremented and the FSM moves to ERR2.
        //
        ERR1:   next_state = ERR2;

        //
        // The FSM enters ERR2 from ERR1 where the error counter was
        // incremented. In this state the max_errcnt signal is tested. If it
        // is asserted, the FSM moves to the TOGGLE state, otherwise the FSM
        // returns to LOCK1.
        //
        ERR2:   if (max_errcnt)
                    next_state = CHANGE;
                else if (locked_int)
                    next_state = LOCK1;
                else
                    next_state = UNLOCK;
                  
        //
        // In the CHANGE state, the FSM sets the change_mode signal and returns
        // to the UNLOCK state.
        //
        CHANGE: next_state = UNLOCK;

        default: next_state = UNLOCK;
    endcase

        
//
// FSM: outputs
//
// This block decodes the current state to generate the various outputs of the
// FSM.
//
always @ (*) 
begin
    // Unless specifically assigned in the case statement, all FSM outputs
    // are low.
    change_mode     = 1'b0;
    clr_errcnt      = 1'b0;
    inc_errcnt      = 1'b0;
    set_locked      = 1'b0;
    clr_locked      = 1'b0;
                                
    case(current_state) 
        
        UNLOCK: clr_locked = 1'b1;

        LOCK3:  begin
                    clr_errcnt = 1'b1;
                    set_locked = 1'b1;
                end

        CHANGE: begin
                    change_mode = 1'b1;
                    clr_errcnt = 1'b1;
                end

        ERR1: inc_errcnt = 1'b1;
    endcase
end

endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/*
Module Description:

This module calculates the CRC value for a line and compares it to the received
CRC value. The module does this for both the Y and C channels. If a CRC error
is detected, the corresponding CRC error output is asserted high. This output
remains asserted for one video line time, until the next CRC check is made.

The module also captures the line number values for the two channels and 
outputs them. The line number values are valid for the entire line time. 

--------------------------------------------------------------------------------
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_rx_crc (
    input  wire         clk,                // receiver clock
    input  wire         rst,                // reset signal
    input  wire         ce,                 // clock enable input
    input  wire [9:0]   c_video,            // C channel video input port
    input  wire [9:0]   y_video,            // Y channel video input port
    input  wire         trs,                // TRS signal asserted during all 4 words of TRS
    output reg          c_crc_err = 1'b0,   // C channel CRC error detected
    output reg          y_crc_err = 1'b0,   // Y channel CRC error detected
    output reg  [10:0]  c_line_num = 0,     // C channel received line number
    output reg  [10:0]  y_line_num = 0      // Y channel received line number
);

// Internal wires
reg     [17:0]      c_rx_crc = 0;
reg     [17:0]      y_rx_crc = 0;
wire    [17:0]      c_calc_crc;
wire    [17:0]      y_calc_crc;
reg     [7:0]       trslncrc = 0;
reg                 crc_clr = 0;
reg                 crc_en = 0;
reg     [6:0]       c_line_num_int = 0;
reg     [6:0]       y_line_num_int = 0;

//
// CRC generator modules
//
v_smpte_uhdsdi_v1_0_5_crc2 crc_C (
    .clk            (clk),
    .ce             (ce),
    .en             (crc_en),
    .rst            (rst),
    .clr            (crc_clr),
    .d              (c_video),
    .crc_out        (c_calc_crc)
);

v_smpte_uhdsdi_v1_0_5_crc2 crc_Y (
    .clk            (clk),
    .ce             (ce),
    .en             (crc_en),
    .rst            (rst),
    .clr            (crc_clr),
    .d              (y_video),
    .crc_out        (y_calc_crc)
);


//
// trslncrc generator
//
// This code generates timing signals indicating where the CRC and LN words
// are located in the EAV symbol.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            trslncrc <= 0;
        else
        begin
            if (trs & ~trslncrc[0] & ~trslncrc[1] & ~trslncrc[2])
                trslncrc[0] <= 1'b1;
            else
                trslncrc[0] <= 1'b0;
            trslncrc[7:1] <= {trslncrc[6:3], trslncrc[2] & y_video[6], trslncrc[1:0]};
        end
    end

//
// crc_clr signal
//
// The crc_clr signal controls when the CRC generator's accumulation register
// gets reset to begin calculating the CRC for a new line.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            crc_clr <= 1'b0;
        else if (trslncrc[2] & ~y_video[6])
            crc_clr <= 1'b1;
        else
            crc_clr <= 1'b0;
    end
        
//
// crc_en signal
//
// The crc_en signal controls which words are included in the CRC calculation.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            crc_en <= 1'b0;
        else if (trslncrc[2] & ~y_video[6])
            crc_en <= 1'b1;
        else if (trslncrc[4])
            crc_en <= 1'b0;
    end
        
//
// received CRC registers
//
// These registers hold the received CRC words from the input video stream.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
        begin
            c_rx_crc <= 0;
            y_rx_crc <= 0;
        end
        else if (trslncrc[5])
        begin
            c_rx_crc[8:0] <= c_video[8:0];
            y_rx_crc[8:0] <= y_video[8:0];
        end
        else if (trslncrc[6])
        begin
            c_rx_crc[17:9] <= c_video[8:0];
            y_rx_crc[17:9] <= y_video[8:0];
        end
    end

//
// CRC comparators
//
// Compare the received CRC values against the calculated CRCs.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
        begin
            c_crc_err <= 1'b0;
            y_crc_err <= 1'b0;
        end
        else if (trslncrc[7])
        begin
            if (c_rx_crc == c_calc_crc)
                c_crc_err <= 1'b0;
            else
                c_crc_err <= 1'b1;

            if (y_rx_crc == y_calc_crc)
                y_crc_err <= 1'b0;
            else
                y_crc_err <= 1'b1;
        end
    end

//
// line number registers
//
// These registers hold the line number values from the input video stream.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
        begin
            c_line_num_int <= 0;
            y_line_num_int <= 0;
            c_line_num <= 0;
            y_line_num <= 0;
        end
        else if (trslncrc[3])
        begin
            c_line_num_int <= c_video[8:2];
            y_line_num_int <= y_video[8:2];
        end
        else if (trslncrc[4])
        begin
            c_line_num <= {c_video[5:2], c_line_num_int};
            y_line_num <= {y_video[5:2], y_line_num_int};
        end
    end

endmodule

// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
//------------------------------------------------------------------------------
/*
Module Description:

This is a multi-rate SDI decoder supporting all SDI rates from SD to 12G.

In SDI the serial bit stream is encoded in two ways. First, a generator 
polynomial of x^9 + x^4 + 1 is used to generate a scrambled NRZ bit sequence. 
Next, a generator polynomial of x + 1 is used to produce the final polarity free
NRZI sequence which is transmitted over the physical layer.

The decoder module described in this file sits at the receiving end of the
SDI link and reverses the two encoding steps to extract the original data. 
First, the x + 1 generator polynomial is used to convert the bit stream from 
NRZI to NRZ. Next, the x^9 + x^4 + 1 generator polynomial is used to descramble 
the data.

This decoder supports 10-bit mode for SD-SDI, 20-bit mode for HD-SDI and 3G-SDI,
and 40-bit mode for 6G-SDI and 12G-SDI. When running in 3G-SDI and HD-SDI modes,
20 bits are decoded every clock cycle. When running in 6G-SDI and 12G-SDI modes,
40 bits are decoded every clock cycle. When running in SD-SDI mode, the 10-bit 
SD-SDI data must be placed on the bits [19:10] of the d port and ten bits are 
decoded every clock cycle. 

The module does accept a width parameter, but this can only be set to 20 or 40.
This parameter specifies the maximum width of the decoder data path. The active
width of the decoder is dynamically set based on the mode port. If the WIDTH
parameter is set to 20, the decoder cannot support 6G-SDI and 12G-SDI modes.

--------------------------------------------------------------------------------
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_rx_decoder #(
    parameter WIDTH = 40)               // Bit width of the decoder path, set to 20 or 40
(
    input  wire                 clk,    // word-rate clock
    input  wire                 ce,     // clock enable
    input  wire [2:0]           mode,   // 000=HD, 001=SD, 010=3G, 100=6G, 101 or 110=12G
    input  wire [WIDTH-1:0]     din,    // input data (SD on bits [19:10])
    output wire [WIDTH-1:0]     dout    // output data (SD on bits [19:10])
);

//
// Signal defintions
//
reg     [2:0]       mode_reg = 3'b000;  // SDI mode input register
wire                b10;                // 1 when running in 10 bit mode
wire                b20;                // 1 when running in 20 bit mode
wire                b40;                // 1 when running in 40 bit mode
reg     [WIDTH-1:0] din_reg = 0;        // input data register
reg                 prev_msb = 1'b0;    // previous msb of input vector stored for use with next input vector
wire    [WIDTH-1:0] nrz;                // output of the NRZI-to-NRZ converter
wire    [WIDTH-1:0] nrz_in;             // input to NRZI-to-NRZ converter
reg     [8:0]       prev_nrz = 9'b0;    // holds 9 MSBs from NRZI-to-NRZ for use in next clock cycle
wire    [WIDTH+8:0] desc_wide;          // concat of two input words used by descrambler
reg     [WIDTH-1:0] out_reg = 0;        // output register
integer             i;                  // for loop variable


//
// input registers
//
always @ (posedge clk)
    if (ce)
    begin
        mode_reg <= mode;
        din_reg <= din;
    end

assign b40 = mode_reg == 3'b100 || mode_reg == 3'b101 || mode == 3'b110;
assign b20 = mode_reg == 3'b000 || mode_reg == 3'b010;
assign b10 = mode_reg == 3'b001;

//
// prev_msb register
//
// This register holds the MSB of the previous clock period's din_reg so
// that a it is available to be XORed to the LSB of the next input word.
// 
always @ (posedge clk)
    if (ce)
    begin
        if (b40)
            prev_msb <= din_reg[WIDTH-1];
        else
            prev_msb <= din_reg[19];
    end

//
// NRZI-to-NRZ converter
//
// This function XORs each bit with the bit that preceded it in the serial
// bitstream. 
//
assign nrz_in = {din_reg[WIDTH-2:10], b10 ? prev_msb : din_reg[9], din_reg[8:0], prev_msb};
assign nrz = din_reg ^ nrz_in;

//
// prev_nrz input register of the descrambler
//
// This register is a pipeline delay register which loads from the output of the
// NRZI-to-NRZ converter. It only holds the nine active MSBs from the converter
// which get combined with bits coming from the converter on the next clock 
// cycle to form the input vector to the descrambler.
//
always @ (posedge clk)
    if (ce)
        prev_nrz <= b40 ? nrz[WIDTH-1:WIDTH-9] : nrz[19:11];

//
// The desc_wide vector is the input to the descrambler below. It is the output
// of the NRZI-to-NRZ conversion concatenated with the prev_nrz value. The
// prev_nrz value is inserted into bits 9:1 in SD-SDI mode.
//
assign desc_wide = {nrz[WIDTH-1:10], b10 ? prev_nrz : nrz[9:1], nrz[0], prev_nrz};

// 
// Descrambler
//
// A for loop is used to generate the HD-SDI x^9 + x^4 + 1 polynomial for 
// each of the output bits using the desc_wide input vector that is made up of 
// the contents of the prev_nrz register and the output of the NRZI-to-NRZ 
// converter.
//
always @ (posedge clk)
    if (ce)
        for (i = 0; i < WIDTH; i = i + 1)
            out_reg[i] <= desc_wide[i] ^ desc_wide[i + 4] ^ desc_wide[i + 9];

assign dout = out_reg;

endmodule


// (c) Copyright 2014 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/*
Module Description:

This is the SDI stream demux function. It takes in an interleaved stream and
separates it into one, two, or four elementary streams. It generates a clock
enable output with a duty cycle appropriate to the SDI mode and number of
interleaved data streams. It also generates trs, eav, and sav output timing
signals and an active_streams_out signal that indicates how many streams are
active. In a fully populated 12G-SDI RX, four of these demux modules operate in
parallel to demux up to 16 interleaved streams.
--------------------------------------------------------------------------------
*/
`timescale 1ns / 1ns
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_rx_demux_4 (
    input   wire        clk,                // input clock
    input   wire        rst,                // reset
    input   wire        ce_in,              // input clock enable
    input   wire        sd_data_strobe,     // SD-SDI data strobe
    input   wire [2:0]  mode,               // SDI mode input
    input   wire        trs_in,             // TRS input signal 
    input   wire [9:0]  din,                // input data
    output  wire [3:0]  active_streams_out, // indicates which streams should be active
    output  reg  [9:0]  ds1 = 10'h000,      // data stream 1 output
    output  reg  [9:0]  ds2 = 10'h000,      // data stream 2 output
    output  reg  [9:0]  ds3 = 10'h000,      // data stream 3 output
    output  reg  [9:0]  ds4 = 10'h000,      // data stream 4 output
    output  wire        ce_out,             // output clock enable
    output  wire        trs_out,            // asserted during all 4 words of each EAV and SAV
    output  reg         eav_out = 1'b0,     // asserted during XYZ word of each EAV
    output  reg         sav_out = 1'b0      // asserted during XYZ word of each SAV
);

//
// Internal signals
//
reg     [9:0]   din_reg = 10'b0;
reg             trs_reg = 0;
reg     [2:0]   mode_reg = 3'b0;
reg     [9:0]   pipe0 = 10'b0;
reg     [9:0]   pipe1 = 10'b0;
reg     [9:0]   pipe2 = 10'b0;
reg     [9:0]   pipe3 = 10'b0;
reg     [2:0]   pipe3ff = 3'b000;
reg     [3:0]   active_streams = 4'b0001;
reg     [3:0]   ce_gen = 4'b1111;
reg     [3:0]   ce_pattern = 4'b1111;
reg     [4:0]   trs_gen = 5'b00000;

//
// Input registers
//
always @ (posedge clk)
    if (ce_in) 
    begin
        din_reg <= din;
        trs_reg <= trs_in;
        mode_reg <= mode;
    end

//
// This is a 4 level deep input pipeline for the input data.
//
always @ (posedge clk)
    if (ce_in)
    begin
        pipe0 <= din_reg;
        pipe1 <= pipe0;
        pipe2 <= pipe1;
        pipe3 <= pipe2;
    end

//
// For each word in the input pipeline, record if that word is all in the
// pipe3ff shift register. The number of data words that are all ones is the
// factor used to determine how many data streams are interleaved.
//
always @ (posedge clk)
    if (ce_in)
        pipe3ff <= {pipe3ff[1:0], &din_reg};

//
// This code determines the number of streams that are interleaved together.
// It sets the active_streams signal to indicate the number of active streams
// and also sets the ce_pattern signal which is used to create the correct duty
// cycle for the clock enable.
//
always @ (posedge clk)
    if (rst)
    begin
        active_streams <= 4'b0001;
        ce_pattern <= 4'b1111;
    end
    else if (ce_in & trs_reg)
    begin
        if (mode_reg[2:1] == 2'b00)         // HD-SDI & SD-SDI Modes
        begin
            active_streams <= 4'b0001;
            ce_pattern <= 4'b1111;
        end
        else if (pipe3ff[2])                // 4 streams interleaved
        begin
            active_streams <= 4'b1111;
            ce_pattern <= 4'b1000;
        end
        else if (pipe3ff[0])                // 2 streams interleaved
        begin
            active_streams <= 4'b0011;
            ce_pattern <= 4'b1010;
        end
        else
        begin
            active_streams <= 4'b0001;      // 1 stream only
            ce_pattern <= 4'b1111;
        end
    end

assign active_streams_out = active_streams;     

//
// This is the clock enable generator. In SD-SDI mode, the clock enable is
// equal to the data strobe from the NI-DRU. In all other modes, the clock
// enable is created using the ce_pattern signal that is based on the SDI mode
// and number of interleaved streams. In all modes except SD-SDI, the ce_gen
// shift register is reloaded whenever the trs input signal is asserted and
// that pattern constantly circulates through the ce_gen shift register until
// the next TRS when it is reloaded.
//
always @ (posedge clk)
    if (rst)
        ce_gen <= 4'b1111;
    else if (mode == 3'b001)                        // SD-SDI mode
        ce_gen <= {sd_data_strobe, 3'b000};
    else
    begin
        if (trs_reg)                                // All other modes
            ce_gen <= ce_pattern;
        else
            ce_gen <= {ce_gen[2:0], ce_gen[3]};
    end
                         
assign ce_out = ce_gen[3];

//
// Set the data stream outputs from the input pipe line registers.
//
always @ (posedge clk)
    if (ce_out)
    begin
        ds2 <= pipe0;
        ds1 <= pipe1;
        ds4 <= pipe2;
        ds3 <= pipe3;
    end 
  
//
// Generate the trs, eav, and sav output signals.
//  
always @ (posedge clk)
    if (trs_reg)
        trs_gen <= 5'b01111;
    else if (ce_out)
        trs_gen <= {trs_gen[3:0], 1'b0};

assign trs_out = trs_gen[4];

always @ (posedge clk)
    if (ce_out)
    begin
        if (trs_gen == 5'b11000)
        begin
            eav_out <= pipe0[6];
            sav_out <= ~pipe0[6];
        end
        else
        begin
            eav_out <= 1'b0;
            sav_out <= 1'b0;
        end
    end
                                
endmodule


// (c) Copyright 2014 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/*
Module Description:

This is the RX framer module for the UHD-SDI receiver. It supports 10, 20, and
40-bit data paths and SD-SDI, HD-SDI, 3G-SDI, 6G-SDI, and 12G-SDI. 10-bit mode
is used for SD-SDI, 20-bit mode for HD-SDI and 3G-SDI, and 40-bit mode for 
6G-SDI and 12G-SDI.

In 10-bit mode, the data enters the framer on bits [19:10] of the din port
and exits the framer on bits [19:10] of the dout port. In 20-bit mode, the data 
must enter the framer on bits [19:0] of the din port and exits the framer on
bits [19:0] of the dout port with the C channel (data stream 1 ) on bits [9:0] 
and the Y channel (data stream 2) on the [19:10] bits. In 40-bit mode, the
assignment of data streams to the four 10-bit portions of the dout port are
dependent on the interleave structure of the data streams as shown below where
the / indicates difference in time (ie 8-way bits [9:0] carry DS8 on first
clock cycle and DS7 on second clock cycle):

            4-way     8-way                   16-way
[ 9: 0]     DS4     DS8 / DS7       DS15 / DS13 / DS16 / DS14
[19:10]     DS2     DS4 / DS3       DS7  / DS5  / DS8  / DS6
[29:20]     DS3     DS6 / DS5       DS11 / DS9  / DS12 / DS10
[39:30]     DS1     DS2 / DS1       DS3  / DS1  / DS4  / DS2

The framer searches for the 30-bit 3FF 000 000 pattern in all cases. In all 
modes except SD-SDI mode, the pattern match logic requires a leading 1 
immediately before the 3FF 000 000 pattern to prevent false detection that can
occur as a combination of the CRC words and the ADF in HD-SDI and 3G-SDI level A
modes. The framer will adjust its alignment when the TRS pattern is detected if
the frame_en input is High. If it is low, the alignment offset is not updated.
The nsp output will be asserted until the next TRS is detected when frame_en is
High. 

The trs output is asserted high for one clock cycle coincident with the 3FF of
the TRS pattern output on the dout register. For 3G-SDI level B and for 6G-SDI
and 12G-SDI with 8 or 16 interleaved streams, the TRS is coincident with the
last word of 3FF on each stream. The 3FF values prior to this clock cycle will
be properly aligned.

--------------------------------------------------------------------------------
*/

`timescale 1ns / 1ns
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_rx_framer (
    input  wire         clk,            // input clock
    input  wire         ce,             // clock enable
    input  wire         rst,            // reset signal
    input  wire [2:0]   mode,           // 000=HD, 001=SD, 010=3G, 100=6G, 101 and 110=12G
    input  wire [39:0]  din,            // input data
    output wire [39:0]  dout,           // output data
    output wire         trs,            // asserted for one clock cycle when a TRS is detected
    input  wire         frame_en,       // enables resynchronization when High
    output reg          nsp = 1'b1      // new start position detected
);

//------------------------------------------------------------------------------
// Internal signals
//
reg     [2:0]       mode_reg = 3'b000;
wire                b10;
wire                b20;
wire                b40;
reg     [39:0]      in_reg = 0;
reg     [39:0]      pipe_reg = 0;
reg     [69:0]      detect_in = 0;
wire    [39:0]      barrel_out;
wire    [29:0]      pattern = 30'b0000000000_0000000000_1111111111;
reg     [39:0]      match = 0;
reg     [39:0]      mask = 40'b0000000000_0000000000_1111111111_1111111111;
reg     [5:0]       loc;
reg     [5:0]       loc_reg = 6'b0;
reg     [5:0]       offset_reg = 6'b0;
wire                match_found;
reg                 load_offset = 1'b0;
integer             i,j;
reg     [39:0]      out_pipe0 = 40'b0;
reg     [39:0]      out_pipe1 = 40'b0;
reg     [39:0]      out_pipe2 = 40'b0;
reg     [39:0]      out_reg = 40'b0;
reg     [79:0]      barrel_in = 80'b0;
reg     [79:0]      barrel_pipe0 = 80'b0;
reg     [79:0]      barrel_pipe1 = 80'b0;
reg     [79:0]      barrel_pipe2 = 80'b0;
reg     [79:0]      barrel_pipe3 = 80'b0;
reg     [79:0]      barrel_pipe4 = 80'b0;
reg     [8:0]       trs_dly = 9'b000000000;
reg     [3:0]       trs_dly_value = 4'h4;
reg                 trs_int = 1'b0;

//------------------------------------------------------------------------------
// Input and data pipeline registers. These provide a wide enough input data
// vector for the match unit to look at. In 40-bit mode, the input vector is
// 70 bits, in 20-bit mode it is 60 bits, and in 10-bit mode it is 40 bits.
//
always @ (posedge clk)
    if (ce)
        mode_reg <= mode;

assign b40 = mode_reg == 3'b100 || mode_reg == 3'b101 || mode_reg == 3'b110;
assign b20 = mode_reg == 3'b000 || mode_reg == 3'b010;
assign b10 = mode_reg == 3'b001;
         
always @ (posedge clk)
    if (ce)
        in_reg <= din;

always @ (posedge clk)
    if (ce)
    begin
        pipe_reg[9:0]   <= b10 ? in_reg[19:10]   : in_reg[9:0];     // In 10-bit mode, the valid 10 bits are on din[19:10]
        pipe_reg[19:10] <= b10 ? pipe_reg[9:0]   : in_reg[19:10];
        pipe_reg[29:20] <= b10 ? pipe_reg[19:10] : b20 ? pipe_reg[9:0]   : in_reg[29:20];
        pipe_reg[39:30] <= b10 ? pipe_reg[29:20] : b20 ? pipe_reg[19:10] : in_reg[39:30];
    end

//------------------------------------------------------------------------------
// TRS Detection Logic
//
// Create a detect_in vector to the pattern matching logic that has the order of
// the bits arranged so that the most recently received bit is the LSB and the
// first bit received is the MSB. The valid bits in the detect_in vector is 
// dependent upon the width of the input data vector.
//
always @ (posedge clk)
    if (ce)
    begin
        if (b10)
            detect_in <= {30'b0, pipe_reg[9:0], pipe_reg[19:10], pipe_reg[29:20], pipe_reg[39:30]};
        else if (b20)
            detect_in <= {20'b0, in_reg[9:0], pipe_reg[19:0], pipe_reg[39:20]};
        else
            detect_in <= {in_reg[29:0], pipe_reg};
    end

//
// The mask vector determines which starting locations are valid based on the
// input data width.
//
always @ (posedge clk)
    if (ce)
        mask <= b10 ? 40'b0000000000_0000000000_0000000000_1111111111 : 
                b20 ? 40'b0000000000_0000000000_1111111111_1111111111 : 
                      40'b1111111111_1111111111_1111111111_1111111111;

//
// This is the pattern matching logic. It compares the 30 or 31 bit TRS preamble 
// pattern to detect_in vector at each of the possible bit offset.
//
always @ (posedge clk)
    if (ce)
        for (i=0; i<40; i=i+1)
            if (b10)
                match[i] <= (detect_in[i +: 30] == pattern) && mask[i];
            else
                match[i] <= (detect_in[i+1 +: 30] == pattern) && detect_in[i] && mask[i];

//
// This logic scans the match vector produced above to determine the bit offset
// of the match. The resulting loc variable is the offset location of the pattern
// in the detect_in vector. The match_found signal will be High if a pattern
// match was found, Low otherwise.
//
always @ (*)
begin
    loc = 6'b0;
    for (j=0; j<40; j=j+1)
        if (match[j])
            loc = j;
end

always @ (posedge clk)
    if (ce)
        loc_reg <= loc + (b10 ? 6'b000000 : 6'b000001);

assign match_found = |match;

always @ (posedge clk)
    if (ce)
        load_offset <= match_found & frame_en;

//
// In 20-bit and 40-bit mode, because of the extra leading 1 requirement, the
// number of bits to shift needs to be increased by one lane value (10 bits).
// This needs to be wrapped around so as not to exceed 40 bits of offset.
//
always @ (posedge clk)
    if (ce)
        if (load_offset)
        begin
            if (b40 | b20)
                offset_reg <= loc_reg + (loc_reg > 30 ? -30 : 10);
            else
                offset_reg <= loc_reg;
        end

always @ (posedge clk)
    if (ce)
        if (match_found)
        begin
            if (loc_reg == offset_reg)
                nsp <= 1'b0;
            else
                nsp <= 1'b1;
        end

//------------------------------------------------------------------------------
// Barrel shifter
//
// The input vector is shifted by the offset stored in the offset_reg. Some
// pipeline registers are required in order to make sure leading 3FF values
// are also shifted by the new offset value when multiple streams are 
// interleaved. The delay from the barrel shifters implemented here support up
// to 16 interleaved data streams.
//
always @ (posedge clk)
    if (ce)
    begin
        barrel_pipe0 <= b40 ? {pipe_reg, barrel_pipe0[79:40]} : {10'b0, detect_in};
        barrel_pipe1 <= barrel_pipe0;
        barrel_pipe2 <= barrel_pipe1;
        barrel_pipe3 <= barrel_pipe2;
        barrel_pipe4 <= barrel_pipe3;
        barrel_in    <= barrel_pipe4;
    end

assign barrel_out = barrel_in[offset_reg +: 40];

always @ (posedge clk)
    if (ce)
    begin
        out_pipe0 <= barrel_out;
        out_pipe1 <= out_pipe0;
        out_pipe2 <= out_pipe1;
        out_reg   <= b40 ? out_pipe2 : out_pipe0;
    end

assign dout = out_reg;
                  
//------------------------------------------------------------------------------
// TRS signal generation logic
//
always @ (posedge clk)
    if (b40 && (offset_reg < 11))
        trs_dly_value <= 7;
    else if (b40)
        trs_dly_value <= 6;
    else
        trs_dly_value <= 4;

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
        begin
            trs_dly <= 9'b000000000;
            trs_int <= 1'b0;
        end
        else
        begin
            trs_dly <= {trs_dly[7:0], match_found};
            trs_int <= trs_dly[trs_dly_value];
        end
    end

assign trs = trs_int;

endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/*
Module Description:

This module captures the SMPTE ST 352 payload ID packet. The payload output port
is only updated when the packet does not have a checksum error. The valid 
output is asserted as long at least one valid packet has been detected in the 
last VPID_TIMEOUT_VBLANKS vertical blanking intervals.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_rx_st352_pid_capture #(  
    parameter VPID_TIMEOUT_VBLANKS = 4)
( 
    // inputs
    input  wire         clk,            // clock input
    input  wire         ce,             // clock enable
    input  wire         rst,            // sync reset input
    input  wire         sav,            // asserted on XYZ word of SAV
    input  wire [9:0]   vid_in,         // video data input
        
    // outputs
    output reg  [31:0]  payload = 0,    // {byte 4, byte 3, byte 2, byte 1}
    output reg          valid = 1'b0    // 1 when payload is valid
);

//-----------------------------------------------------------------------------
// Parameter definitions
//      

//
// This group of parameters defines the states of the finite state machine.
//
localparam STATE_WIDTH   = 4;
localparam STATE_MSB     = STATE_WIDTH - 1;

localparam [STATE_WIDTH-1:0]
    STATE_START     = 0,
    STATE_ADF2      = 1,
    STATE_ADF3      = 2,
    STATE_DID       = 3,
    STATE_SDID      = 4,
    STATE_DC        = 5,
    STATE_UDW0      = 6,
    STATE_UDW1      = 7,
    STATE_UDW2      = 8,
    STATE_UDW3      = 9,
    STATE_CS        = 10;

localparam MUXSEL_MSB = 2;

localparam [MUXSEL_MSB:0]
    MUX_SEL_000     = 0,
    MUX_SEL_3FF     = 1,
    MUX_SEL_DID     = 2,
    MUX_SEL_SDID    = 3,
    MUX_SEL_DC      = 4,
    MUX_SEL_CS      = 5;

localparam SR_MSB = VPID_TIMEOUT_VBLANKS - 1;

reg  [STATE_MSB:0]  current_state = STATE_START;
reg  [STATE_MSB:0]  next_state;
reg  [8:0]          checksum = 0;
reg                 old_v = 0;
reg                 v = 0;
wire                v_fall;
wire                v_rise;
reg                 packet_rx = 0;
reg [SR_MSB:0]      packet_det = 0;
reg [7:0]           byte1 = 0;
reg [7:0]           byte2 = 0;
reg [7:0]           byte3 = 0;
reg [7:0]           byte4 = 0;
reg                 ld_byte1;
reg                 ld_byte2;
reg                 ld_byte3;
reg                 ld_byte4;
reg                 ld_cs_err;
reg                 clr_cs;
reg [MUXSEL_MSB:0]  cmp_mux_sel;
reg [9:0]           cmp_mux;
wire                cmp_equal;
reg                 packet_ok = 1'b0;


//
// FSM: current_state register
//
// This code implements the current state register. 
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            current_state <= STATE_START;
        else
            current_state <= next_state;
    end

//
// FSM: next_state logic
//
// This case statement generates the next_state value for the FSM based on
// the current_state and the various FSM inputs.
//
always @ (*)
    case(current_state)
        STATE_START:
            if (cmp_equal)
                next_state = STATE_ADF2;
            else
                next_state = STATE_START;
                
        STATE_ADF2:
            if (cmp_equal)
                next_state = STATE_ADF3;
            else
                next_state = STATE_START;

        STATE_ADF3:
            if (cmp_equal)
                next_state = STATE_DID;
            else
                next_state = STATE_START;

        STATE_DID:
            if (cmp_equal)
                next_state = STATE_SDID;
            else
                next_state = STATE_START;

        STATE_SDID:
            if (cmp_equal)
                next_state = STATE_DC;
            else
                next_state = STATE_START;

        STATE_DC:
            if (cmp_equal)
                next_state = STATE_UDW0;
            else
                next_state = STATE_START;

        STATE_UDW0:
            next_state = STATE_UDW1;

        STATE_UDW1:
            next_state = STATE_UDW2;

        STATE_UDW2:
            next_state = STATE_UDW3;

        STATE_UDW3:
            next_state = STATE_CS;

        STATE_CS:
            next_state = STATE_START;

        default:    next_state = STATE_START;
    endcase
        
//
// FSM: outputs
//
// This block decodes the current state to generate the various outputs of the
// FSM.
//
always @ (*)
    begin
        // Unless specifically assigned in the case statement, all FSM outputs
        // are given the values assigned here.
        ld_byte1    = 1'b0;
        ld_byte2    = 1'b0;
        ld_byte3    = 1'b0;
        ld_byte4    = 1'b0;
        ld_cs_err   = 1'b0;
        clr_cs      = 1'b0;
        cmp_mux_sel = MUX_SEL_000;
                                
        case(current_state) 

            STATE_START:    clr_cs = 1'b1;

            STATE_ADF2:     begin
                                cmp_mux_sel = MUX_SEL_3FF;
                                clr_cs = 1'b1;
                            end

            STATE_ADF3:     begin
                                cmp_mux_sel = MUX_SEL_3FF;
                                clr_cs = 1'b1;
                            end

            STATE_DID:      cmp_mux_sel = MUX_SEL_DID;

            STATE_SDID:     cmp_mux_sel = MUX_SEL_SDID;

            STATE_DC:       cmp_mux_sel = MUX_SEL_DC;

            STATE_UDW0:     ld_byte1 = 1'b1;

            STATE_UDW1:     ld_byte2 = 1'b1;

            STATE_UDW2:     ld_byte3 = 1'b1;

            STATE_UDW3:     ld_byte4 = 1'b1;

            STATE_CS:       begin
                                cmp_mux_sel = MUX_SEL_CS;
                                ld_cs_err = 1'b1;
                            end
        endcase
    end

//
// Comparator
//
// Compares the expected value of each word, except the user data words, to the
// received value.
//
always @ (*)
    case(cmp_mux_sel)
        MUX_SEL_000:    cmp_mux = 10'h000;
        MUX_SEL_3FF:    cmp_mux = 10'h3ff;
        MUX_SEL_DID:    cmp_mux = 10'h241;
        MUX_SEL_SDID:   cmp_mux = 10'h101;
        MUX_SEL_DC:     cmp_mux = 10'h104;
        MUX_SEL_CS:     cmp_mux = {~checksum[8], checksum};
        default:        cmp_mux = 10'h000;
    endcase

assign cmp_equal = cmp_mux == vid_in;

//
// User data word registers
//
always @ (posedge clk)
    if (ce & ld_byte1)
        byte1 <= vid_in[7:0];

always @ (posedge clk)
    if (ce & ld_byte2)
        byte2 <= vid_in[7:0];

always @ (posedge clk)
    if (ce & ld_byte3)
        byte3 <= vid_in[7:0];

always @ (posedge clk)
    if (ce & ld_byte4)
        byte4 <= vid_in[7:0];

//
// Checksum generation and error flag
//
always @ (posedge clk)
    if (ce) begin
        if (clr_cs)
            checksum <= 0;
        else
            checksum <= checksum + vid_in[8:0];
    end
    
always @ (posedge clk)
    if (ce) 
        packet_ok <= ld_cs_err & cmp_equal;

//
// Packet valid signal generation
//
// The valid output is updated immediatly if a packet is received. Once a
// packet has been detected in any of the last VPID_TIMEOUT_VBLANKS blanking 
// intervals, the valid output will be asserted.
//
always @ (posedge clk)
    if (ce & sav) begin
        v <= vid_in[7];
        old_v <= v;
    end
    
assign v_fall = old_v & ~v;
assign v_rise = ~old_v & v;

always @ (posedge clk)
    if (ce) begin
        if (rst)
            packet_rx <= 1'b0;
        else if (packet_ok)
            packet_rx <= 1'b1;
        else if (v_rise)
            packet_rx <= 1'b0;
    end

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            packet_det <= 0;
        else if (v_fall)
            packet_det <= {packet_det[SR_MSB - 1: 0], packet_rx};
    end

always @ (posedge clk) 
    if (ce)
    begin
        if (rst)
            valid <= 1'b0;
        else
            valid <= packet_rx | (|packet_det);
    end
         
//
// Output registers
//
// The payload register is loaded from the captured bytes at the same time that
// packet_rx is set -- when packet_ok is asserted.
//
always @ (posedge clk)
    if (ce & packet_ok)
        payload <= {byte4, byte3, byte2, byte1};

endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
//------------------------------------------------------------------------------
/*
Module Description:

This is the first part of the SDI RX data path, up to and including the stream
demux unit. It contains the descrambler, the framer, and the demux. For SD-SDI,
it also contains the NI-DRU.

*/
`timescale 1ns / 1ns
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_rx_to_demux #(
    parameter           MAX_RXDATA_WIDTH = 40)
(
    input   wire                        clk,                // connect to GT RXUSRCLK
    input   wire                        sd_data_strobe,     // SD-SDI data strobe from NI-DRU
    input   wire                        rst,                // synchronous reset
    input   wire [MAX_RXDATA_WIDTH-1:0] rxdata,             // connect to GT RXDATA
    input   wire [2:0]                  mode,               // SDI mode
    input   wire                        frame_en,           // 1 to enable framer
    output  wire                        nsp,                // 1 when a new bit alignment is detected by framer
    output  wire                        ce_out,             // clock enable output
    output  reg                         trs = 1'b0,
    output  reg                         eav = 1'b0,
    output  reg                         sav = 1'b0,
    output  reg                         level_b = 1'b0,
    output  wire                        raw_sav,
    output  wire                        muxed_ds_ce,
    output  reg  [2:0]                  active_streams = 3'b001,    
    output  reg  [9:0]                  ds1 = 10'h000,
    output  reg  [9:0]                  ds2 = 10'h000,
    output  reg  [9:0]                  ds3 = 10'h000,
    output  reg  [9:0]                  ds4 = 10'h000,
    output  reg  [9:0]                  ds5 = 10'h000,
    output  reg  [9:0]                  ds6 = 10'h000,
    output  reg  [9:0]                  ds7 = 10'h000,
    output  reg  [9:0]                  ds8 = 10'h000,
    output  reg  [9:0]                  ds9 = 10'h000,
    output  reg  [9:0]                  ds10 = 10'h000,
    output  reg  [9:0]                  ds11 = 10'h000,
    output  reg  [9:0]                  ds12 = 10'h000,
    output  reg  [9:0]                  ds13 = 10'h000,
    output  reg  [9:0]                  ds14 = 10'h000,
    output  reg  [9:0]                  ds15 = 10'h000,
    output  reg  [9:0]                  ds16 = 10'h000
);

reg                         int_ce = 1'b0;
wire [MAX_RXDATA_WIDTH-1:0] desc_out;
wire [39:0]                 framer_in;
wire [39:0]                 framer_out;
wire [39:0]                 restore_out;
wire                        framer_trs;
wire                        restore_trs;
wire [3:0]                  demux1_active_streams;
wire [9:0]                  demux1_ds1;
wire [9:0]                  demux1_ds2;
wire [9:0]                  demux1_ds3;
wire [9:0]                  demux1_ds4;
wire                        demux1_ce;
wire                        demux1_trs;
wire                        demux1_eav;
wire                        demux1_sav;
wire [9:0]                  demux2_ds1;
wire [9:0]                  demux2_ds2;
wire [9:0]                  demux2_ds3;
wire [9:0]                  demux2_ds4;
wire [9:0]                  demux3_ds1;
wire [9:0]                  demux3_ds2;
wire [9:0]                  demux3_ds3;
wire [9:0]                  demux3_ds4;
wire [9:0]                  demux4_ds1;
wire [9:0]                  demux4_ds2;
wire [9:0]                  demux4_ds3;
wire [9:0]                  demux4_ds4;
reg                         trs_dly = 1'b0;
reg                         sav_dly = 1'b0;
reg                         eav_dly = 1'b0;

//
// This is the internal clock enable signal for this module. It is High always
// in all SDI modes except SD-SDI where it follows the sd_data_strobe signal.
//
always @ (posedge clk)
    if (mode == 3'b001)
        int_ce <= sd_data_strobe;
    else
        int_ce <= 1'b1;

//
// The decoder descrambles the SDI signal.
//
v_smpte_uhdsdi_v1_0_5_rx_decoder #(
    .WIDTH      (MAX_RXDATA_WIDTH))
DEC (
    .clk        (clk),
    .ce         (int_ce),
    .mode       (mode),
    .din        (rxdata),
    .dout       (desc_out));

generate
    if (MAX_RXDATA_WIDTH == 40)
    begin : WIDTH40DEC
        assign framer_in = desc_out;
    end else begin : WIDTH20DEC
        assign framer_in = {20'b0, desc_out};
    end
endgenerate

//
// The framer looks for SAV and EAV sequences and aligns the data to the proper
// word alignment.
//
v_smpte_uhdsdi_v1_0_5_rx_framer FRM (
    .clk        (clk),
    .ce         (int_ce),
    .rst        (rst),
    .mode       (mode),
    .din        (framer_in),
    .dout       (framer_out),
    .trs        (framer_trs),
    .frame_en   (frame_en),
    .nsp        (nsp));

assign raw_sav = framer_trs & ~framer_out[6];
assign muxed_ds_ce = int_ce;

//
// The trs_restore module undoes the run length mitigation of 6G-SDI and 12G-SDI,
// converting words where the upper 8 bits are all ones to a value of 0x3FF and
// converting words where the upper 8 bits are all zeros to a value of 0x000.
//
v_smpte_uhdsdi_v1_0_5_rx_trs_restore RSTR (
    .clk        (clk),
    .ce         (int_ce),
    .trs_in     (framer_trs),
    .trs_out    (restore_trs),
    .din        (framer_out),
    .dout       (restore_out));

//
// These are the stream demux modules.
//
v_smpte_uhdsdi_v1_0_5_rx_demux_4 DMUX1 (
    .clk                (clk),
    .rst                (rst),
    .ce_in              (int_ce),
    .sd_data_strobe     (sd_data_strobe),
    .mode               (mode),
    .trs_in             (restore_trs),
    .din                (restore_out[19:10]),
    .active_streams_out (demux1_active_streams),
    .ds1                (demux1_ds1),
    .ds2                (demux1_ds2),
    .ds3                (demux1_ds3),
    .ds4                (demux1_ds4),
    .ce_out             (demux1_ce),
    .trs_out            (demux1_trs),
    .eav_out            (demux1_eav),
    .sav_out            (demux1_sav));

v_smpte_uhdsdi_v1_0_5_rx_demux_4 DMUX2 (
    .clk                (clk),
    .rst                (rst),
    .ce_in              (int_ce),
    .sd_data_strobe     (sd_data_strobe),
    .mode               (mode),
    .trs_in             (restore_trs),
    .din                (restore_out[9:0]),
    .active_streams_out (),
    .ds1                (demux2_ds1),
    .ds2                (demux2_ds2),
    .ds3                (demux2_ds3),
    .ds4                (demux2_ds4),
    .ce_out             (),
    .trs_out            (),
    .eav_out            (),
    .sav_out            ());

generate
    if (MAX_RXDATA_WIDTH == 40)
    begin : WIDTH40
        v_smpte_uhdsdi_v1_0_5_rx_demux_4 DMUX3 (
            .clk                (clk),
            .rst                (rst),
            .ce_in              (int_ce),
            .sd_data_strobe     (sd_data_strobe),
            .mode               (mode),
            .trs_in             (restore_trs),
            .din                (restore_out[39:30]),
            .active_streams_out (),
            .ds1                (demux3_ds1),
            .ds2                (demux3_ds2),
            .ds3                (demux3_ds3),
            .ds4                (demux3_ds4),
            .ce_out             (),
            .trs_out            (),
            .eav_out            (),
            .sav_out            ());

        v_smpte_uhdsdi_v1_0_5_rx_demux_4 DMUX4 (
            .clk                (clk),
            .rst                (rst),
            .ce_in              (int_ce),
            .sd_data_strobe     (sd_data_strobe),
            .mode               (mode),
            .trs_in             (restore_trs),
            .din                (restore_out[29:20]),
            .active_streams_out (),
            .ds1                (demux4_ds1),
            .ds2                (demux4_ds2),
            .ds3                (demux4_ds3),
            .ds4                (demux4_ds4),
            .ce_out             (),
            .trs_out            (),
            .eav_out            (),
            .sav_out            ());
    end
    else 
    begin : WIDTH20
        assign demux3_ds1 = 10'b0;
        assign demux3_ds2 = 10'b0;
        assign demux3_ds3 = 10'b0;
        assign demux3_ds4 = 10'b0;
        assign demux4_ds1 = 10'b0;
        assign demux4_ds2 = 10'b0;
        assign demux4_ds3 = 10'b0;
        assign demux4_ds4 = 10'b0;
    end
endgenerate

//
// In SD, HD, and 3GA modes, the TRS, EAV, and SAV signals from the demux have
// to be delayed by one clock cycle to get them properly aligned with the data
// streams.
//
always @ (posedge clk)
    if (int_ce)
    begin
        trs_dly <= demux1_trs;
        eav_dly <= demux1_eav;
        sav_dly <= demux1_sav;
    end

assign ce_out  = demux1_ce;

//
// Depending on the SDI mode, the output data streams are assigned to the various
// streams from the demux modules.
//
always @ (posedge clk)
    if (int_ce)
    begin
        if (mode == 3'b001)
        begin                                                           // SD-SDI mode
            ds1 <= demux1_ds1;
            ds2 <= 10'b0;
            ds3 <= 10'b0;
            ds4 <= 10'b0;
            ds5 <= 10'b0;
            ds6 <= 10'b0;
            ds7 <= 10'b0;
            ds8 <= 10'b0;
            ds9 <= 10'b0;
            ds10 <= 10'b0;
            ds11 <= 10'b0;
            ds12 <= 10'b0;
            ds13 <= 10'b0;
            ds14 <= 10'b0;
            ds15 <= 10'b0;
            ds16 <= 10'b0;
            trs  <= trs_dly;
            eav  <= eav_dly;
            sav  <= sav_dly;
            level_b <= 1'b0;
            active_streams <= 3'b000;
        end
        else if (mode == 3'b000)                                        // HD-SDI mode
        begin
            ds1 <= demux1_ds1;
            ds2 <= demux2_ds1;
            ds3 <= 10'b0;
            ds4 <= 10'b0;
            ds5 <= 10'b0;
            ds6 <= 10'b0;
            ds7 <= 10'b0;
            ds8 <= 10'b0;
            ds9 <= 10'b0;
            ds10 <= 10'b0;
            ds11 <= 10'b0;
            ds12 <= 10'b0;
            ds13 <= 10'b0;
            ds14 <= 10'b0;
            ds15 <= 10'b0;
            ds16 <= 10'b0;
            trs  <= trs_dly;
            eav  <= eav_dly;
            sav  <= sav_dly;
            level_b <= 1'b0;
            active_streams <= 3'b001;
        end
        else if (mode == 3'b010 && demux1_active_streams == 4'b0001)    // 3G-SDI level A
        begin
            ds1 <= demux1_ds1;
            ds2 <= demux2_ds1;
            ds3 <= 10'b0;
            ds4 <= 10'b0;
            ds5 <= 10'b0;
            ds6 <= 10'b0;
            ds7 <= 10'b0;
            ds8 <= 10'b0;
            ds9 <= 10'b0;
            ds10 <= 10'b0;
            ds11 <= 10'b0;
            ds12 <= 10'b0;
            ds13 <= 10'b0;
            ds14 <= 10'b0;
            ds15 <= 10'b0;
            ds16 <= 10'b0;
            trs  <= trs_dly;
            eav  <= eav_dly;
            sav  <= sav_dly;
            level_b <= 1'b0;
            active_streams <= 3'b001;
        end
        else if (mode == 3'b010 && demux1_active_streams == 4'b0011)    // 3G-SDI level B
        begin
            ds1 <= demux1_ds2;
            ds2 <= demux1_ds1;
            ds3 <= demux2_ds2;
            ds4 <= demux2_ds1;
            ds5 <= 10'b0;
            ds6 <= 10'b0;
            ds7 <= 10'b0;
            ds8 <= 10'b0;
            ds9 <= 10'b0;
            ds10 <= 10'b0;
            ds11 <= 10'b0;
            ds12 <= 10'b0;
            ds13 <= 10'b0;
            ds14 <= 10'b0;
            ds15 <= 10'b0;
            ds16 <= 10'b0;
            trs  <= demux1_trs;
            eav  <= demux1_eav;
            sav  <= demux1_sav;
            level_b <= 1'b1;
            active_streams <= 3'b010;
        end
        else if (mode == 3'b100 && demux1_active_streams == 4'b0001)    // SL 6G-SDI mode 2 & 3 or DL 6G-SDI mode 1 & 2
        begin
            ds1 <= demux3_ds1;
            ds2 <= demux1_ds1;
            ds3 <= demux4_ds1;
            ds4 <= demux2_ds1;
            ds5 <= 10'b0;
            ds6 <= 10'b0;
            ds7 <= 10'b0;
            ds8 <= 10'b0;
            ds9 <= 10'b0;
            ds10 <= 10'b0;
            ds11 <= 10'b0;
            ds12 <= 10'b0;
            ds13 <= 10'b0;
            ds14 <= 10'b0;
            ds15 <= 10'b0;
            ds16 <= 10'b0;
            trs  <= trs_dly;
            eav  <= eav_dly;
            sav  <= sav_dly;
            level_b <= 1'b0;
            active_streams <= 3'b010;
        end
        else if (demux1_active_streams == 4'b0011)
        begin
            ds1 <= demux3_ds2;
            ds2 <= demux3_ds1;
            ds3 <= demux1_ds2;
            ds4 <= demux1_ds1;
            ds5 <= demux4_ds2;
            ds6 <= demux4_ds1;
            ds7 <= demux2_ds2;
            ds8 <= demux2_ds1;
            ds9 <= 10'b0;
            ds10 <= 10'b0;
            ds11 <= 10'b0;
            ds12 <= 10'b0;
            ds13 <= 10'b0;
            ds14 <= 10'b0;
            ds15 <= 10'b0;
            ds16 <= 10'b0;
            trs  <= demux1_trs;
            eav  <= demux1_eav;
            sav  <= demux1_sav;
            level_b <= 1'b0;
            active_streams <= 3'b011;
        end
        else
        begin
            ds1 <= demux3_ds2;
            ds2 <= demux3_ds4;
            ds3 <= demux3_ds1;
            ds4 <= demux3_ds3;
            ds5 <= demux1_ds2;
            ds6 <= demux1_ds4;
            ds7 <= demux1_ds1;
            ds8 <= demux1_ds3;
            ds9 <= demux4_ds2;
            ds10 <= demux4_ds4;
            ds11 <= demux4_ds1;
            ds12 <= demux4_ds3;
            ds13 <= demux2_ds2;
            ds14 <= demux2_ds4;
            ds15 <= demux2_ds1;
            ds16 <= demux2_ds3;
            trs  <= demux1_trs;
            eav  <= demux1_eav;
            sav  <= demux1_sav;
            level_b <= 1'b0;
            active_streams <= 3'b100;
        end
    end
endmodule

    


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/*
Module Description:

This module will examine a HD data stream and detect the transport format. It
detects all the video standards currently supported by ST 292-2010, including
the ST 2048-2 2K video formats. It also detects the transports supported by 
ST 425-2010, ST 372-2010, and the SD-SDI NTSC and PAL formats.

Note that this module detects transport timing and not necessarily  the actual 
video format. The module determines the transport format by examining the timing
of the video signals and does not rely on ST 352 video payload ID packets.
However, this means that it is not able to determine the exact video format,
only the nature of the transport timing.

The transport_family port indicates the video format family of the signal
being received. It is encoded as follows:

ST 274      1920x1080   0000
ST 296      1280x720    0001
ST 2048-2   2048x1080   0010        This also includes the ST 428-9 and ST 428-19 formats
ST 295                  0011        Obsolete format
NTSC        720x486     1000
PAL         720x576     1001
UNKNOWN                 1111

All other codes are reserved for future use. The format detector does detect
and lock to the obsolete ST 260 video format, but simply reports it as the
1920x1080 ST 274 format.

The transport_rate port indicates the frame rate of the transport, not 
necessarily the frame rate of the picture. This port is encoded in the same way 
that the picture rate field of the ST 352 video payload ID packet is encoded:

NONE        0000
23.98 Hz    0010
24 Hz       0011
47.95 Hz    0100
25 Hz       0101
29.97 Hz    0110
30 Hz       0111
48 Hz       1000
50 Hz       1001
59.94 Hz    1010
60 Hz       1011

The format detector uses the bit_rate input port to distinguish between the
otherwise identical timings of the 1/1.000 rates and the 1/1.001 rates. If the
bit rate port is hard wired to 1'b0, all rates will be reported as exact 
1/1.000 rates.

The transport_locked output is asserted as long as the transport_family and
transport_rate are known good values. It will be cleared to zero whenever
mode_locked is negated.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_rx_transport_detect
(
    input  wire        clk,                     // recovered SDI clock
    input  wire        rst,                     // synchronous reset
    input  wire        ce,                      // clock enable input
    input  wire        vid_7,                   // connect to bit 7 of C or Y data stream (V bit) 
    input  wire        eav,                     // must be asserted during XYZ word of EAV
    input  wire        sav,                     // must be asserted during XYZ word of SAV
    input  wire        bit_rate,                // 1 = rate/1.001
    input  wire [2:0]  mode,                    // SDI mode
    input  wire [2:0]  active_streams,          // number of active streams
    input  wire        mode_locked,             // indicates when mode is valid
    input  wire        level_b,                 // 3G-SDI level code
    input  wire [10:0] ln,                      // current line number
    output reg  [3:0]  transport_family=4'hF,   // transport format family code
    output reg  [3:0]  transport_rate=4'hF,     // frame rate code
    output reg         transport_scan=1'b0,     // 0 = interlaced, 1 = progressive
    output wire        transport_locked         // 1 = transport format has been detected
);

//-----------------------------------------------------------------------------
// Parameter definitions
//

localparam HCNT_MSB     = 5;                // MS bit # of modulo 63 HANC counter
localparam HANC_MOD     = 63;               // Modulo value to use for HANC counter
localparam HANC_TC      = HANC_MOD-1;
localparam VCNT_MSB     = 10;               // MS bit # of vertical counter
localparam FA_DLY_MSB   = 9;                // MS bit # of first active line delay shift reg

localparam [3:0]
    FAM_1920_1080       = 4'b0000,
    FAM_1280_720        = 4'b0001,
    FAM_2048_1080       = 4'b0010,
    FAM_ST295           = 4'b0011,
    FAM_NTSC            = 4'b1000,
    FAM_PAL             = 4'b1001,
    FAM_UNKNOWN         = 4'b1111;

localparam [2:0]
    RATE_24             = 3'b000,
    RATE_25             = 3'b001,
    RATE_30             = 3'b010,
    RATE_48             = 3'b011,
    RATE_50             = 3'b100,
    RATE_60             = 3'b101,
    RATE_UNKNOWN        = 3'b111;

localparam [3:0]
    SMPTE_RATE_NONE     = 4'h0,
    SMPTE_RATE_24M      = 4'h2,
    SMPTE_RATE_24       = 4'h3,
    SMPTE_RATE_48M      = 4'h4,
    SMPTE_RATE_25       = 4'h5,
    SMPTE_RATE_30M      = 4'h6,
    SMPTE_RATE_30       = 4'h7,
    SMPTE_RATE_48       = 4'h8,
    SMPTE_RATE_50       = 4'h9,
    SMPTE_RATE_60M      = 4'hA,
    SMPTE_RATE_60       = 4'hB;

localparam [2:0]
    MODE_HD             = 3'b000,
    MODE_SD             = 3'b001,
    MODE_3G             = 3'b010,
    MODE_6G             = 3'b100,
    MODE_12G            = 3'b101,
    MODE_12G_1          = 3'b110;
//
// Signal definitions
//
reg                     eav_reg = 1'b0;
reg                     sav_reg = 1'b0;
reg     [2:0]           mode_reg = 3'b000;           // SDI mode input register
reg     [2:0]           active_streams_reg = 3'b000; // active streams input register
reg                     level_b_reg = 1'b0;
reg                     v_reg = 1'b0;
reg                     v_last = 1'b0;          // previous V flag value
wire                    fa;                     // first active line indicator
reg     [FA_DLY_MSB:0]  fa_dly = 0;             // delays first active signal by 8 clocks
wire                    fa_dly_out;
reg     [HCNT_MSB:0]    hanc_counter = 0;       // counts samples in HANC, modulo 8
reg     [HCNT_MSB:0]    hanc_counter_save = 0;  // saves the last HANC counter value
reg     [VCNT_MSB:0]    first_active_line = 0;  // register holds line # of first active video line
wire                    is_1080p;               // 1 when format is 1080p
reg                     hanc_counter_en = 1'b0; // HANC interval counter enable
reg                     mode_3GA;
reg                     locked = 1'b0;
reg     [HCNT_MSB+2:0]  rom_address = 0;
reg     [7:0]           rom_out = 0;
wire    [3:0]           family;
wire    [2:0]           rate;
wire                    scan;
reg                     bit_rate_reg = 1'b0;

// -----------------------------------------------------------------------------
// Input registers
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            eav_reg <= 1'b0;
        else
            eav_reg <= eav;
    end

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            sav_reg <= 1'b0;
        else
            sav_reg <= sav;
    end

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            mode_reg <= 3'b000;
        else
            mode_reg <= mode;
    end

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            active_streams_reg <= 3'b000;
        else
            active_streams_reg <= active_streams;
    end

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            level_b_reg <= 1'b0;
        else
            level_b_reg <= level_b;
    end

//
// The mode_3GA signals is used to select the detected frame rate as either 
// being in the 25&30 Hz family (if mode_3GA is Low) or in the 50&60 Hz family
// if mode_3GA is High. In 6G-SDI mode, if there are 8 active data streams, the
// mode_3GA signal is Low to select the 25&30 Hz family and if there are 4 active
// streams, mode_3GA is High to select the 50&60 Hz family. It is not possible
// for the frame rate detector to distinguish between the 50&60 Hz frame rate
// family and the 100&120 Hz frame rate family carried in 6G-SDI mapping modes
// 2 & 3 because and the 100&120 Hz frame rates are always reported as 50&60 Hz.
// In 12G-SDI mode, the mode_3GA signal is asserted if there are 8 data streams
// and it is not asserted if there are 16 data streams.
//
always @ (*)
    case (mode_reg)
        MODE_SD:    mode_3GA = 1'b0;
        MODE_HD:    mode_3GA = 1'b0;
        MODE_3G:    mode_3GA = ~level_b_reg;
        MODE_6G:    mode_3GA = active_streams_reg == 3'b010;
        default:    mode_3GA = active_streams_reg == 3'b011;
    endcase
    
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            v_reg <= 1'b0;
        else
            v_reg <= vid_7;
    end

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            bit_rate_reg <= 1'b0;
        else
            bit_rate_reg <= bit_rate;
    end

//------------------------------------------------------------------------------
// HANC counter
//
// The HANC counter is a modulo 63 counter that counts the duration of the
// HANC interval. It begins counting when the eav input is asserted and stops
// when sav is asserted.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst | sav_reg)
            hanc_counter_en <= 1'b0;
        else if (eav_reg)
            hanc_counter_en <= 1'b1;
    end

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            hanc_counter <= 63; 
        else if (eav_reg)
            hanc_counter <= 0;
        else if (hanc_counter_en)
        begin
            if (hanc_counter == HANC_TC)
                hanc_counter <= 0;
            else
                hanc_counter <= hanc_counter + 1;
        end
    end

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            hanc_counter_save <= 63;
        else if (~hanc_counter_en)
            hanc_counter_save <= hanc_counter;
    end

//------------------------------------------------------------------------------
// Detect first active video line
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            v_last <= 1'b0;
        else if (eav_reg)
            v_last <= v_reg;
    end

assign fa = ~v_reg & v_last & eav_reg;

always @ (posedge clk)
    if (ce)
        fa_dly <= {fa_dly[FA_DLY_MSB-1:0], fa};

assign fa_dly_out = fa_dly[FA_DLY_MSB-2];

always @ (posedge clk)
    if (ce)
    begin
        if (fa_dly_out)
            first_active_line <= ln;
    end
    
assign is_1080p = first_active_line == 11'd42;

//------------------------------------------------------------------------------
// Transport family code ROM
//
always @ (posedge clk)
    if (ce)
        rom_address <= {mode_3GA, is_1080p, hanc_counter_save};

always @ (*)
    case(rom_address)
        8'd20   :   rom_out = {1'b0, RATE_30, FAM_NTSC};           // SD:      NTSC
        8'd32   :   rom_out = {1'b0, RATE_25, FAM_PAL};            // SD:      PAL
        8'd24   :   rom_out = {1'b0, RATE_30, FAM_1920_1080};      // HD/3GB:  1080i60 
        8'd23   :   rom_out = {1'b0, RATE_25, FAM_1920_1080};      // HD/3GB:  1080i50
        8'd88   :   rom_out = {1'b1, RATE_30, FAM_1920_1080};      // HD/3GB:  1080p30
        8'd87   :   rom_out = {1'b1, RATE_25, FAM_1920_1080};      // HD/3GB:  1080p25
        8'd71   :   rom_out = {1'b1, RATE_24, FAM_1920_1080};      // HD-3GB:  1080p24
        8'd7    :   rom_out = {1'b0, RATE_24, FAM_1920_1080};      // HD-3GB:  1080psF24
        8'd51   :   rom_out = {1'b1, RATE_60, FAM_1280_720};       // HD:      720p60
        8'd3    :   rom_out = {1'b1, RATE_50, FAM_1280_720};       // HD:      720p50
        8'd0    :   rom_out = {1'b1, RATE_30, FAM_1280_720};       // HD:      720p30
        8'd30   :   rom_out = {1'b1, RATE_25, FAM_1280_720};       // HD:      720p25
        8'd6    :   rom_out = {1'b1, RATE_24, FAM_1280_720};       // HD:      720p24
        8'd86   :   rom_out = {1'b1, RATE_30, FAM_2048_1080};      // HD/3GB:  2Kx1080p30
        8'd85   :   rom_out = {1'b1, RATE_25, FAM_2048_1080};      // HD/3GB:  2Kx1080p25
        8'd69   :   rom_out = {1'b1, RATE_24, FAM_2048_1080};      // HD/3GB:  2Kx1080p24
        8'd22   :   rom_out = {1'b0, RATE_30, FAM_2048_1080};      // HD/3GB:  2Kx1080psF30
        8'd21   :   rom_out = {1'b0, RATE_25, FAM_2048_1080};      // HD/3GB:  2Kx1080psF25
        8'd5    :   rom_out = {1'b0, RATE_24, FAM_2048_1080};      // HD/3GB:  2Kx1080psF24
        8'd216  :   rom_out = {1'b1, RATE_60, FAM_1920_1080};      // 3GA:     1080p60
        8'd215  :   rom_out = {1'b1, RATE_50, FAM_1920_1080};      // 3GA:     1080p50
        8'd214  :   rom_out = {1'b1, RATE_60, FAM_2048_1080};      // 3GA:     2Kx1080p60
        8'd213  :   rom_out = {1'b1, RATE_50, FAM_2048_1080};      // 3GA:     2Kx1080p50
        8'd197  :   rom_out = {1'b1, RATE_48, FAM_2048_1080};      // 3GA:     2Kx1080p48
        8'd199  :   rom_out = {1'b1, RATE_48, FAM_1920_1080};      // 3GA:     1080p48
        8'd180  :   rom_out = {1'b0, RATE_30, FAM_1920_1080};      // 3GA:     1080i60
        8'd178  :   rom_out = {1'b0, RATE_25, FAM_1920_1080};      // 3GA:     1080i50
        8'd244  :   rom_out = {1'b1, RATE_30, FAM_1920_1080};      // 3GA:     1080p30
        8'd242  :   rom_out = {1'b1, RATE_25, FAM_1920_1080};      // 3GA:     1080p25
        8'd210  :   rom_out = {1'b1, RATE_24, FAM_1920_1080};      // 3GA:     1080p24
        8'd146  :   rom_out = {1'b0, RATE_24, FAM_1920_1080};      // 3GA:     1080psF24
        8'd240  :   rom_out = {1'b1, RATE_30, FAM_2048_1080};      // 3GA:     2Kx1080p30
        8'd238  :   rom_out = {1'b1, RATE_25, FAM_2048_1080};      // 3GA:     2Kx1080p25
        8'd206  :   rom_out = {1'b1, RATE_24, FAM_2048_1080};      // 3GA:     2Kx1080p24
        8'd176  :   rom_out = {1'b0, RATE_30, FAM_2048_1080};      // 3GA:     2Kx1080psF30
        8'd174  :   rom_out = {1'b0, RATE_25, FAM_2048_1080};      // 3GA:     2Kx1080psF25
        8'd142  :   rom_out = {1'b0, RATE_24, FAM_2048_1080};      // 3GA:     2Kx1080psF24
        8'd171  :   rom_out = {1'b1, RATE_60, FAM_1280_720};       // 3GA:     720p60
        8'd138  :   rom_out = {1'b1, RATE_50, FAM_1280_720};       // 3GA:     720p50
        8'd132  :   rom_out = {1'b1, RATE_30, FAM_1280_720};       // 3GA:     720p30
        8'd129  :   rom_out = {1'b1, RATE_25, FAM_1280_720};       // 3GA:     720p25
        8'd144  :   rom_out = {1'b1, RATE_24, FAM_1280_720};       // 3GA:     720p24
        8'd11   :   rom_out = {1'b0, RATE_25, FAM_ST295};          // HD:      ST295
        default :   rom_out = {1'b0, RATE_UNKNOWN, FAM_UNKNOWN};
    endcase

assign family = rom_out[3:0];
assign rate   = rom_out[6:4];
assign scan   = rom_out[7];

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            transport_family <= FAM_UNKNOWN;
        else if (((family == FAM_PAL) || (family == FAM_NTSC)) && (mode_reg != 3'b001))
            transport_family <= FAM_UNKNOWN;
        else
            transport_family <= family;
    end

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            transport_rate <= SMPTE_RATE_NONE;
        else if (family == FAM_NTSC)
            transport_rate <= SMPTE_RATE_30M;
        else
            casex({rate, bit_rate_reg})
                4'b000_0 :  transport_rate <= SMPTE_RATE_24;
                4'b000_1 :  transport_rate <= SMPTE_RATE_24M;
                4'b001_x :  transport_rate <= SMPTE_RATE_25;
                4'b010_0 :  transport_rate <= SMPTE_RATE_30;
                4'b010_1 :  transport_rate <= SMPTE_RATE_30M;
                4'b011_0 :  transport_rate <= SMPTE_RATE_48;
                4'b011_1 :  transport_rate <= SMPTE_RATE_48M;
                4'b100_x :  transport_rate <= SMPTE_RATE_50;
                4'b101_0 :  transport_rate <= SMPTE_RATE_60;
                4'b101_1 :  transport_rate <= SMPTE_RATE_60M;   
                default  :  transport_rate <= SMPTE_RATE_NONE;
            endcase
    end

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            transport_scan <= 1'b0;
        else
            transport_scan <= scan;
    end


//------------------------------------------------------------------------------
// Transport locked detection
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst | ~mode_locked)
            locked <= 1'b0;
        else if (mode_locked & (mode == 3'b001))
            locked <= (rate != RATE_UNKNOWN) && (family != FAM_UNKNOWN);
        else if (fa_dly[FA_DLY_MSB])
            locked <= (rate != RATE_UNKNOWN) && (family != FAM_UNKNOWN);
    end

assign transport_locked = locked;

endmodule


// (c) Copyright 2014 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/*
Module Description:

This module restores the LS 2 bits of 3FD and 002 values in the TRS and ADF
sequences to their full 3FF and 000 values. The trs input is delayed by the same
number of clock cycles as the data path, but is not modified in any other way.

--------------------------------------------------------------------------------
*/

`timescale 1ns / 1ns
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_rx_trs_restore (
    input   wire        clk,            // input clock
    input   wire        ce,             // clock enable
    input   wire        trs_in,         // trs input signal 
    output  reg         trs_out,        // trs output signal
    input   wire [39:0] din,            // input value
    output  reg  [39:0] dout = 40'b0    // output register
);

reg [39:0]  in_reg = 40'b0;
reg         trs_reg = 1'b0;

function [9:0] restore10;
    input   [9:0] d;

    if (d[9:2] == 8'hff)
        restore10 = 10'h3FF;
    else if (d[9:2] == 8'h00)
        restore10 = 10'h000;
    else
        restore10 = d;
endfunction

always @ (posedge clk)
    if (ce)
    begin
        in_reg <= din;
        trs_reg <= trs_in;
    end

always @ (posedge clk)
    if (ce)
    begin
        dout[9:0]   <= restore10(in_reg[9:0]);
        dout[19:10] <= restore10(in_reg[19:10]);
        dout[29:20] <= restore10(in_reg[29:20]);
        dout[39:30] <= restore10(in_reg[39:30]);
        trs_out <= trs_reg;
    end

endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/*
Module Description:

This is the top level of the UHD-SDI RX supporting all rates from SD to 12G.
*/

`timescale 1ns / 1ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_rx #(
    parameter INCLUDE_RX_EDH_PROCESSOR = "TRUE",
    parameter NUM_CE                = 1,                // number of clock enable outputs
    parameter ERRCNT_WIDTH          = 4,                // width of counter tracking lines with errors
    parameter MAX_ERRS_LOCKED       = 15,               // max number of consecutive lines with errors
    parameter MAX_ERRS_UNLOCKED     = 2,                // max number of lines with errors during search
    parameter RXDATA_WIDTH          = 40,               // width of rxdata port, must be 40 if 6G/12G are used, otherwise 20
    parameter EDH_ERR_WIDTH         = 16)               // width of EDH error counter
(
    // inputs
    input  wire                     clk,                // rxusrclk input
    input  wire                     rst,                // sync reset input
    input  wire                     mode_detect_rst,    // sync reset for SDI mode detection function
    input  wire [RXDATA_WIDTH-1:0]  data_in,            // raw data from GTX RXDATA port, in SD mode, the 10 LSBs must be driven by the DRU output
    input  wire                     sd_data_strobe,     // asserted high when SD data is available on data_in
    input  wire                     frame_en,           // 1 = enable framer position update
    input  wire                     bit_rate,           // 1 = 1000/1001 bit rate, 0 = 1000/1000 bit rate
    input  wire [5:0]               mode_enable,        // unary enable bits for SDI mode search {12G/1.001,12G/1, 6G, 3G, SD, HD} 1=enable, 0=disable
    input  wire                     mode_detect_en,     // 1 enables SDI mode detection
    input  wire [2:0]               forced_mode,        // if mode_detect_en=0, this port specifies the SDI mode of the RX
    input  wire                     rx_ready,           // when 0, prevents the SDI mode search from running

    // outputs
    output wire [2:0]               mode,               // 000=HD, 001=SD, 010=3G, 100=6G, 101=12G/1, 110=12G/1.001
    output reg                      mode_HD = 1'b0,     // 1 = HD mode      
    output reg                      mode_SD = 1'b0,     // 1 = SD mode
    output reg                      mode_3G = 1'b0,     // 1 = 3G mode
    output reg                      mode_6G = 1'b0,     // 1 = 6G mode
    output reg                      mode_12G = 1'b0,    // 1 = 12G mode
    output wire                     mode_locked,        // auto mode detection locked
    output wire                     t_locked,           // transport format detection locked
    output wire [3:0]               t_family,           // transport format family
    output wire [3:0]               t_rate,             // transport frame rate
    output wire                     t_scan,             // transport scan: 0=interlaced, 1=progressive
    output reg                      level_b_3G = 1'b0,  // 0 = level A, 1 = level B
    output wire [NUM_CE-1:0]        ce_out,             // clock enable
    output wire                     nsp,                // framer new start position
    output wire [2:0]               active_streams,     // 2^active_streams = number of active streams
    output wire [10:0]              ln_ds1,             // line number for ds1
    output wire [10:0]              ln_ds2,             // line number for ds2
    output wire [10:0]              ln_ds3,             // line number for ds3
    output wire [10:0]              ln_ds4,             // line number for ds4
    output wire [10:0]              ln_ds5,             // line number for ds5
    output wire [10:0]              ln_ds6,             // line number for ds6
    output wire [10:0]              ln_ds7,             // line number for ds7
    output wire [10:0]              ln_ds8,             // line number for ds8
    output wire [10:0]              ln_ds9,             // line number for ds9
    output wire [10:0]              ln_ds10,            // line number for ds10
    output wire [10:0]              ln_ds11,            // line number for ds11
    output wire [10:0]              ln_ds12,            // line number for ds12
    output wire [10:0]              ln_ds13,            // line number for ds13
    output wire [10:0]              ln_ds14,            // line number for ds14
    output wire [10:0]              ln_ds15,            // line number for ds15
    output wire [10:0]              ln_ds16,            // line number for ds16
    output wire [31:0]              vpid_0,             // video payload ID packet channel 0 (for 3G-SDI level A, Y VPID)
    output wire                     vpid_0_valid,       // 1 = vpid_0 is valid
    output wire [31:0]              vpid_1,             // video payload ID packet channel 1 (for 3G-SDI level A, C VPID) 
    output wire                     vpid_1_valid,       // 1 = vpid_1 is valid
    output wire [31:0]              vpid_2,             // video payload ID packet channel 2
    output wire                     vpid_2_valid,       // 1 = vpid_2 is valid
    output wire [31:0]              vpid_3,             // video payload ID packet channel 3
    output wire                     vpid_3_valid,       // 1 = vpid_3 is valid
    output wire [31:0]              vpid_4,             // video payload ID packet channel 4
    output wire                     vpid_4_valid,       // 1 = vpid_4 is valid
    output wire [31:0]              vpid_5,             // video payload ID packet channel 5
    output wire                     vpid_5_valid,       // 1 = vpid_5 is valid
    output wire [31:0]              vpid_6,             // video payload ID packet channel 6
    output wire                     vpid_6_valid,       // 1 = vpid_6 is valid
    output wire [31:0]              vpid_7,             // video payload ID packet channel 7
    output wire                     vpid_7_valid,       // 1 = vpid_7 is valid
    output reg                      crc_err_ds1 = 1'b0, // CRC error for ds1
    output reg                      crc_err_ds2 = 1'b0, // CRC error for ds2
    output reg                      crc_err_ds3 = 1'b0, // CRC error for ds3
    output reg                      crc_err_ds4 = 1'b0, // CRC error for ds4
    output reg                      crc_err_ds5 = 1'b0, // CRC error for ds5
    output reg                      crc_err_ds6 = 1'b0, // CRC error for ds6
    output reg                      crc_err_ds7 = 1'b0, // CRC error for ds7
    output reg                      crc_err_ds8 = 1'b0, // CRC error for ds8
    output reg                      crc_err_ds9 = 1'b0, // CRC error for ds9
    output reg                      crc_err_ds10 = 1'b0,// CRC error for ds10
    output reg                      crc_err_ds11 = 1'b0,// CRC error for ds11
    output reg                      crc_err_ds12 = 1'b0,// CRC error for ds12
    output reg                      crc_err_ds13 = 1'b0,// CRC error for ds13
    output reg                      crc_err_ds14 = 1'b0,// CRC error for ds14
    output reg                      crc_err_ds15 = 1'b0,// CRC error for ds15
    output reg                      crc_err_ds16 = 1'b0,// CRC error for ds16
    output wire [9:0]               ds1,                // SD=Y/C, HD=Y, 3GA=ds1, 3GB=Y link A, 6G/12G=ds1
    output wire [9:0]               ds2,                // HD=C, 3GA=ds2, 3GB=C link A, 6G/12G=ds2
    output wire [9:0]               ds3,                // 3GB=Y link B, 6G/12G=ds3
    output wire [9:0]               ds4,                // 3GB=C link B, 6G/12G=ds4
    output wire [9:0]               ds5,                // 6G/12G=ds5
    output wire [9:0]               ds6,                // 6G/12G=ds6
    output wire [9:0]               ds7,                // 6G/12G=ds7
    output wire [9:0]               ds8,                // 6G/12G=ds8
    output wire [9:0]               ds9,                // 12G=ds9
    output wire [9:0]               ds10,               // 12G=ds10
    output wire [9:0]               ds11,               // 12G=ds11
    output wire [9:0]               ds12,               // 12G=ds12
    output wire [9:0]               ds13,               // 12G=ds13
    output wire [9:0]               ds14,               // 12G=ds14
    output wire [9:0]               ds15,               // 12G=ds15
    output wire [9:0]               ds16,               // 12G=ds16
    output wire                     eav,                // EAV
    output wire                     sav,                // SAV
    output wire                     trs,                // TRS
    input  wire [15:0]              edh_errcnt_en,      // enables various error to increment rx_edh_errcnt
    input  wire                     edh_clr_errcnt,     // clears rx_edh_errcnt
    output wire                     edh_ap,             // 1 = AP CRC error detected previous field
    output wire                     edh_ff,             // 1 = FF CRC error detected previous field
    output wire                     edh_anc,            // 1 = ANC checksum error detected
    output wire [4:0]               edh_ap_flags,       // EDH AP flags received in last EDH packet
    output wire [4:0]               edh_ff_flags,       // EDH FF flags received in last EDH packet
    output wire [4:0]               edh_anc_flags,      // EDH ANC flags received in last EDH packet
    output wire [3:0]               edh_packet_flags,   // EDH packet error condition flags
    output wire [15:0]              edh_errcnt          // EDH error counter

);

//
// Internal signal declarations
//

// Clock enables
localparam NUM_INT_CE = 2;                  // Number of internal clock enables used

(* equivalent_register_removal = "no" *)
(* KEEP = "TRUE" *)
reg [NUM_INT_CE-1:0]    ce_int = 0;         // internal SD clock enable FFs

(* equivalent_register_removal = "no" *)
(* KEEP = "TRUE" *)
reg [NUM_CE-1:0]        ce_ff = 0;          // external SD clock enable FFs

(* equivalent_register_removal = "no" *)
(* KEEP = "TRUE" *)
reg                     ce_edh = 0;         // EDH clock enable FF

reg  [RXDATA_WIDTH-1:0] rxdata = 0;
reg  [9:0]              sd_rxdata = 0;
wire [2:0]              mode_int;
wire [2:0]              mode_x;
wire                    mode_locked_int;
wire                    mode_locked_x;
reg                     mode_HD_int;
reg                     mode_SD_int;
reg                     mode_3G_int;
reg                     mode_6G_int;
reg                     mode_12G_int;
wire [19:0]             descrambler_in_ls;
wire [RXDATA_WIDTH-1:0] descrambler_in;
wire [9:0]              framer_ds1;
wire [9:0]              framer_ds2;
wire [9:0]              framer_ds3;
wire [9:0]              framer_ds4;
wire [9:0]              framer_ds5;
wire [9:0]              framer_ds6;
wire [9:0]              framer_ds7;
wire [9:0]              framer_ds8;
wire [9:0]              framer_ds9;
wire [9:0]              framer_ds10;
wire [9:0]              framer_ds11;
wire [9:0]              framer_ds12;
wire [9:0]              framer_ds13;
wire [9:0]              framer_ds14;
wire [9:0]              framer_ds15;
wire [9:0]              framer_ds16;
wire                    framer_eav;
wire                    framer_sav;
wire                    framer_trs;
wire                    framer_trs_err;
reg                     eav_int = 1'b0;
reg                     sav_int = 1'b0;
reg                     trs_int = 1'b0;
wire                    ds1_crc_err;
wire                    ds2_crc_err;
wire                    ds3_crc_err;
wire                    ds4_crc_err;
wire                    ds5_crc_err;
wire                    ds6_crc_err;
wire                    ds7_crc_err;
wire                    ds8_crc_err;
wire                    ds9_crc_err;
wire                    ds10_crc_err;
wire                    ds11_crc_err;
wire                    ds12_crc_err;
wire                    ds13_crc_err;
wire                    ds14_crc_err;
wire                    ds15_crc_err;
wire                    ds16_crc_err;
wire [10:0]             ln_ds1_int;
wire [10:0]             ln_ds2_int;
wire [10:0]             ln_ds3_int;
wire [10:0]             ln_ds4_int;
wire [10:0]             ln_ds5_int;
wire [10:0]             ln_ds6_int;
wire [10:0]             ln_ds7_int;
wire [10:0]             ln_ds8_int;
wire [10:0]             ln_ds9_int;
wire [10:0]             ln_ds10_int;
wire [10:0]             ln_ds11_int;
wire [10:0]             ln_ds12_int;
wire [10:0]             ln_ds13_int;
wire [10:0]             ln_ds14_int;
wire [10:0]             ln_ds15_int;
wire [10:0]             ln_ds16_int;
wire                    framer_ce;
wire [5:0]              mode_enable_int;
wire [9:0]              vpid_1_mux;
wire                    mode_3ga;
wire                    level_b;
wire                    sd_strobe = sd_data_strobe;
wire                    autorate_ce;
wire                    autorate_sav;
wire                    bit_rate_int;
wire [2:0]              active_streams_int;
reg                     trs_err = 1'b0;
wire [15:0]             crc_err_vector;

assign active_streams = active_streams_int;

//------------------------------------------------------------------------------
// Clock enable generation
//

//
// Generate multiple copies of the clock enable signal. In SD-SDI mode, the CE
// comes from the DRU data strobe (the sd_data_strobe) input. In all other modes,
// the ce comes from the framer.
//
always @ (posedge clk)
    if (mode_int == 3'b001)
        ce_int <= {NUM_INT_CE {sd_data_strobe}};
    else
        ce_int <= {NUM_INT_CE {framer_ce}};

always @ (posedge clk)
    if (mode_int == 3'b001)
        ce_ff <= {NUM_CE {sd_data_strobe}};
    else
        ce_ff <= {NUM_CE {framer_ce}};
        
assign ce_out = ce_ff;

generate
    if (INCLUDE_RX_EDH_PROCESSOR == "TRUE")
    begin : INCLUDE_EDH_CE
        
        always @ (posedge clk)
            if (mode_int == 3'b001)
                ce_edh <= sd_data_strobe;
            else
                ce_edh <= 1'b0;
    end
    else
    begin : NO_EDH_CE
        always @ (posedge clk)
            ce_edh <= 1'b0;
    end
endgenerate

//------------------------------------------------------------------------------
// Data input registers
//
always @ (posedge clk)
    rxdata <= data_in;

always @ (posedge clk)
    if (sd_data_strobe)
        sd_rxdata <= data_in[9:0];

//------------------------------------------------------------------------------
// SDI descrambler, framer, and data stream mux.
//
assign descrambler_in_ls = (mode_int == 3'b001) ? {sd_rxdata, 10'b0} : rxdata[19:0];

generate
    if (RXDATA_WIDTH == 20) begin: rx20b
        assign mode_enable_int = {3'b000, mode_enable[2:0]};
        assign descrambler_in = descrambler_in_ls;
    end else begin: rx40b
        assign mode_enable_int = mode_enable;
        assign descrambler_in = {rxdata[39:20], descrambler_in_ls};
    end
endgenerate

v_smpte_uhdsdi_v1_0_5_rx_to_demux #(
    .MAX_RXDATA_WIDTH   (RXDATA_WIDTH))
RXDPCOMMON (
    .clk            (clk),
    .sd_data_strobe (sd_data_strobe),
    .rst            (rst | ~rx_ready),
    .rxdata         (descrambler_in),
    .mode           (mode_int),
    .frame_en       (frame_en),
    .nsp            (framer_nsp),
    .ce_out         (framer_ce),
    .trs            (framer_trs),
    .eav            (framer_eav),
    .sav            (framer_sav),
    .level_b        (level_b),
    .raw_sav        (autorate_sav),
    .muxed_ds_ce    (autorate_ce),
    .active_streams (active_streams_int),
    .ds1            (framer_ds1),
    .ds2            (framer_ds2),
    .ds3            (framer_ds3),
    .ds4            (framer_ds4),
    .ds5            (framer_ds5),
    .ds6            (framer_ds6),
    .ds7            (framer_ds7),
    .ds8            (framer_ds8),
    .ds9            (framer_ds9),
    .ds10           (framer_ds10),
    .ds11           (framer_ds11),
    .ds12           (framer_ds12),
    .ds13           (framer_ds13),
    .ds14           (framer_ds14),
    .ds15           (framer_ds15),
    .ds16           (framer_ds16));

assign framer_trs_err = framer_sav & (
                        (framer_ds1[5] ^ framer_ds1[6] ^ framer_ds1[7]) |
                        (framer_ds1[4] ^ framer_ds1[8] ^ framer_ds1[6]) |
                        (framer_ds1[3] ^ framer_ds1[8] ^ framer_ds1[7]) |
                        (framer_ds1[2] ^ framer_ds1[8] ^ framer_ds1[7] ^ framer_ds1[6]) |
                        ~framer_ds1[9] | framer_ds1[1] | framer_ds1[0]);
 
assign nsp = framer_nsp;

//------------------------------------------------------------------------------
// SDI mode detection
//

//
// Validate every SAV for the autorate module. If the CRC error signal of
// all active data streams is asserted, then the SAV isn't valid.
//
assign crc_err_vector = {ds16_crc_err, ds15_crc_err, ds14_crc_err, ds13_crc_err, ds12_crc_err, ds11_crc_err, ds10_crc_err, ds9_crc_err,
                         ds8_crc_err, ds7_crc_err, ds6_crc_err, ds5_crc_err, ds4_crc_err, ds3_crc_err, ds2_crc_err, ds1_crc_err};

always @ (posedge clk)
    case(active_streams_int)
        3'b000:     trs_err <= 1'b0;                    // CRC errors aren't valid in SD-SDI mode, so trs_err is always Low
        3'b001:     trs_err <= &crc_err_vector[1:0];    // 2 active streams
        3'b010:     trs_err <= &crc_err_vector[3:0];    // 4 active streams
        3'b011:     trs_err <= &crc_err_vector[7:0];    // 8 active streams
        default:    trs_err <= &crc_err_vector[15:0];   // 16 active streams
    endcase

v_smpte_uhdsdi_v1_0_5_rx_autorate #(
    .ERRCNT_WIDTH       (ERRCNT_WIDTH),
    .MAX_ERRS_LOCKED    (MAX_ERRS_LOCKED),
    .MAX_ERRS_UNLOCKED  (MAX_ERRS_UNLOCKED))
AUTORATE (
    .clk                (clk),
    .ce                 (autorate_ce),
    .rst                (mode_detect_rst),
	.ds1                (framer_ds1),
	.eav                (framer_eav),
    .sav                (framer_sav),
    .trs_err            (trs_err | framer_trs_err),
    .rx_ready           (rx_ready),
    .mode_enable        (mode_enable_int),
    .mode               (mode_x),
    .locked             (mode_locked_x));

//
// Decode the RX mode into unary mode signals.
//
always @ (*)
begin
    mode_HD_int = 1'b0;
    mode_SD_int = 1'b0;
    mode_3G_int = 1'b0;
    mode_6G_int = 1'b0;
    mode_12G_int= 1'b0;

    case(mode_int)
        3'b001:   mode_SD_int = 1'b1;
        3'b010:   mode_3G_int = 1'b1;
        3'b100:   mode_6G_int = 1'b1;
        3'b101:   mode_12G_int = 1'b1;
        3'b110:   mode_12G_int = 1'b1;
        default:  mode_HD_int = 1'b1;
    endcase
end

//
// If the mode_detect_en input is 1, then use the mode detected by the 
// v_smpte_uhdsdi_v1_0_5_rx_autorate module and the associated mode_locked signal.
// Otherwise, use the forced_mode input and always assert mode_locked.
//
assign mode_int = mode_detect_en ? mode_x : forced_mode;
assign mode_locked_int = mode_detect_en ? mode_locked_x : 1'b1;

assign mode = mode_int;
assign mode_locked = mode_locked_int;

assign ds1 = framer_ds1;
assign ds2 = framer_ds2;
assign ds3 = framer_ds3;
assign ds4 = framer_ds4;
assign ds5 = framer_ds5;
assign ds6 = framer_ds6;
assign ds7 = framer_ds7;
assign ds8 = framer_ds8;
assign ds9 = framer_ds9;
assign ds10 = framer_ds10;
assign ds11 = framer_ds11;
assign ds12 = framer_ds12;
assign ds13 = framer_ds13;
assign ds14 = framer_ds14;
assign ds15 = framer_ds15;
assign ds16 = framer_ds16;

assign eav  = framer_eav;
assign sav  = framer_sav;
assign trs  = framer_trs;

//------------------------------------------------------------------------------
// Transport timing detection module
//
assign bit_rate_int = mode_12G_int ? ~mode_int[0] : bit_rate; 

v_smpte_uhdsdi_v1_0_5_rx_transport_detect TD (
    .clk                (clk),
    .rst                (rst),
    .ce                 (ce_int[0]),
    .vid_7              (framer_ds1[7]),
    .eav                (framer_eav),
    .sav                (framer_sav),
    .bit_rate           (bit_rate_int),
    .mode               (mode_int),
    .active_streams     (active_streams_int),
    .mode_locked        (mode_locked_int),
    .level_b            (level_b),
    .ln                 (ln_ds1_int),
    .transport_family   (t_family),
    .transport_rate     (t_rate),
    .transport_scan     (t_scan),
    .transport_locked   (t_locked));

//------------------------------------------------------------------------------
// CRC error detection and line number capture
//
v_smpte_uhdsdi_v1_0_5_rx_crc RXCRC1 (
    .clk        (clk),
    .rst        (rst),
    .ce         (ce_int[0]), 
    .c_video    (framer_ds2),
    .y_video    (framer_ds1),
    .trs        (framer_trs),
    .c_crc_err  (ds2_crc_err),
    .y_crc_err  (ds1_crc_err),
    .c_line_num (ln_ds2_int),
    .y_line_num (ln_ds1_int));

assign ln_ds1 = ln_ds1_int;
assign ln_ds2 = ln_ds2_int;

v_smpte_uhdsdi_v1_0_5_rx_crc RXCRC2 (
    .clk        (clk),
    .rst        (rst),
    .ce         (ce_int[0]), 
    .c_video    (framer_ds4),
    .y_video    (framer_ds3),
    .trs        (framer_trs),
    .c_crc_err  (ds4_crc_err),
    .y_crc_err  (ds3_crc_err),
    .c_line_num (ln_ds4_int),
    .y_line_num (ln_ds3_int));

assign ln_ds3 = ln_ds3_int;
assign ln_ds4 = ln_ds4_int;

v_smpte_uhdsdi_v1_0_5_rx_crc RXCRC3 (
    .clk        (clk),
    .rst        (rst),
    .ce         (ce_int[0]), 
    .c_video    (framer_ds6),
    .y_video    (framer_ds5),
    .trs        (framer_trs),
    .c_crc_err  (ds6_crc_err),
    .y_crc_err  (ds5_crc_err),
    .c_line_num (ln_ds6_int),
    .y_line_num (ln_ds5_int));

assign ln_ds5 = ln_ds5_int;
assign ln_ds6 = ln_ds6_int;

v_smpte_uhdsdi_v1_0_5_rx_crc RXCRC4 (
    .clk        (clk),
    .rst        (rst),
    .ce         (ce_int[0]), 
    .c_video    (framer_ds8),
    .y_video    (framer_ds7),
    .trs        (framer_trs),
    .c_crc_err  (ds8_crc_err),
    .y_crc_err  (ds7_crc_err),
    .c_line_num (ln_ds8_int),
    .y_line_num (ln_ds7_int));

assign ln_ds7 = ln_ds7_int;
assign ln_ds8 = ln_ds8_int;

v_smpte_uhdsdi_v1_0_5_rx_crc RXCRC5 (
    .clk        (clk),
    .rst        (rst),
    .ce         (ce_int[1]), 
    .c_video    (framer_ds10),
    .y_video    (framer_ds9),
    .trs        (framer_trs),
    .c_crc_err  (ds10_crc_err),
    .y_crc_err  (ds9_crc_err),
    .c_line_num (ln_ds10_int),
    .y_line_num (ln_ds9_int));

assign ln_ds9 = ln_ds9_int;
assign ln_ds10 = ln_ds10_int;

v_smpte_uhdsdi_v1_0_5_rx_crc RXCRC6 (
    .clk        (clk),
    .rst        (rst),
    .ce         (ce_int[1]), 
    .c_video    (framer_ds12),
    .y_video    (framer_ds11),
    .trs        (framer_trs),
    .c_crc_err  (ds12_crc_err),
    .y_crc_err  (ds11_crc_err),
    .c_line_num (ln_ds12_int),
    .y_line_num (ln_ds11_int));

assign ln_ds11 = ln_ds11_int;
assign ln_ds12 = ln_ds12_int;

v_smpte_uhdsdi_v1_0_5_rx_crc RXCRC7 (
    .clk        (clk),
    .rst        (rst),
    .ce         (ce_int[1]), 
    .c_video    (framer_ds14),
    .y_video    (framer_ds13),
    .trs        (framer_trs),
    .c_crc_err  (ds14_crc_err),
    .y_crc_err  (ds13_crc_err),
    .c_line_num (ln_ds14_int),
    .y_line_num (ln_ds13_int));

assign ln_ds13 = ln_ds13_int;
assign ln_ds14 = ln_ds14_int;

v_smpte_uhdsdi_v1_0_5_rx_crc RXCRC8 (
    .clk        (clk),
    .rst        (rst),
    .ce         (ce_int[1]), 
    .c_video    (framer_ds16),
    .y_video    (framer_ds15),
    .trs        (framer_trs),
    .c_crc_err  (ds16_crc_err),
    .y_crc_err  (ds15_crc_err),
    .c_line_num (ln_ds16_int),
    .y_line_num (ln_ds15_int));

assign ln_ds15 = ln_ds15_int;
assign ln_ds16 = ln_ds16_int;

//------------------------------------------------------------------------------
// SMPTE 352 payload ID capture
//

//
// In 3G-SDI level A mode, a ST 352 packet is present in the C data stream (data
// stream 2). This is the only mode in which ST 352 packets are present in the C
// data stream. The following mux routes data stream 2 through the ST 352 packet
// data stream 3 capture module in 3G-SDI level A mode. Otherwise, ST 352 packets
// are only detected on the Y data stream of each data stream pair.
//
assign mode_3ga = (mode_int == 3'b010) && ~level_b;
assign vpid_1_mux = mode_3ga ? framer_ds2 : framer_ds3;

v_smpte_uhdsdi_v1_0_5_rx_st352_pid_capture PLOD0 (
    .clk            (clk),
    .ce             (ce_int[0]),
    .rst            (rst),
    .sav            (framer_sav),
    .vid_in         (framer_ds1),
    .payload        (vpid_0),
    .valid          (vpid_0_valid));

v_smpte_uhdsdi_v1_0_5_rx_st352_pid_capture PLOD1 (
    .clk            (clk),
    .ce             (ce_int[0]),
    .rst            (rst),
    .sav            (framer_sav),
    .vid_in         (vpid_1_mux),
    .payload        (vpid_1),
    .valid          (vpid_1_valid));

v_smpte_uhdsdi_v1_0_5_rx_st352_pid_capture PLOD2 (
    .clk            (clk),
    .ce             (ce_int[0]),
    .rst            (rst),
    .sav            (framer_sav),
    .vid_in         (framer_ds5),
    .payload        (vpid_2),
    .valid          (vpid_2_valid));

v_smpte_uhdsdi_v1_0_5_rx_st352_pid_capture PLOD3 (
    .clk            (clk),
    .ce             (ce_int[0]),
    .rst            (rst),
    .sav            (framer_sav),
    .vid_in         (framer_ds7),
    .payload        (vpid_3),
    .valid          (vpid_3_valid));

v_smpte_uhdsdi_v1_0_5_rx_st352_pid_capture PLOD4 (
    .clk            (clk),
    .ce             (ce_int[1]),
    .rst            (rst),
    .sav            (framer_sav),
    .vid_in         (framer_ds9),
    .payload        (vpid_4),
    .valid          (vpid_4_valid));

v_smpte_uhdsdi_v1_0_5_rx_st352_pid_capture PLOD5 (
    .clk            (clk),
    .ce             (ce_int[1]),
    .rst            (rst),
    .sav            (framer_sav),
    .vid_in         (framer_ds11),
    .payload        (vpid_5),
    .valid          (vpid_5_valid));

v_smpte_uhdsdi_v1_0_5_rx_st352_pid_capture PLOD6 (
    .clk            (clk),
    .ce             (ce_int[1]),
    .rst            (rst),
    .sav            (framer_sav),
    .vid_in         (framer_ds13),
    .payload        (vpid_6),
    .valid          (vpid_6_valid));

v_smpte_uhdsdi_v1_0_5_rx_st352_pid_capture PLOD7 (
    .clk            (clk),
    .ce             (ce_int[1]),
    .rst            (rst),
    .sav            (framer_sav),
    .vid_in         (framer_ds15),
    .payload        (vpid_7),
    .valid          (vpid_7_valid));

//------------------------------------------------------------------------------
// Output registers for the unary mode signals, the level_b_3G signal, and the
// CRC error signals.
//
always @ (posedge clk)
    if (ce_int[0])
    begin
        if (rst)
        begin
            mode_HD <= 1'b0;
            mode_SD <= 1'b0;
            mode_3G <= 1'b0;
            mode_6G <= 1'b0;
            mode_12G <= 1'b0;
            level_b_3G <= 1'b0;
            crc_err_ds1 <= 1'b0;
            crc_err_ds2 <= 1'b0;
            crc_err_ds3 <= 1'b0;
            crc_err_ds4 <= 1'b0;
            crc_err_ds5 <= 1'b0;
            crc_err_ds6 <= 1'b0;
            crc_err_ds7 <= 1'b0;
            crc_err_ds8 <= 1'b0;
            crc_err_ds9 <= 1'b0;
            crc_err_ds10 <= 1'b0;
            crc_err_ds11 <= 1'b0;
            crc_err_ds12 <= 1'b0;
            crc_err_ds13 <= 1'b0;
            crc_err_ds14 <= 1'b0;
            crc_err_ds15 <= 1'b0;
            crc_err_ds16 <= 1'b0;
        end
        else
        begin
            mode_HD <= mode_HD_int & mode_locked_int;
            mode_SD <= mode_SD_int & mode_locked_int;
            mode_3G <= mode_3G_int & mode_locked_int;
            mode_6G <= mode_6G_int & mode_locked_int;
            mode_12G <= mode_12G_int & mode_locked_int;
            level_b_3G <= mode_3G_int & level_b;
            crc_err_ds1 <= ds1_crc_err;
            crc_err_ds2 <= ds2_crc_err;
            crc_err_ds3 <= ds3_crc_err;
            crc_err_ds4 <= ds4_crc_err;
            crc_err_ds5 <= ds5_crc_err;
            crc_err_ds6 <= ds6_crc_err;
            crc_err_ds7 <= ds7_crc_err;
            crc_err_ds8 <= ds8_crc_err;
            crc_err_ds9 <= ds9_crc_err;
            crc_err_ds10 <= ds10_crc_err;
            crc_err_ds11 <= ds11_crc_err;
            crc_err_ds12 <= ds12_crc_err;
            crc_err_ds13 <= ds13_crc_err;
            crc_err_ds14 <= ds14_crc_err;
            crc_err_ds15 <= ds15_crc_err;
            crc_err_ds16 <= ds16_crc_err;
        end
    end

//------------------------------------------------------------------------------
// SD-SDI EDH Processor
//
generate
    if (INCLUDE_RX_EDH_PROCESSOR == "TRUE")
    begin : INCLUDE_EDH

        wire [4:0]              ap_flags;
        wire [4:0]              ff_flags;
        wire [4:0]              anc_flags;

        v_smpte_uhdsdi_v1_0_5_edh_processor #(
            .ERROR_COUNT_WIDTH  (EDH_ERR_WIDTH))
        EDH (
            .clk                (clk),
            .ce                 (ce_edh),
            .rst                (rst),
            .vid_in             (framer_ds1),
            .reacquire          (1'b0),
            .en_sync_switch     (1'b1),
            .en_trs_blank       (1'b0),
            .anc_idh_local      (1'b0),
            .anc_ues_local      (1'b0),
            .ap_idh_local       (1'b0),
            .ff_idh_local       (1'b0),
            .errcnt_flg_en      (edh_errcnt_en),
            .clr_errcnt         (edh_clr_errcnt),
            .receive_mode       (1'b1),                   
            .vid_out            (),
            .std                (),
            .std_locked         (),
            .trs                (),
            .field              (),
            .v_blank            (),
            .h_blank            (),
            .horz_count         (),
            .vert_count         (),
            .sync_switch        (),
            .locked             (),
            .eav_next           (),
            .sav_next           (),
            .xyz_word           (),
            .anc_next           (),
            .edh_next           (),
            .rx_ap_flags        (edh_ap_flags),
            .rx_ff_flags        (edh_ff_flags),
            .rx_anc_flags       (edh_anc_flags),
            .ap_flags           (ap_flags),
            .ff_flags           (ff_flags),
            .anc_flags          (anc_flags),
            .packet_flags       (edh_packet_flags),
            .errcnt             (edh_errcnt),
            .edh_packet         ());

        assign edh_ap = ap_flags[0];
        assign edh_ff = ff_flags[0];
        assign edh_anc = anc_flags[0];
    end
    else
    begin : NO_EDH
        assign edh_ap_flags = 0;
        assign edh_ff_flags = 0;
        assign edh_anc_flags = 0;
        assign edh_packet_flags = 0;
        assign edh_ap = 1'b0;
        assign edh_ff = 1'b0;
        assign edh_anc = 1'b0;
        assign edh_errcnt = 0;
    end
endgenerate

endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/*
Module Description:

This module performs the bit replication of the incoming data. Each input bit is
replicated 11 times. The module generates 20 bits on every clock cycle. This 
module requires an alternating cadence of 5/6/5/6 on the clock enable (ce) 
input. The state machine automatically aligns itself regardless of whether the 
first step of the cadence is 5 or 6 when it starts up. If the 5/6/5/6 cadence 
gets out of step, the state machine will realign itself and will also assert the
align_err output for one clock cycle.

--------------------------------------------------------------------------------
*/

`timescale 1ns / 1ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_tx_bitrep_20b (
    input  wire             clk,                // clock input
    input  wire             rst,                // sync reset 
    input  wire             ce,                 // clock enable 
    input  wire [9:0]       d,                  // input data
    output reg  [19:0]      q = 0,              // output data
    output reg              align_err = 1'b0);  // ce alignment error



//-------------------------------------------------------------------
// Parameter definitions
//

localparam STATE_WIDTH = 4;
localparam STATE_MSB   = STATE_WIDTH - 1;

localparam [STATE_MSB:0] 
    START = 4'b1111,
    S0    = 4'b0000,
    S1    = 4'b0001,
    S2    = 4'b0010,
    S3    = 4'b0011,
    S4    = 4'b0100,
    S5    = 4'b0101,
    S6    = 4'b0110,
    S7    = 4'b0111,
    S8    = 4'b1000,
    S9    = 4'b1001,
    S10   = 4'b1010,
    S5X   = 4'b1011;
  
//--------------------------------------------------------------------
// Signal definitions
//

reg  [STATE_MSB:0]  current_state = START;
reg  [STATE_MSB:0]  next_state;
reg  [9:0]          in_reg = 0;
reg  [9:0]          d_reg = 0;
reg                 b9_save = 1'b0;
reg                 ce_dly = 1'b0;
reg  [19:0]         q_int;

//
// Input registers
//
always @ (posedge clk)
    if (ce)
        in_reg <= d;
        
always @ (posedge clk)
    ce_dly <= ce;
    
always @ (posedge clk)
    if (ce_dly)
        d_reg <= in_reg;                

always @ (posedge clk)
    if (ce_dly)
        b9_save <= d_reg[9];

//
// FSM: current_state register
//
// This code implements the current state register. It loads with the S0
// state on reset and the next_state value with each rising clock edge.
//
always @ (posedge clk)
    if (rst)
        current_state <= START;
    else 
        current_state <= next_state;
        

// FSM: next_state logic
//
// This case statement generates the next_state value for the FSM based on
// the current_state and the various FSM inputs.
//        
always@ *
    case(current_state)
        START:  if (ce_dly)
                    next_state = S0;
                else
                    next_state = START;
        
        S0:     next_state = S1;
        
        S1:     next_state = S2;
        
        S2:     next_state = S3;
        
        S3:     next_state = S4;
        
        S4:     if (ce_dly) 
                    next_state = S5;
                else
                    next_state = S5X;
        
        S5:     next_state = S6;            // Two different state 5's depending
                                            // on when the occurred
        S5X:    next_state = S6;
        
        S6:     next_state = S7;
        
        S7:     next_state = S8;
        
        S8:     next_state = S9;
        
        S9:     next_state = S10;
        
        S10:    if (ce_dly) 
                    next_state = S0; 
                else 
                    next_state = START;
        
        default: next_state = START; 
    endcase 

//
// Output mux
//
// Use the current state encoding to select the output bits.
//
always @ *
    case(current_state)
        S1:         q_int = { {7{d_reg[3]}}, {11{d_reg[2]}}, {2{d_reg[1]}}};
        S2:         q_int = { {5{d_reg[5]}}, {11{d_reg[4]}}, {4{d_reg[3]}}};
        S3:         q_int = { {3{d_reg[7]}}, {11{d_reg[6]}}, {6{d_reg[5]}}};
        S4:         q_int = {    d_reg[9],   {11{d_reg[8]}}, {8{d_reg[7]}}};
        S5:         q_int = {{10{d_reg[0]}}, {10{b9_save}}};                
        S6:         q_int = { {8{d_reg[2]}}, {11{d_reg[1]}},    d_reg[0]};
        S7:         q_int = { {6{d_reg[4]}}, {11{d_reg[3]}}, {3{d_reg[2]}}};
        S8:         q_int = { {4{d_reg[6]}}, {11{d_reg[5]}}, {5{d_reg[4]}}};
        S9:         q_int = { {2{d_reg[8]}}, {11{d_reg[7]}}, {7{d_reg[6]}}};
        S10:        q_int = {{11{d_reg[9]}}, { 9{d_reg[8]}}};               
        S5X:        q_int = {{10{in_reg[0]}},{10{d_reg[9]}}};               
        default:    q_int = { {9{d_reg[1]}}, {11{d_reg[0]}}};               
    endcase

always @ (posedge clk)
    q <= q_int;
        
always @ (posedge clk)
    align_err <= ((current_state == S10) || (current_state == S5X)) & ~ce_dly;

endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/*
Module Description:

This module implements the SDI TX data formatting operations for a Y/C data
stream pair. The funtions it implements are ST 352 PID packet generation & 
insertion, line number insertion, and CRC generation and insertion.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_tx_channel (
    input  wire             clk,                // txusrclk
    input  wire             ce,                 // clock enable
    input  wire             rst,                // sync reset input
    input  wire             sd_mode,            // 1 in SD-SDI mode, 0 in other modes
    input  wire             insert_crc,         // 1 = insert CRC for HD and 3G
    input  wire             insert_ln,          // 1 = insert LN for HD and 3G
    input  wire             insert_st352,       // 1 = insert st352 PID packets
    input  wire             overwrite_st352,    // 1= overwrite existing ST 352 packets
    input  wire [10:0]      line,               // current line number
    input  wire [10:0]      st352_line_f1,      // line number in field 1 to insert ST 352
    input  wire [10:0]      st352_line_f2,      // line number in field 2 to insert ST 352
    input  wire             st352_f2_en,        // 1 = insert packets on st352_line_f2 line
    input  wire [31:0]      st352_data,         // {byte4, byte3, byte2, byte1} 
    input  wire [9:0]       ds1_in,             // data stream 1 (Y) in
    input  wire [9:0]       ds2_in,             // data stream 2 (C) in -- not used in SD-SDI mode
    output wire [9:0]       ds1_st352_out,      // data stream 1 after ST352 insertion
    output wire [9:0]       ds2_st352_out,      // data stream 2 after ST352 insertion
    input  wire [9:0]       ds1_anc_in,         // data stream 1 after ANC insertion input
    input  wire [9:0]       ds2_anc_in,         // data stream 2 after ANC section input
    input  wire             use_anc_in,         // use the ds[1/2]_anc_in ports
    output reg  [9:0]       ds1_out = 10'b0,    // data stream 1 (Y) out
    output reg  [9:0]       ds2_out = 10'b0     // data stream 2 (C) out
);

//
// Internal signals
//
reg  [9:0]      ds1_anc = 10'b0;
reg  [9:0]      ds2_anc = 10'b0;
wire            eav;
wire            sav;
reg  [3:0]      eav_dly = 4'b0000;          // generates timing signals based on EAV
wire [9:0]      ds1_ln_out;
wire [9:0]      ds2_ln_out;
reg             crc_en = 1'b0;              // CRC control signal
reg             clr_crc = 1'b0;             // CRC control signal
wire [17:0]     ds1_crc;
wire [17:0]     ds2_crc;
wire [9:0]      ds1_crc_out;
wire [9:0]      ds2_crc_out;

//
// ST352 Payload ID packet insertion
//
v_smpte_uhdsdi_v1_0_5_tx_st352_pid_insert ST352 (
    .clk        (clk),
    .ce         (ce),
    .rst        (rst),
    .hd_sd      (sd_mode),
    .level_b    (1'b0),
    .enable     (insert_st352),
    .overwrite  (overwrite_st352),
    .line       (line),
    .line_a     (st352_line_f1),
    .line_b     (st352_line_f2),
    .line_b_en  (st352_f2_en),
    .byte1      (st352_data[7:0]),
    .byte2      (st352_data[15:8]),
    .byte3      (st352_data[23:16]),
    .byte4      (st352_data[31:24]),
    .y_in       (ds1_in),
    .c_in       (ds2_in),
    .y_out      (ds1_st352_out),
    .c_out      (ds2_st352_out),
    .eav_out    (),
    .sav_out    ());

//
// These muxes either pass the output of the st352pid_insert module on to the
// rest of the channel (when use_anc_in = 0) or pass the dsx_anc_in streams to
// the reset of the channel (when use_anc_in = 1).
//
always @ (posedge clk)
    if (ce)
    begin
        ds1_anc <= use_anc_in ? ds1_anc_in : ds1_st352_out;
        ds2_anc <= use_anc_in ? ds2_anc_in : ds2_st352_out;
    end

//
// Generate EAV and SAV timing signals from input data
//
v_smpte_uhdsdi_v1_0_5_tx_trsgen TRS (
    .clk        (clk),
    .ce         (ce),
    .din_rdy    (1'b1),
    .video      (ds1_anc),
    .eav        (eav),
    .sav        (sav));

//
// EAV delay register
//
// Generates timing control signals for line number insertion and CRC generation
// and insertion.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst) 
            eav_dly <= 0;
        else if (ce)
            eav_dly <= {eav_dly[2:0], eav};
    end

//
// Line number formatting and insertion modules
//
v_smpte_uhdsdi_v1_0_5_tx_insert_ln INSLN (
    .insert_ln  (insert_ln),
    .ln_word0   (eav_dly[0]),
    .ln_word1   (eav_dly[1]),
    .c_in       (ds2_anc),
    .y_in       (ds1_anc),
    .ln         (line),
    .c_out      (ds2_ln_out),
    .y_out      (ds1_ln_out));
        
//
// Generate timing control signals for the CRC calculators.
//
// The crc_en signal determines which words are included into the CRC 
// calculation. All words that enter the hdsdi_crc module when crc_en is high
// are included in the calculation. To meet the HD-SDI spec, the CRC calculation
// must being with the first word after the SAV and end after the second line
// number word after the EAV.
//
// The clr_crc signal clears the internal registers of the hdsdi_crc modules to
// cause a new CRC calculation to begin. The crc_en signal is asserted during
// the XYZ word of the SAV since the next word after the SAV XYZ word is the
// first word to be included into the new CRC calculation.
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            crc_en <= 1'b0;
        else if (ce)
            begin
                if (sav)
                    crc_en <= 1'b1;
                else if (eav_dly[1])
                    crc_en <= 1'b0;
            end
    end

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            clr_crc <= 1'b0;
        else if (ce)
            clr_crc <= sav;
    end

//
// Instantiate the CRC generators
//
v_smpte_uhdsdi_v1_0_5_crc2 CRC1 (
    .clk        (clk),
    .ce         (ce),
    .en         (crc_en),
    .rst        (rst),
    .clr        (clr_crc),
    .d          (ds1_ln_out),
    .crc_out    (ds1_crc)
);

v_smpte_uhdsdi_v1_0_5_crc2 CRC2 (
    .clk        (clk),
    .ce         (ce),
    .en         (crc_en),
    .rst        (rst),
    .clr        (clr_crc),
    .d          (ds2_ln_out),
    .crc_out    (ds2_crc)
);

//
// Insert the CRC values into the data streams. The CRC values are inserted
// after the line number words after the EAV.
//
v_smpte_uhdsdi_v1_0_5_tx_insert_crc INSCRC (
    .insert_crc (insert_crc),
    .crc_word0  (eav_dly[2]),
    .crc_word1  (eav_dly[3]),
    .y_in       (ds1_ln_out),
    .c_in       (ds2_ln_out),
    .y_crc      (ds1_crc),
    .c_crc      (ds2_crc),
    .y_out      (ds1_crc_out),
    .c_out      (ds2_crc_out));

always @ (posedge clk)
    if (ce)
    begin
        ds1_out <= ds1_crc_out;
        ds2_out <= ds2_crc_out;
    end

endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/*
Module Description:

This modules implements a SMPTE SDI scrambler. It operates in 10-bit mode for
SD-SDI, with the active bits on [19:10] of the input and output ports, 20-bit
mode for HD-SDI and 3G-SDI, and 40-bit mode for 6G-SDI and 12G-SDI. 
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_tx_encoder (
    input  wire         clk,        // input clock
    input  wire         ce,         // input register load signal
    input  wire [2:0]   mode,       // 000=HD, 001=SD, 010=3G, 100=6G, 101=12G
    input  wire         nrzi,       // enables NRZ-to-NRZI conversion when high
    input  wire         scram,      // enables SDI scrambler when high
    input  wire [39:0]  d,          // input data port
    output wire [39:0]  q           // output data port
);


//
// Signal definitions
//
reg     [39:0]      in_reg = 40'b0;     // C channel input register
reg     [2:0]       mode_reg = 3'b0;    // SDI mode input register
reg                 scram_reg = 1'b1;
reg                 nrzi_reg = 1'b1;
wire    [8:0]       u0_i_scram;         // intermediate scrambled data from scrambler 0
wire    [8:0]       u1_i_scram;         // intermediate scrambled data from scrambler 1
wire    [8:0]       u2_i_scram;         // intermediate scrambled data from scrambler 2
wire                u0_i_nrzi;          // intermediate nrzi data from scrambler 0
wire                u1_i_nrzi;          // intermediate nrzi data from scrambler 1
wire                u2_i_nrzi;          // intermediate nrzi data from scrambler 2
wire    [8:0]       u1_i_scram_q;       // registered intermediate scrambled data from scrambler 1
wire    [8:0]       u3_i_scram_q;       // registered intermediate scrambled data from scrambler 3
wire    [39:0]      scram_out;          // output of scrambler
wire    [8:0]       u0_p_scram_mux;     // p_scram input MUX for scrambler 0
wire                u0_p_nrzi_mux;      // p_nrzi input MUX for scrambler 0
wire    [8:0]       u1_p_scram_mux;     // p_scram input MUX for scrambler 1
wire                u1_p_nrzi_mux;      // p_nrzi input MUX for scrambler 1
wire                mode_40b;
wire                mode_SD;

//
// Input registers
//
always @ (posedge clk)
    if (ce)
    begin
        in_reg <= d;
        mode_reg <= mode;
        scram_reg <= scram;
        nrzi_reg <= nrzi;
    end

assign mode_SD = mode_reg == 3'b001;
assign mode_40b = mode_reg[2];

//
// Scrambler modules
//
assign u0_p_scram_mux = mode_40b ? u3_i_scram_q : u1_i_scram_q;
assign u0_p_nrzi_mux  = mode_40b ? scram_out[39] : scram_out[19];

v_smpte_uhdsdi_v1_0_5_tx_scrambler SCRAM0 (
    .clk        (clk),
    .ce         (ce),
    .nrzi       (nrzi_reg),
    .scram      (scram_reg),
    .d          (in_reg[9:0]),
    .p_scram    (u0_p_scram_mux),
    .p_nrzi     (u0_p_nrzi_mux),
    .q          (scram_out[9:0]),
    .i_scram    (u0_i_scram),
    .i_scram_q  (),
    .i_nrzi     (u0_i_nrzi)
);

assign u1_p_scram_mux = mode_SD ? u1_i_scram_q : u0_i_scram;
assign u1_p_nrzi_mux  = mode_SD ? scram_out[19] : u0_i_nrzi;

v_smpte_uhdsdi_v1_0_5_tx_scrambler SCRAM1 (
    .clk        (clk),
    .ce         (ce),
    .nrzi       (nrzi_reg),
    .scram      (scram_reg),
    .d          (in_reg[19:10]),
    .p_scram    (u1_p_scram_mux),
    .p_nrzi     (u1_p_nrzi_mux),
    .q          (scram_out[19:10]),
    .i_scram    (u1_i_scram),
    .i_scram_q  (u1_i_scram_q),
    .i_nrzi     (u1_i_nrzi)
);

v_smpte_uhdsdi_v1_0_5_tx_scrambler SCRAM2 (
    .clk        (clk),
    .ce         (ce & mode_40b),
    .nrzi       (nrzi_reg),
    .scram      (scram_reg),
    .d          (in_reg[29:20]),
    .p_scram    (u1_i_scram),
    .p_nrzi     (u1_i_nrzi),
    .q          (scram_out[29:20]),
    .i_scram    (u2_i_scram),
    .i_scram_q  (),
    .i_nrzi     (u2_i_nrzi)
);

v_smpte_uhdsdi_v1_0_5_tx_scrambler SCRAM3 (
    .clk        (clk),
    .ce         (ce & mode_40b),
    .nrzi       (nrzi_reg),
    .scram      (scram_reg),
    .d          (in_reg[39:30]),
    .p_scram    (u2_i_scram),
    .p_nrzi     (u2_i_nrzi),
    .q          (scram_out[39:30]),
    .i_scram    (),
    .i_scram_q  (u3_i_scram_q),
    .i_nrzi     ()
);

assign q = scram_out;

endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/*
This formats the 18-bit CRC values for each channel into two 10-bit video words
and inserts them into the appropriate places immediately after the line number
words in the EAV.

An 18-bit CRC value is formatted into two 10-bit words that are inserted after
the EAV and line number words. The format of the CRC words is shown below:
 
         b9     b8     b7     b6     b5     b4     b3     b2     b1     b0
      +------+------+------+------+------+------+------+------+------+------+
CRC0: |~crc8 | crc8 | crc7 | crc6 | crc5 | crc4 | crc3 | crc2 | crc1 | crc0 |
      +------+------+------+------+------+------+------+------+------+------+
CRC1: |~crc17| crc16| crc15| crc14| crc13| crc12| crc11| crc10| crc9 | crc8 |
      +------+------+------+------+------+------+------+------+------+------+

This module is purely combinatorial and contains no clocked registers.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_tx_insert_crc (
    input  wire         insert_crc, // CRC values will be inserted when this input is high
    input  wire         crc_word0,  // input asserted during time for first CRC word in EAV 
    input  wire         crc_word1,  // input asserted during time for second CRC word in EAV
    input  wire [9:0]   c_in,       // C channel video input
    input  wire [9:0]   y_in,       // Y channel video input
    input  wire [17:0]  c_crc,      // C channel CRC value input
    input  wire [17:0]  y_crc,      // Y channel CRC value input
    output reg  [9:0]   c_out,      // C channel video output
    output reg  [9:0]   y_out       // Y channel video output
);

always @ (*)
    if (insert_crc & crc_word0)
        c_out = {~c_crc[8], c_crc[8:0]};
    else if (insert_crc & crc_word1)
        c_out = {~c_crc[17], c_crc[17:9]};
    else
        c_out = c_in;

always @ (*)
    if (insert_crc & crc_word0)
        y_out = {~y_crc[8], y_crc[8:0]};
    else if (insert_crc & crc_word1)
        y_out = {~y_crc[17], y_crc[17:9]};
    else
        y_out = y_in;

endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/*
This module formats the 11-bit line number value into two 10-bit words and 
inserts them into their proper places immediately after the EAV word. The
insert_ln input can disable the insertion of line numbers. The same line
number value is inserted into both video channels. 

In the SMPTE SDI standards, the 11-bit line numbers must be formatted into two
10-bit words with the format of each word as follows:

        b9    b8    b7    b6    b5    b4    b3    b2    b1    b0
     +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
LN0: | ~ln6| ln6 | ln5 | ln4 | ln3 | ln2 | ln1 | ln0 |  0  |  0  |
     +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
LN1: |  1  |  0  |  0  |  0  | ln10| ln9 | ln8 | ln7 |  0  |  0  |
     +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
      

This module is purely combinatorial and has no clocked registers.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_tx_insert_ln (
input  wire             insert_ln,      // enables insertion of line numbers when high
input  wire             ln_word0,       // asserted during first word of line number
input  wire             ln_word1,       // asserted during second word of line number
input  wire [9:0]       c_in,           // C channel video input
input  wire [9:0]       y_in,           // Y channel video input
input  wire [10:0]      ln,             // 11-bit line number input
output reg  [9:0]       c_out,          // C channel video output
output reg  [9:0]       y_out           // Y channel video output
);

always @ (*)
    if (insert_ln & ln_word0)
        c_out = {~ln[6], ln[6:0], 2'b00};
    else if (insert_ln & ln_word1)
        c_out = {4'b1000, ln[10:7], 2'b00};
    else
        c_out = c_in;

always @ (*)
    if (insert_ln & ln_word0)
        y_out = {~ln[6], ln[6:0], 2'b00};
    else if (insert_ln & ln_word1)
        y_out = {4'b1000, ln[10:7], 2'b00};
    else
        y_out = y_in;

endmodule



// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/*
Module Description:

This module implements the various multiplexing modes for the SDI transmitter.
Five different multiplexing patterns are supported. The pattern used is selected
by the pattern input port.

Pattern 000: SD-SDI, HD-SDI, and 3G-SDI level A
Pattern 001: 3G-SDI level B 
Pattern 010: 6G-SDI SL mode 1, 6G-SDI QL mode 1, 12G-SDI SL mode 1 & 2, 12G-SDI DL mode 2 & 3
Pattern 011: 6G-SDI SL modes 2 & 3, 6G-SDI DL modes 1 & 2, 6G-SDI QL modes 2 & 3
Pattern 100: 12G-SDI DL mode 1

Pattern 000 requires ce to be asserted all of the time. ds1 passes straight through
to output bits [19:10] and ds2 passes through to output bits [9:0].

Pattern 001 requires ce to be asserted with a 50% duty cycle. When ce is low,
{ds2, ds4} is output. When ce is high, {ds1, ds3} is output.

Pattern 010 requires ce to be asserted with a 50% duty cycle. When ce is low,
{ds2, ds6, ds4, ds8} is output. When ce is high, {ds1, ds5, ds3, ds7} is output.

Pattern 011 requires ce to be asserted all of the time. The output is
{ds1, ds3, ds2, ds4}.

Pattern 100 requires ce to be asserted 25% of the time. After the rising edge
of the clock in which ce is asserted, the output will be {ds4, ds12, ds8, ds16}.
The next clock cycle the output will be {ds2, ds10, ds6, ds14}. The next clock
cycle the output will be {ds3, ds11, ds7, ds15}. And in the fourth and final
clock cycle, the output is {ds1, ds9, ds5, ds13}.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_tx_mux (
input   wire        clk,        // input clock
input   wire        ce,         // input register load signal
input   wire [2:0]  pattern,    // select the multiplex pattern
input   wire [9:0]  ds1,
input   wire [9:0]  ds2,
input   wire [9:0]  ds3,
input   wire [9:0]  ds4,
input   wire [9:0]  ds5,
input   wire [9:0]  ds6,
input   wire [9:0]  ds7,
input   wire [9:0]  ds8,
input   wire [9:0]  ds9,
input   wire [9:0]  ds10,
input   wire [9:0]  ds11,
input   wire [9:0]  ds12,
input   wire [9:0]  ds13,
input   wire [9:0]  ds14,
input   wire [9:0]  ds15,
input   wire [9:0]  ds16,
output  reg  [39:0] dout = 40'b0

);

//
// Signal definitions
//
reg     [2:0]       pat_reg = 3'b000;
reg     [3:0]       seqnce = 4'b0000;
reg     [39:0]      mux_out;

always @ (posedge clk)
    if (ce)
        pat_reg <= pattern;

//
// Generate the mux control pattern based on the pat_reg value and the assertion
// of ce.
//
always @ (posedge clk)
    if (pat_reg == 3'b000 || pat_reg == 3'b011)
        seqnce <= 4'b1111;
    else if ((pat_reg == 3'b001 || pat_reg == 3'b010) & ce)
        seqnce <= 4'b0101;
    else if ((pat_reg == 3'b100) & ce)
        seqnce <= 4'b0001;
    else
        seqnce <= {seqnce[2:0], seqnce[3]};

//
// Mux logic
//
always @ (*)
    case(pat_reg)
        3'b001:     mux_out = seqnce[1] ? {20'b0, ds1, ds3} : {20'b0, ds2, ds4};
        3'b010:     mux_out = seqnce[3] ? {ds1, ds5, ds3, ds7} : {ds2, ds6, ds4, ds8};
        3'b011:     mux_out = {ds1, ds3, ds2, ds4};
        3'b100:     mux_out = seqnce[0] ? {ds4, ds12, ds8, ds16} : 
                              seqnce[1] ? {ds2, ds10, ds6, ds14} :
                              seqnce[2] ? {ds3, ds11, ds7, ds15} :
                                            {ds1, ds9,  ds5, ds13};
        default:    mux_out = {20'b0, ds1, ds2};
    endcase

//
// Output register
//
always @ (posedge clk)
    dout <= mux_out;

endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/*
Module Description:

This is the output module for the SDI transmitter. It contains the multiplexer,
the scrambler, and the SD-SDI bit replicator.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_tx_output (
    input  wire             clk,                // 74.25 MHz (HD) or 148.5 MHz (SD/3G)
    input  wire             ce,                 // data stream mux clock enable
    input  wire             sd_ce,              // SD-SDI clock enable, must be High in all other modes
    input  wire             rst,                // sync reset input
    input  wire [2:0]       mode,               // data path mode: 00 = HD or 3GA, 01 = SD, 10 = 3GB
    input  wire [2:0]       mux_pattern,        // specifies the multiplex interleave pattern
    input  wire [9:0]       ds1,                // SD Y/C input, HD Y input, 3G Y input, dual link A_Y input
    input  wire             insert_sync_bit,    // 1 enables the 6G/12G sync bit insertion function
    input  wire [9:0]       ds2,                // C
    input  wire [9:0]       ds3,                // Y
    input  wire [9:0]       ds4,                // C
    input  wire [9:0]       ds5,                // Y
    input  wire [9:0]       ds6,                // C
    input  wire [9:0]       ds7,                // Y
    input  wire [9:0]       ds8,                // C
    input  wire [9:0]       ds9,                // Y
    input  wire [9:0]       ds10,               // C
    input  wire [9:0]       ds11,               // Y
    input  wire [9:0]       ds12,               // C
    input  wire [9:0]       ds13,               // Y
    input  wire [9:0]       ds14,               // C
    input  wire [9:0]       ds15,               // Y
    input  wire [9:0]       ds16,               // C
    input  wire             sd_bitrep_bypass,   // 1 bypasses the SD-SDI 11X bit replicator
    output wire [39:0]      txdata,             // output data stream
    output wire             ce_align_err);      // 1 if ce 5/6/5/6 cadence is broken


//
// Internal signals
//
wire [39:0]     mux_out;
wire [39:0]     sync_insert_out;
wire [39:0]     sync_insert_mux;
wire [39:0]     scram_out;
wire [19:0]     sd_bit_rep_out;             // output of SD 11X bit replicate
reg  [39:0]     txdata_reg = 40'b0;
wire            align_err;
wire            mode_SD;

//
// SDI data stream MUX
//
v_smpte_uhdsdi_v1_0_5_tx_mux DSMUX (
    .clk        (clk),
    .ce         (ce),
    .pattern    (mux_pattern),
    .ds1        (ds1),
    .ds2        (ds2),
    .ds3        (ds3),
    .ds4        (ds4),
    .ds5        (ds5),
    .ds6        (ds6),
    .ds7        (ds7),
    .ds8        (ds8),
    .ds9        (ds9),
    .ds10       (ds10),
    .ds11       (ds11),
    .ds12       (ds12),
    .ds13       (ds13),
    .ds14       (ds14),
    .ds15       (ds15),
    .ds16       (ds16),
    .dout       (mux_out));


//
// This is the syncbit insertion module that replaces 3FF words with 3FD and
// 000 words with 002. This only operates in 6G and 12G modes.
//
v_smpte_uhdsdi_v1_0_5_tx_syncbit_insert SBINS (
    .clk        (clk),
    .enable     (insert_sync_bit),
    .din        (mux_out),
    .dout       (sync_insert_out));

assign sync_insert_mux = (mode[2] & insert_sync_bit) ? sync_insert_out : mux_out;

//
// SDI scrambler
//
v_smpte_uhdsdi_v1_0_5_tx_encoder SCRAM (
    .clk        (clk),
    .ce         (sd_ce),
    .mode       (mode),
    .nrzi       (1'b1),
    .scram      (1'b1),
    .d          (sync_insert_mux),
    .q          (scram_out)); 

//
// SD-SDI 11X bit replicater
//
v_smpte_uhdsdi_v1_0_5_tx_bitrep_20b BITREP (
    .clk        (clk),
    .rst        (rst),
    .ce         (sd_ce),
    .d          (scram_out[19:10]),
    .q          (sd_bit_rep_out),
    .align_err  (align_err));

assign mode_SD = mode == 3'b001;
assign ce_align_err = align_err & mode_SD;

//
// Output register
//
always @ (posedge clk)
    if (mode_SD & ~sd_bitrep_bypass)
        txdata_reg <= sd_bit_rep_out;
    else
        txdata_reg <= scram_out;

assign txdata = txdata_reg;

endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/*
Module Description:

This module performs the SMPTE scrambling and NRZ-to-NRZI conversion algorithms
on 10-bit video words. It is designed to support both SDI (SMPTE 259M) and
HD-SDI (SMPTE 292M) standards.

When scrambling HD-SDI video, two of these modules can be used to encode the
two video channels Y and C. Each module would run at the word rate (74.25 MHz)
and accept one video in and generate one scrambled data word out per clock cycle.
It is also possible to use just one of these modules to scramble both data
channels by running the module a 2X the video rate.

When encoding SD-SDI video, one module is used and data is scramble one word
per clock cycle.

The module has two clock cycles of latency. It accepts one 10-bit word every
clock cycle and also produces 10-bits of scrambled data every clock cycle.

One clock cycle is used to scramble the data using the SMPTE X^9 + X^4 + 1
polynomial. During the second clock cycles, the scrambled data is converted to
NRZI data using the X + 1 polynomial.

Both the scrambling and NRZ-to-NRZI conversion have separate enable inputs. The
scram input enables scrambling when High. The nrzi input enables NRZ-to-NRZI
conversion when high.

The p_scram input vector provides 9 bits of data that was scrambled by the
during the previous clock cycle or by the other channel's scrambler module.  
When implementing a HD-SDI scrambler, the p_scram input of the C scrambler 
module  must be connected to the i_scram_q output of the Y module and the 
p_scram input  of the Y scrambler module must be connected to the i_scram 
output of the C  module. For SD-SDI or for HD-SDI when running this module at 2X
the HD-SDI word rate, the p_scram input must be connected to the i_scram_q
output of this same  module.

The p_nrzi input provides one bit of data that was converted to NRZI by the
companion hdsdi_scram_lower module. When implementing a HD-SDI scrambler, the 
p_nrzi input of the C scrambler module must be connected to the q[9] bit from 
the Y module and the p_nrzi input of the Y scrambler module must be connected to
the i_nrzi output of the C module. For SD-SDI or for HD-SDI when running this
module at 2X the HD-SDI word rate, the p_nrzi input must be connected to the 
q[9] output bit of this same module.

--------------------------------------------------------------------------------
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_tx_scrambler (
    input  wire         clk,        // input clock (bit-rate)
    input  wire         ce,         // clock enable
    input  wire         nrzi,       // enables NRZ-to-NRZI conversion when high
    input  wire         scram,      // enables SDI scrambler when high
    input  wire [9:0]   d,          // input data
    input  wire [8:0]   p_scram,    // previously scrambled data input 
    input  wire         p_nrzi,     // MSB of previously converted NRZI word
    output wire [9:0]   q,          // output data
    output wire [8:0]   i_scram,    // intermediate scrambled data output
    output wire [8:0]   i_scram_q,  // registered intermediate scrambled data output
    output wire         i_nrzi      // intermediate nrzi data output
);

//
// Signal definitions
//
reg     [9:0]       scram_reg = 0;  // pipeline delay register
reg     [9:0]       out_reg = 0;    // output register
wire    [13:0]      scram_in;       // input to the scrambler
reg     [9:0]       scram_temp;     // intermediate output of the scrambler
wire    [9:0]       scram_out;      // output of the scrambler
wire    [9:0]       nrzi_out;       // output of NRZ-to-NRZI converter
reg     [9:0]       nrzi_temp;      // intermediate output of the NRZ-to-NRZI converter
integer             i, j;           // for loop variables

//
// Scrambler
//
// This block of logic implements the SDI scrambler algorithm. The scrambler
// uses the 10 incoming bits from the input port and a 14-bit vector called 
// scram_in. scram_in is made up of 9 bits that were scrambled in the previous 
// clock cycle (p_scram) and the 5 LS scrambled bits that have been generated 
// during the current clock cycle. The results of the scrambler are assigned to 
// scram_temp.
//
// A MUX will output either the value of scram_temp or the d input word
// depending on the scram enable input. The output of the MUX is stored in the
// scram_reg.
//
assign scram_in = {scram_temp[4:0], p_scram[8:0]};

always @ (*)
    for (i = 0; i < 10; i = i + 1)
        scram_temp[i] <= d[i] ^ scram_in[i] ^ scram_in[i + 4];

assign scram_out = scram ? scram_temp : d;

always @ (posedge clk)
    if (ce)
        scram_reg <= scram_out;

//
// NRZ-to-NRZI converter
//
// This block of logic implements the NRZ-to-NRZI conversion. It operates on the
// 10 bits coming from the scram_reg and the MSB from the output of the NRZ-to
// NRZI conversion done on the previous word (p_nrzi).. A MUX bypasses the 
// conversion process if the nrzi input is low.
//
always @ (*)
    begin
        nrzi_temp[0] <= p_nrzi ^ scram_reg[0];
        for (j = 1; j < 10; j = j + 1)
            nrzi_temp[j] <= nrzi_out[j - 1] ^ scram_reg[j];
    end

assign nrzi_out = nrzi ? nrzi_temp : scram_reg;

//
// out_reg: Output register
//
always @ (posedge clk)
    if (ce)
        out_reg <= nrzi_out;

//
// output assignments
//
assign q = out_reg;
assign i_scram = scram_temp[9:1];
assign i_scram_q = scram_reg[9:1];
assign i_nrzi = nrzi_temp[9];

endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/*
Module Description:

This module inserts SMPTE 352M video payload ID packets into a video stream.
The stream may be either HD or SD, as indicated by the hd_sd input signal.
The module will overwrite an existing VPID packet if the overwrite input
is asserted, otherwise if a VPID packet exists in the HANC space, it will
not be overwritten and a new packet will not be inserted.

The module does not create the user data words of the VPID packet. Those
are generated externally and enter the module on the byte1, byte2, byte3,
and byte4 ports.

The module requires an interface line number on its input. This line number
must be valid for the new line one clock cycle before the start of the
HANC space -- that is during the second CRC word following the EAV.

If the overwrite input is 1, this module will also deleted any VPID packets
that occur elsewhere in any HANC space. These packets will be marked as
deleted packets.

When the level_b input is 1, then the module works a little bit differently.
It will always overwrite the first data word of the VPID packet with the value
present on the byte1 input port, even if overwrite is 0. This is because
conversions from dual link to level B 3G-SDI require the first byte to be
modified. The checksum is recalculated and inserted.

This module is compliant with the 2007 revision of SMPTE 425M for inserting
SMPTE 352M VPID packets in level B streams.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_tx_st352_pid_insert (
    input  wire             clk,            // clock input
    input  wire             ce,             // clock enable
    input  wire             rst,            // sync reset input
    input  wire             hd_sd,          // 0 = HD, 1 = SD
    input  wire             level_b,        // 1 = SMPTE 425M Level B
    input  wire             enable,         // 0 = disable insertion
    input  wire             overwrite,      // 1 = overwrite existing packets
    input  wire [10:0]      line,           // current video line
    input  wire [10:0]      line_a,         // field 1 line for packet insertion
    input  wire [10:0]      line_b,         // field 2 line for packet insertion
    input  wire             line_b_en,      // 1 = use line_b, 0 = ignore line_b
    input  wire [7:0]       byte1,          // first byte of VPID data
    input  wire [7:0]       byte2,          // second byte of VPID data
    input  wire [7:0]       byte3,          // third byte of VPID data
    input  wire [7:0]       byte4,          // fourth byte of VPID data
    input  wire [9:0]       y_in,           // Y data stream in
    input  wire [9:0]       c_in,           // C data stream in
    output reg  [9:0]       y_out = 0,      // Y data stream out
    output reg  [9:0]       c_out = 0,      // C data stream out
    output reg              eav_out = 0,    // asserted on XYZ word of EAV
    output reg              sav_out = 0     // asserted on XYZ word of SAV
);

localparam STATE_WIDTH   = 6;
localparam STATE_MSB     = STATE_WIDTH - 1;

localparam [STATE_WIDTH-1:0]
    STATE_WAIT      = 6'd0,
    STATE_ADF0      = 6'd1,
    STATE_ADF1      = 6'd2,
    STATE_ADF2      = 6'd3,
    STATE_DID       = 6'd4,
    STATE_SDID      = 6'd5,
    STATE_DC        = 6'd6,
    STATE_B0        = 6'd7,
    STATE_B1        = 6'd8,
    STATE_B2        = 6'd9,
    STATE_B3        = 6'd10,
    STATE_CS        = 6'd11,
    STATE_DID2      = 6'd12,
    STATE_SDID2     = 6'd13,
    STATE_DC2       = 6'd14,
    STATE_UDW       = 6'd15,
    STATE_CS2       = 6'd16,
    STATE_INS_ADF0  = 6'd17,
    STATE_INS_ADF1  = 6'd18,
    STATE_INS_ADF2  = 6'd19,
    STATE_INS_DID   = 6'd20,
    STATE_INS_SDID  = 6'd21,
    STATE_INS_DC    = 6'd22,
    STATE_INS_B0    = 6'd23,
    STATE_INS_B1    = 6'd24,
    STATE_INS_B2    = 6'd25,
    STATE_INS_B3    = 6'd26,
    STATE_ADF0_X    = 6'd27,
    STATE_ADF1_X    = 6'd28,
    STATE_ADF2_X    = 6'd29,
    STATE_DID_X     = 6'd30,
    STATE_SDID_X    = 6'd31,
    STATE_DC_X      = 6'd32,
    STATE_UDW_X     = 6'd33,
    STATE_CS_X      = 6'd34;
        
localparam [3:0]
    MUX_SEL_000     = 4'd0,
    MUX_SEL_3FF     = 4'd1,
    MUX_SEL_DID     = 4'd2,
    MUX_SEL_SDID    = 4'd3,
    MUX_SEL_DC      = 4'd4,
    MUX_SEL_UDW     = 4'd5,
    MUX_SEL_CS      = 4'd6,
    MUX_SEL_DEL     = 4'd7,
    MUX_SEL_VID     = 4'd8;

// internal signals
reg     [9:0]   vid_reg0 = 0;           // video pipeline register
reg     [9:0]   vid_reg1 = 0;           // video pipeline register
reg     [9:0]   vid_reg2 = 0;           // video pipeline register
reg     [9:0]   vid_dly = 0;            // last stage of video pipeline
wire            all_ones_in;            // asserted when in_reg is all ones
wire            all_zeros_in;           // asserted when in_reg is all zeros
reg     [2:0]   all_zeros_pipe = 0;     // delay pipe for all zeros
reg     [2:0]   all_ones_pipe = 0;      // delay pipe for all ones
wire            xyz;                    // current word is the XYZ word
wire            eav_next;               // 1 = next word is first word of EAV
wire            sav_next;               // 1 = next word is first word of SAV
wire            anc_next;               // 1 = next word is first word of ANC
wire            hanc_start_next;        // 1 = next word is first word of HANC
reg     [3:0]   hanc_dly;               // delay value from xyz to hanc_start_next
reg     [15:0]  hanc_dly_srl = 0;       // SRL reg used to generate hanc_start_next
reg     [9:0]   in_reg = 0;             // input register
reg     [9:0]   vid_out = 0;            // internal version of y_out
wire            line_match_a;           // output of line_a comparitor
wire            line_match_b;           // output of line_b comparitor
reg             vpid_line = 0;          // 1 = insert VPID packet on this line
wire            vpid_pkt;               // 1 = ANC packet is a VPID
wire            del_pkt_ok;             // 1 = ANC act is deleted packet with
reg     [7:0]   udw_cntr = 0;           // user data word counter
wire    [7:0]   udw_cntr_mux;           // mux on input of udw_cntr
reg             ld_udw_cntr;            // 1 = load udw_cntr
wire            udw_cntr_tc;            // 1 = udw_cntr == 0
reg     [8:0]   cs_reg = 0;             // checksum generation register
reg             clr_cs_reg;             // 1 = clear cs_reg to 0
reg     [7:0]   vpid_mux;               // selects the VPID byte to be output 
reg     [1:0]   vpid_mux_sel;           // controls vpid_mux
reg     [3:0]   out_mux_sel;            // controls the vid_out data mux
wire            parity;                 // parity calculation
reg     [3:0]   sav_timing = 0;         // shift register for generating sav_out
reg     [3:0]   eav_timing = 0;         // shift register for generating eav_out
reg     [9:0]   cdly0 = 0;
reg     [9:0]   cdly1 = 0;
reg     [9:0]   cdly2 = 0;
reg     [9:0]   cdly3 = 0;
reg     [9:0]   cdly4 = 0;

reg     [STATE_MSB:0]   current_state = STATE_WAIT;     // FSM current state
reg     [STATE_MSB:0]   next_state;                     // FSM next state

reg     [7:0]   byte1_reg = 0;
reg     [7:0]   byte2_reg = 0;
reg     [7:0]   byte3_reg = 0;
reg     [7:0]   byte4_reg = 0;

//
// Input registers and video pipeline registers
//
always @ (posedge clk)
    if (ce) begin
        in_reg    <= y_in;
        vid_reg0  <= in_reg;
        vid_reg1  <= vid_reg0;
        vid_reg2  <= vid_reg1;
        vid_dly   <= vid_reg2;
        byte1_reg <= byte1;
        byte2_reg <= byte2;
        byte3_reg <= byte3;
        byte4_reg <= byte4;
    end

//
// all ones and all zeros detectors
//
assign all_ones_in = &in_reg;
assign all_zeros_in = ~|in_reg;

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            all_zeros_pipe <= 0;
        else
            all_zeros_pipe <= {all_zeros_pipe[1:0], all_zeros_in};
    end

always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            all_ones_pipe <= 0;
        else
            all_ones_pipe <= {all_ones_pipe[1:0], all_ones_in};
    end

//
// EAV, SAV, and ADF detection
//
assign xyz = all_ones_pipe[2] & all_zeros_pipe[1] & all_zeros_pipe[0];

assign eav_next = xyz & in_reg[6];
assign sav_next = xyz & ~in_reg[6];
assign anc_next = all_zeros_pipe[2] & all_ones_pipe[1] & all_ones_pipe[0];

//
// This SRL16 is used to generate the hanc_start_next signal. The input to the
// shift register is eav_next. The depth of the shift register depends on 
// whether the video is HD or SD.
//
always @ (*)
    if (hd_sd)
        hanc_dly = 4'd3;
    else
        hanc_dly = 4'd7;

always @ (posedge clk)
    if (ce)
        hanc_dly_srl <= {hanc_dly_srl[14:0], eav_next};
        
assign hanc_start_next = hanc_dly_srl[hanc_dly];         
         
//
// Line number comparison
//
// Two comparators are used to determine if the current line number matches
// either of the two lines where the VPID packets are located. The second
// line can be disabled for progressive video by setting line_b_en low.
//
assign line_match_a = line == line_a;
assign line_match_b = line == line_b;

always @ (posedge clk)
    if (ce)
        vpid_line <= line_match_a | (line_match_b & line_b_en);

//
// DID/SDID match
//
// The vpid_pkt signal is asserted when the next two words in the video delay
// pipeline indicate a video payload ID packet. The del_pkt_ok signal is
// asserted when the data in the video delay pipeline indicates that a deleted
// ANC packet is present with a data count of at least 4.
//
assign vpid_pkt = vid_reg2[7:0] == 8'h41 && vid_reg1[7:0] == 8'h01;
assign del_pkt_ok = vid_reg2[7:0] == 8'h80 && vid_reg0[7:0] >= 8'h04;

//
// UDW counter
//
// This counter is used to cycle through the user data words of non-VPID ANC 
// packets that may be encountered before empty HANC space is found.
//
assign udw_cntr_mux = ld_udw_cntr ? vid_dly[7:0] : udw_cntr;
assign udw_cntr_tc = udw_cntr_mux == 8'h00;

always @ (posedge clk)
    if (ce)
        udw_cntr <= udw_cntr_mux - 1;

//
// Checksum generation
//
always @ (posedge clk)
    if (ce) begin
        if (clr_cs_reg)
            cs_reg <= 0;
        else
            cs_reg <= cs_reg + vid_out[8:0];
    end

//
// Video data path
//
always @ (*)
    case(vpid_mux_sel)
        2'b00:   vpid_mux = byte1_reg;
        2'b01:   vpid_mux = byte2_reg;
        2'b10:   vpid_mux = byte3_reg;
        default: vpid_mux = byte4_reg;
    endcase

assign parity = ^vpid_mux;

always @ (*)
    case(out_mux_sel)
        MUX_SEL_000:  vid_out = 10'h000;
        MUX_SEL_3FF:  vid_out = 10'h3ff;
        MUX_SEL_DID:  vid_out = 10'h241;   // DID
        MUX_SEL_SDID: vid_out = 10'h101;   // SDID
        MUX_SEL_DC:   vid_out = 10'h104;   // DC
        MUX_SEL_UDW:  vid_out = {~parity, parity, vpid_mux};
        MUX_SEL_CS:   vid_out = {~cs_reg[8], cs_reg};
        MUX_SEL_DEL:  vid_out = 10'h180;   // deleted pkt DID
        default:      vid_out = vid_dly;
    endcase

always @ (posedge clk)
    if (ce)
        y_out <= vid_out;

//
// Delay the C data stream by 6 clock cycles to match the Y data stream delay.
//
always @ (posedge clk)
    if (ce)
    begin
        cdly0 <= c_in;
        cdly1 <= cdly0;
        cdly2 <= cdly1;
        cdly3 <= cdly2;
        cdly4 <= cdly3;
        c_out <= cdly4;
    end

//
// EAV & SAV output generation
//
always @ (posedge clk)
    if (ce)
        eav_timing <= {eav_timing[2:0], eav_next};
        
always @ (posedge clk)
    if (ce)
        eav_out <= eav_timing[3];

always @ (posedge clk)
    if (ce)
        sav_timing <= {sav_timing[2:0], sav_next};

always @ (posedge clk)
    if (ce)
        sav_out <= sav_timing[3];

//
// FSM: current_state register
//
// This code implements the current state register. 
//
always @ (posedge clk)
    if (ce)
    begin
        if (rst)
            current_state <= STATE_WAIT;
        else if (ce)
        begin
            if (sav_next)
                current_state <= STATE_WAIT;
            else
                current_state <= next_state;
        end
    end

//
// FSM: next_state logic
//
// This case statement generates the next_state value for the FSM based on
// the current_state and the various FSM inputs.
//
always @ (*)
    case(current_state)
        STATE_WAIT:
            if (enable & vpid_line & hanc_start_next) begin
                if (anc_next)
                    next_state = STATE_ADF0;
                else
                    next_state = STATE_INS_ADF0;
            end else if (enable & ~vpid_line & anc_next & overwrite)
                next_state = STATE_ADF0_X;
            else    
                next_state = STATE_WAIT;
                
        STATE_ADF0:
            next_state = STATE_ADF1;

        STATE_ADF1:
            next_state = STATE_ADF2;

        STATE_ADF2:
            if (vpid_pkt)
                next_state = STATE_DID;
            else if (del_pkt_ok)
                next_state = STATE_INS_DID;
            else
                next_state = STATE_DID2;

        STATE_DID:
            next_state = STATE_SDID;

        STATE_SDID:
            if (overwrite)
                next_state = STATE_INS_DC;
            else
                next_state = STATE_DC;

        STATE_DC:
            next_state = STATE_B0;

        STATE_B0:
            next_state = STATE_B1;

        STATE_B1:
            next_state = STATE_B2;

        STATE_B2:
            next_state = STATE_B3;

        STATE_B3:
            next_state = STATE_CS;

        STATE_CS:
            next_state = STATE_WAIT;

        STATE_DID2:
            next_state = STATE_SDID2;

        STATE_SDID2:
            next_state = STATE_DC2;

        STATE_DC2:
            if (udw_cntr_tc)
                next_state = STATE_CS2;
            else
                next_state = STATE_UDW;

        STATE_UDW:
            if (udw_cntr_tc)
                next_state = STATE_CS2;
            else
                next_state = STATE_UDW;

        STATE_CS2:
            if (anc_next)
                next_state = STATE_ADF0;
            else
                next_state = STATE_INS_ADF0;

        STATE_INS_ADF0:
            next_state = STATE_INS_ADF1;

        STATE_INS_ADF1:
            next_state = STATE_INS_ADF2;

        STATE_INS_ADF2:
            next_state = STATE_INS_DID;

        STATE_INS_DID:
            next_state = STATE_INS_SDID;

        STATE_INS_SDID:
            next_state = STATE_INS_DC;

        STATE_INS_DC:
            next_state = STATE_INS_B0;

        STATE_INS_B0:
            next_state = STATE_INS_B1;

        STATE_INS_B1:
            next_state = STATE_INS_B2;

        STATE_INS_B2:
            next_state = STATE_INS_B3;

        STATE_INS_B3:   
            next_state = STATE_CS;

        STATE_ADF0_X:
            next_state = STATE_ADF1_X;

        STATE_ADF1_X:
            next_state = STATE_ADF2_X;

        STATE_ADF2_X:
            if (vpid_pkt)
                next_state = STATE_DID_X;
            else
                next_state = STATE_WAIT;

        STATE_DID_X:
            next_state = STATE_SDID_X;

        STATE_SDID_X:
            next_state = STATE_DC_X;

        STATE_DC_X:
            if (udw_cntr_tc)
                next_state = STATE_CS_X;
            else
                next_state = STATE_UDW_X;

        STATE_UDW_X:
            if (udw_cntr_tc)
                next_state = STATE_CS_X;
            else
                next_state = STATE_UDW_X;

        STATE_CS_X:
            if (anc_next)
                next_state = STATE_ADF0_X;
            else
                next_state = STATE_WAIT;

        default:    next_state = STATE_WAIT;
    endcase
        
//
// FSM: outputs
//
// This block decodes the current state to generate the various outputs of the
// FSM.
//
always @ (*)
    begin
        // Unless specifically assigned in the case statement, all FSM outputs
        // are given the values assigned here.
        ld_udw_cntr     = 1'b0;
        clr_cs_reg      = 1'b0;
        vpid_mux_sel    = 2'b00;
        out_mux_sel     = MUX_SEL_VID;
                                
        case(current_state) 

            STATE_ADF2:     clr_cs_reg = 1'b1;

            STATE_B0:       begin
                                out_mux_sel = level_b ? MUX_SEL_UDW : MUX_SEL_VID;
                                vpid_mux_sel = 2'b00;
                            end
        
            STATE_CS:       out_mux_sel = MUX_SEL_CS;

            STATE_DC2:      ld_udw_cntr = 1'b1;

            STATE_INS_ADF0: out_mux_sel = MUX_SEL_000;

            STATE_INS_ADF1: out_mux_sel = MUX_SEL_3FF;

            STATE_INS_ADF2: begin
                                out_mux_sel = MUX_SEL_3FF;
                                clr_cs_reg = 1'b1;
                            end

            STATE_INS_DID:  out_mux_sel = MUX_SEL_DID;

            STATE_INS_SDID: out_mux_sel = MUX_SEL_SDID;

            STATE_INS_DC:   out_mux_sel = MUX_SEL_DC;

            STATE_INS_B0:   begin
                                out_mux_sel = MUX_SEL_UDW;
                                vpid_mux_sel = 2'b00;
                            end
        
            STATE_INS_B1:   begin
                                out_mux_sel = MUX_SEL_UDW;
                                vpid_mux_sel = 2'b01;
                            end
        
            STATE_INS_B2:   begin
                                out_mux_sel = MUX_SEL_UDW;
                                vpid_mux_sel = 2'b10;
                            end
        
            STATE_INS_B3:   begin
                                out_mux_sel = MUX_SEL_UDW;
                                vpid_mux_sel = 2'b11;
                            end

            STATE_ADF2_X:   clr_cs_reg = 1'b1;

            STATE_DID_X:    out_mux_sel = MUX_SEL_DEL;

            STATE_DC_X:     ld_udw_cntr = 1'b1;

            STATE_CS_X:     out_mux_sel = MUX_SEL_CS;

        endcase
    end

endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/*
Module Description:

This module implements the sync bit insertion algorithm required for 6G-SDI and
12G-SDI. Except for a core 3FF 000 000 sequence, all instances of 3FF are
replaced with 3FD and 000 replaced with 002.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_tx_syncbit_insert (
    input   wire        clk,        // input clock
    input   wire        enable,     // 1 enables the sync bit insert function
    input   wire [39:0] din,
    output  reg  [39:0] dout = 40'b0
);

//
// Signal definitions
//
reg     [39:0]      pipe0 = 40'b0;
reg     [39:0]      pipe1 = 40'b0;
reg     [39:0]      pipe2 = 40'b0;
reg                 all_ones = 1'b0;
wire                all_zeros;
reg                 core_trs_1s = 1'b0;
reg                 core_trs_0s = 1'b0;
wire                enable3;
wire                enable2;
wire                enable1;
wire    [39:0]      replace_out;
reg                 en_reg = 1'b0;

function   [9:0] replace;
    input  [9:0] din;
    input        enable;
begin
    if (enable)
    begin
        if (din == 10'h3ff)
            replace = 10'h3fd;
        else if (din == 10'h000)
            replace = 10'h002;
        else
            replace = din;
    end else
        replace = din;
end
endfunction

assign all_zeros = ~|pipe0;
assign enable3 = en_reg & ~core_trs_1s;
assign enable2 = en_reg;
assign enable1 = en_reg & ~core_trs_0s;
assign replace_out = {replace(pipe2[39:30], enable3), replace(pipe2[29:20], enable2), 
                      replace(pipe2[19:10], enable1), replace(pipe2[9:0], enable1)};

always @ (posedge clk)
begin
    en_reg <= enable;
    pipe0 <= din;
    pipe1 <= pipe0;
    pipe2 <= pipe1;
    all_ones <= &pipe0;
    core_trs_1s <= all_ones & all_zeros;
    core_trs_0s <= core_trs_1s;
    dout <= replace_out;
end

endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------ 
/*
Module Description:

This module generates the EAV and SAV timing signals required at the input of 
the SDI transmitter module. Up to four video data streams may pass through the
module. These data streams are delayed by the appropriate amount to match the
latency of the TRS generation logic.
*/
`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_tx_trsgen
(
    input  wire         clk,        // sample rate clock
    input  wire         ce,         // clock enable input
    input  wire         din_rdy,    // data ready
    input  wire [9:0]   video,      // connect to video data stream
    output wire         eav,        // 1 during XYZ word of EAV
    output wire         sav         // 1 during XYZ word of SAV     
);

// Internal signals
reg     [1:0]           ones_reg = 2'b00;
reg                     zeros_reg = 1'b0;
wire                    zeros_in;
reg                     trs = 1'b0;

always @ (posedge clk)
    if (ce & din_rdy)
        ones_reg <= {ones_reg[0], &video};

assign zeros_in = ~|video;

always @ (posedge clk)
    if (ce & din_rdy)
        zeros_reg <= zeros_in;

always @ (posedge clk)
    if (ce & din_rdy)
        trs <= ones_reg[1] & zeros_reg & zeros_in;

assign eav = trs & video[6];
assign sav = trs & ~video[6];

endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/*
Module Description:

This module implements the SDI TX data path.
*/

`timescale 1ns / 1 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5_tx (
    input  wire             clk,                // txusrclk
    input  wire             ce,                 // clock enable
    input  wire             sd_ce,              // SD-SDI clock enable, must be High in all other modes
    input  wire             edh_ce,             // EDH clock enable, recommended Low in all modes except SD-SDI
    input  wire             rst,                // sync reset input
    input  wire [2:0]       mode,               // SDI mode
    input  wire             insert_crc,         // 1 = insert CRC for HD and 3G
    input  wire             insert_ln,          // 1 = insert LN for HD and 3G
    input  wire             insert_st352,       // 1 = insert st352 PID packets
    input  wire             overwrite_st352,    // 1 = overwrite existing ST 352 packets
    input  wire             insert_edh,         // 1 = generate & insert EDH packets in SD-SDI mode
    input  wire [2:0]       mux_pattern,        // specifies the multiplex interleave pattern of data streams
    input  wire             insert_sync_bit,    // 1 enables sync bit insertion
    input  wire             sd_bitrep_bypass,   // 1 bypasses the SD-SDI 11X bit replicator
    input  wire [10:0]      line_ch0,           // current line number for channel 0
    input  wire [10:0]      line_ch1,           // current line number for channel 1
    input  wire [10:0]      line_ch2,           // current line number for channel 2
    input  wire [10:0]      line_ch3,           // current line number for channel 3
    input  wire [10:0]      line_ch4,           // current line number for channel 4
    input  wire [10:0]      line_ch5,           // current line number for channel 5
    input  wire [10:0]      line_ch6,           // current line number for channel 6
    input  wire [10:0]      line_ch7,           // current line number for channel 7
    input  wire [10:0]      st352_line_f1,      // line number in field 1 to insert ST 352
    input  wire [10:0]      st352_line_f2,      // line number in field 2 to insert ST 352
    input  wire             st352_f2_en,        // 1 = insert packets on st352_line_f2 line
    input  wire [31:0]      st352_data_ch0,     // ST352 data bytes for channel 0 {byte4, byte3, byte2, byte1} 
    input  wire [31:0]      st352_data_ch1,     // ST352 data bytes for channel 1 {byte4, byte3, byte2, byte1} 
    input  wire [31:0]      st352_data_ch2,     // ST352 data bytes for channel 2 {byte4, byte3, byte2, byte1} 
    input  wire [31:0]      st352_data_ch3,     // ST352 data bytes for channel 3 {byte4, byte3, byte2, byte1} 
    input  wire [31:0]      st352_data_ch4,     // ST352 data bytes for channel 4 {byte4, byte3, byte2, byte1} 
    input  wire [31:0]      st352_data_ch5,     // ST352 data bytes for channel 5 {byte4, byte3, byte2, byte1} 
    input  wire [31:0]      st352_data_ch6,     // ST352 data bytes for channel 6 {byte4, byte3, byte2, byte1} 
    input  wire [31:0]      st352_data_ch7,     // ST352 data bytes for channel 7 {byte4, byte3, byte2, byte1} 
    input  wire [9:0]       ds1_in,             // data stream 1 (Y) in
    input  wire [9:0]       ds2_in,             // data stream 2 (C) in -- not used in SD-SDI mode
    input  wire [9:0]       ds3_in,             // data stream 3 (Y) in
    input  wire [9:0]       ds4_in,             // data stream 4 (C) in
    input  wire [9:0]       ds5_in,             // data stream 5 (Y) in
    input  wire [9:0]       ds6_in,             // data stream 6 (C) in
    input  wire [9:0]       ds7_in,             // data stream 7 (Y) in
    input  wire [9:0]       ds8_in,             // data stream 8 (C) in
    input  wire [9:0]       ds9_in,             // data stream 9 (Y) in
    input  wire [9:0]       ds10_in,            // data stream 10 (C) in
    input  wire [9:0]       ds11_in,            // data stream 11 (Y) in
    input  wire [9:0]       ds12_in,            // data stream 12 (C) in
    input  wire [9:0]       ds13_in,            // data stream 13 (Y) in
    input  wire [9:0]       ds14_in,            // data stream 14 (C) in
    input  wire [9:0]       ds15_in,            // data stream 15 (Y) in
    input  wire [9:0]       ds16_in,            // data stream 16 (C) in
    output wire [9:0]       ds1_st352_out,      // data stream 1 after ST352 insertion
    output wire [9:0]       ds2_st352_out,      // data stream 2 after ST352 insertion
    output wire [9:0]       ds3_st352_out,      // data stream 3 after ST352 insertion
    output wire [9:0]       ds4_st352_out,      // data stream 4 after ST352 insertion
    output wire [9:0]       ds5_st352_out,      // data stream 5 after ST352 insertion
    output wire [9:0]       ds6_st352_out,      // data stream 6 after ST352 insertion
    output wire [9:0]       ds7_st352_out,      // data stream 7 after ST352 insertion
    output wire [9:0]       ds8_st352_out,      // data stream 8 after ST352 insertion
    output wire [9:0]       ds9_st352_out,      // data stream 9 after ST352 insertion
    output wire [9:0]       ds10_st352_out,     // data stream 10 after ST352 insertion
    output wire [9:0]       ds11_st352_out,     // data stream 11 after ST352 insertion
    output wire [9:0]       ds12_st352_out,     // data stream 12 after ST352 insertion
    output wire [9:0]       ds13_st352_out,     // data stream 13 after ST352 insertion
    output wire [9:0]       ds14_st352_out,     // data stream 14 after ST352 insertion
    output wire [9:0]       ds15_st352_out,     // data stream 15 after ST352 insertion
    output wire [9:0]       ds16_st352_out,     // data stream 16 after ST352 insertion
    input  wire [9:0]       ds1_anc_in,         // data stream 1 after ANC insertion input
    input  wire [9:0]       ds2_anc_in,         // data stream 2 after ANC insertion input
    input  wire [9:0]       ds3_anc_in,         // data stream 3 after ANC section input
    input  wire [9:0]       ds4_anc_in,         // data stream 4 after ANC section input
    input  wire [9:0]       ds5_anc_in,         // data stream 5 after ANC section input
    input  wire [9:0]       ds6_anc_in,         // data stream 6 after ANC section input
    input  wire [9:0]       ds7_anc_in,         // data stream 7 after ANC section input
    input  wire [9:0]       ds8_anc_in,         // data stream 8 after ANC section input
    input  wire [9:0]       ds9_anc_in,         // data stream 9 after ANC section input
    input  wire [9:0]       ds10_anc_in,        // data stream 10 after ANC section input
    input  wire [9:0]       ds11_anc_in,        // data stream 11 after ANC section input
    input  wire [9:0]       ds12_anc_in,        // data stream 12 after ANC section input
    input  wire [9:0]       ds13_anc_in,        // data stream 13 after ANC section input
    input  wire [9:0]       ds14_anc_in,        // data stream 14 after ANC section input
    input  wire [9:0]       ds15_anc_in,        // data stream 15 after ANC section input
    input  wire [9:0]       ds16_anc_in,        // data stream 16 after ANC section input
    input  wire             use_anc_in,         // use the dsX_anc_in ports
    output wire [39:0]      txdata,             // output data stream to GT TXDATA port
    output wire             ce_align_err        // 1 if ce 5/6/5/6 cadence is broken in SD-SDI mode
);

//
// Internal signals
//
reg             sd_mode = 1'b0;
wire [9:0]      ds1_ch_out;
wire [9:0]      ds2_ch_out;
wire [9:0]      ds3_ch_out;
wire [9:0]      ds4_ch_out;
wire [9:0]      ds5_ch_out;
wire [9:0]      ds6_ch_out;
wire [9:0]      ds7_ch_out;
wire [9:0]      ds8_ch_out;
wire [9:0]      ds9_ch_out;
wire [9:0]      ds10_ch_out;
wire [9:0]      ds11_ch_out;
wire [9:0]      ds12_ch_out;
wire [9:0]      ds13_ch_out;
wire [9:0]      ds14_ch_out;
wire [9:0]      ds15_ch_out;
wire [9:0]      ds16_ch_out;
wire [9:0]      edh_mux;
wire [9:0]      edh_out;
wire [9:0]      ch1_in_mux;
wire [10:0]     ch1_line_mux;
reg             mode_3ga = 1'b0;
wire [9:0]      ds2_ch_out_int;
wire [9:0]      ds2_st352_out_int;

always @ (posedge clk)
    if (ce)
        sd_mode <= mode == 3'b001;

always @ (posedge clk)
    if (ce)
        mode_3ga <= (mode == 3'b010) && (mux_pattern == 3'b000);

//
// UHD-SDI TX channels
//
v_smpte_uhdsdi_v1_0_5_tx_channel CH0 (
    .clk            (clk),
    .ce             (ce & sd_ce),
    .rst            (rst),
    .sd_mode        (sd_mode),
    .insert_crc     (insert_crc & ~sd_mode),
    .insert_ln      (insert_ln & ~sd_mode),
    .insert_st352   (insert_st352),
    .overwrite_st352(overwrite_st352),
    .line           (line_ch0),
    .st352_line_f1  (st352_line_f1),
    .st352_line_f2  (st352_line_f2),
    .st352_f2_en    (st352_f2_en),
    .st352_data     (st352_data_ch0),
    .ds1_in         (ds1_in),
    .ds2_in         (ds2_in),
    .ds1_st352_out  (ds1_st352_out),
    .ds2_st352_out  (ds2_st352_out_int),
    .ds1_anc_in     (ds1_anc_in),
    .ds2_anc_in     (ds2_anc_in),
    .use_anc_in     (use_anc_in),
    .ds1_out        (ds1_ch_out),
    .ds2_out        (ds2_ch_out_int));

//
// These muxes are used to route ds2 through the CH1 TX channel in 3G-SDI level A
// mode because ST352 packets need to be inserted into both ds1 and ds2 in 3G-SDI
// level A mode only.
//
assign ch1_in_mux = mode_3ga ? ds2_in : ds3_in;
assign ds2_ch_out = (mode_3ga & ~use_anc_in) ? ds3_ch_out : ds2_ch_out_int;
assign ds2_st352_out = mode_3ga ? ds3_st352_out : ds2_st352_out_int;
assign ch1_line_mux = mode_3ga ? line_ch0 : line_ch1;

v_smpte_uhdsdi_v1_0_5_tx_channel CH1 (
    .clk            (clk),
    .ce             (ce),
    .rst            (rst),
    .sd_mode        (sd_mode),
    .insert_crc     (insert_crc & ~sd_mode),
    .insert_ln      (insert_ln & ~sd_mode),
    .insert_st352   (insert_st352),
    .overwrite_st352(overwrite_st352),
    .line           (ch1_line_mux),
    .st352_line_f1  (st352_line_f1),
    .st352_line_f2  (st352_line_f2),
    .st352_f2_en    (st352_f2_en),
    .st352_data     (st352_data_ch1),
    .ds1_in         (ch1_in_mux),
    .ds2_in         (ds4_in),
    .ds1_st352_out  (ds3_st352_out),
    .ds2_st352_out  (ds4_st352_out),
    .ds1_anc_in     (ds3_anc_in),
    .ds2_anc_in     (ds4_anc_in),
    .use_anc_in     (use_anc_in),
    .ds1_out        (ds3_ch_out),
    .ds2_out        (ds4_ch_out));

v_smpte_uhdsdi_v1_0_5_tx_channel CH2 (
    .clk            (clk),
    .ce             (ce),
    .rst            (rst),
    .sd_mode        (sd_mode),
    .insert_crc     (insert_crc & ~sd_mode),
    .insert_ln      (insert_ln & ~sd_mode),
    .insert_st352   (insert_st352),
    .overwrite_st352(overwrite_st352),
    .line           (line_ch2),
    .st352_line_f1  (st352_line_f1),
    .st352_line_f2  (st352_line_f2),
    .st352_f2_en    (st352_f2_en),
    .st352_data     (st352_data_ch2),
    .ds1_in         (ds5_in),
    .ds2_in         (ds6_in),
    .ds1_st352_out  (ds5_st352_out),
    .ds2_st352_out  (ds6_st352_out),
    .ds1_anc_in     (ds5_anc_in),
    .ds2_anc_in     (ds6_anc_in),
    .use_anc_in     (use_anc_in),
    .ds1_out        (ds5_ch_out),
    .ds2_out        (ds6_ch_out));

v_smpte_uhdsdi_v1_0_5_tx_channel CH3 (
    .clk            (clk),
    .ce             (ce),
    .rst            (rst),
    .sd_mode        (sd_mode),
    .insert_crc     (insert_crc & ~sd_mode),
    .insert_ln      (insert_ln & ~sd_mode),
    .insert_st352   (insert_st352),
    .overwrite_st352(overwrite_st352),
    .line           (line_ch3),
    .st352_line_f1  (st352_line_f1),
    .st352_line_f2  (st352_line_f2),
    .st352_f2_en    (st352_f2_en),
    .st352_data     (st352_data_ch3),
    .ds1_in         (ds7_in),
    .ds2_in         (ds8_in),
    .ds1_st352_out  (ds7_st352_out),
    .ds2_st352_out  (ds8_st352_out),
    .ds1_anc_in     (ds7_anc_in),
    .ds2_anc_in     (ds8_anc_in),
    .use_anc_in     (use_anc_in),
    .ds1_out        (ds7_ch_out),
    .ds2_out        (ds8_ch_out));

v_smpte_uhdsdi_v1_0_5_tx_channel CH4 (
    .clk            (clk),
    .ce             (ce),
    .rst            (rst),
    .sd_mode        (sd_mode),
    .insert_crc     (insert_crc & ~sd_mode),
    .insert_ln      (insert_ln & ~sd_mode),
    .insert_st352   (insert_st352),
    .overwrite_st352(overwrite_st352),
    .line           (line_ch4),
    .st352_line_f1  (st352_line_f1),
    .st352_line_f2  (st352_line_f2),
    .st352_f2_en    (st352_f2_en),
    .st352_data     (st352_data_ch4),
    .ds1_in         (ds9_in),
    .ds2_in         (ds10_in),
    .ds1_st352_out  (ds9_st352_out),
    .ds2_st352_out  (ds10_st352_out),
    .ds1_anc_in     (ds9_anc_in),
    .ds2_anc_in     (ds10_anc_in),
    .use_anc_in     (use_anc_in),
    .ds1_out        (ds9_ch_out),
    .ds2_out        (ds10_ch_out));

v_smpte_uhdsdi_v1_0_5_tx_channel CH5 (
    .clk            (clk),
    .ce             (ce),
    .rst            (rst),
    .sd_mode        (sd_mode),
    .insert_crc     (insert_crc & ~sd_mode),
    .insert_ln      (insert_ln & ~sd_mode),
    .insert_st352   (insert_st352),
    .overwrite_st352(overwrite_st352),
    .line           (line_ch5),
    .st352_line_f1  (st352_line_f1),
    .st352_line_f2  (st352_line_f2),
    .st352_f2_en    (st352_f2_en),
    .st352_data     (st352_data_ch5),
    .ds1_in         (ds11_in),
    .ds2_in         (ds12_in),
    .ds1_st352_out  (ds11_st352_out),
    .ds2_st352_out  (ds12_st352_out),
    .ds1_anc_in     (ds11_anc_in),
    .ds2_anc_in     (ds12_anc_in),
    .use_anc_in     (use_anc_in),
    .ds1_out        (ds11_ch_out),
    .ds2_out        (ds12_ch_out));

v_smpte_uhdsdi_v1_0_5_tx_channel CH6 (
    .clk            (clk),
    .ce             (ce),
    .rst            (rst),
    .sd_mode        (sd_mode),
    .insert_crc     (insert_crc & ~sd_mode),
    .insert_ln      (insert_ln & ~sd_mode),
    .insert_st352   (insert_st352),
    .overwrite_st352(overwrite_st352),
    .line           (line_ch6),
    .st352_line_f1  (st352_line_f1),
    .st352_line_f2  (st352_line_f2),
    .st352_f2_en    (st352_f2_en),
    .st352_data     (st352_data_ch6),
    .ds1_in         (ds13_in),
    .ds2_in         (ds14_in),
    .ds1_st352_out  (ds13_st352_out),
    .ds2_st352_out  (ds14_st352_out),
    .ds1_anc_in     (ds13_anc_in),
    .ds2_anc_in     (ds14_anc_in),
    .use_anc_in     (use_anc_in),
    .ds1_out        (ds13_ch_out),
    .ds2_out        (ds14_ch_out));

v_smpte_uhdsdi_v1_0_5_tx_channel CH7 (
    .clk            (clk),
    .ce             (ce),
    .rst            (rst),
    .sd_mode        (sd_mode),
    .insert_crc     (insert_crc & ~sd_mode),
    .insert_ln      (insert_ln & ~sd_mode),
    .insert_st352   (insert_st352),
    .overwrite_st352(overwrite_st352),
    .line           (line_ch7),
    .st352_line_f1  (st352_line_f1),
    .st352_line_f2  (st352_line_f2),
    .st352_f2_en    (st352_f2_en),
    .st352_data     (st352_data_ch7),
    .ds1_in         (ds15_in),
    .ds2_in         (ds16_in),
    .ds1_st352_out  (ds15_st352_out),
    .ds2_st352_out  (ds16_st352_out),
    .ds1_anc_in     (ds15_anc_in),
    .ds2_anc_in     (ds16_anc_in),
    .use_anc_in     (use_anc_in),
    .ds1_out        (ds15_ch_out),
    .ds2_out        (ds16_ch_out));


//
// SD-SDI EDH processor
//
v_smpte_uhdsdi_v1_0_5_edh_processor TXEDH (
    .clk             (clk),
    .ce              (edh_ce),
    .rst             (rst),
    .vid_in          (ds1_ch_out),
    .reacquire       (1'b0),
    .en_sync_switch  (1'b0),
    .en_trs_blank    (1'b0),
    .anc_idh_local   (1'b0),
    .anc_ues_local   (1'b0),
    .ap_idh_local    (1'b0),
    .ff_idh_local    (1'b0),
    .errcnt_flg_en   (16'b0),
    .clr_errcnt      (1'b0),
    .receive_mode    (1'b0),

    .vid_out         (edh_out),
    .std             (),
    .std_locked      (),
    .trs             (),
    .field           (),
    .v_blank         (),
    .h_blank         (),
    .horz_count      (),
    .vert_count      (),
    .sync_switch     (),
    .locked          (),
    .eav_next        (),
    .sav_next        (),
    .xyz_word        (),
    .anc_next        (),
    .edh_next        (),
    .rx_ap_flags     (),
    .rx_ff_flags     (),
    .rx_anc_flags    (),
    .ap_flags        (),
    .ff_flags        (),
    .anc_flags       (),
    .packet_flags    (),
    .errcnt          (),
    .edh_packet      ());


//
// This mux bypasses the EDH processor if insert_edh is 0.
//
assign edh_mux = (sd_mode & insert_edh) ? edh_out : ds1_ch_out;

//
// SDI TX output module
//
v_smpte_uhdsdi_v1_0_5_tx_output TXOUT  (
    .clk                (clk),
    .ce                 (ce),
    .sd_ce              (sd_ce),
    .rst                (rst),
    .mode               (mode),
    .mux_pattern        (mux_pattern),
    .insert_sync_bit    (insert_sync_bit),
    .ds1                (edh_mux),
    .ds2                (ds2_ch_out),
    .ds3                (ds3_ch_out),
    .ds4                (ds4_ch_out),
    .ds5                (ds5_ch_out),
    .ds6                (ds6_ch_out),
    .ds7                (ds7_ch_out),
    .ds8                (ds8_ch_out),
    .ds9                (ds9_ch_out),
    .ds10               (ds10_ch_out),
    .ds11               (ds11_ch_out),
    .ds12               (ds12_ch_out),
    .ds13               (ds13_ch_out),
    .ds14               (ds14_ch_out),
    .ds15               (ds15_ch_out),
    .ds16               (ds16_ch_out),
    .sd_bitrep_bypass   (sd_bitrep_bypass),
    .txdata             (txdata),
    .ce_align_err       (ce_align_err));

endmodule


// (c) Copyright 2002 - 2015 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
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
// 
// 
//------------------------------------------------------------------------------
/*
Module Description:

This is the top level of the UHD-SDI RX supporting all rates from SD to 12G.
*/

`timescale 1ns / 1ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module v_smpte_uhdsdi_v1_0_5 #(
    parameter INCLUDE_RX_EDH_PROCESSOR = "TRUE",
    parameter NUM_RX_CE             = 1,                    // number of rx clock enable outputs
    parameter DATA_WIDTH            = 20,                   // width of rxdata and txdata port, must be 40 if 6G/12G are used, otherwise 20
    parameter EDH_ERR_WIDTH         = 16)                   // bit width of the EDH error counter
(
    // RX Ports
    input  wire                     rx_clk,                 // rxusrclk input
    input  wire                     rx_rst,                 // sync reset input
    input  wire                     rx_mode_detect_rst,     // synchronous reset for SDI mode detection function    
    input  wire [DATA_WIDTH-1:0]    rx_data_in,             // raw data from GTX RXDATA port, in SD mode, the 10 LSBs must be driven by the DRU output
    input  wire                     rx_sd_data_strobe,      // asserted high when SD data is available on data_in
    input  wire                     rx_frame_en,            // 1 = enable framer position update
    input  wire                     rx_bit_rate,            // 1 = 1000/1001 bit rate, 0 = 1000/1000 bit rate
    input  wire [5:0]               rx_mode_enable,         // unary enable bits for SDI mode search {12G/1.001, 12G/1, 6G, 3G, SD, HD} 1=enable, 0=disable
    input  wire                     rx_mode_detect_en,      // 1 enables SDI mode detection
    input  wire [2:0]               rx_forced_mode,         // if mode_detect_en=0, this port specifies the SDI mode of the RX
    input  wire                     rx_ready,               // when 0, prevents the SDI mode search from running
    output wire [2:0]               rx_mode,                // 000=HD, 001=SD, 010=3G, 100=6G, 101=12G
    output wire                     rx_mode_hd,             // 1 = HD mode      
    output wire                     rx_mode_sd,             // 1 = SD mode
    output wire                     rx_mode_3g,             // 1 = 3G mode
    output wire                     rx_mode_6g,             // 1 = 6G mode
    output wire                     rx_mode_12g,            // 1 = 12G mode
    output wire                     rx_mode_locked,         // auto mode detection locked
    output wire                     rx_t_locked,            // transport format detection locked
    output wire [3:0]               rx_t_family,            // transport format family
    output wire [3:0]               rx_t_rate,              // transport frame rate
    output wire                     rx_t_scan,              // transport scan: 0=interlaced, 1=progressive
    output wire                     rx_level_b_3g,          // 0 = level A, 1 = level B
    output wire [NUM_RX_CE-1:0]     rx_ce_out,              // clock enable
    output wire [2:0]               rx_active_streams,      // 2^active_streams = number of active streams
    output wire [10:0]              rx_ln_ds1,              // line number for ds1
    output wire [10:0]              rx_ln_ds2,              // line number for ds2
    output wire [10:0]              rx_ln_ds3,              // line number for ds3
    output wire [10:0]              rx_ln_ds4,              // line number for ds4
    output wire [10:0]              rx_ln_ds5,              // line number for ds5
    output wire [10:0]              rx_ln_ds6,              // line number for ds6
    output wire [10:0]              rx_ln_ds7,              // line number for ds7
    output wire [10:0]              rx_ln_ds8,              // line number for ds8
    output wire [10:0]              rx_ln_ds9,              // line number for ds9
    output wire [10:0]              rx_ln_ds10,             // line number for ds10
    output wire [10:0]              rx_ln_ds11,             // line number for ds11
    output wire [10:0]              rx_ln_ds12,             // line number for ds12
    output wire [10:0]              rx_ln_ds13,             // line number for ds13
    output wire [10:0]              rx_ln_ds14,             // line number for ds14
    output wire [10:0]              rx_ln_ds15,             // line number for ds15
    output wire [10:0]              rx_ln_ds16,             // line number for ds16
    output wire [31:0]              rx_st352_0,             // video payload ID packet ds1 (for 3G-SDI level A, Y VPID)
    output wire                     rx_st352_0_valid,       // 1 = st352_0 is valid
    output wire [31:0]              rx_st352_1,             // video payload ID packet ds3 (ds2 for 3G-SDI level A, C VPID) 
    output wire                     rx_st352_1_valid,       // 1 = st352_1 is valid
    output wire [31:0]              rx_st352_2,             // video payload ID packet ds5
    output wire                     rx_st352_2_valid,       // 1 = st352_2 is valid
    output wire [31:0]              rx_st352_3,             // video payload ID packet ds7
    output wire                     rx_st352_3_valid,       // 1 = st352_3 is valid
    output wire [31:0]              rx_st352_4,             // video payload ID packet ds9
    output wire                     rx_st352_4_valid,       // 1 = st352_4 is valid
    output wire [31:0]              rx_st352_5,             // video payload ID packet ds11
    output wire                     rx_st352_5_valid,       // 1 = st352_5 is valid
    output wire [31:0]              rx_st352_6,             // video payload ID packet ds13
    output wire                     rx_st352_6_valid,       // 1 = st352_6 is valid
    output wire [31:0]              rx_st352_7,             // video payload ID packet ds15
    output wire                     rx_st352_7_valid,       // 1 = st352_7 is valid
    output wire                     rx_crc_err_ds1,         // CRC error for ds1
    output wire                     rx_crc_err_ds2,         // CRC error for ds2
    output wire                     rx_crc_err_ds3,         // CRC error for ds3
    output wire                     rx_crc_err_ds4,         // CRC error for ds4
    output wire                     rx_crc_err_ds5,         // CRC error for ds5
    output wire                     rx_crc_err_ds6,         // CRC error for ds6
    output wire                     rx_crc_err_ds7,         // CRC error for ds7
    output wire                     rx_crc_err_ds8,         // CRC error for ds8
    output wire                     rx_crc_err_ds9,         // CRC error for ds9
    output wire                     rx_crc_err_ds10,        // CRC error for ds10
    output wire                     rx_crc_err_ds11,        // CRC error for ds11
    output wire                     rx_crc_err_ds12,        // CRC error for ds12
    output wire                     rx_crc_err_ds13,        // CRC error for ds13
    output wire                     rx_crc_err_ds14,        // CRC error for ds14
    output wire                     rx_crc_err_ds15,        // CRC error for ds15
    output wire                     rx_crc_err_ds16,        // CRC error for ds16
    output wire [9:0]               rx_ds1,                 // SD=Y/C, HD=Y, 3GA=ds1, 3GB=Y link A, 6G/12G=ds1
    output wire [9:0]               rx_ds2,                 // HD=C, 3GA=ds2, 3GB=C link A, 6G/12G=ds2
    output wire [9:0]               rx_ds3,                 // 3GB=Y link B, 6G/12G=ds3
    output wire [9:0]               rx_ds4,                 // 3GB=C link B, 6G/12G=ds4
    output wire [9:0]               rx_ds5,                 // 6G/12G=ds5
    output wire [9:0]               rx_ds6,                 // 6G/12G=ds6
    output wire [9:0]               rx_ds7,                 // 6G/12G=ds7
    output wire [9:0]               rx_ds8,                 // 6G/12G=ds8
    output wire [9:0]               rx_ds9,                 // 12G=ds9
    output wire [9:0]               rx_ds10,                // 12G=ds10
    output wire [9:0]               rx_ds11,                // 12G=ds11
    output wire [9:0]               rx_ds12,                // 12G=ds12
    output wire [9:0]               rx_ds13,                // 12G=ds13
    output wire [9:0]               rx_ds14,                // 12G=ds14
    output wire [9:0]               rx_ds15,                // 12G=ds15
    output wire [9:0]               rx_ds16,                // 12G=ds16
    output wire                     rx_eav,                 // EAV
    output wire                     rx_sav,                 // SAV
    output wire                     rx_trs,                 // TRS
    input  wire [15:0]              rx_edh_errcnt_en,       // enables various error to increment rx_edh_errcnt
    input  wire                     rx_edh_clr_errcnt,      // clears rx_edh_errcnt
    output wire                     rx_edh_ap,              // 1 = AP CRC error detected previous field
    output wire                     rx_edh_ff,              // 1 = FF CRC error detected previous field
    output wire                     rx_edh_anc,             // 1 = ANC checksum error detected
    output wire [4:0]               rx_edh_ap_flags,        // EDH AP flags received in last EDH packet
    output wire [4:0]               rx_edh_ff_flags,        // EDH FF flags received in last EDH packet
    output wire [4:0]               rx_edh_anc_flags,       // EDH ANC flags received in last EDH packet
    output wire [3:0]               rx_edh_packet_flags,    // EDH packet error condition flags
    output wire [EDH_ERR_WIDTH-1:0] rx_edh_errcnt,          // EDH error counter

    // TX Ports
    input  wire                     tx_clk,                 // txusrclk
    input  wire                     tx_ce,                  // clock enable
    input  wire                     tx_sd_ce,               // SD-SDI clock enable, must be High in all other modes
    input  wire                     tx_edh_ce,              // EDH clock enable, recommended Low in all modes except SD-SDI
    input  wire                     tx_rst,                 // sync reset input
    input  wire [2:0]               tx_mode,                // SDI mode
    input  wire                     tx_insert_crc,          // 1 = insert CRC for HD and 3G
    input  wire                     tx_insert_ln,           // 1 = insert LN for HD and 3G
    input  wire                     tx_insert_st352,        // 1 = insert st352 PID packets
    input  wire                     tx_overwrite_st352,     // 1 = overwrite existing ST 352 packets
    input  wire                     tx_insert_edh,          // 1 = generate & insert EDH packets in SD-SDI mode
    input  wire [2:0]               tx_mux_pattern,         // specifies the multiplex interleave pattern of data streams
    input  wire                     tx_insert_sync_bit,     // 1 enables sync bit insertion
    input  wire                     tx_sd_bitrep_bypass,    // 1 bypasses the SD-SDI 11X bit replicator
    input  wire [10:0]              tx_line_ch0,            // current line number for ds1 & ds2
    input  wire [10:0]              tx_line_ch1,            // current line number for ds3 & ds4
    input  wire [10:0]              tx_line_ch2,            // current line number for ds5 & ds6 
    input  wire [10:0]              tx_line_ch3,            // current line number for ds7 & ds8
    input  wire [10:0]              tx_line_ch4,            // current line number for ds9 & ds10
    input  wire [10:0]              tx_line_ch5,            // current line number for ds11 & ds12
    input  wire [10:0]              tx_line_ch6,            // current line number for ds13 & ds14
    input  wire [10:0]              tx_line_ch7,            // current line number for ds15 & ds16
    input  wire [10:0]              tx_st352_line_f1,       // line number in field 1 to insert ST 352
    input  wire [10:0]              tx_st352_line_f2,       // line number in field 2 to insert ST 352
    input  wire                     tx_st352_f2_en,         // 1 = insert packets on st352_line_f2 line
    input  wire [31:0]              tx_st352_data_ch0,      // ST352 data bytes for ds1 {byte4, byte3, byte2, byte1} 
    input  wire [31:0]              tx_st352_data_ch1,      // ST352 data bytes for ds3 (and ds2 in 3GA mode) {byte4, byte3, byte2, byte1} 
    input  wire [31:0]              tx_st352_data_ch2,      // ST352 data bytes for ds5 {byte4, byte3, byte2, byte1} 
    input  wire [31:0]              tx_st352_data_ch3,      // ST352 data bytes for ds7 {byte4, byte3, byte2, byte1} 
    input  wire [31:0]              tx_st352_data_ch4,      // ST352 data bytes for ds9 {byte4, byte3, byte2, byte1} 
    input  wire [31:0]              tx_st352_data_ch5,      // ST352 data bytes for ds11 {byte4, byte3, byte2, byte1} 
    input  wire [31:0]              tx_st352_data_ch6,      // ST352 data bytes for ds13 {byte4, byte3, byte2, byte1} 
    input  wire [31:0]              tx_st352_data_ch7,      // ST352 data bytes for ds15 {byte4, byte3, byte2, byte1} 
    input  wire [9:0]               tx_ds1_in,              // data stream 1 (Y) in -- only active ds in SD, Y for HD & 3GA, AY for 3GB
    input  wire [9:0]               tx_ds2_in,              // data stream 2 (C) in -- C for HD & 3GA, AC for 3GB
    input  wire [9:0]               tx_ds3_in,              // data stream 3 (Y) in -- BY for 3GB
    input  wire [9:0]               tx_ds4_in,              // data stream 4 (C) in -- BC for 3GB
    input  wire [9:0]               tx_ds5_in,              // data stream 5 (Y) in
    input  wire [9:0]               tx_ds6_in,              // data stream 6 (C) in
    input  wire [9:0]               tx_ds7_in,              // data stream 7 (Y) in
    input  wire [9:0]               tx_ds8_in,              // data stream 8 (C) in
    input  wire [9:0]               tx_ds9_in,              // data stream 9 (Y) in
    input  wire [9:0]               tx_ds10_in,             // data stream 10 (C) in
    input  wire [9:0]               tx_ds11_in,             // data stream 11 (Y) in
    input  wire [9:0]               tx_ds12_in,             // data stream 12 (C) in
    input  wire [9:0]               tx_ds13_in,             // data stream 13 (Y) in
    input  wire [9:0]               tx_ds14_in,             // data stream 14 (C) in
    input  wire [9:0]               tx_ds15_in,             // data stream 15 (Y) in
    input  wire [9:0]               tx_ds16_in,             // data stream 16 (C) in
    output wire [9:0]               tx_ds1_st352_out,       // data stream 1 after ST352 insertion
    output wire [9:0]               tx_ds2_st352_out,       // data stream 2 after ST352 insertion
    output wire [9:0]               tx_ds3_st352_out,       // data stream 3 after ST352 insertion
    output wire [9:0]               tx_ds4_st352_out,       // data stream 4 after ST352 insertion
    output wire [9:0]               tx_ds5_st352_out,       // data stream 5 after ST352 insertion
    output wire [9:0]               tx_ds6_st352_out,       // data stream 6 after ST352 insertion
    output wire [9:0]               tx_ds7_st352_out,       // data stream 7 after ST352 insertion
    output wire [9:0]               tx_ds8_st352_out,       // data stream 8 after ST352 insertion
    output wire [9:0]               tx_ds9_st352_out,       // data stream 9 after ST352 insertion
    output wire [9:0]               tx_ds10_st352_out,      // data stream 10 after ST352 insertion
    output wire [9:0]               tx_ds11_st352_out,      // data stream 11 after ST352 insertion
    output wire [9:0]               tx_ds12_st352_out,      // data stream 12 after ST352 insertion
    output wire [9:0]               tx_ds13_st352_out,      // data stream 13 after ST352 insertion
    output wire [9:0]               tx_ds14_st352_out,      // data stream 14 after ST352 insertion
    output wire [9:0]               tx_ds15_st352_out,      // data stream 15 after ST352 insertion
    output wire [9:0]               tx_ds16_st352_out,      // data stream 16 after ST352 insertion
    input  wire [9:0]               tx_ds1_anc_in,          // data stream 1 after ANC insertion input
    input  wire [9:0]               tx_ds2_anc_in,          // data stream 2 after ANC insertion input
    input  wire [9:0]               tx_ds3_anc_in,          // data stream 3 after ANC section input
    input  wire [9:0]               tx_ds4_anc_in,          // data stream 4 after ANC section input
    input  wire [9:0]               tx_ds5_anc_in,          // data stream 5 after ANC section input
    input  wire [9:0]               tx_ds6_anc_in,          // data stream 6 after ANC section input
    input  wire [9:0]               tx_ds7_anc_in,          // data stream 7 after ANC section input
    input  wire [9:0]               tx_ds8_anc_in,          // data stream 8 after ANC section input
    input  wire [9:0]               tx_ds9_anc_in,          // data stream 9 after ANC section input
    input  wire [9:0]               tx_ds10_anc_in,         // data stream 10 after ANC section input
    input  wire [9:0]               tx_ds11_anc_in,         // data stream 11 after ANC section input
    input  wire [9:0]               tx_ds12_anc_in,         // data stream 12 after ANC section input
    input  wire [9:0]               tx_ds13_anc_in,         // data stream 13 after ANC section input
    input  wire [9:0]               tx_ds14_anc_in,         // data stream 14 after ANC section input
    input  wire [9:0]               tx_ds15_anc_in,         // data stream 15 after ANC section input
    input  wire [9:0]               tx_ds16_anc_in,         // data stream 16 after ANC section input
    input  wire                     tx_use_anc_in,          // use the dsX_anc_in ports
    output wire [DATA_WIDTH-1:0]    tx_txdata,              // output data stream to GT TXDATA port
    output wire                     tx_ce_align_err         // 1 if ce 5/6/5/6 cadence is broken in SD-SDI mode
);

localparam ERRCNT_WIDTH          = 4;                       // width of counter tracking received lines with errors
localparam MAX_ERRS_LOCKED       = 15;                      // max number of consecutive received lines with errors
localparam MAX_ERRS_UNLOCKED     = 2;                       // max number of received lines with errors during search

wire [39:0]     txdata;

//
// UHD-SDI RX
//
v_smpte_uhdsdi_v1_0_5_rx #(
    .RXDATA_WIDTH               (DATA_WIDTH),
    .INCLUDE_RX_EDH_PROCESSOR   (INCLUDE_RX_EDH_PROCESSOR),
    .NUM_CE                     (NUM_RX_CE),
    .ERRCNT_WIDTH               (ERRCNT_WIDTH),
    .MAX_ERRS_LOCKED            (MAX_ERRS_LOCKED),
    .MAX_ERRS_UNLOCKED          (MAX_ERRS_UNLOCKED),
    .EDH_ERR_WIDTH              (EDH_ERR_WIDTH))
RX (
    .clk                        (rx_clk),
    .rst                        (rx_rst),
    .data_in                    (rx_data_in),
    .sd_data_strobe             (rx_sd_data_strobe),
    .frame_en                   (rx_frame_en),
    .bit_rate                   (rx_bit_rate),
    .mode_enable                (rx_mode_enable),
    .mode_detect_en             (rx_mode_detect_en),
    .forced_mode                (rx_forced_mode),
    .rx_ready                   (rx_ready),
    .mode_detect_rst            (rx_mode_detect_rst),
    .mode                       (rx_mode),
    .mode_HD                    (rx_mode_hd),
    .mode_SD                    (rx_mode_sd),
    .mode_3G                    (rx_mode_3g),
    .mode_6G                    (rx_mode_6g),
    .mode_12G                   (rx_mode_12g),
    .mode_locked                (rx_mode_locked),
    .t_locked                   (rx_t_locked),
    .t_family                   (rx_t_family),
    .t_rate                     (rx_t_rate),
    .t_scan                     (rx_t_scan),
    .level_b_3G                 (rx_level_b_3g),
    .ce_out                     (rx_ce_out),
    .nsp                        (),
    .active_streams             (rx_active_streams),
    .ln_ds1                     (rx_ln_ds1),
    .ln_ds2                     (rx_ln_ds2),
    .ln_ds3                     (rx_ln_ds3),
    .ln_ds4                     (rx_ln_ds4),
    .ln_ds5                     (rx_ln_ds5),
    .ln_ds6                     (rx_ln_ds6),
    .ln_ds7                     (rx_ln_ds7),
    .ln_ds8                     (rx_ln_ds8),
    .ln_ds9                     (rx_ln_ds9),
    .ln_ds10                    (rx_ln_ds10),
    .ln_ds11                    (rx_ln_ds11),
    .ln_ds12                    (rx_ln_ds12),
    .ln_ds13                    (rx_ln_ds13),
    .ln_ds14                    (rx_ln_ds14),
    .ln_ds15                    (rx_ln_ds15),
    .ln_ds16                    (rx_ln_ds16),
    .vpid_0                     (rx_st352_0),
    .vpid_0_valid               (rx_st352_0_valid),
    .vpid_1                     (rx_st352_1),
    .vpid_1_valid               (rx_st352_1_valid),
    .vpid_2                     (rx_st352_2),
    .vpid_2_valid               (rx_st352_2_valid),
    .vpid_3                     (rx_st352_3),
    .vpid_3_valid               (rx_st352_3_valid),
    .vpid_4                     (rx_st352_4),
    .vpid_4_valid               (rx_st352_4_valid),
    .vpid_5                     (rx_st352_5),
    .vpid_5_valid               (rx_st352_5_valid),
    .vpid_6                     (rx_st352_6),
    .vpid_6_valid               (rx_st352_6_valid),
    .vpid_7                     (rx_st352_7),
    .vpid_7_valid               (rx_st352_7_valid),
    .crc_err_ds1                (rx_crc_err_ds1),
    .crc_err_ds2                (rx_crc_err_ds2),
    .crc_err_ds3                (rx_crc_err_ds3),
    .crc_err_ds4                (rx_crc_err_ds4),
    .crc_err_ds5                (rx_crc_err_ds5),
    .crc_err_ds6                (rx_crc_err_ds6),
    .crc_err_ds7                (rx_crc_err_ds7),
    .crc_err_ds8                (rx_crc_err_ds8),
    .crc_err_ds9                (rx_crc_err_ds9),
    .crc_err_ds10               (rx_crc_err_ds10),
    .crc_err_ds11               (rx_crc_err_ds11),
    .crc_err_ds12               (rx_crc_err_ds12),
    .crc_err_ds13               (rx_crc_err_ds13),
    .crc_err_ds14               (rx_crc_err_ds14),
    .crc_err_ds15               (rx_crc_err_ds15),
    .crc_err_ds16               (rx_crc_err_ds16),
    .ds1                        (rx_ds1),
    .ds2                        (rx_ds2),
    .ds3                        (rx_ds3),
    .ds4                        (rx_ds4),
    .ds5                        (rx_ds5),
    .ds6                        (rx_ds6),
    .ds7                        (rx_ds7),
    .ds8                        (rx_ds8),
    .ds9                        (rx_ds9),
    .ds10                       (rx_ds10),
    .ds11                       (rx_ds11),
    .ds12                       (rx_ds12),
    .ds13                       (rx_ds13),
    .ds14                       (rx_ds14),
    .ds15                       (rx_ds15),
    .ds16                       (rx_ds16),
    .eav                        (rx_eav),
    .sav                        (rx_sav),
    .trs                        (rx_trs),
    .edh_errcnt_en              (rx_edh_errcnt_en),
    .edh_clr_errcnt             (rx_edh_clr_errcnt),
    .edh_ap                     (rx_edh_ap),
    .edh_ff                     (rx_edh_ff),
    .edh_anc                    (rx_edh_anc),
    .edh_ap_flags               (rx_edh_ap_flags),
    .edh_ff_flags               (rx_edh_ff_flags),
    .edh_anc_flags              (rx_edh_anc_flags),
    .edh_packet_flags           (rx_edh_packet_flags),
    .edh_errcnt                 (rx_edh_errcnt));

v_smpte_uhdsdi_v1_0_5_tx TX (
    .clk                        (tx_clk),
    .ce                         (tx_ce),
    .sd_ce                      (tx_sd_ce),
    .edh_ce                     (tx_edh_ce),
    .rst                        (tx_rst),
    .mode                       (tx_mode),
    .insert_crc                 (tx_insert_crc),
    .insert_ln                  (tx_insert_ln),
    .insert_st352               (tx_insert_st352),
    .overwrite_st352            (tx_overwrite_st352),
    .insert_edh                 (tx_insert_edh),
    .mux_pattern                (tx_mux_pattern),
    .insert_sync_bit            (tx_insert_sync_bit),
    .sd_bitrep_bypass           (tx_sd_bitrep_bypass),
    .line_ch0                   (tx_line_ch0),
    .line_ch1                   (tx_line_ch1),
    .line_ch2                   (tx_line_ch2),
    .line_ch3                   (tx_line_ch3),
    .line_ch4                   (tx_line_ch4),
    .line_ch5                   (tx_line_ch5),
    .line_ch6                   (tx_line_ch6),
    .line_ch7                   (tx_line_ch7),
    .st352_line_f1              (tx_st352_line_f1),
    .st352_line_f2              (tx_st352_line_f2),
    .st352_f2_en                (tx_st352_f2_en),
    .st352_data_ch0             (tx_st352_data_ch0),
    .st352_data_ch1             (tx_st352_data_ch1),
    .st352_data_ch2             (tx_st352_data_ch2),
    .st352_data_ch3             (tx_st352_data_ch3),
    .st352_data_ch4             (tx_st352_data_ch4),
    .st352_data_ch5             (tx_st352_data_ch5),
    .st352_data_ch6             (tx_st352_data_ch6),
    .st352_data_ch7             (tx_st352_data_ch7),
    .ds1_in                     (tx_ds1_in),
    .ds2_in                     (tx_ds2_in),
    .ds3_in                     (tx_ds3_in),
    .ds4_in                     (tx_ds4_in),
    .ds5_in                     (tx_ds5_in),
    .ds6_in                     (tx_ds6_in),
    .ds7_in                     (tx_ds7_in),
    .ds8_in                     (tx_ds8_in),
    .ds9_in                     (tx_ds9_in),
    .ds10_in                    (tx_ds10_in),
    .ds11_in                    (tx_ds11_in),
    .ds12_in                    (tx_ds12_in),
    .ds13_in                    (tx_ds13_in),
    .ds14_in                    (tx_ds14_in),
    .ds15_in                    (tx_ds15_in),
    .ds16_in                    (tx_ds16_in),
    .ds1_st352_out              (tx_ds1_st352_out),
    .ds2_st352_out              (tx_ds2_st352_out),
    .ds3_st352_out              (tx_ds3_st352_out),
    .ds4_st352_out              (tx_ds4_st352_out),
    .ds5_st352_out              (tx_ds5_st352_out),
    .ds6_st352_out              (tx_ds6_st352_out),
    .ds7_st352_out              (tx_ds7_st352_out),
    .ds8_st352_out              (tx_ds8_st352_out),
    .ds9_st352_out              (tx_ds9_st352_out),
    .ds10_st352_out             (tx_ds10_st352_out),
    .ds11_st352_out             (tx_ds11_st352_out),
    .ds12_st352_out             (tx_ds12_st352_out),
    .ds13_st352_out             (tx_ds13_st352_out),
    .ds14_st352_out             (tx_ds14_st352_out),
    .ds15_st352_out             (tx_ds15_st352_out),
    .ds16_st352_out             (tx_ds16_st352_out),
    .ds1_anc_in                 (tx_ds1_anc_in),
    .ds2_anc_in                 (tx_ds2_anc_in),
    .ds3_anc_in                 (tx_ds3_anc_in),
    .ds4_anc_in                 (tx_ds4_anc_in),
    .ds5_anc_in                 (tx_ds5_anc_in),
    .ds6_anc_in                 (tx_ds6_anc_in),
    .ds7_anc_in                 (tx_ds7_anc_in),
    .ds8_anc_in                 (tx_ds8_anc_in),
    .ds9_anc_in                 (tx_ds9_anc_in),
    .ds10_anc_in                (tx_ds10_anc_in),
    .ds11_anc_in                (tx_ds11_anc_in),
    .ds12_anc_in                (tx_ds12_anc_in),
    .ds13_anc_in                (tx_ds13_anc_in),
    .ds14_anc_in                (tx_ds14_anc_in),
    .ds15_anc_in                (tx_ds15_anc_in),
    .ds16_anc_in                (tx_ds16_anc_in),
    .use_anc_in                 (tx_use_anc_in),
    .txdata                     (txdata),
    .ce_align_err               (tx_ce_align_err));

generate
    if (DATA_WIDTH == 40)
    begin : TX40
        assign tx_txdata = txdata;
    end else begin : TX20
        assign tx_txdata = txdata[19:0];
    end
endgenerate

endmodule


