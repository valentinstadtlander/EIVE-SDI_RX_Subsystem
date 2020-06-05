--Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2017.4_AR70593 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
--Date        : Thu Mar  5 21:14:09 2020
--Host        : DESKTOP-FS0PH5V running 64-bit major release  (build 9200)
--Command     : generate_target SDI_RX_Subsystem_v1_0_bfm_1_wrapper.bd
--Design      : SDI_RX_Subsystem_v1_0_bfm_1_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity SDI_RX_Subsystem_v1_0_bfm_1_wrapper is
  port (
    ACLK : in STD_LOGIC;
    ARESETN : in STD_LOGIC
  );
end SDI_RX_Subsystem_v1_0_bfm_1_wrapper;

architecture STRUCTURE of SDI_RX_Subsystem_v1_0_bfm_1_wrapper is
  component SDI_RX_Subsystem_v1_0_bfm_1 is
  port (
    ACLK : in STD_LOGIC;
    ARESETN : in STD_LOGIC
  );
  end component SDI_RX_Subsystem_v1_0_bfm_1;
begin
SDI_RX_Subsystem_v1_0_bfm_1_i: component SDI_RX_Subsystem_v1_0_bfm_1
     port map (
      ACLK => ACLK,
      ARESETN => ARESETN
    );
end STRUCTURE;
