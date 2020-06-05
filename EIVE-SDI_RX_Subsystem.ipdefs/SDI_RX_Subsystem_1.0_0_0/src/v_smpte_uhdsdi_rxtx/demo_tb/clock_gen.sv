

//====================================================================
//  This module generates the Clock signal for different Video Modes
//====================================================================

`timescale 1ns / 1ps


module clk_gen (
 input  wire [2:0] MODE,
 output reg tb_clk
 );

localparam reg [2:0]
    MODE_HD = 3'b000,
    MODE_SD = 3'b001,
    MODE_3G = 3'b010,
    MODE_6G = 3'b100,
    MODE_12G = 3'b101,
    MODE_12G_1 = 3'b110;

initial
begin
  tb_clk = 1'h0;
end

always
begin
  if((MODE == MODE_3G) || (MODE == MODE_6G) || (MODE == MODE_SD))
  begin
  #3.37 tb_clk = ~tb_clk;     // 148.5 Mhz
  end 
  else if(MODE == MODE_HD)
  begin
  #6.73 tb_clk = ~tb_clk;     // 74.25 Mhz
  end 
  else if(MODE == MODE_12G)
  begin
  #1.68 tb_clk = ~tb_clk;     // 297 Mhz
  end 
  else
  begin
  #3.37 tb_clk = ~tb_clk;     // 148.5 Mhz
  end 
end


endmodule
