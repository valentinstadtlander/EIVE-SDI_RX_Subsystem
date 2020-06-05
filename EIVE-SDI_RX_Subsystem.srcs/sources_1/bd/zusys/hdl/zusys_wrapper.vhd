--Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
--Date        : Fri May  8 09:11:06 2020
--Host        : ILH-517 running 64-bit major release  (build 9200)
--Command     : generate_target zusys_wrapper.bd
--Design      : zusys_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity zusys_wrapper is
  port (
    gth_cpll_refclk_n_in : in STD_LOGIC;
    gth_cpll_refclk_p_in : in STD_LOGIC;
    gth_rxn_in : in STD_LOGIC;
    gth_rxp_in : in STD_LOGIC
  );
end zusys_wrapper;

architecture STRUCTURE of zusys_wrapper is
  component zusys is
  port (
    gth_cpll_refclk_p_in : in STD_LOGIC;
    gth_cpll_refclk_n_in : in STD_LOGIC;
    gth_rxp_in : in STD_LOGIC;
    gth_rxn_in : in STD_LOGIC
  );
  end component zusys;
begin
zusys_i: component zusys
     port map (
      gth_cpll_refclk_n_in => gth_cpll_refclk_n_in,
      gth_cpll_refclk_p_in => gth_cpll_refclk_p_in,
      gth_rxn_in => gth_rxn_in,
      gth_rxp_in => gth_rxp_in
    );
end STRUCTURE;
