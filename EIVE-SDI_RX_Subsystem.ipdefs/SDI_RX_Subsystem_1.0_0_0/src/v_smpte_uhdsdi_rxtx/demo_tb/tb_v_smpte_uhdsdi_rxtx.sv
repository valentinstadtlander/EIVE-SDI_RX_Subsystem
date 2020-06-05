
// $Revision: 1.3 $ $Date: 2011/04/01 21:28:08 $
//-----------------------------------------------------------------------------
// (c) Copyright 2010 = 2011 Xilinx, Inc. All rights reserved.
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
//----------------------------------------------------------
/*
Module Description:

This is the test bench for the triple-rate SDI RX & TX module. Tests the basic
RX and TX functions of the module for all video formats.

*/

`timescale 1ns / 1ps

`define DATA_WIDTH 20

//
// Global type definitions
//
typedef bit [10:0]  line_num;       // Line number type def
typedef bit [13:0]  sample_num;     // Sample number type def
typedef bit [3:0]   nibble;         // Type def used for 4-bit family and rate codes
typedef bit [2:0]   mode_type;      // SDI mode type def
typedef bit [9:0]   video_type;     // 10-bit video stream
typedef reg [7:0]   vid_frmt;      // SDI video_frmt

//
// This is the test bench top module.
//
module tb_v_smpte_uhdsdi_rxtx;


bit                 clk = 1'b0;
bit                 rst;
line_num            line;
logic               eav;
logic               sav;
nibble              family;
nibble              rate;
logic               scan;
logic               bit_rate;
logic               level;
line_num            first_active;
sample_num          active_samples;
sample_num          total_samples;
video_type          y, c;
logic               tx_ce;
logic   [10:0]      sd_tx_ce_gen = 11'b00000100001;
logic               level_b_ce = 1'b1;
logic               vidgen_ce;
video_type          tx_ds1a, tx_ds2a, tx_ds1b, tx_ds2b;
logic               tx_din_rdy;
mode_type           rx_mode;
logic               rx_mode_HD, rx_mode_SD, rx_mode_3G, rx_mode_6G, rx_mode_12G;
logic               rx_level;
line_num            rx_ln_a, rx_ln_b;
video_type          rx_ds1a, rx_ds2a, rx_ds1b, rx_ds2b;
logic               rx_dout_rdy_3G;
logic               rx_crc_a, rx_crc_b;
integer             errs = 0;
logic   [31:0]      tx_vpid_data=0;
logic   [7:0]       tx_vpid_data_b4=0;
logic   [31:0]      rx_a_vpid, rx_b_vpid;
logic               rx_a_vpid_valid, rx_b_vpid_valid;
logic [5:0]	    count =6'd0;

sample_num          hanc_check = 0;

//==========================================================

