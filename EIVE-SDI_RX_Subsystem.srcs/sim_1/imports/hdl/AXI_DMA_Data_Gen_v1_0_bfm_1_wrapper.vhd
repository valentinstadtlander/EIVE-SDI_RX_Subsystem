--Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2017.4_AR70593 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
--Date        : Sat Feb 29 17:40:29 2020
--Host        : DESKTOP-FS0PH5V running 64-bit major release  (build 9200)
--Command     : generate_target AXI_DMA_Data_Gen_v1_0_bfm_1_wrapper.bd
--Design      : AXI_DMA_Data_Gen_v1_0_bfm_1_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity AXI_DMA_Data_Gen_v1_0_bfm_1_wrapper is
  port (
    ACLK : in STD_LOGIC;
    ARESETN : in STD_LOGIC
  );
end AXI_DMA_Data_Gen_v1_0_bfm_1_wrapper;

architecture STRUCTURE of AXI_DMA_Data_Gen_v1_0_bfm_1_wrapper is
  component AXI_DMA_Data_Gen_v1_0_bfm_1 is
  port (
    ACLK : in STD_LOGIC;
    ARESETN : in STD_LOGIC
  );
  end component AXI_DMA_Data_Gen_v1_0_bfm_1;
begin
AXI_DMA_Data_Gen_v1_0_bfm_1_i: component AXI_DMA_Data_Gen_v1_0_bfm_1
     port map (
      ACLK => ACLK,
      ARESETN => ARESETN
    );
end STRUCTURE;
