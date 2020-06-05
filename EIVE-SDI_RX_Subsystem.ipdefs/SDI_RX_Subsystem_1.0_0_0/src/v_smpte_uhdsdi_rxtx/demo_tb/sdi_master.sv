
//====================================================================
//  This module drives the SDI Tx core 
//====================================================================

`timescale 1ns / 1ps


module sdi_master (

  input clk,
  input rst,
  output logic tx_ce,
  output logic tx_sd_ce,
  output logic tx_edh_ce,
  output logic [2:0] tx_mode,
  output logic tx_insert_crc,
  output logic tx_insert_ln,
  output logic tx_insert_st352,
  output logic tx_overwrite_st352,
  output logic tx_insert_edh,
  output logic [2:0] tx_mux_pattern,
  output logic tx_insert_sync_bit,
  output logic tx_sd_bitrep_bypass,
  output logic [10:0] tx_st352_line_f1, 
  output logic [10:0] tx_st352_line_f2, 
  output logic tx_st352_f2_en,
  output logic [9:0] tx_ds1_in, 
  output logic [9:0] tx_ds2_in, 
  output logic [9:0] tx_ds3_in, 
  output logic [9:0] tx_ds4_in, 
  output logic [9:0] tx_ds5_in, 
  output logic [9:0] tx_ds6_in, 
  output logic [9:0] tx_ds7_in, 
  output logic [9:0] tx_ds8_in, 
  output logic [9:0] tx_ds9_in, 
  output logic [9:0] tx_ds10_in, 
  output logic [9:0] tx_ds11_in, 
  output logic [9:0] tx_ds12_in, 
  output logic [9:0] tx_ds13_in, 
  output logic [9:0] tx_ds14_in, 
  output logic [9:0] tx_ds15_in, 
  output logic [9:0] tx_ds16_in, 
  output logic [31:0] tx_st352_data_ch0, 
  output logic [31:0] tx_st352_data_ch1, 
  output logic [31:0] tx_st352_data_ch2, 
  output logic [31:0] tx_st352_data_ch3, 
  output logic [31:0] tx_st352_data_ch4, 
  output logic [31:0] tx_st352_data_ch5, 
  output logic [31:0] tx_st352_data_ch6, 
  output logic [31:0] tx_st352_data_ch7, 
  output logic [10:0] tx_line_ch0,
  output logic [10:0] tx_line_ch1,
  output logic [10:0] tx_line_ch2,
  output logic [10:0] tx_line_ch3,
  output logic [10:0] tx_line_ch4,
  output logic [10:0] tx_line_ch5,
  output logic [10:0] tx_line_ch6,
  output logic [10:0] tx_line_ch7,
  output logic [10:0] tx_line_no,
  output logic        tx_use_anc_in,

  // Information needed by slv for checking        

  output logic [3:0]  mst_rx_t_family,
  output logic [3:0]  mst_rx_t_rate,
  output logic        mst_rx_t_scan,
  input  logic [2:0]    rx_mode,
  output logic        rx_bit_rate    

);

  // Signal declaration
  logic [13:0] active_sample,total_sample,sample;
  logic [10:0] line_no,sd_line_no,first_active; 
  logic [9:0] sd_xyz,xyz; 
  logic sd_v,v,sd_h,h,f;
  logic config_done;
  logic [9:0] tx_data,tx_sd_ds,tx_sd1,tx_sd2; 
  logic [1:0] ce_cnt; 
  int data_stream; 
  logic level_3G;
  integer sd_cdnc_cnt;
  logic sd_cdnc_flag;  // 0 : Cadence 5 1: Cadence 6 
  logic mode_ce;
  logic [2:0]    rx_mode_chk;
  logic [31:0] tx_st352_data; 
  logic [9:0] y, c;

localparam logic [2:0]
    MODE_HD = 3'b000,
    MODE_SD = 3'b001,
    MODE_3G = 3'b010,
    MODE_6G = 3'b100,
    MODE_12G = 3'b101,
    MODE_12G_1 = 3'b110;

localparam logic [7:0]
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

  initial
  begin
    tx_insert_crc = 1'h0;
    tx_insert_ln = 1'h0;
    tx_insert_st352 = 1'h0;
    tx_overwrite_st352 = 1'h0;
    tx_st352_line_f1 = 11'h0;
    tx_st352_line_f2 = 11'h0;
    tx_st352_f2_en = 1'h0;
    tx_insert_edh = 1'h0;
    tx_insert_sync_bit = 1'h0;
    tx_sd_bitrep_bypass = 1'h1;
    tx_use_anc_in = 1'h0;
    f = 1'h0;
    tx_st352_data = 32'h1234;
    y = 10'h3AC;
    c = 10'h3C0;

    tx_st352_data_ch0 = 32'h0;
    tx_st352_data_ch1 = 32'h0;
    tx_st352_data_ch2 = 32'h0;
    tx_st352_data_ch3 = 32'h0;
    tx_st352_data_ch4 = 32'h0;
    tx_st352_data_ch5 = 32'h0;
    tx_st352_data_ch6 = 32'h0;
    tx_st352_data_ch7 = 32'h0;
  end

  // Needed only for SD mode

  task insert_edh();
  begin
    tx_insert_edh = 1'h1;
  end
  endtask 

  task insert_st352(input logic [2:0] mode, input logic [10:0] line_no, input logic field = 1'h0);
  begin
    tx_insert_st352 = 1'h1;
    tx_overwrite_st352 = 1'h1;
    if(field == 1'h0)   //Progressive or Interlaced field 1
    begin  
      tx_st352_f2_en = 1'h0;
      tx_st352_line_f1 = line_no;
    end
    else                //interlaced field 2 
    begin
      tx_st352_f2_en = 1'h1;
      tx_st352_line_f2 = line_no;
    end

    tb_v_smpte_uhdsdi_rxtx.rst_gen();
  end
  endtask 

  task insert_line();
  begin
    tx_insert_ln = 1'h1;
  end
  endtask 

  task insert_sync_bit();
  begin 
    tx_insert_sync_bit = 1'h1;
  end
  endtask 

  task insert_crc();
  begin
    tx_insert_crc = 1'h1;
  end
  endtask 

  task use_anc();
  begin
    tx_use_anc_in = 1'h1;
  end
  endtask

task Video_CFG(input logic [7:0] format, input logic field = 1'h0);
begin
    if(field == 1'h0) 
    begin
      case(format)
        VID_1080i60 : first_active = 11'd21;
        VID_1080i59_94 : first_active = 11'd21;
        VID_1080i50 : first_active = 11'd21;
        VID_1080p30 : first_active = 11'd42;
        VID_1080p29_97 : first_active = 11'd42;
        VID_1080p25 : first_active = 11'd42;
        VID_1080p24 : first_active = 11'd42;
        VID_1080p23_98 : first_active = 11'd42;
        VID_720p60 : first_active = 11'd26;
        VID_720p59_94 : first_active = 11'd26;
        VID_720p50 : first_active = 11'd26;
        VID_720p30 : first_active = 11'd26;
        VID_720p29_97 : first_active = 11'd26;
        VID_720p25 : first_active = 11'd26;
        VID_720p24 : first_active = 11'd26;
        VID_720p23_98 : first_active = 11'd26;
        VID_2K_1080p30 : first_active = 11'd42;
        VID_2K_1080p29_97 : first_active = 11'd42;
        VID_2K_1080p25 : first_active = 11'd42;
        VID_2K_1080p24 : first_active = 11'd42;
        VID_2K_1080p23_98 : first_active = 11'd42;
        VID_1080p60 : first_active = 11'd42;
        VID_1080p59_94 : first_active = 11'd42;
        VID_1080p50 : first_active = 11'd42;
        VID_2K_1080p60 : first_active = 11'd42;
        VID_2K_1080p59_94 : first_active = 11'd42;
        VID_2K_1080p50 : first_active = 11'd42;
        VID_2K_1080p48 : first_active = 11'd42;
        VID_2K_1080p47_95 : first_active = 11'd42;
        VID_NTSC : first_active = 11'd20;
        VID_PAL : first_active = 11'd23;

      endcase
      f = 1'h0;
    end 
    else
    begin
      case(format)
        VID_1080i60 : first_active = 11'd584;
        VID_1080i59_94 : first_active = 11'd584;
        VID_1080i50 : first_active = 11'd584;
        VID_1080p30 : first_active = 11'd42;
        VID_1080p29_97 : first_active = 11'd42;
        VID_1080p25 : first_active = 11'd42;
        VID_1080p24 : first_active = 11'd42;
        VID_1080p23_98 : first_active = 11'd42;
        VID_720p60 : first_active = 11'd26;
        VID_720p59_94 : first_active = 11'd26;
        VID_720p50 : first_active = 11'd26;
        VID_720p30 : first_active = 11'd26;
        VID_720p29_97 : first_active = 11'd26;
        VID_720p25 : first_active = 11'd26;
        VID_720p24 : first_active = 11'd26;
        VID_720p23_98 : first_active = 11'd26;
        VID_2K_1080p30 : first_active = 11'd42;
        VID_2K_1080p29_97 : first_active = 11'd42;
        VID_2K_1080p25 : first_active = 11'd42;
        VID_2K_1080p24 : first_active = 11'd42;
        VID_2K_1080p23_98 : first_active = 11'd42;
        VID_1080p60 : first_active = 11'd42;
        VID_1080p59_94 : first_active = 11'd42;
        VID_1080p50 : first_active = 11'd42;
        VID_2K_1080p60 : first_active = 11'd42;
        VID_2K_1080p59_94 : first_active = 11'd42;
        VID_2K_1080p50 : first_active = 11'd42;
        VID_2K_1080p48 : first_active = 11'd42;
        VID_2K_1080p47_95 : first_active = 11'd42;
        VID_NTSC : first_active = 11'd283;
        VID_PAL : first_active = 11'd336;
      endcase
      f = 1'h1;
    end

      $display("SDI MASTER :: ======================================================");
      case(format)
        VID_1080i60 : begin
                       total_sample = 14'd2200;
                       active_sample = 14'd1920;
                       mst_rx_t_family = 4'b0000;    // SMPTE ST 274 1920X1080
                       mst_rx_t_rate   = 4'b0111;    // 30 Hz 
                       mst_rx_t_scan   = 1'b0;       // Interlaced
                       rx_bit_rate     = 1'b0;       // 1.485 Gb/s
                       $display("SDI MASTER :: Video Format -  1920x1080 Interlaced 30Hz %0s configured",(f == 1'h0)?"Field 1":"Field 2");
                      end
        VID_1080i59_94 : begin
                       total_sample = 14'd2200;
                       active_sample = 14'd1920;
                       mst_rx_t_family = 4'b0000;    // SMPTE ST 274 1920X1080
                       mst_rx_t_rate   = 4'b0110;    // 30/1.001 Hz 
                       mst_rx_t_scan   = 1'b0;       // Interlaced
                       rx_bit_rate     = 1'b1;       // 1.485/1.001 Gb/s
                       $display("SDI MASTER :: Video Format -  1920x1080 Interlaced 29.97Hz %0s configured",(f == 1'h0)?"Field 1":"Field 2");
                      end
        VID_1080i50 : begin
                       total_sample = 14'd2640;
                       active_sample = 14'd1920;
                       mst_rx_t_family = 4'b0000;    // SMPTE ST 274 1920X1080
                       mst_rx_t_rate   = 4'b0101;    // 25 Hz 
                       mst_rx_t_scan   = 1'b0;       // Interlaced
                       rx_bit_rate     = 1'b0;       // 1.485/s
                       $display("SDI MASTER :: Video Format -  1920x1080 Interlaced 25Hz %0s configured",(f == 1'h0)?"Field 1":"Field 2");
                      end
        VID_1080p30 : begin
                       total_sample = 14'd2200;
                       active_sample = 14'd1920;
                       mst_rx_t_family = 4'b0000;    // SMPTE ST 274 1920X1080
                       mst_rx_t_rate   = 4'b0111;    // 30 Hz 
                       mst_rx_t_scan   = 1'b1;       // Progressive
                       rx_bit_rate     = 1'b0;       // 1.485 Gb/s
                       $display("SDI MASTER :: Video Format -  1920x1080 Progressive 30Hz configured");
                      end
        VID_1080p29_97 : begin
                       total_sample = 14'd2200;
                       active_sample = 14'd1920;
                       mst_rx_t_family = 4'b0000;    // SMPTE ST 274 1920X1080
                       mst_rx_t_rate   = 4'b0110;    // 29.97 Hz 
                       mst_rx_t_scan   = 1'b1;       // Progressive
                       rx_bit_rate     = 1'b1;       // 1.485/1.001 Gb/s
                       $display("SDI MASTER :: Video Format -  1920x1080 Progressive 29.97Hz configured");
                      end
        VID_1080p25 : begin
                       total_sample = 14'd2640;
                       active_sample = 14'd1920;
                       mst_rx_t_family = 4'b0000;    // SMPTE ST 274 1920X1080
                       mst_rx_t_rate   = 4'b0101;    // 25 Hz 
                       mst_rx_t_scan   = 1'b1;       // Progressive
                       rx_bit_rate     = 1'b0;       // 1.485 Gb/s
                       $display("SDI MASTER :: Video Format -  1920x1080 Progressive 25Hz configured");
                      end
        VID_1080p24 : begin
                       total_sample = 14'd2750;
                       active_sample = 14'd1920;
                       mst_rx_t_family = 4'b0000;    // SMPTE ST 274 1920X1080
                       mst_rx_t_rate   = 4'b0011;    // 24 Hz 
                       mst_rx_t_scan   = 1'b1;       // Progressive
                       rx_bit_rate     = 1'b0;       // 1.485 Gb/s
                       $display("SDI MASTER :: Video Format -  1920x1080 Progressive 24Hz configured");
                      end
        VID_1080p23_98 : begin
                       total_sample = 14'd2750;
                       active_sample = 14'd1920;
                       mst_rx_t_family = 4'b0000;    // SMPTE ST 274 1920X1080
                       mst_rx_t_rate   = 4'b0010;    // 23.98 Hz 
                       mst_rx_t_scan   = 1'b1;       // Progressive
                       rx_bit_rate     = 1'b1;       // 1.485/1.001 Gb/s
                       $display("SDI MASTER :: Video Format -  1920x1080 Progressive 23.98Hz configured");
                      end
        VID_720p60 : begin
                       total_sample = 14'd1650;
                       active_sample = 14'd1280;
                       mst_rx_t_family = 4'b0001;    // SMPTE ST 296 1280X720
                       mst_rx_t_rate   = 4'b1011;    // 60 Hz 
                       mst_rx_t_scan   = 1'b1;       // Progressive
                       rx_bit_rate     = 1'b0;       // 1.485 Gb/s
                       $display("SDI MASTER :: Video Format -  1280X720 Progressive 60Hz configured");
                      end
        VID_720p59_94 : begin
                       total_sample = 14'd1650;
                       active_sample = 14'd1280;
                       mst_rx_t_family = 4'b0001;    // SMPTE ST 296 1280X720
                       mst_rx_t_rate   = 4'b1010;    // 59.94 Hz 
                       mst_rx_t_scan   = 1'b1;       // Progressive
                       rx_bit_rate     = 1'b1;       // 1.485/1.001 Gb/s
                       $display("SDI MASTER :: Video Format -  1280X720 Progressive 59.94Hz configured");
                      end
        VID_720p50 : begin
                       total_sample = 14'd1980;
                       active_sample = 14'd1280;
                       mst_rx_t_family = 4'b0001;    // SMPTE ST 296 1280X720
                       mst_rx_t_rate   = 4'b1001;    // 50 Hz 
                       mst_rx_t_scan   = 1'b1;       // Progressive
                       rx_bit_rate     = 1'b0;       // 1.485 Gb/s
                       $display("SDI MASTER :: Video Format -  1280X720 Progressive 50Hz configured");
                      end
        VID_720p30 : begin
                       total_sample = 14'd3300;
                       active_sample = 14'd1280;
                       mst_rx_t_family = 4'b0001;    // SMPTE ST 296 1280X720
                       mst_rx_t_rate   = 4'b0111;    // 30 Hz 
                       mst_rx_t_scan   = 1'b1;       // Progressive
                       rx_bit_rate     = 1'b0;       // 1.485 Gb/s
                       $display("SDI MASTER :: Video Format -  1280X720 Progressive 30Hz configured");
                      end
        VID_720p29_97 : begin
                       total_sample = 14'd3300;
                       active_sample = 14'd1280;
                       mst_rx_t_family = 4'b0001;    // SMPTE ST 296 1280X720
                       mst_rx_t_rate   = 4'b0110;    // 29.97 Hz 
                       mst_rx_t_scan   = 1'b1;       // Progressive
                       rx_bit_rate     = 1'b1;       // 1.485/1.001 Gb/s
                       $display("SDI MASTER :: Video Format -  1280X720 Progressive 29.97Hz configured");
                      end
        VID_720p25 : begin
                       total_sample = 14'd3960;
                       active_sample = 14'd1280;
                       mst_rx_t_family = 4'b0001;    // SMPTE ST 296 1280X720
                       mst_rx_t_rate   = 4'b0101;    // 25 Hz 
                       mst_rx_t_scan   = 1'b1;       // Progressive
                       rx_bit_rate     = 1'b0;       // 1.485 Gb/s
                       $display("SDI MASTER :: Video Format -  1280X720 Progressive 25Hz configured");
                      end
        VID_720p24 : begin
                       total_sample = 14'd4125;
                       active_sample = 14'd1280;
                       mst_rx_t_family = 4'b0001;    // SMPTE ST 296 1280X720
                       mst_rx_t_rate   = 4'b0011;    // 24 Hz 
                       mst_rx_t_scan   = 1'b1;       // Progressive
                       rx_bit_rate     = 1'b0;       // 1.485 Gb/s
                       $display("SDI MASTER :: Video Format -  1280X720 Progressive 24Hz configured");
                      end
        VID_720p23_98 : begin
                       total_sample = 14'd4125;
                       active_sample = 14'd1280;
                       mst_rx_t_family = 4'b0001;    // SMPTE ST 296 1280X720
                       mst_rx_t_rate   = 4'b0010;    // 23.98 Hz 
                       mst_rx_t_scan   = 1'b1;       // Progressive
                       rx_bit_rate     = 1'b1;       // 1.485/1.001 Gb/s
                       $display("SDI MASTER :: Video Format -  1280X720 Progressive 23.98Hz configured");
                      end
        VID_2K_1080p30 : begin
                       total_sample = 14'd2200;
                       active_sample = 14'd2048;
                       mst_rx_t_family = 4'b0010;    // SMPTE ST 2048-2
                       mst_rx_t_rate   = 4'b0111;    // 30 Hz 
                       mst_rx_t_scan   = 1'b1;       // Progressive
                       rx_bit_rate     = 1'b0;       // 1.485 Gb/s
                       $display("SDI MASTER :: Video Format -  2K 2048x1080 Progressive 30Hz configured");
                      end
        VID_2K_1080p29_97 : begin
                       total_sample = 14'd2200;
                       active_sample = 14'd2048;
                       mst_rx_t_family = 4'b0010;    // SMPTE ST 2048-2
                       mst_rx_t_rate   = 4'b0110;    // 29.97 Hz 
                       mst_rx_t_scan   = 1'b1;       // Progressive
                       rx_bit_rate     = 1'b1;       // 1.485/1.001 Gb/s
                       $display("SDI MASTER :: Video Format -  2K 2048x1080 Progressive 29.97Hz configured");
                      end
        VID_2K_1080p25 : begin
                       total_sample = 14'd2640;
                       active_sample = 14'd2048;
                       mst_rx_t_family = 4'b0010;    // SMPTE ST 2048-2
                       mst_rx_t_rate   = 4'b0101;    // 25 Hz 
                       mst_rx_t_scan   = 1'b1;       // Progressive
                       rx_bit_rate     = 1'b0;       // 1.485 Gb/s
                       $display("SDI MASTER :: Video Format -  2K 2048x1080 Progressive 25Hz configured");
                      end
        VID_2K_1080p24 : begin
                       total_sample = 14'd2750;
                       active_sample = 14'd2048;
                       mst_rx_t_family = 4'b0010;    // SMPTE ST 2048-2
                       mst_rx_t_rate   = 4'b0011;    // 24 Hz 
                       mst_rx_t_scan   = 1'b1;       // Progressive
                       rx_bit_rate     = 1'b0;       // 1.485 Gb/s
                       $display("SDI MASTER :: Video Format -  2K 2048x1080 Progressive 24Hz configured");
                      end
        VID_2K_1080p23_98 : begin
                       total_sample = 14'd2750;
                       active_sample = 14'd2048;
                       mst_rx_t_family = 4'b0010;    // SMPTE ST 2048-2
                       mst_rx_t_rate   = 4'b0010;    // 23.98 Hz 
                       mst_rx_t_scan   = 1'b1;       // Progressive
                       rx_bit_rate     = 1'b1;       // 1.485/1.001 Gb/s
                       $display("SDI MASTER :: Video Format -  2K 2048x1080 Progressive 23.98Hz configured");
                      end
        VID_1080p60 : begin
                       total_sample = 14'd2200;
                       active_sample = 14'd1920;
                       mst_rx_t_family = 4'b0000;    // SMPTE ST 274 1920X1080
                       mst_rx_t_rate   = 4'b1011;    // 60 Hz 
                       mst_rx_t_scan   = 1'b1;       // Progressive
                       rx_bit_rate     = 1'b0;       // 1.485 Gb/s
                       $display("SDI MASTER :: Video Format -  1920x1080 Progressive 60Hz configured");
                      end
        VID_1080p59_94 : begin
                       total_sample = 14'd2200;
                       active_sample = 14'd1920;
                       mst_rx_t_family = 4'b0000;    // SMPTE ST 274 1920X1080
                       mst_rx_t_rate   = 4'b1010;    // 59.94 Hz 
                       mst_rx_t_scan   = 1'b1;       // Progressive
                       rx_bit_rate     = 1'b1;       // 1.485/1.001 Gb/s
                       $display("SDI MASTER :: Video Format -  1920x1080 Progressive 59.94Hz configured");
                      end
        VID_1080p50 : begin
                       total_sample = 14'd2640;
                       active_sample = 14'd1920;
                       mst_rx_t_family = 4'b0000;    // SMPTE ST 274 1920X1080
                       mst_rx_t_rate   = 4'b1001;    // 50 Hz 
                       mst_rx_t_scan   = 1'b1;       // Progressive
                       rx_bit_rate     = 1'b0;       // 1.485 Gb/s
                       $display("SDI MASTER :: Video Format -  1920x1080 Progressive 50Hz configured");
                      end
        VID_2K_1080p60 : begin
                       total_sample = 14'd2200;
                       active_sample = 14'd2048;
                       mst_rx_t_family = 4'b0010;    // SMPTE ST 2048-2
                       mst_rx_t_rate   = 4'b1011;    // 60 Hz 
                       mst_rx_t_scan   = 1'b1;       // Progressive
                       rx_bit_rate     = 1'b0;       // 1.485 Gb/s
                       $display("SDI MASTER :: Video Format -  2K 2048x1080 Progressive 60Hz configured");
                      end
        VID_2K_1080p59_94 : begin
                       total_sample = 14'd2200;
                       active_sample = 14'd2048;
                       mst_rx_t_family = 4'b0010;    // SMPTE ST 2048-2
                       mst_rx_t_rate   = 4'b1010;    // 59.94 Hz 
                       mst_rx_t_scan   = 1'b1;       // Progressive
                       rx_bit_rate     = 1'b1;       // 1.485/1.001 Gb/s
                       $display("SDI MASTER :: Video Format -  2K 2048x1080 Progressive 59.94Hz configured");
                      end
        VID_2K_1080p50 : begin
                       total_sample = 14'd2640;
                       active_sample = 14'd2048;
                       mst_rx_t_family = 4'b0010;    // SMPTE ST 2048-2
                       mst_rx_t_rate   = 4'b1001;    // 50 Hz 
                       mst_rx_t_scan   = 1'b1;       // Progressive
                       rx_bit_rate     = 1'b0;       // 1.485 Gb/s
                       $display("SDI MASTER :: Video Format -  2K 2048x1080 Progressive 50Hz configured");
                      end
        VID_2K_1080p48 : begin
                       total_sample = 14'd2750;
                       active_sample = 14'd2048;
                       mst_rx_t_family = 4'b0010;    // SMPTE ST 2048-2
                       mst_rx_t_rate   = 4'b1000;    // 50 Hz 
                       mst_rx_t_scan   = 1'b1;       // Progressive
                       rx_bit_rate     = 1'b0;       // 1.485 Gb/s
                       $display("SDI MASTER :: Video Format -  2K 2048x1080 Progressive 48Hz configured");
                      end
        VID_2K_1080p47_95 : begin
                       total_sample = 14'd2750;
                       active_sample = 14'd2048;
                       mst_rx_t_family = 4'b0010;    // SMPTE ST 2048-2
                       mst_rx_t_rate   = 4'b0100;    // 47.95 Hz 
                       mst_rx_t_scan   = 1'b1;       // Progressive
                       rx_bit_rate     = 1'b1;       // 1.485/1.001 Gb/s
                       $display("SDI MASTER :: Video Format -  2K 2048x1080 Progressive 47.95Hz configured");
                      end
        VID_NTSC : begin
                       total_sample = 14'd1716;
                       active_sample = 14'd1440;
                       mst_rx_t_family = 4'b1000;    // NTSC
                       mst_rx_t_rate   = 4'b0110;    // 29.97 Hz 
                       mst_rx_t_scan   = 1'b0;       // Interlaced
                       rx_bit_rate     = 1'b1;       // 1.485 Gb/s
                       $display("SDI MASTER :: Video Format NTSC-  720x486 29.97Hz %0s configured",(f == 1'h0)?"Field 1":"Field 2");
                    end
        VID_PAL : begin
                       total_sample = 14'd1728;
                       active_sample = 14'd1440;
                       mst_rx_t_family = 4'b1001;    // PAL
                       mst_rx_t_rate   = 4'b0101;    // 25 Hz 
                       mst_rx_t_scan   = 1'b0;       // Interlaced
                       rx_bit_rate     = 1'b0;       // 1.485 Gb/s
                       $display("SDI MASTER :: Video Format PAL-  720x576 25Hz %0s configured",(f == 1'h0)?"Field 1":"Field 2");
                    end

      endcase
      $display("SDI MASTER :: ======================================================");
     
end
endtask


task HD_video(input logic [7:0] format, input logic field = 1'h0);
begin
   $display("SDI MASTER : Core configured for HD Video");

    Video_CFG(format, field); 

    tx_mode     = MODE_HD;
    tx_mux_pattern = 3'h0;
    data_stream =32'd2;
    rx_mode_chk = tx_mode;

    tb_v_smpte_uhdsdi_rxtx.rst_gen();
end
endtask

task video_3G(input logic [7:0] format,input logic level = 1'h0, input logic field = 1'h0);
begin

   $display("SDI MASTER : Core configured for 3G Video %0s",(level == 1'h0)?"LEVEL A":"LEVEL B");

    tx_mode     = MODE_3G;
    if(level == 1'h0)  
    begin 
      tx_mux_pattern = 3'h0;
      level_3G = 1'h0;
    end
    else if (level == 1'h1)
    begin
      tx_mux_pattern = 3'b001;
      level_3G = 1'h1;
    end
 
    Video_CFG(format, field); 
    insert_line();
    insert_crc();
    insert_st352(MODE_3G,first_active - 11'd2,0);
    rx_mode_chk = tx_mode;


    data_stream =32'd2;

    tb_v_smpte_uhdsdi_rxtx.rst_gen();
end
endtask


task video_6G(input logic [7:0] format,input logic[1:0] map_mode = 1'h1);

   $display("SDI MASTER : Core configured for 6G MAP mode %0d",map_mode);

   tx_mode = MODE_6G;
   if(map_mode == 2'h1)
   begin
     tx_mux_pattern = 3'b010;
   end
   else 
   begin
     tx_mux_pattern = 3'b011;
   end

   Video_CFG(format); 
   insert_line();
   insert_crc();
   insert_st352(MODE_6G,first_active - 11'd2,0);
   insert_sync_bit();
   rx_mode_chk = tx_mode;

   tb_v_smpte_uhdsdi_rxtx.rst_gen();

endtask

task video_12G(input logic [7:0] format,input logic[1:0] map_mode = 1'h1);

   $display("SDI MASTER : Core configured for 12G MAP mode %0d",map_mode);

   tx_mode = MODE_12G;
   if(map_mode == 2'h1)
   begin
     tx_mux_pattern = 3'b010;
   end
   else 
   begin
     tx_mux_pattern = 3'b100;
   end

   Video_CFG(format); 
   insert_line();
   insert_crc();
   insert_st352(MODE_12G,first_active - 11'd2,0);
   insert_sync_bit();
   if(rx_bit_rate == 1'h1)
   begin
     rx_mode_chk = 3'b110;
   end
   else
   begin
     rx_mode_chk = tx_mode;
   end

   tb_v_smpte_uhdsdi_rxtx.rst_gen();

endtask

task video_SD(input logic [7:0] format, input logic field = 1'h0);
begin

   $display("SDI MASTER : Core configured for SD Video");

    tx_mode     = MODE_SD;
    tx_mux_pattern = 3'h0;
    tx_sd_bitrep_bypass = 1'h0;
 
    Video_CFG(format,field); 
    insert_line();
    insert_crc();
    //insert_edh();
    insert_st352(MODE_3G,first_active - 11'd2,0);
    rx_mode_chk = tx_mode;

    tb_v_smpte_uhdsdi_rxtx.rst_gen();
end
endtask


//JJ
  always @(posedge clk)
  begin
    #1; 
    if(rst == 1'h1)
    begin
      sample <= 32'd0;
    end
    else if((mode_ce == 1'h1) && (rx_mode == rx_mode_chk))
    begin
      if(sample == total_sample - 32'd1)
        sample <= 32'd0;
      else
        sample <= sample + 32'd1;
    end
  end

  always @(posedge clk)
  begin
    #1; 
    if(rst == 1'h1) 
    begin
      line_no <= first_active - 15;
    end
    else if((sample == active_sample + 3 ) && (mode_ce == 1'h1) && (rx_mode == rx_mode_chk))
    begin
     line_no <= line_no + 1;
    end
  end


  //tx_ce generation for different mode
  // TODO 3G B mode need to finish
  //===================================
  always @(posedge clk)
  begin
    if(rst == 1'h1)
    begin
      tx_ce =1'h0;
      ce_cnt = 2'h0;
    end
    else
    begin
      if((tx_mux_pattern == 3'b010) || (tx_mux_pattern == 3'b001))
      begin
        if((ce_cnt == 2'h1) || (ce_cnt == 2'h3))
        begin
          tx_ce =1'h1;
        end
        else
        begin
          tx_ce =1'h0;
        end
      end
      else if(tx_mux_pattern == 3'b100)
      begin
        if(ce_cnt == 2'h1)
        begin
          tx_ce =1'h1;
        end
        else
        begin
          tx_ce =1'h0;
        end
      end
      else
      begin
        tx_ce =1'h1;
      end 
      ce_cnt = ce_cnt + 2'h1;
    end
  end 

 always @(negedge clk)
 begin
   if(rst == 1'h1)
   begin
     sd_cdnc_cnt = 32'd1;
   end
   else if (sd_cdnc_cnt == 32'd11)
   begin
     sd_cdnc_cnt = 32'd1;
   end 
   else
   begin
     sd_cdnc_cnt = sd_cdnc_cnt+32'd1;
   end 
 end  

  assign tx_sd_ce = (tx_mode == MODE_SD)?(((sd_cdnc_cnt == 32'd1) || (sd_cdnc_cnt == 32'd6))? clk: 1'd0):1'd1;
  assign tx_edh_ce =(tx_mode == MODE_SD)?(((sd_cdnc_cnt == 32'd1) || (sd_cdnc_cnt == 32'd6))? clk: 1'd0):1'd0;
  assign mode_ce = (tx_mode == MODE_SD)? tx_sd_ce: tx_ce;


//
// Generate the eav and sav timing signals at the appropriate place on each line
// by examining the sample counter.
//
  assign eav = (sample == active_sample+3);
  assign sav = (sample == total_sample-1);
  assign tx_line_no = line_no;
  assign tx_line_ch0 =(tx_insert_ln == 1)?line_no: 11'h0;
  assign tx_line_ch1 =((tx_insert_ln == 1) && ((tx_mux_pattern == 3'b001) || (tx_mux_pattern == 3'b011) || (tx_mux_pattern == 3'b010) || (tx_mux_pattern == 3'b100)))?line_no: 11'h0;
  assign tx_line_ch2 =((tx_insert_ln == 1) && ((tx_mux_pattern == 3'b010) || (tx_mux_pattern == 3'b100)))?line_no: 11'h0;
  assign tx_line_ch3 =((tx_insert_ln == 1) && ((tx_mux_pattern == 3'b010) || (tx_mux_pattern == 3'b100)))?line_no: 11'h0;
  assign tx_line_ch4 =((tx_insert_ln == 1) &&  (tx_mux_pattern == 3'b100))?line_no: 11'h0;
  assign tx_line_ch5 =((tx_insert_ln == 1) &&  (tx_mux_pattern == 3'b100))?line_no: 11'h0;
  assign tx_line_ch6 =((tx_insert_ln == 1) &&  (tx_mux_pattern == 3'b100))?line_no: 11'h0;
  assign tx_line_ch7 =((tx_insert_ln == 1) &&  (tx_mux_pattern == 3'b100))?line_no: 11'h0;


  always @(posedge clk)
  begin
   #1; 
   if(rst == 1'h1)
    begin
      v <= 1'h1;
    end
    else if((sample == active_sample) && (mode_ce == 1'h1) && (rx_mode == rx_mode_chk))
      v <= line_no < first_active -1; 
  end

  assign h = (sample < active_sample+6);
  assign xyz = {1'b1,f,v,h,v^h,f^h,f^v,f^v^h,2'b00};

  always @(posedge clk)
  begin
    #1; 
    if(rst == 1'h1)
    begin
      tx_ds1_in <= 10'h0;
      tx_ds2_in <= 10'h0;
      tx_ds3_in <= 10'h0;
      tx_ds4_in <= 10'h0;
      tx_ds5_in <= 10'h0;
      tx_ds6_in <= 10'h0;
      tx_ds7_in <= 10'h0;
      tx_ds8_in <= 10'h0;
      tx_ds9_in <= 10'h0;
      tx_ds10_in <= 10'h0;
      tx_ds11_in <= 10'h0;
      tx_ds12_in <= 10'h0;
      tx_ds13_in <= 10'h0;
      tx_ds14_in <= 10'h0;
      tx_ds15_in <= 10'h0;
      tx_ds16_in <= 10'h0;
    end
    else if ((mode_ce == 1'h1)  && (rx_mode == rx_mode_chk))
    begin 
      if(sample inside {active_sample,total_sample-4})
      begin
        tx_ds1_in <= 10'h3FF;
        tx_ds2_in <= 10'h3FF;
        if((tx_mux_pattern == 3'b001) || (tx_mux_pattern == 3'b011) || (tx_mux_pattern == 3'b010) || (tx_mux_pattern == 3'b100))
        begin
          tx_ds3_in <= 10'h3FF;
          tx_ds4_in <= 10'h3FF;
        end
        if ((tx_mux_pattern == 3'b010) || (tx_mux_pattern == 3'b100))
        begin
          tx_ds5_in <= 10'h3FF;
          tx_ds6_in <= 10'h3FF;
          tx_ds7_in <= 10'h3FF;
          tx_ds8_in <= 10'h3FF;
        end
        if (tx_mux_pattern == 3'b100)
        begin
          tx_ds9_in <= 10'h3FF;
          tx_ds10_in <= 10'h3FF;
          tx_ds11_in <= 10'h3FF;
          tx_ds12_in <= 10'h3FF;
          tx_ds13_in <= 10'h3FF;
          tx_ds14_in <= 10'h3FF;
          tx_ds15_in <= 10'h3FF;
          tx_ds16_in <= 10'h3FF;
        end
      end
      else if (sample inside {active_sample + 1,active_sample + 2,total_sample -3, total_sample - 2})
      begin
        tx_ds1_in <= 10'h000;
        tx_ds2_in <= 10'h000;
        if((tx_mux_pattern == 3'b001) || (tx_mux_pattern == 3'b011) || (tx_mux_pattern == 3'b010) || (tx_mux_pattern == 3'b100))
        begin
          tx_ds3_in <= 10'h000;
          tx_ds4_in <= 10'h000;
        end
        if ((tx_mux_pattern == 3'b010) || (tx_mux_pattern == 3'b100))
        begin
          tx_ds5_in <= 10'h000;
          tx_ds6_in <= 10'h000;
          tx_ds7_in <= 10'h000;
          tx_ds8_in <= 10'h000;
        end
        if (tx_mux_pattern == 3'b100)
        begin
          tx_ds9_in <= 10'h000;
          tx_ds10_in <= 10'h000;
          tx_ds11_in <= 10'h000;
          tx_ds12_in <= 10'h000;
          tx_ds13_in <= 10'h000;
          tx_ds14_in <= 10'h000;
          tx_ds15_in <= 10'h000;
          tx_ds16_in <= 10'h000;
        end
      end
      else if (sample inside {active_sample + 3,total_sample -1})
      begin
        tx_ds1_in <= xyz;
        tx_ds2_in <= xyz;
        if(tx_insert_st352 == 1'h1)
        begin
          tx_st352_data_ch0 <= tx_st352_data;
          if((tx_mode == MODE_3G) && (level_3G == 1'h0))
          begin
            tx_st352_data_ch1 <= tx_st352_data;
          end
        end
        if((tx_mux_pattern == 3'b001) || (tx_mux_pattern == 3'b011) || (tx_mux_pattern == 3'b010) || (tx_mux_pattern == 3'b100))
        begin
          tx_ds3_in <= xyz;
          tx_ds4_in <= xyz;
          if((sample inside {active_sample +3}) && (tx_insert_st352 == 1'h1))
          begin
            tx_st352_data_ch1 <= tx_st352_data;
          end
        end
        if ((tx_mux_pattern == 3'b010) || (tx_mux_pattern == 3'b100))
        begin
          tx_ds5_in <= xyz;
          tx_ds6_in <= xyz;
          tx_ds7_in <= xyz;
          tx_ds8_in <= xyz;
          if((sample inside {active_sample +3}) && (tx_insert_st352 == 1'h1))
          begin
            tx_st352_data_ch2 <= tx_st352_data;
            tx_st352_data_ch3 <= tx_st352_data;
          end
        end
        if (tx_mux_pattern == 3'b100)
        begin
          tx_ds9_in <= xyz;
          tx_ds10_in <= xyz;
          tx_ds11_in <= xyz;
          tx_ds12_in <= xyz;
          tx_ds13_in <= xyz;
          tx_ds14_in <= xyz;
          tx_ds15_in <= xyz;
          tx_ds16_in <= xyz;
          if((sample inside {active_sample +3}) && (tx_insert_st352 == 1'h1))
          begin
            tx_st352_data_ch4 <= tx_st352_data;
            tx_st352_data_ch5 <= tx_st352_data;
            tx_st352_data_ch6 <= tx_st352_data;
            tx_st352_data_ch7 <= tx_st352_data;
          end
        end

      end
      else if (sample  inside {active_sample + 4})
      begin
        tx_ds1_in <= {~line_no[6],line_no[6:0],2'b00};   // LN0
        tx_ds2_in <= {~line_no[6],line_no[6:0],2'b00};   // LN0
        if((tx_mux_pattern == 3'b001) || (tx_mux_pattern == 3'b011) || (tx_mux_pattern == 3'b010) || (tx_mux_pattern == 3'b100))
        begin
          tx_ds3_in <= {~line_no[6],line_no[6:0],2'b00};
          tx_ds4_in <= {~line_no[6],line_no[6:0],2'b00};
        end
        if ((tx_mux_pattern == 3'b010) || (tx_mux_pattern == 3'b100))
        begin
          tx_ds5_in <= {~line_no[6],line_no[6:0],2'b00};
          tx_ds6_in <= {~line_no[6],line_no[6:0],2'b00};
          tx_ds7_in <= {~line_no[6],line_no[6:0],2'b00};
          tx_ds8_in <= {~line_no[6],line_no[6:0],2'b00};
        end
        if (tx_mux_pattern == 3'b100)
        begin
          tx_ds9_in <= {~line_no[6],line_no[6:0],2'b00};
          tx_ds10_in <= {~line_no[6],line_no[6:0],2'b00};
          tx_ds11_in <= {~line_no[6],line_no[6:0],2'b00};
          tx_ds12_in <= {~line_no[6],line_no[6:0],2'b00};
          tx_ds13_in <= {~line_no[6],line_no[6:0],2'b00};
          tx_ds14_in <= {~line_no[6],line_no[6:0],2'b00};
          tx_ds15_in <= {~line_no[6],line_no[6:0],2'b00};
          tx_ds16_in <= {~line_no[6],line_no[6:0],2'b00};
        end

      end
      else if (sample  inside {active_sample + 5})
      begin
	tx_ds1_in <= {4'b1000,line_no[10:7],2'b00};      // LN1
        tx_ds2_in <= {4'b1000,line_no[10:7],2'b00};      // LN1
        if((tx_mux_pattern == 3'b001) || (tx_mux_pattern == 3'b011) || (tx_mux_pattern == 3'b010) || (tx_mux_pattern == 3'b100))
        begin
          tx_ds3_in <= {4'b1000,line_no[10:7],2'b00};
          tx_ds4_in <= {4'b1000,line_no[10:7],2'b00};
        end
        if ((tx_mux_pattern == 3'b010) || (tx_mux_pattern == 3'b100))
        begin
          tx_ds5_in <= {4'b1000,line_no[10:7],2'b00};
          tx_ds6_in <= {4'b1000,line_no[10:7],2'b00};
          tx_ds7_in <= {4'b1000,line_no[10:7],2'b00};
          tx_ds8_in <= {4'b1000,line_no[10:7],2'b00};
        end
        if (tx_mux_pattern == 3'b100)
        begin
          tx_ds9_in <= {4'b1000,line_no[10:7],2'b00};
          tx_ds10_in <= {4'b1000,line_no[10:7],2'b00};
          tx_ds11_in <= {4'b1000,line_no[10:7],2'b00};
          tx_ds12_in <= {4'b1000,line_no[10:7],2'b00};
          tx_ds13_in <= {4'b1000,line_no[10:7],2'b00};
          tx_ds14_in <= {4'b1000,line_no[10:7],2'b00};
          tx_ds15_in <= {4'b1000,line_no[10:7],2'b00};
          tx_ds16_in <= {4'b1000,line_no[10:7],2'b00};
        end

      end
      else 
      begin
        if((v == 1'h0) && (h== 1'h1))
        begin
          tx_ds1_in <= y;
          tx_ds2_in <= c;
          if((tx_mux_pattern == 3'b001) || (tx_mux_pattern == 3'b011) || (tx_mux_pattern == 3'b010) || (tx_mux_pattern == 3'b100))
          begin
            tx_ds3_in <= y;
            tx_ds4_in <= c;
          end
          if ((tx_mux_pattern == 3'b010) || (tx_mux_pattern == 3'b100))
          begin
            tx_ds5_in <= y;
            tx_ds6_in <= c;
            tx_ds7_in <= y;
            tx_ds8_in <= c;
          end
          if (tx_mux_pattern == 3'b100)
          begin
            tx_ds9_in <= y;
            tx_ds10_in <= c;
            tx_ds11_in <= y;
            tx_ds12_in <= c;
            tx_ds13_in <= y;
            tx_ds14_in <= c;
            tx_ds15_in <= y;
            tx_ds16_in <= c;
          end
        end
        else
        begin
          tx_ds1_in <= 10'h200;
          tx_ds2_in <= 10'h40;
          if((tx_mux_pattern == 3'b001) || (tx_mux_pattern == 3'b011) || (tx_mux_pattern == 3'b010) || (tx_mux_pattern == 3'b100))
          begin
            tx_ds3_in <= 10'h200;
            tx_ds4_in <= 10'h40;
          end
          if ((tx_mux_pattern == 3'b010) || (tx_mux_pattern == 3'b100))
          begin
            tx_ds5_in <= 10'h200;
            tx_ds6_in <= 10'h40;
            tx_ds7_in <= 10'h200;
            tx_ds8_in <= 10'h40;
          end
          if (tx_mux_pattern == 3'b100)
          begin
            tx_ds9_in <= 10'h200;
            tx_ds10_in <= 10'h40;
            tx_ds11_in <= 10'h200;
            tx_ds12_in <= 10'h40;
            tx_ds13_in <= 10'h200;
            tx_ds14_in <= 10'h40;
            tx_ds15_in <= 10'h200;
            tx_ds16_in <= 10'h40;
          end
        end
      end
    end
  end

endmodule