bit                 tb_clk;
bit                 tb_rst = 1'b1;
logic               tb_clk_dly;
mode_type           mode;
logic               w_tx_ce;
logic               w_tx_sd_ce;
logic               w_tx_edh_ce;
mode_type           w_tx_mode;
logic               w_tx_insert_crc;
logic               w_tx_insert_ln;
logic               w_tx_insert_st352;
logic               w_tx_overwrite_st352;
logic               w_tx_insert_edh;
logic [2:0]         w_tx_mux_pattern;
logic               w_tx_insert_sync_bit;
logic               w_tx_sd_bitrep_bypass;
logic [10:0]        w_tx_st352_line_f1; 
logic [10:0]        w_tx_st352_line_f2; 
logic               w_tx_st352_f2_en;
logic [9:0]         w_tx_ds1_in,w_tx_ds2_in,w_tx_ds3_in,w_tx_ds4_in,w_tx_ds5_in,w_tx_ds6_in,w_tx_ds7_in,w_tx_ds8_in; 
logic [9:0]         w_tx_ds9_in,w_tx_ds10_in,w_tx_ds11_in,w_tx_ds12_in,w_tx_ds13_in,w_tx_ds14_in,w_tx_ds15_in,w_tx_ds16_in; 
logic [31:0]        w_tx_st352_data_ch0,w_tx_st352_data_ch1,w_tx_st352_data_ch2,w_tx_st352_data_ch3,w_tx_st352_data_ch4,w_tx_st352_data_ch5,w_tx_st352_data_ch6,w_tx_st352_data_ch7; 
logic [10:0]        w_tx_line_ch0,w_tx_line_ch1,w_tx_line_ch2,w_tx_line_ch3,w_tx_line_ch4,w_tx_line_ch5,w_tx_line_ch6,w_tx_line_ch7;     
logic               w_rx_mode_locked;
logic               w_rx_t_locked;
logic [3:0] 	    w_rx_t_family;
logic [3:0]         w_rx_t_rate;
logic               w_rx_t_scan;
logic               w_rx_level_b_3g; 
mode_type           w_rx_mode;
logic               w_rx_mode_hd;
logic               w_rx_mode_sd;
logic               w_rx_mode_3g;
logic               w_rx_mode_6g;
logic               w_rx_mode_12g;              
logic 		    w_rx_bit_rate;
logic [3:0]         w_mst_rx_t_family;
logic [3:0]         w_mst_rx_t_rate;  
logic               w_mst_rx_t_scan;  
line_num            w_rx_ln_ds1; 
line_num            w_rx_ln_ds2; 
line_num            w_rx_ln_ds3; 
line_num            w_rx_ln_ds4; 
line_num            w_rx_ln_ds5; 
line_num            w_rx_ln_ds6; 
line_num            w_rx_ln_ds7; 
line_num            w_rx_ln_ds8; 
line_num            w_rx_ln_ds9; 
line_num            w_rx_ln_ds10;
line_num            w_rx_ln_ds11;
line_num            w_rx_ln_ds12;
line_num            w_rx_ln_ds13;
line_num            w_rx_ln_ds14;
line_num            w_rx_ln_ds15;
line_num            w_rx_ln_ds16;
logic               w_rx_ce_out;
logic               w_rx_eav, w_rx_sav, w_rx_trs;
logic [10:0]        w_tx_line_no;     
logic               w_rx_crc_err_ds1,w_rx_crc_err_ds2,w_rx_crc_err_ds3,w_rx_crc_err_ds4; 
logic               w_rx_crc_err_ds5,w_rx_crc_err_ds6,w_rx_crc_err_ds7,w_rx_crc_err_ds8; 
logic               w_rx_crc_err_ds9,w_rx_crc_err_ds10,w_rx_crc_err_ds11,w_rx_crc_err_ds12; 
logic               w_rx_crc_err_ds13,w_rx_crc_err_ds14,w_rx_crc_err_ds15,w_rx_crc_err_ds16; 
video_type          w_rx_ds1,w_rx_ds2,w_rx_ds3,w_rx_ds4,w_rx_ds5,w_rx_ds6,w_rx_ds7,w_rx_ds8;
video_type          w_rx_ds9,w_rx_ds10,w_rx_ds11,w_rx_ds12,w_rx_ds13,w_rx_ds14,w_rx_ds15,w_rx_ds16;
logic              mode_flag,mode_mtch;

logic [31:0] w_rx_st352_0      ;
logic w_rx_st352_0_valid;
logic [31:0] w_rx_st352_1      ;
logic w_rx_st352_1_valid;
logic [31:0] w_rx_st352_2      ;
logic w_rx_st352_2_valid;
logic [31:0] w_rx_st352_3      ;
logic w_rx_st352_3_valid;
logic [31:0] w_rx_st352_4      ;
logic w_rx_st352_4_valid;
logic [31:0] w_rx_st352_5      ;
logic w_rx_st352_5_valid;
logic [31:0] w_rx_st352_6      ;
logic w_rx_st352_6_valid;
logic [31:0] w_rx_st352_7      ;
logic w_rx_st352_7_valid;


logic [9:0] w_tx_ds1_st352_out; 
logic [9:0] w_tx_ds2_st352_out; 
logic [9:0] w_tx_ds3_st352_out; 
logic [9:0] w_tx_ds4_st352_out; 
logic [9:0] w_tx_ds5_st352_out; 
logic [9:0] w_tx_ds6_st352_out; 
logic [9:0] w_tx_ds7_st352_out; 
logic [9:0] w_tx_ds8_st352_out; 
logic [9:0] w_tx_ds9_st352_out; 
logic [9:0] w_tx_ds10_st352_out;
logic [9:0] w_tx_ds11_st352_out;
logic [9:0] w_tx_ds12_st352_out;
logic [9:0] w_tx_ds13_st352_out;
logic [9:0] w_tx_ds14_st352_out;
logic [9:0] w_tx_ds15_st352_out;
logic [9:0] w_tx_ds16_st352_out;
logic [5:0] w_rx_mode_enable;
logic       w_rx_mode_detect_en;
logic       w_rx_sd_data_strobe,sd_data_strobe;
mode_type   w_rx_forced_mode;

logic [9:0] dru_dout,sd_data;
logic [2:0] w_rx_active_streams; 
logic       w_rx_edh_clr_errcnt;
logic sd_en;

integer             err = 32'd0 ;

//==========================================================

