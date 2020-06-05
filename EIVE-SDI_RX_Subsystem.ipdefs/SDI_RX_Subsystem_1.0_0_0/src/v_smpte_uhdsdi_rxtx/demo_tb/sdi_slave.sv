
//====================================================================
//  This module collects information from SDI Rx core and checks it 
//====================================================================

`timescale 1ns / 1ps


module sdi_slave (

  input logic 		clk,
  input logic 		rst,
  input logic 		rx_ce_out,
  input logic 		rx_mode_locked,
  input logic 		rx_t_locked,
  input logic [3:0] 	rx_t_family,
  input logic [3:0] 	rx_t_rate,
  input logic 		rx_t_scan,
  input logic 		rx_level_b_3g, 
  input logic [2:0] 	rx_mode,
  input logic 		rx_mode_hd,
  input logic 		rx_mode_sd,
  input logic 		rx_mode_3g,
  input logic 		rx_mode_6g,
  input logic 		rx_mode_12g,              
  input logic           rx_eav,
  input logic           rx_sav,
  input logic           rx_trs,

  input logic [9:0]      rx_ds1, 
  input logic [9:0]      rx_ds2, 
  input logic [9:0]      rx_ds3, 
  input logic [9:0]      rx_ds4, 
  input logic [9:0]      rx_ds5, 
  input logic [9:0]      rx_ds6, 
  input logic [9:0]      rx_ds7, 
  input logic [9:0]      rx_ds8, 
  input logic [9:0]      rx_ds9, 
  input logic [9:0]      rx_ds10,
  input logic [9:0]      rx_ds11,
  input logic [9:0]      rx_ds12,
  input logic [9:0]      rx_ds13,
  input logic [9:0]      rx_ds14,
  input logic [9:0]      rx_ds15,
  input logic [9:0]      rx_ds16,

  input logic [10:0]        rx_ln_ds1,
  input logic [10:0]        rx_ln_ds2,
  input logic [10:0]        rx_ln_ds3,
  input logic [10:0]        rx_ln_ds4,
  input logic [10:0]        rx_ln_ds5,
  input logic [10:0]        rx_ln_ds6,
  input logic [10:0]        rx_ln_ds7,
  input logic [10:0]        rx_ln_ds8,
  input logic [10:0]        rx_ln_ds9,
  input logic [10:0]        rx_ln_ds10,
  input logic [10:0]        rx_ln_ds11,
  input logic [10:0]        rx_ln_ds12,
  input logic [10:0]        rx_ln_ds13,
  input logic [10:0]        rx_ln_ds14,
  input logic [10:0]        rx_ln_ds15,
  input logic [10:0]        rx_ln_ds16,

  input logic           rx_crc_err_ds1, 
  input logic           rx_crc_err_ds2, 
  input logic           rx_crc_err_ds3, 
  input logic           rx_crc_err_ds4, 
  input logic           rx_crc_err_ds5, 
  input logic           rx_crc_err_ds6, 
  input logic           rx_crc_err_ds7, 
  input logic           rx_crc_err_ds8, 
  input logic           rx_crc_err_ds9, 
  input logic           rx_crc_err_ds10,
  input logic           rx_crc_err_ds11,
  input logic           rx_crc_err_ds12,
  input logic           rx_crc_err_ds13,
  input logic           rx_crc_err_ds14,
  input logic           rx_crc_err_ds15,
  input logic           rx_crc_err_ds16,
  input logic [31:0]    rx_st352_0,             // video payload ID packet ds1 (for 3G-SDI level A, Y VPID)
  input logic           rx_st352_0_valid,       // 1 = st352_0 is valid
  input logic [31:0]    rx_st352_1,             // video payload ID packet ds3 (ds2 for 3G-SDI level A, C VPID) 
  input logic           rx_st352_1_valid,       // 1 = st352_1 is valid
  input logic [31:0]    rx_st352_2,             // video payload ID packet ds5
  input logic           rx_st352_2_valid,       // 1 = st352_2 is valid
  input logic [31:0]    rx_st352_3,             // video payload ID packet ds7
  input logic           rx_st352_3_valid,       // 1 = st352_3 is valid
  input logic [31:0]    rx_st352_4,             // video payload ID packet ds9
  input logic           rx_st352_4_valid,       // 1 = st352_4 is valid
  input logic [31:0]    rx_st352_5,             // video payload ID packet ds11
  input logic           rx_st352_5_valid,       // 1 = st352_5 is valid
  input logic [31:0]    rx_st352_6,             // video payload ID packet ds13
  input logic           rx_st352_6_valid,       // 1 = st352_6 is valid
  input logic [31:0]    rx_st352_7,             // video payload ID packet ds15
  input logic           rx_st352_7_valid,       // 1 = st352_7 is valid
  output logic [5:0]    rx_mode_enable, 
  output logic          rx_mode_detect_en,
  output logic [2:0]      rx_forced_mode,
  input logic [2:0]     rx_active_streams,

  input logic [10:0]        tx_line_ch0,
  input logic [10:0]        tx_line_ch1,
  input logic [10:0]        tx_line_ch2,
  input logic [10:0]        tx_line_ch3,
  input logic [10:0]        tx_line_ch4,
  input logic [10:0]        tx_line_ch5,
  input logic [10:0]        tx_line_ch6,
  input logic [10:0]        tx_line_ch7,
  input logic 		tx_insert_ln,
  input logic [10:0]        tx_line_no,
  input logic [2:0] 	tx_mux_pattern,

  input logic [3:0] 	mst_rx_t_family,
  input logic [3:0] 	mst_rx_t_rate,
  input logic 		mst_rx_t_scan,
  input logic           mst_tx_insert_crc,
  input logic [2:0] 	mst_tx_mode


  );

  logic mode_lock_flag,t_lock_flag ;
  logic rx_mode_locked_q,rx_mode_locked_2q,rx_mode_locked_3q,rx_mode_locked_4q;
  logic rx_t_locked_q,rx_t_locked_2q;
  logic eav_flag,sav_flag,active_line_flag;
  int  crc_cnt,crc_err_cnt;
  logic [9:0] DS1_CRC1,DS2_CRC1,DS3_CRC1,DS4_CRC1,DS5_CRC1,DS6_CRC1,DS7_CRC1,DS8_CRC1;
  logic [9:0] DS9_CRC1,DS10_CRC1,DS11_CRC1,DS12_CRC1,DS13_CRC1,DS14_CRC1,DS15_CRC1,DS16_CRC1;
  logic [9:0] DS1_CRC0,DS2_CRC0,DS3_CRC0,DS4_CRC0,DS5_CRC0,DS6_CRC0,DS7_CRC0,DS8_CRC0;
  logic [9:0] DS9_CRC0,DS10_CRC0,DS11_CRC0,DS12_CRC0,DS13_CRC0,DS14_CRC0,DS15_CRC0,DS16_CRC0;
  logic ds1_active_vid_flg;
  logic [9:0]  temp;

  always @(posedge clk)
  begin
    if(rst == 1'h1)
    begin
      rx_mode_locked_q <= 0;
      rx_mode_locked_2q <= 0;
      rx_mode_locked_3q <= 0;
      rx_mode_locked_4q <= 0;
      rx_t_locked_q <= 0;
      rx_t_locked_2q <= 0;
    end
    else if (rx_ce_out == 1'h1)
    begin
      rx_mode_locked_q <= rx_mode_locked;
      rx_mode_locked_2q <= rx_mode_locked_q;
      rx_mode_locked_3q <= rx_mode_locked_2q;
      rx_mode_locked_4q <= rx_mode_locked_3q;
      rx_t_locked_q <= rx_t_locked;
      rx_t_locked_2q <= rx_t_locked_q;
    end
  end 

  always @(posedge clk)
  begin
    if(rst == 1'h1)
    begin
      rx_mode_enable =6'b111111;
      rx_mode_detect_en = 1'h1;
    end
  end


  task dis_mode(input logic [2:0] mode_name=3'b111);
    case(mode_name)
      3'b000 : rx_mode_enable[0]= 1'b0;
      3'b001 : rx_mode_enable[1]= 1'b0;
      3'b010 : rx_mode_enable[2]= 1'b0;
      3'b100 : rx_mode_enable[3]= 1'b0;
      3'b101 : rx_mode_enable[4]= 1'b0;
      3'b110 : rx_mode_enable[5]= 1'b0;
      3'b111 : rx_mode_enable= 6'h0;
    endcase
  endtask

  task force_mode(input logic [2:0] mode_name);
    rx_mode_detect_en = 1'h0;
    rx_forced_mode = mode_name;
  endtask

  // Line detection
  always @(posedge clk)
  begin
    if(rst == 1'h1)
    begin
      eav_flag <= 1'h0;
      sav_flag <= 1'h0;
      active_line_flag <= 1'h0;
    end
    else if (rx_ce_out == 1'h1) 
    begin
      if (active_line_flag == 1'h0) 
      begin
        if((rx_mode_locked == 1'h1) && (rx_trs == 1'h1) && (rx_eav == 1'h1) && (sav_flag == 1'h0))
          eav_flag <= 1'h1;
        else if ((rx_mode_locked == 1'h1) && (rx_trs == 1'h1) && (rx_sav == 1'h1) && (eav_flag == 1'h1))
          sav_flag <= 1'h1;
      end
      else if (active_line_flag == 1'h1)
      begin
        eav_flag <= 1'h0;
        sav_flag <= 1'h0;
      end
    end
  end
  
  always @(*)
    active_line_flag = eav_flag & sav_flag;

  always @(posedge clk)
  begin
    if(mst_tx_mode != 3'b001)
    begin
      if(active_line_flag == 1'h1)
      begin
        if(tx_insert_ln == 1'h1)
        begin
          if(rx_ln_ds1 != tx_line_ch0)
          begin
            $error ("Error : SDI SLAVE :: Captured Line no. Mismatch for  expected line no: %0d actual DS1 line no: %0d ",tx_line_ch0,rx_ln_ds1); 
            tb_v_smpte_uhdsdi_rxtx.err++;
          end
        end
        else
        begin
          if(rx_ln_ds1 != tx_line_no)
          begin
            $error ("Error : SDI SLAVE :: Captured Line no. Mismatch for  expected line no: %0d actual DS1 line no: %0d ",tx_line_no,rx_ln_ds1); 
            tb_v_smpte_uhdsdi_rxtx.err++;
          end
        end
       
        if((rx_active_streams == 3'b001) || (rx_active_streams == 3'b010) || (rx_active_streams == 3'b011) || (rx_active_streams == 3'b100))
        begin
          if(tx_insert_ln == 1'h1)
          begin
            if(rx_ln_ds2 != tx_line_ch0)
            begin
              $error ("Error : SDI SLAVE :: Captured Line no. Mismatch for  expected line no: %0d actual DS2 line no: %0d ",tx_line_ch0,rx_ln_ds2); 
              tb_v_smpte_uhdsdi_rxtx.err++;
            end
          end
          else
          begin
            if(rx_ln_ds2 != tx_line_no)
            begin
              $display ("Error : SDI SLAVE :: Captured Line no. Mismatch for  expected line no: %0d actual DS2 line no: %0d ",tx_line_no,rx_ln_ds2); 
              tb_v_smpte_uhdsdi_rxtx.err++;
            end
          end
        end

        if((rx_active_streams == 3'b010)  || (rx_active_streams == 3'b011) || (rx_active_streams == 3'b100))
        begin
          if(tx_insert_ln == 1'h1)
          begin
            if((rx_ln_ds3 != tx_line_ch1) || (rx_ln_ds4 != tx_line_ch1))
            begin
              $error ("Error : SDI SLAVE :: Captured Line no. Mismatch for  expected line no: %0d actual DS3 line no: %0d DS4 line no: %0d",tx_line_ch1,rx_ln_ds3,rx_ln_ds4); 
              tb_v_smpte_uhdsdi_rxtx.err++;
            end
          end
          else
          begin
            if((rx_ln_ds3 != tx_line_no) || (rx_ln_ds4 != tx_line_no))
            begin
              $error ("Error : SDI SLAVE :: Captured Line no. Mismatch for  expected line no: %0d actual DS3 line no: %0d DS4 line no: %0d",tx_line_no,rx_ln_ds3,rx_ln_ds4); 
              tb_v_smpte_uhdsdi_rxtx.err++;
            end
          end
        end

        if((rx_active_streams == 3'b011) || (rx_active_streams == 3'b100))
        begin
          if(tx_insert_ln == 1'h1)
          begin
            if((rx_ln_ds5 != tx_line_ch2) || (rx_ln_ds6 != tx_line_ch2))
            begin
              $error ("Error : SDI SLAVE :: Captured Line no. Mismatch for  expected line no: %0d actual DS5 line no: %0d DS6 line no: %0d",tx_line_ch2,rx_ln_ds5,rx_ln_ds6); 
              tb_v_smpte_uhdsdi_rxtx.err++;
            end
            if((rx_ln_ds7 != tx_line_ch3) || (rx_ln_ds8 != tx_line_ch3))
            begin
              $error ("Error : SDI SLAVE :: Captured Line no. Mismatch for  expected line no: %0d actual DS7 line no: %0d DS8 line no: %0d",tx_line_ch3,rx_ln_ds7,rx_ln_ds8); 
              tb_v_smpte_uhdsdi_rxtx.err++;
            end
          end
          else
          begin
            if((rx_ln_ds5 != tx_line_no) || (rx_ln_ds6 != tx_line_no))
            begin
              $error ("Error : SDI SLAVE :: Captured Line no. Mismatch for  expected line no: %0d actual DS5 line no: %0d DS6 line no: %0d",tx_line_no,rx_ln_ds5,rx_ln_ds6); 
              tb_v_smpte_uhdsdi_rxtx.err++;
            end
            if((rx_ln_ds7 != tx_line_no) || (rx_ln_ds8 != tx_line_no))
            begin
              $error ("Error : SDI SLAVE :: Captured Line no. Mismatch for  expected line no: %0d actual DS7 line no: %0d DS8 line no: %0d",tx_line_no,rx_ln_ds7,rx_ln_ds8); 
              tb_v_smpte_uhdsdi_rxtx.err++;
            end
          end
        end

        if(rx_active_streams == 3'b100)
        begin
          if(tx_insert_ln == 1'h1)
          begin
            if((rx_ln_ds9 != tx_line_ch4) || (rx_ln_ds10 != tx_line_ch4))
            begin
              $error ("Error : SDI SLAVE :: Captured Line no. Mismatch for  expected line no: %0d actual DS9 line no: %0d DS10 line no: %0d",tx_line_ch4,rx_ln_ds9,rx_ln_ds10); 
              tb_v_smpte_uhdsdi_rxtx.err++;
            end
            if((rx_ln_ds11 != tx_line_ch5) || (rx_ln_ds12 != tx_line_ch5))
            begin
              $error ("Error : SDI SLAVE :: Captured Line no. Mismatch for  expected line no: %0d actual DS11 line no: %0d DS12 line no: %0d",tx_line_ch5,rx_ln_ds11,rx_ln_ds12); 
              tb_v_smpte_uhdsdi_rxtx.err++;
            end
            if((rx_ln_ds13 != tx_line_ch6) || (rx_ln_ds14 != tx_line_ch6))
            begin
              $error ("Error : SDI SLAVE :: Captured Line no. Mismatch for  expected line no: %0d actual DS13 line no: %0d DS14 line no: %0d",tx_line_ch6,rx_ln_ds13,rx_ln_ds14); 
              tb_v_smpte_uhdsdi_rxtx.err++;
            end
            if((rx_ln_ds15 != tx_line_ch7) || (rx_ln_ds16 != tx_line_ch7))
            begin
              $error ("Error : SDI SLAVE :: Captured Line no. Mismatch for  expected line no: %0d actual DS15 line no: %0d DS16 line no: %0d",tx_line_ch7,rx_ln_ds15,rx_ln_ds16); 
              tb_v_smpte_uhdsdi_rxtx.err++;
            end
          end
          else
          begin
            if((rx_ln_ds9 != tx_line_no) || (rx_ln_ds10 != tx_line_no))
            begin
              $error ("Error : SDI SLAVE :: Captured Line no. Mismatch for  expected line no: %0d actual DS9 line no: %0d DS10 line no: %0d",tx_line_no,rx_ln_ds9,rx_ln_ds10); 
              tb_v_smpte_uhdsdi_rxtx.err++;
            end
            if((rx_ln_ds11 != tx_line_no) || (rx_ln_ds12 != tx_line_no))
            begin
              $error ("Error : SDI SLAVE :: Captured Line no. Mismatch for  expected line no: %0d actual DS11 line no: %0d DS12 line no: %0d",tx_line_no,rx_ln_ds11,rx_ln_ds12); 
              tb_v_smpte_uhdsdi_rxtx.err++;
            end
            if((rx_ln_ds13 != tx_line_no) || (rx_ln_ds14 != tx_line_no))
            begin
              $error ("Error : SDI SLAVE :: Captured Line no. Mismatch for  expected line no: %0d actual DS13 line no: %0d DS14 line no: %0d",tx_line_no,rx_ln_ds13,rx_ln_ds14); 
              tb_v_smpte_uhdsdi_rxtx.err++;
            end
            if((rx_ln_ds15 != tx_line_no) || (rx_ln_ds16 != tx_line_no))
            begin
              $error ("Error : SDI SLAVE :: Captured Line no. Mismatch for  expected line no: %0d actual DS15 line no: %0d DS16 line no: %0d",tx_line_no,rx_ln_ds15,rx_ln_ds16); 
              tb_v_smpte_uhdsdi_rxtx.err++;
            end
          end
        end
      end
    end
  end

  // Transport Info Check
  // ---------------------

  always @(posedge clk)
  begin
    if(rst == 1'h1)
    begin
      t_lock_flag = 1'h0;
    end
    else if (rx_ce_out == 1'h1)
    begin
      if(rx_t_locked_2q == 1'h1) 
      begin
        if(t_lock_flag == 1'h0) 
        begin
          case(rx_t_family) 
            4'b0000 : $display ("SDI SLAVE :: Transport Video Format SDI SLAVE :: SMPTE ST274 - Pixel 1920 x 1080 detected"); 
            4'b0001 : $display ("SDI SLAVE ::  Transport Video Format SDI SLAVE :: SMPTE ST296 - Pixel 1280 x 720  detected"); 
            4'b0010 : $display ("SDI SLAVE ::  Transport Video Format SDI SLAVE :: SMPTE ST2048-2 - Pixel 2048 x 1080 detected"); 
            4'b0011 : $display ("SDI SLAVE ::  Transport Video Format SDI SLAVE :: SMPTE ST295 - Pixel 1920 x 1080 detected"); 
            4'b1000 : $display ("SDI SLAVE ::  Transport Video Format SDI SLAVE :: NTSC - Pixel 720 x 486 detected"); 
            4'b1001 : $display ("SDI SLAVE ::  Transport Video Format SDI SLAVE :: PAL - Pixel 720 x 576 detected"); 
            4'b1111 : $display ("SDI SLAVE ::  Transport Video Format SDI SLAVE :: Unknown Video Format detected"); 
            default : $display ("SDI SLAVE ::  Transport Video Format SDI SLAVE :: Incorrect Video Format detected");
          endcase

          if(mst_rx_t_family != rx_t_family)
          begin
            $error ("Error : SDI SLAVE ::  Transport Video Format Mismatch - Exp family =%0b Actual family=%0b",mst_rx_t_family,rx_t_family);
            tb_v_smpte_uhdsdi_rxtx.err++;
          end 

          case(rx_t_rate) 
            4'b0000 : $display ("SDI SLAVE :: Frame Rate None detected"); 
            4'b0010 : $display ("SDI SLAVE :: Frame Rate 23.98 Hz detected"); 
            4'b0011 : $display ("SDI SLAVE :: Frame Rate 24 Hz detected"); 
            4'b0100 : $display ("SDI SLAVE :: Frame Rate 47.95 Hz detected"); 
            4'b0101 : $display ("SDI SLAVE :: Frame Rate 25 Hz detected"); 
            4'b0110 : $display ("SDI SLAVE :: Frame Rate 29.97 Hz detected"); 
            4'b0111 : $display ("SDI SLAVE :: Frame Rate 30 Hz detected"); 
            4'b1000 : $display ("SDI SLAVE :: Frame Rate 48 Hz detected"); 
            4'b1001 : $display ("SDI SLAVE :: Frame Rate 50 Hz detected"); 
            4'b1010 : $display ("SDI SLAVE :: Frame Rate 59.94 Hz detected"); 
            4'b1011 : $display ("SDI SLAVE :: Frame Rate 60 Hz detected"); 
            default : $display ("SDI SLAVE :: Frame Rate Reserved for future use detected"); 
          endcase

          if(mst_rx_t_rate != rx_t_rate)
          begin
            $error ("Error : SDI SLAVE :: Frame Rate Mismatch - Exp frame rate =%0b Actual frame rate =%0b",mst_rx_t_rate,rx_t_rate);
            tb_v_smpte_uhdsdi_rxtx.err++;
          end 

          case(rx_t_scan) 
            1'b0 : $display ("SDI SLAVE ::  Interlaced transport detected"); 
            1'b1 : $display ("SDI SLAVE ::  Progressive transport detected"); 
          endcase

          if(mst_rx_t_scan != rx_t_scan)
          begin
            $error ("Error : SDI SLAVE :: Scan mode Mismatch - Exp scan mode =%0b Actual scan mode  =%0b",mst_rx_t_scan,rx_t_scan);
            tb_v_smpte_uhdsdi_rxtx.err++;
          end 

          t_lock_flag = 1'h1;

        end
      end
    end
  end


  // Mode detection check
  // --------------------

  always @(posedge clk)
  begin
    if(rst == 1'h1)
    begin
      mode_lock_flag = 1'h0;
    end
    else if (rx_ce_out == 1'h1)
    begin
      if(rx_mode_locked_4q == 1'h1) 
      begin
        if(mode_lock_flag == 1'h0) 
        begin
          case(rx_mode) 
            3'b000  : $display ("SDI SLAVE :: Rx locked for HD mode"); 
            3'b001  : $display ("SDI SLAVE :: Rx locked for SD mode"); 
            3'b010  : $display ("SDI SLAVE :: Rx locked for 3G mode %0s",(rx_level_b_3g == 1)?"Level B": "Level A"); 
            3'b100  : $display ("SDI SLAVE :: Rx locked for 6G mode"); 
            3'b101  : $display ("SDI SLAVE :: Rx locked for 12G 1000/1000 mode"); 
            3'b110  : $display ("SDI SLAVE :: Rx locked for 12G 1000/1001 mode"); 
            default : $display ("SDI SLAVE :: Rx lock error - Rx mode and Rx mode type mismatch rx_mode = %0b rx_mode_hd/sd/3g/6g/12g =%0b ",rx_mode,{rx_mode_hd,rx_mode_sd,rx_mode_3g,rx_mode_6g,rx_mode_12g}); 
          endcase

          if(mst_tx_mode != rx_mode)
          begin
            $error ("Error : SDI SLAVE :: Rx mode Mismatch - Exp mode =%0b Actual mode  =%0b",mst_tx_mode,rx_mode);
            tb_v_smpte_uhdsdi_rxtx.err++;
          end 

          mode_lock_flag = 1'h1;
        end
      end
    end

  end

  task vid_frmt_check_end(input logic [10:0] line_no);
  begin
    begin : lock_chk 
      wait((rx_mode_locked) && (tx_line_no >= tb_v_smpte_uhdsdi_rxtx.SDI_MST.first_active + line_no ));
    end
    disable lock_chk;
    if(rx_mode_locked == 1'h0)
    begin
      $error ("Error : SDI SLAVE :: SDI mode not detected ");
      tb_v_smpte_uhdsdi_rxtx.err++;
    end 
    if(rx_t_locked == 1'h0)
    begin
      $error ("Error : SDI SLAVE :: SDI transport stream not detected ");
      tb_v_smpte_uhdsdi_rxtx.err++;
    end 
    $display ("SDI SLAVE :: Video format tested, test ran till line no. %0d",tx_line_no);
    $display ("===============================================================");
  end  
  endtask

  //CRC Error Check

  always @(posedge clk)
  begin
    if(rst == 1'h1)
    begin
      crc_cnt = 32'h1;
    end
    else if ((rx_mode_locked == 1'h1) && (mst_tx_mode != 3'b001))
    begin
      if((rx_ce_out == 1'h1) && (rx_eav == 1'h1))
      begin
        crc_cnt = 32'h1;
      end
      else if ((rx_ce_out == 1'h1) && (rx_eav == 1'h0))
      begin
        crc_cnt = crc_cnt+32'd1;
      end
      if((rx_ce_out == 1'h1) && (crc_cnt  == 32'd4))  
      begin
        DS1_CRC0=rx_ds1;
        if((rx_active_streams == 3'b001) || (rx_active_streams == 3'b010) || (rx_active_streams == 3'b011) || (rx_active_streams == 3'b100))
          DS2_CRC0=rx_ds2;
        if((rx_active_streams == 3'b010) || (rx_active_streams == 3'b011) || (rx_active_streams == 3'b100))
        begin
          DS3_CRC0=rx_ds3;
          DS4_CRC0=rx_ds4;
        end
        if((rx_active_streams == 3'b011) || (rx_active_streams == 3'b100))
        begin
          DS5_CRC0=rx_ds5;
          DS6_CRC0=rx_ds6;
          DS7_CRC0=rx_ds7;
          DS8_CRC0=rx_ds8;
        end
        if(rx_active_streams == 3'b100)
        begin
          DS9_CRC0=rx_ds9;
          DS10_CRC0=rx_ds10;
          DS11_CRC0=rx_ds11;
          DS12_CRC0=rx_ds12;
          DS13_CRC0=rx_ds13;
          DS14_CRC0=rx_ds14;
          DS15_CRC0=rx_ds15;
          DS16_CRC0=rx_ds16;
        end
      end
      if((rx_ce_out == 1'h1) && (crc_cnt  == 32'd5))  
      begin
        DS1_CRC1=rx_ds1;
        if((rx_active_streams == 3'b001) || (rx_active_streams == 3'b010) || (rx_active_streams == 3'b011) || (rx_active_streams == 3'b100))
          DS2_CRC1=rx_ds2;
        if((rx_active_streams == 3'b010) || (rx_active_streams == 3'b011) || (rx_active_streams == 3'b100))
        begin
          DS3_CRC1=rx_ds3;
          DS4_CRC1=rx_ds4;
        end
        if((rx_active_streams == 3'b011) || (rx_active_streams == 3'b100))
        begin
          DS5_CRC1=rx_ds5;
          DS6_CRC1=rx_ds6;
          DS7_CRC1=rx_ds7;
          DS8_CRC1=rx_ds8;
        end
        if(rx_active_streams == 3'b100)
        begin
          DS9_CRC1=rx_ds9;
          DS10_CRC1=rx_ds10;
          DS11_CRC1=rx_ds11;
          DS12_CRC1=rx_ds12;
          DS13_CRC1=rx_ds13;
          DS14_CRC1=rx_ds14;
          DS15_CRC1=rx_ds15;
          DS16_CRC1=rx_ds16;
        end
      end
      if((rx_ce_out == 1'h1) && (crc_cnt  == 32'd8))
      begin
          if(rx_crc_err_ds1 == 1'h1)
          begin
            $error("Error : SDI SLAVE :: CRC error detected on Data Stream 1 for line no %0d",rx_ln_ds1-32'd1);
            if(mst_tx_insert_crc == 1'h1)
            begin
              $display("SDI SLAVE :: CRC0=%0h and CRC1=%0h for Data Stream 1 ",DS1_CRC0,DS1_CRC1);
            end
            tb_v_smpte_uhdsdi_rxtx.err++;
            crc_err_cnt++;
          end
          if((rx_active_streams == 3'b001) || (rx_active_streams == 3'b010) || (rx_active_streams == 3'b011) || (rx_active_streams == 3'b100))
          begin
            if(rx_crc_err_ds2 == 1'h1)
            begin
              $error("Error : SDI SLAVE :: CRC error detected on Data Stream 2 for line no %0d",rx_ln_ds2-32'd1);
              if(mst_tx_insert_crc == 1'h1)
              begin
                $display("SDI SLAVE :: CRC0=%0h and CRC1=%0h for Data Stream 2 ",DS2_CRC0,DS2_CRC1);
              end
              tb_v_smpte_uhdsdi_rxtx.err++;
              crc_err_cnt++;
            end
          end
          if((rx_active_streams == 3'b010) || (rx_active_streams == 3'b011) || (rx_active_streams == 3'b100))
          begin
            if(rx_crc_err_ds3 == 1'h1)
            begin
              $error("Error : SDI SLAVE :: CRC error detected on Data Stream 3 for line no %0d",rx_ln_ds3-32'd1);
              if(mst_tx_insert_crc == 1'h1)
              begin
                $display("SDI SLAVE :: CRC0=%0h and CRC1=%0h for Data Stream 3 ",DS3_CRC0,DS3_CRC1);
              end
              tb_v_smpte_uhdsdi_rxtx.err++;
              crc_err_cnt++;
            end
            if(rx_crc_err_ds4 == 1'h1)
            begin
              $error("Error : SDI SLAVE :: CRC error detected on Data Stream 4 for line no %0d",rx_ln_ds4-32'd1);
              if(mst_tx_insert_crc == 1'h1)
              begin
                $display("SDI SLAVE :: CRC0=%0h and CRC1=%0h for Data Stream 4 ",DS4_CRC0,DS4_CRC1);
              end
              tb_v_smpte_uhdsdi_rxtx.err++;
              crc_err_cnt++;
            end
          end
          if( (rx_active_streams == 3'b011) || (rx_active_streams == 3'b100))
          begin
            if(rx_crc_err_ds5 == 1'h1)
            begin
              $error("Error : SDI SLAVE :: CRC error detected on Data Stream 5 for line no %0d",rx_ln_ds5-32'd1);
              if(mst_tx_insert_crc == 1'h1)
              begin
                $display("SDI SLAVE :: CRC0=%0h and CRC1=%0h for Data Stream 5 ",DS5_CRC0,DS5_CRC1);
              end
              tb_v_smpte_uhdsdi_rxtx.err++;
              crc_err_cnt++;
            end
            if(rx_crc_err_ds6 == 1'h1)
            begin
              $error("Error : SDI SLAVE :: CRC error detected on Data Stream 6 for line no %0d",rx_ln_ds6-32'd1);
              if(mst_tx_insert_crc == 1'h1)
              begin
                $display("SDI SLAVE :: CRC0=%0h and CRC1=%0h for Data Stream 6 ",DS6_CRC0,DS6_CRC1);
              end
              tb_v_smpte_uhdsdi_rxtx.err++;
              crc_err_cnt++;
            end
            if(rx_crc_err_ds7 == 1'h1)
            begin
              $error("Error : SDI SLAVE :: CRC error detected on Data Stream 7 for line no %0d",rx_ln_ds7-32'd1);
              if(mst_tx_insert_crc == 1'h1)
              begin
                $display("SDI SLAVE :: CRC0=%0h and CRC1=%0h for Data Stream 7 ",DS7_CRC0,DS7_CRC1);
              end
              tb_v_smpte_uhdsdi_rxtx.err++;
              crc_err_cnt++;
            end
            if(rx_crc_err_ds8 == 1'h1)
            begin
              $error("Error : SDI SLAVE :: CRC error detected on Data Stream 8 for line no %0d",rx_ln_ds8-32'd1);
              if(mst_tx_insert_crc == 1'h1)
              begin
                $display("SDI SLAVE :: CRC0=%0h and CRC1=%0h for Data Stream 1 ",DS8_CRC0,DS8_CRC1);
              end
              tb_v_smpte_uhdsdi_rxtx.err++;
              crc_err_cnt++;
            end
          end
          if(rx_active_streams == 3'b100)
          begin
            if(rx_crc_err_ds9 == 1'h1)
            begin
              $error("Error : SDI SLAVE :: CRC error detected on Data Stream 9 for line no %0d",rx_ln_ds9-32'd1);
              if(mst_tx_insert_crc == 1'h1)
              begin
                $display("SDI SLAVE :: CRC0=%0h and CRC1=%0h for Data Stream 1 ",DS9_CRC0,DS9_CRC1);
              end
              tb_v_smpte_uhdsdi_rxtx.err++;
              crc_err_cnt++;
            end
            if(rx_crc_err_ds10 == 1'h1)
            begin
              $error("Error : SDI SLAVE :: CRC error detected on Data Stream 10 for line no %0d",rx_ln_ds10-32'd1);
              if(mst_tx_insert_crc == 1'h1)
              begin
                $display("SDI SLAVE :: CRC0=%0h and CRC1=%0h for Data Stream 10 ",DS10_CRC0,DS10_CRC1);
              end
              tb_v_smpte_uhdsdi_rxtx.err++;
              crc_err_cnt++;
            end
            if(rx_crc_err_ds11 == 1'h1)
            begin
              $error("Error : SDI SLAVE :: CRC error detected on Data Stream 11 for line no %0d",rx_ln_ds11-32'd1);
              if(mst_tx_insert_crc == 1'h1)
              begin
                $display("SDI SLAVE :: CRC0=%0h and CRC1=%0h for Data Stream 11 ",DS11_CRC0,DS11_CRC1);
              end
              tb_v_smpte_uhdsdi_rxtx.err++;
              crc_err_cnt++;
            end
            if(rx_crc_err_ds12 == 1'h1)
            begin
              $error("Error : SDI SLAVE :: CRC error detected on Data Stream 12 for line no %0d",rx_ln_ds12-32'd1);
              tb_v_smpte_uhdsdi_rxtx.err++;
              crc_err_cnt++;
            end
            if(rx_crc_err_ds13 == 1'h1)
            begin
              $error("Error : SDI SLAVE :: CRC error detected on Data Stream 13 for line no %0d",rx_ln_ds13-32'd1);
              if(mst_tx_insert_crc == 1'h1)
              begin
                $display("SDI SLAVE :: CRC0=%0h and CRC1=%0h for Data Stream 13 ",DS13_CRC0,DS13_CRC1);
              end
              tb_v_smpte_uhdsdi_rxtx.err++;
              crc_err_cnt++;
            end
            if(rx_crc_err_ds14 == 1'h1)
            begin
              $error("Error : SDI SLAVE :: CRC error detected on Data Stream 14 for line no %0d",rx_ln_ds14-32'd1);
              if(mst_tx_insert_crc == 1'h1)
              begin
                $display("SDI SLAVE :: CRC0=%0h and CRC1=%0h for Data Stream 14 ",DS14_CRC0,DS14_CRC1);
              end
              tb_v_smpte_uhdsdi_rxtx.err++;
              crc_err_cnt++;
            end
            if(rx_crc_err_ds15 == 1'h1)
            begin
              $error("Error : SDI SLAVE :: CRC error detected on Data Stream 15 for line no %0d",rx_ln_ds15-32'd1);
              if(mst_tx_insert_crc == 1'h1)
              begin
                $display("SDI SLAVE :: CRC0=%0h and CRC1=%0h for Data Stream 15 ",DS15_CRC0,DS15_CRC1);
              end
              tb_v_smpte_uhdsdi_rxtx.err++;
              crc_err_cnt++;
            end
            if(rx_crc_err_ds16 == 1'h1)
            begin
              $error("Error : SDI SLAVE :: CRC error detected on Data Stream 16 for line no %0d",rx_ln_ds16-32'd1);
              if(mst_tx_insert_crc == 1'h1)
              begin
                $display("SDI SLAVE :: CRC0=%0h and CRC1=%0h for Data Stream 15 ",DS15_CRC0,DS15_CRC1);
              end
              tb_v_smpte_uhdsdi_rxtx.err++;
              crc_err_cnt++;
            end

          end
      end
    end
  end

  //ST352 DATA check

  always @(posedge rx_st352_0_valid)
  begin
    if(32'h1234 != rx_st352_0)
    begin
      $error("Error : SDI SLAVE :: ST352 DATA mismatch at DS1 for line %0d  ",rx_ln_ds1);
      tb_v_smpte_uhdsdi_rxtx.err++;
    end
  end
   
  always @(posedge rx_st352_1_valid)
  begin
    if((rx_mode == 3'b010) && (rx_level_b_3g ==1'h0))
    begin 
      if(32'h1234 != rx_st352_1)
      begin
        $error("Error : SDI SLAVE :: ST352 DATA mismatch at DS2  for line %0d ",rx_ln_ds1);
        tb_v_smpte_uhdsdi_rxtx.err++;
      end
    end
    else
    begin 
      if(32'h1234 != rx_st352_1)
      begin
        $error("Error : SDI SLAVE :: ST352 DATA mismatch at DS3  for line %0d ",rx_ln_ds3);
        tb_v_smpte_uhdsdi_rxtx.err++;
      end
    end
  end
   
  always @(posedge rx_st352_2_valid)
  begin
    if(32'h1234 != rx_st352_2)
    begin
      $error("Error : SDI SLAVE :: ST352 DATA mismatch at DS5  for line %0d ",rx_ln_ds5);
      tb_v_smpte_uhdsdi_rxtx.err++;
    end
  end
   
  always @(posedge rx_st352_3_valid)
  begin
    if(32'h1234 != rx_st352_3)
    begin
      $error("Error : SDI SLAVE :: ST352 DATA mismatch at DS7  for line %0d ",rx_ln_ds7);
      tb_v_smpte_uhdsdi_rxtx.err++;
    end
  end
   
  always @(posedge rx_st352_4_valid)
  begin
    if(32'h1234 != rx_st352_4)
    begin
      $error("Error : SDI SLAVE :: ST352 DATA mismatch at DS9  for line %0d ",rx_ln_ds9);
      tb_v_smpte_uhdsdi_rxtx.err++;
    end
  end
   
  always @(posedge rx_st352_5_valid)
  begin
    if(32'h1234 != rx_st352_5)
    begin
      $error("Error : SDI SLAVE :: ST352 DATA mismatch at DS11  for line %0d ",rx_ln_ds11);
      tb_v_smpte_uhdsdi_rxtx.err++;
    end
  end
   
  always @(posedge rx_st352_6_valid)
  begin
    if(32'h1234 != rx_st352_6)
    begin
      $error("Error : SDI SLAVE :: ST352 DATA mismatch at DS13  for line %0d ",rx_ln_ds13);
      tb_v_smpte_uhdsdi_rxtx.err++;
    end
  end
   
  always @(posedge rx_st352_7_valid)
  begin
    if(32'h1234 != rx_st352_7)
    begin
      $error("Error : SDI SLAVE :: ST352 DATA mismatch at DS15  for line %0d ",rx_ln_ds15);
      tb_v_smpte_uhdsdi_rxtx.err++;
    end
  end


  // Data stream Check
  // --------------------------
  always @(posedge clk)
  begin
    if(rst == 1'h1)
    begin
      ds1_active_vid_flg <= 1'h0;
    end
    else if ((rx_mode_locked == 1'h1) && (rx_ce_out == 1'h1))
    begin
      if(rx_sav == 1)    
      begin
        if(rx_ds1[7] == 1'h0)
        begin
          ds1_active_vid_flg <= 1'h1;
        end 
      end
      else if ((rx_trs == 1) && (ds1_active_vid_flg ==1'h1))
      begin
          ds1_active_vid_flg <= 1'h0;
      end 
    end
  end 

  always @(posedge clk)
  begin
    if(rst == 1'h1)
    begin
    end
    else if ((rx_mode_locked == 1'h1) && (rx_ce_out == 1'h1) && (ds1_active_vid_flg ==1'h1) && (rx_trs == 0))
    begin
      if(10'h3AC != rx_ds1)
      begin
        $error("Error : SDI SLAVE :: DATA mismatch at DS1  for line %0d  Data recieved from rx =%0h",rx_ln_ds1,rx_ds1);
        tb_v_smpte_uhdsdi_rxtx.err++;
      end
      if((rx_active_streams == 3'b001) || (rx_active_streams == 3'b010) || (rx_active_streams == 3'b011) || (rx_active_streams == 3'b100))
      begin 
        if(10'h3C0 != rx_ds2)
        begin
          $error("Error : SDI SLAVE :: DATA mismatch at DS2  for line %0d  Data recieved from rx =%0h",rx_ln_ds2,rx_ds2);
          tb_v_smpte_uhdsdi_rxtx.err++;
        end
      end
      if((rx_active_streams == 3'b010) || (rx_active_streams == 3'b011) || (rx_active_streams == 3'b100))
      begin
        if(10'h3AC != rx_ds3)
        begin
          $error("Error : SDI SLAVE :: DATA mismatch at DS3  for line %0d  Data recieved from rx =%0h",rx_ln_ds3,rx_ds3);
          tb_v_smpte_uhdsdi_rxtx.err++;
        end
        if(10'h3C0 != rx_ds4)
        begin
          $error("Error : SDI SLAVE :: DATA mismatch at DS4  for line %0d  Data recieved from rx =%0h",rx_ln_ds4,rx_ds4);
          tb_v_smpte_uhdsdi_rxtx.err++;
        end
      end
      if((rx_active_streams == 3'b011) || (rx_active_streams == 3'b100))
      begin
        if(10'h3AC != rx_ds5)
        begin
          $error("Error : SDI SLAVE :: DATA mismatch at DS5  for line %0d  Data recieved from rx =%0h",rx_ln_ds5,rx_ds5);
          tb_v_smpte_uhdsdi_rxtx.err++;
        end
        if(10'h3C0 != rx_ds6)
        begin
          $error("Error : SDI SLAVE :: DATA mismatch at DS6  for line %0d  Data recieved from rx =%0h",rx_ln_ds6,rx_ds6);
          tb_v_smpte_uhdsdi_rxtx.err++;
        end
        if(10'h3AC != rx_ds7)
        begin
          $error("Error : SDI SLAVE :: DATA mismatch at DS7  for line %0d  Data recieved from rx =%0h",rx_ln_ds7,rx_ds7);
          tb_v_smpte_uhdsdi_rxtx.err++;
        end
        if(10'h3C0 != rx_ds8)
        begin
          $error("Error : SDI SLAVE :: DATA mismatch at DS8  for line %0d  Data recieved from rx =%0h",rx_ln_ds8,rx_ds8);
          tb_v_smpte_uhdsdi_rxtx.err++;
        end

      end
      if(rx_active_streams == 3'b100)
      begin
        if(10'h3AC != rx_ds9)
        begin
          $error("Error : SDI SLAVE :: DATA mismatch at DS9  for line %0d  Data recieved from rx =%0h",rx_ln_ds9,rx_ds9);
          tb_v_smpte_uhdsdi_rxtx.err++;
        end
        if(10'h3C0 != rx_ds10)
        begin
          $error("Error : SDI SLAVE :: DATA mismatch at DS10  for line %0d  Data recieved from rx =%0h",rx_ln_ds10,rx_ds10);
          tb_v_smpte_uhdsdi_rxtx.err++;
        end
        if(10'h3AC != rx_ds11)
        begin
          $error("Error : SDI SLAVE :: DATA mismatch at DS11  for line %0d  Data recieved from rx =%0h",rx_ln_ds11,rx_ds11);
          tb_v_smpte_uhdsdi_rxtx.err++;
        end
        if(10'h3C0 != rx_ds12)
        begin
          $error("Error : SDI SLAVE :: DATA mismatch at DS12  for line %0d  Data recieved from rx =%0h",rx_ln_ds12,rx_ds12);
          tb_v_smpte_uhdsdi_rxtx.err++;
        end
        if(10'h3AC != rx_ds13)
        begin
          $error("Error : SDI SLAVE :: DATA mismatch at DS13  for line %0d  Data recieved from rx =%0h",rx_ln_ds13,rx_ds13);
          tb_v_smpte_uhdsdi_rxtx.err++;
        end
        if(10'h3C0 != rx_ds14)
        begin
          $error("Error : SDI SLAVE :: DATA mismatch at DS14  for line %0d  Data recieved from rx =%0h",rx_ln_ds14,rx_ds14);
          tb_v_smpte_uhdsdi_rxtx.err++;
        end
        if(10'h3AC != rx_ds15)
        begin
          $error("Error : SDI SLAVE :: DATA mismatch at DS15  for line %0d  Data recieved from rx =%0h",rx_ln_ds15,rx_ds15);
          tb_v_smpte_uhdsdi_rxtx.err++;
        end
        if(10'h3C0 != rx_ds16)
        begin
          $error("Error : SDI SLAVE :: DATA mismatch at DS16  for line %0d  Data recieved from rx =%0h",rx_ln_ds16,rx_ds16);
          tb_v_smpte_uhdsdi_rxtx.err++;
        end

      end

    end
  end

endmodule 