localparam mode_type
    MODE_HD = 3'b000,
    MODE_SD = 3'b001,
    MODE_3G = 3'b010,
    MODE_6G = 3'b100,
    MODE_12G = 3'b101,
    MODE_12G_1 = 3'b110;

localparam vid_frmt
     VID_1080i60 = 8'd0,
     VID_1080i59_94 = 8'd1,
     VID_1080i50 = 8'd2,
     VID_1080p30 = 8'd3,
     VID_1080p29_97 = 8'd4,
     VID_1080p25 = 8'd5,
     VID_1080p24 = 8'd6,
     VID_1080p23_98 = 8'd7,
     VID_720p60 = 8'd8,
     VID_720p59_94 = 8'd9,
     VID_720p50 = 8'd10,
     VID_720p30 = 8'd11,
     VID_720p29_97 = 8'd12,
     VID_720p25 = 8'd13,
     VID_720p24 = 8'd14,
     VID_720p23_98 = 8'd15,
     VID_2K_1080p30 = 8'd16,
     VID_2K_1080p29_97 = 8'd17,
     VID_2K_1080p25 = 8'd18,
     VID_2K_1080p24 = 8'd19,
     VID_2K_1080p23_98 = 8'd20,
     VID_1080p60 = 8'd21,
     VID_1080p59_94 = 8'd22,
     VID_1080p50 = 8'd23,
     VID_2K_1080p60 = 8'd24,
     VID_2K_1080p59_94 = 8'd25,
     VID_2K_1080p50 = 8'd26,
     VID_2K_1080p48 = 8'd27,
     VID_2K_1080p47_95 = 8'd28,
     VID_NTSC = 8'd29,
     VID_PAL = 8'd30;

//==========================================================
// TEST CASE START
//==========================================================

initial
begin
  #60;

  // Video Format - 3G 1280x720 Progressive 60Hz 
  // =================================================================
 
  mode = MODE_3G;

  SDI_MST.video_3G(VID_720p60,1);
  SDI_SLV.vid_frmt_check_end(10); //Line No. after first active
  rst_gen();

  // Video Format - HD 1280X720 Progressive 60Hz 
  // ===============================================================

  mode = MODE_HD;
  SDI_MST.HD_video(VID_720p60);
  SDI_MST.insert_crc(); 
  SDI_MST.insert_line();
  SDI_MST.insert_st352(MODE_HD,SDI_MST.first_active - 11'd2,0);
  SDI_SLV.vid_frmt_check_end(10); //Line No. after first active
  rst_gen();

  // Video Format - SD NTSC Field 1 
  // ====================================================
 
  mode = MODE_SD;   //This is needed for clock frequency

  $display("TEST CASE :: Core configured for SD NTSC ");
  SDI_MST.video_SD(VID_NTSC,0);
  SDI_SLV.vid_frmt_check_end(10); //Line No. after first active
  rst_gen();






  sim_end();
end

//==========================================================
// TEST CASE END
//==========================================================


  // This declaration has to be after the testcase inclusion
  //----------------------------
  logic [`DATA_WIDTH-1:0]      w_tx_txdata, w_rx_data_in,txdata;

  assign sd_data = (sd_data_strobe)?dru_dout:sd_data;
  assign txdata = (w_tx_mode == MODE_SD)?{10'd0,sd_data}:w_tx_txdata;
  assign w_rx_data_in = (w_rx_mode == w_tx_mode)?txdata:0;
  assign w_rx_sd_data_strobe = (w_tx_mode == MODE_SD)?sd_data_strobe:1'b1;
  
  always @(posedge tb_clk)
  begin
    if(tb_rst == 1'h1)
    begin
      mode_flag = 1'h0;
      mode_mtch = 1'h0;
    end  
    if((w_rx_mode == w_tx_mode) && (mode_mtch == 1'h0))
    begin
      mode_flag = 1'h1;
      mode_mtch = 1'h1;
    end
    else
    begin
      mode_flag = 1'h0;
    end  
  end   

  initial
  begin
    rst_gen();
  end 


  task rst_gen();
    @(posedge tb_clk); 
    tb_rst = 1'h1;
    for(int i = 0; i<90;i++)
    begin
      @(posedge tb_clk); 
    end
    tb_rst = 1'h0; 
  endtask


  task conditional_test_pass(input int err_cnt);
    if(err == err_cnt)
    begin
      $display("TEST has expected errors which can be ignored");
      err = 32'd0;
    end
  endtask

  task sim_end();
    if(err == 32'd0)
    begin
      $display("========= TEST PASSED ==========");
      $display("Test completed successfully");
    end
    else
    begin
      if(SDI_SLV.crc_err_cnt != 32'd0) 
      begin
        $display("%0d CRC Error detected",SDI_SLV.crc_err_cnt); 
      end

      $display(" %0d Total Errors detected ",err);
      $display("========= TEST FAILED ==========");
    end
    $finish;
  endtask

  initial
  begin
    #80ms;
    $display("========= TEST FAILED: Simulation hanged and test did not finish in 80 ms ==========");
    $finish;
  end



  clk_gen CLK_GEN ( 
    .MODE(mode), 
    .tb_clk (tb_clk)
  );

  sdi_master SDI_MST (
    .clk 			(tb_clk),
    .rst			(tb_rst),
    .tx_ce		(w_tx_ce		),
    .tx_sd_ce		(w_tx_sd_ce		),
    .tx_edh_ce		(w_tx_edh_ce		),
    .tx_mode		(w_tx_mode		),
    .tx_insert_crc	(w_tx_insert_crc	),
    .tx_insert_ln		(w_tx_insert_ln		),
    .tx_insert_st352	(w_tx_insert_st352	),
    .tx_overwrite_st352	(w_tx_overwrite_st352	),
    .tx_insert_edh	(w_tx_insert_edh	),
    .tx_mux_pattern	(w_tx_mux_pattern	),
    .tx_insert_sync_bit	(w_tx_insert_sync_bit	),
    .tx_sd_bitrep_bypass	(w_tx_sd_bitrep_bypass	),
    .tx_st352_line_f1	(w_tx_st352_line_f1	), 
    .tx_st352_line_f2	(w_tx_st352_line_f2	), 
    .tx_st352_f2_en	(w_tx_st352_f2_en	),
    .tx_ds1_in		(w_tx_ds1_in		), 
    .tx_ds2_in		(w_tx_ds2_in		), 
    .tx_ds3_in                (w_tx_ds3_in),      
    .tx_ds4_in                (w_tx_ds4_in),      
    .tx_ds5_in                (w_tx_ds5_in),      
    .tx_ds6_in                (w_tx_ds6_in),      
    .tx_ds7_in                (w_tx_ds7_in),      
    .tx_ds8_in                (w_tx_ds8_in),      
    .tx_ds9_in                (w_tx_ds9_in),      
    .tx_ds10_in               (w_tx_ds10_in),      
    .tx_ds11_in               (w_tx_ds11_in),      
    .tx_ds12_in               (w_tx_ds12_in),      
    .tx_ds13_in               (w_tx_ds13_in),      
    .tx_ds14_in               (w_tx_ds14_in),      
    .tx_ds15_in               (w_tx_ds15_in),      
    .tx_ds16_in               (w_tx_ds16_in),      
    .tx_st352_data_ch0	      (w_tx_st352_data_ch0), 
    .tx_st352_data_ch1        (w_tx_st352_data_ch1),    
    .tx_st352_data_ch2        (w_tx_st352_data_ch2),    
    .tx_st352_data_ch3        (w_tx_st352_data_ch3),    
    .tx_st352_data_ch4        (w_tx_st352_data_ch4),    
    .tx_st352_data_ch5        (w_tx_st352_data_ch5),    
    .tx_st352_data_ch6        (w_tx_st352_data_ch6),    
    .tx_st352_data_ch7        (w_tx_st352_data_ch7),    
    .tx_line_ch0	      (w_tx_line_ch0),        
    .tx_line_ch1              (w_tx_line_ch1),      
    .tx_line_ch2              (w_tx_line_ch2),      
    .tx_line_ch3              (w_tx_line_ch3),      
    .tx_line_ch4              (w_tx_line_ch4),      
    .tx_line_ch5              (w_tx_line_ch5),      
    .tx_line_ch6              (w_tx_line_ch6),      
    .tx_line_ch7              (w_tx_line_ch7),      
    .tx_line_no  	      (w_tx_line_no ),        
    .tx_use_anc_in            (w_tx_use_anc_in),      

    .mst_rx_t_family    (w_mst_rx_t_family),
    .mst_rx_t_rate      (w_mst_rx_t_rate  ),
    .mst_rx_t_scan      (w_mst_rx_t_scan  ),
    .rx_mode            (w_rx_mode),
    .rx_bit_rate        (w_rx_bit_rate)

  );

  assign sd_en = (w_tx_mode == MODE_SD)? 1'b1:1'b0;
  //------------------------------------------------------------------------------
  // 11X oversampling data recovery unit for SD-SDI
  //
  nidru_20_wrapper #(
      .S_MAX      (2))
  NIDRU (
      .DT_IN      (w_tx_txdata[19:0]),
      .CENTER_F   (37'b0000111010001101011111110100101111011),
      .EN         (sd_en),
      .G1         (5'b00110),
      .G1_P       (5'b10000),
      .G2         (5'b00111),
      .CLK        (tb_clk_dly),
      .PH_OUT     (),
      .INTEG      (),
      .DIRECT     (),
      .CTRL       (),
      .AL_PPM     (),
      .RST        (tb_rst),
      .RST_FREQ   (1'b0),
      .EN_INTEG   (1'b1),
      .PH_EST_DIS (1'b0),
      .VER        (),
      .RECCLK     (),
      .SAMV       (),
      .SAM        (),
      .EN_OUT     (sd_data_strobe),
      .DOUT       (dru_dout));


  sdi_slave SDI_SLV (

  .clk			(tb_clk_dly),
  .rst			(tb_rst),
  .rx_ce_out            (w_rx_ce_out),      
  .rx_mode_locked	(w_rx_mode_locked),
  .rx_t_locked		(w_rx_t_locked),
  .rx_t_family		(w_rx_t_family	),
  .rx_t_rate		(w_rx_t_rate	),
  .rx_t_scan		(w_rx_t_scan	),
  .rx_level_b_3g	(w_rx_level_b_3g), 
  .rx_mode		(w_rx_mode	),
  .rx_mode_hd		(w_rx_mode_hd	),
  .rx_mode_sd		(w_rx_mode_sd	),
  .rx_mode_3g		(w_rx_mode_3g	),
  .rx_mode_6g		(w_rx_mode_6g	),
  .rx_mode_12g		(w_rx_mode_12g	),
  .rx_eav               (w_rx_eav),
  .rx_sav               (w_rx_sav),  
  .rx_trs               (w_rx_trs),
  .rx_ds1               (w_rx_ds1 ),      
  .rx_ds2               (w_rx_ds2 ),      
  .rx_ds3               (w_rx_ds3 ),      
  .rx_ds4               (w_rx_ds4 ),      
  .rx_ds5               (w_rx_ds5 ),      
  .rx_ds6               (w_rx_ds6 ),      
  .rx_ds7               (w_rx_ds7 ),      
  .rx_ds8               (w_rx_ds8 ),      
  .rx_ds9               (w_rx_ds9 ),      
  .rx_ds10              (w_rx_ds10),      
  .rx_ds11              (w_rx_ds11),      
  .rx_ds12              (w_rx_ds12),      
  .rx_ds13              (w_rx_ds13),      
  .rx_ds14              (w_rx_ds14),      
  .rx_ds15              (w_rx_ds15),      
  .rx_ds16              (w_rx_ds16),      

  .rx_ln_ds1		(w_rx_ln_ds1 ),
  .rx_ln_ds2		(w_rx_ln_ds2 ),
  .rx_ln_ds3		(w_rx_ln_ds3 ),
  .rx_ln_ds4		(w_rx_ln_ds4 ),
  .rx_ln_ds5		(w_rx_ln_ds5 ),
  .rx_ln_ds6		(w_rx_ln_ds6 ),
  .rx_ln_ds7		(w_rx_ln_ds7 ),
  .rx_ln_ds8		(w_rx_ln_ds8 ),
  .rx_ln_ds9		(w_rx_ln_ds9 ),
  .rx_ln_ds10		(w_rx_ln_ds10),
  .rx_ln_ds11		(w_rx_ln_ds11),
  .rx_ln_ds12		(w_rx_ln_ds12),
  .rx_ln_ds13		(w_rx_ln_ds13),
  .rx_ln_ds14		(w_rx_ln_ds14),
  .rx_ln_ds15		(w_rx_ln_ds15),
  .rx_ln_ds16		(w_rx_ln_ds16),
  .rx_crc_err_ds1       (w_rx_crc_err_ds1 ),      
  .rx_crc_err_ds2       (w_rx_crc_err_ds2 ),      
  .rx_crc_err_ds3       (w_rx_crc_err_ds3 ),      
  .rx_crc_err_ds4       (w_rx_crc_err_ds4 ),      
  .rx_crc_err_ds5       (w_rx_crc_err_ds5 ),      
  .rx_crc_err_ds6       (w_rx_crc_err_ds6 ),      
  .rx_crc_err_ds7       (w_rx_crc_err_ds7 ),      
  .rx_crc_err_ds8       (w_rx_crc_err_ds8 ),      
  .rx_crc_err_ds9       (w_rx_crc_err_ds9 ),      
  .rx_crc_err_ds10      (w_rx_crc_err_ds10),      
  .rx_crc_err_ds11      (w_rx_crc_err_ds11),      
  .rx_crc_err_ds12      (w_rx_crc_err_ds12),      
  .rx_crc_err_ds13      (w_rx_crc_err_ds13),      
  .rx_crc_err_ds14      (w_rx_crc_err_ds14),      
  .rx_crc_err_ds15      (w_rx_crc_err_ds15),      
  .rx_crc_err_ds16      (w_rx_crc_err_ds16),      
  .rx_st352_0           (w_rx_st352_0      ),      
  .rx_st352_0_valid     (w_rx_st352_0_valid),      
  .rx_st352_1           (w_rx_st352_1      ),      
  .rx_st352_1_valid     (w_rx_st352_1_valid),      
  .rx_st352_2           (w_rx_st352_2      ),      
  .rx_st352_2_valid     (w_rx_st352_2_valid),      
  .rx_st352_3           (w_rx_st352_3      ),      
  .rx_st352_3_valid     (w_rx_st352_3_valid),      
  .rx_st352_4           (w_rx_st352_4      ),      
  .rx_st352_4_valid     (w_rx_st352_4_valid),      
  .rx_st352_5           (w_rx_st352_5      ),      
  .rx_st352_5_valid     (w_rx_st352_5_valid),      
  .rx_st352_6           (w_rx_st352_6      ),      
  .rx_st352_6_valid     (w_rx_st352_6_valid),      
  .rx_st352_7           (w_rx_st352_7      ),      
  .rx_st352_7_valid     (w_rx_st352_7_valid),      
  .rx_mode_enable       (w_rx_mode_enable), 
  .rx_mode_detect_en    (w_rx_mode_detect_en),      
  .rx_forced_mode       (w_rx_forced_mode   ),      
  .rx_active_streams    (w_rx_active_streams),
           
  .tx_line_ch0          (w_tx_line_ch0),          
  .tx_line_ch1          (w_tx_line_ch1),
  .tx_line_ch2          (w_tx_line_ch2),
  .tx_line_ch3          (w_tx_line_ch3),
  .tx_line_ch4          (w_tx_line_ch4),
  .tx_line_ch5          (w_tx_line_ch5),
  .tx_line_ch6          (w_tx_line_ch6),
  .tx_line_ch7          (w_tx_line_ch7),
  .tx_insert_ln         (w_tx_insert_ln),
  .tx_line_no  	        (w_tx_line_no ),        
  .tx_mux_pattern	(w_tx_mux_pattern	),

  .mst_rx_t_family      (w_mst_rx_t_family),
  .mst_rx_t_rate        (w_mst_rx_t_rate  ),
  .mst_rx_t_scan        (w_mst_rx_t_scan  ),
  .mst_tx_insert_crc    (w_tx_insert_crc),      
  .mst_tx_mode          (w_tx_mode  )

  );

  assign #1 tb_clk_dly = tb_clk;


//==========================================================

//======================================================================
// UHD SDI DUT INSTANTIATION STARTS


v_smpte_uhdsdi_rxtx DUT ( 
    // RX Ports
    .rx_clk                   (tb_clk_dly),      //input                      rxusrclk input
    .rx_rst                   (tb_rst),      //input                      sync reset input
    .rx_mode_detect_rst       (tb_rst),      //input                      synchronous reset for SDI mode detection function    
    .rx_data_in               (w_rx_data_in),      //input  [DATA_WIDTH-1:0]    raw data from GTX RXDATA port, in SD mode, the 10 LSBs must be driven by the DRU output
    .rx_sd_data_strobe        (w_rx_sd_data_strobe),      //input                      asserted high when SD data is available on data_in
    .rx_frame_en              (1'b1),      //input                      1 = enable framer position update
    .rx_bit_rate              (w_rx_bit_rate),      //input                      1 = 1000/1001 bit rate, 0 = 1000/1000 bit rate
    .rx_mode_enable           (w_rx_mode_enable),      //input  [5:0]               unary enable bits for SDI mode search {12G/1.001, 12G/1, 6G, 3G, SD, HD} 1=enable, 0=disable
    .rx_mode_detect_en        (w_rx_mode_detect_en),      //input                      1 enables SDI mode detection
    .rx_forced_mode           (w_rx_forced_mode   ),      //input  [2:0]               if mode_detect_en=0, this port specifies the SDI mode of the RX
    .rx_ready                 (1'h1),      //input                      when 0, prevents the SDI mode search from running -- JJ used to indicate clock stabe should go low when changing clock and assert it back when clock is stable
    .rx_mode                  (w_rx_mode),      //output [2:0]               000=HD, 001=SD, 010=3G, 100=6G, 101=12G   
    .rx_mode_hd               (w_rx_mode_hd ),      //output                     1 = HD mode      
    .rx_mode_sd               (w_rx_mode_sd ),      //output                     1 = SD mode
    .rx_mode_3g               (w_rx_mode_3g ),      //output                     1 = 3G mode



 // Review to be Done
    .rx_mode_locked           (w_rx_mode_locked),      //output                     auto mode detection locked
    .rx_t_locked              (w_rx_t_locked),      //output                     transport format detection locked
    .rx_t_family              (w_rx_t_family),      //output [3:0]               transport format family
    .rx_t_rate                (w_rx_t_rate),      //output [3:0]               transport frame rate
    .rx_t_scan                (w_rx_t_scan),      //output                     transport scan: 0=interlaced, 1=progressive
    .rx_level_b_3g            (w_rx_level_b_3g),      //output                     0 = level A, 1 = level B
    .rx_ce_out                (w_rx_ce_out),      //output [NUM_RX_CE-1:0]     clock enable
    .rx_active_streams        (w_rx_active_streams),      //output [2:0]		    2^active_streams = number of active streams
    .rx_ln_ds1                (w_rx_ln_ds1 ),      //output [10:0]              line number for ds1
    .rx_ln_ds2                (w_rx_ln_ds2 ),      //output [10:0]              line number for ds2
    .rx_ln_ds3                (w_rx_ln_ds3 ),      //output [10:0]              line number for ds3
    .rx_ln_ds4                (w_rx_ln_ds4 ),      //output [10:0]              line number for ds4
    .rx_st352_0               (w_rx_st352_0),      //output [31:0]              video payload ID packet ds1 (for 3G-SDI level A, Y VPID)
    .rx_st352_0_valid         (w_rx_st352_0_valid),      //output                     1 = st352_0 is valid
    .rx_st352_1               (w_rx_st352_1      ),      //output [31:0]              video payload ID packet ds3 (ds2 for 3G-SDI level A, C VPID) 
    .rx_st352_1_valid         (w_rx_st352_1_valid),      //output                     1 = st352_1 is valid
    .rx_crc_err_ds1           (w_rx_crc_err_ds1 ),      //output                     CRC error for ds1
    .rx_crc_err_ds2           (w_rx_crc_err_ds2 ),      //output                     CRC error for ds2
    .rx_crc_err_ds3           (w_rx_crc_err_ds3 ),      //output                     CRC error for ds3
    .rx_crc_err_ds4           (w_rx_crc_err_ds4 ),      //output                     CRC error for ds4
    .rx_ds1                   (w_rx_ds1 ),      //output [9:0]               SD=Y/C, HD=Y, 3GA=ds1, 3GB=Y link A, 6G/12G=ds1
    .rx_ds2                   (w_rx_ds2 ),      //output [9:0]               HD=C, 3GA=ds2, 3GB=C link A, 6G/12G=ds2
    .rx_ds3                   (w_rx_ds3 ),      //output [9:0]               3GB=Y link B, 6G/12G=ds3
    .rx_ds4                   (w_rx_ds4 ),      //output [9:0]               3GB=C link B, 6G/12G=ds4
    .rx_eav                   (w_rx_eav),      //output                     EAV
    .rx_sav                   (w_rx_sav),      //output                     SAV
    .rx_trs                   (w_rx_trs),      //output                     TRS
    .rx_edh_errcnt_en         (16'b0),      //input  [15:0]              enables various error to increment rx_edh_errcnt
    .rx_edh_clr_errcnt        (1'b0),      //input                      clears rx_edh_errcnt
    .rx_edh_ap                (),      //output                     1 = AP CRC error detected previous field
    .rx_edh_ff                (),      //output                     1 = FF CRC error detected previous field
    .rx_edh_anc               (),      //output                     1 = ANC checksum error detected
    .rx_edh_ap_flags          (),      //output [4:0]               EDH AP flags received in last EDH packet
    .rx_edh_ff_flags          (),      //output [4:0]               EDH FF flags received in last EDH packet
    .rx_edh_anc_flags         (),      //output [4:0]               EDH ANC flags received in last EDH packet
    .rx_edh_packet_flags      (),      //output [3:0]               EDH packet error condition flags
    .rx_edh_errcnt            (),      //output [EDH_ERR_WIDTH-1:0] EDH error counter

    // TX Ports
    .tx_clk                   (tb_clk_dly),      //input  wire        txusrclk
    .tx_ce                    (w_tx_ce),      //input  wire        clock enable
    .tx_sd_ce                 (w_tx_sd_ce),      //input  wire        SD-SDI clock enable, must be High in all other modes
    .tx_edh_ce                (w_tx_edh_ce),      //input  wire        EDH clock enable, recommended Low in all modes except SD-SDI
    .tx_rst                   (tb_rst),      //input  wire        sync reset input
    .tx_mode                  (w_tx_mode),      //input  wire [2:0]  SDI mode
    .tx_insert_crc            (w_tx_insert_crc),      //input  wire        1 = insert CRC for HD and 3G
    .tx_insert_ln             (w_tx_insert_ln),      //input  wire        1 = insert LN for HD and 3G
    .tx_insert_st352          (w_tx_insert_st352),      //input  wire        1 = insert st352 PID pakcets
    .tx_overwrite_st352       (w_tx_overwrite_st352),      //input  wire        1 = overwrite existing ST 352 packets
    .tx_insert_edh            (w_tx_insert_edh),      //input  wire        1 = generate & insert EDH packets in SD-SDI mode
    .tx_mux_pattern           (w_tx_mux_pattern),      //input  wire [2:0]  specifies the multiplex interleave pattern of data streams
    .tx_insert_sync_bit       (w_tx_insert_sync_bit),      //input  wire        1 enables sync bit insertion
    .tx_sd_bitrep_bypass      (w_tx_sd_bitrep_bypass),      //input  wire        1 bypasses the SD-SDI 11X bit replicator
    .tx_line_ch0              (w_tx_line_ch0),      //input  wire [10:0] current line number for ds1 & ds2
    .tx_line_ch1              (w_tx_line_ch1),      //input  wire [10:0] current line number for ds3 & ds4
    .tx_st352_line_f1         (w_tx_st352_line_f1),      //input  wire [10:0] line number in field 1 to insert ST 352
    .tx_st352_line_f2         (w_tx_st352_line_f2),      //input  wire [10:0] line number in field 2 to insert ST 352
    .tx_st352_f2_en           (w_tx_st352_f2_en),      //input  wire        1 = insert packets on st352_line_f2 line
    .tx_st352_data_ch0        (w_tx_st352_data_ch0),      //input  wire [31:0] ST352 data bytes for ds1 {byte4, byte3, byte2, byte1} 
    .tx_st352_data_ch1        (w_tx_st352_data_ch1),      //input  wire [31:0] ST352 data bytes for ds3 (and ds2 in 3GA mode) {byte4, byte3, byte2, byte1} 
    .tx_ds1_in                (w_tx_ds1_in),      //input  wire [9:0]  data stream 1 (Y) in -- only active ds in SD, Y for HD & 3GA, AY for 3GB
    .tx_ds2_in                (w_tx_ds2_in),      //input  wire [9:0]  data stream 2 (C) in -- C for HD & 3GA, AC for 3GB
    .tx_ds3_in                (w_tx_ds3_in),      //input  wire [9:0]  data stream 3 (Y) in -- BY for 3GB
    .tx_ds4_in                (w_tx_ds4_in),      //input  wire [9:0]  data stream 4 (C) in -- BC for 3GB
    .tx_ds1_st352_out         (w_tx_ds1_st352_out ),      //output wire [9:0]  data stream 1 after ST352 insertion
    .tx_ds2_st352_out         (w_tx_ds2_st352_out ),      //output wire [9:0]  data stream 2 after ST352 insertion
    .tx_ds3_st352_out         (w_tx_ds3_st352_out ),      //output wire [9:0]  data stream 3 after ST352 insertion
    .tx_ds4_st352_out         (w_tx_ds4_st352_out ),      //output wire [9:0]  data stream 4 after ST352 insertion
    .tx_ds1_anc_in            (w_tx_ds1_st352_out ),      //input  wire [9:0]  data stream 1 after ANC insertion input
    .tx_ds2_anc_in            (w_tx_ds2_st352_out ),      //input  wire [9:0]  data stream 2 after ANC isnertion input
    .tx_ds3_anc_in            (w_tx_ds3_st352_out ),      //input  wire [9:0]  data stream 3 after ANC isnertion input
    .tx_ds4_anc_in            (w_tx_ds4_st352_out ),      //input  wire [9:0]  data stream 4 after ANC isnertion input
    .tx_use_anc_in            (w_tx_use_anc_in),      //input  wire        use the dsX_anc_in ports
    .tx_txdata                (w_tx_txdata),      //output wire [DATA_WIDTH-1:0] output data stream to GT TXDATA port
    .tx_ce_align_err          ()       //output wire 1 if ce 5/6/5/6 cadence is broken in SD-SDI mode
);


// UHD SDI DUT INSTANTIATION ENDS
//======================================================================

endmodule

