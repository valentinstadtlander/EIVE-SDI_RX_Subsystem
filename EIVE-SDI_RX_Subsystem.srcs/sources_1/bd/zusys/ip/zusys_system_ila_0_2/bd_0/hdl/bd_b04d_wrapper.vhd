--Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Command: generate_target bd_b04d_wrapper.bd
--Design : bd_b04d_wrapper
--Purpose: IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity bd_b04d_wrapper is
  port (
    SLOT_0_AXIS_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    SLOT_0_AXIS_tkeep : in STD_LOGIC_VECTOR ( 3 downto 0 );
    SLOT_0_AXIS_tlast : in STD_LOGIC;
    SLOT_0_AXIS_tready : in STD_LOGIC;
    SLOT_0_AXIS_tvalid : in STD_LOGIC;
    SLOT_1_AXI_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    SLOT_1_AXI_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    SLOT_1_AXI_arready : in STD_LOGIC;
    SLOT_1_AXI_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    SLOT_1_AXI_arvalid : in STD_LOGIC;
    SLOT_1_AXI_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    SLOT_1_AXI_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    SLOT_1_AXI_awready : in STD_LOGIC;
    SLOT_1_AXI_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    SLOT_1_AXI_awvalid : in STD_LOGIC;
    SLOT_1_AXI_bready : in STD_LOGIC;
    SLOT_1_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    SLOT_1_AXI_bvalid : in STD_LOGIC;
    SLOT_1_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    SLOT_1_AXI_rlast : in STD_LOGIC;
    SLOT_1_AXI_rready : in STD_LOGIC;
    SLOT_1_AXI_rvalid : in STD_LOGIC;
    SLOT_1_AXI_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    SLOT_1_AXI_wlast : in STD_LOGIC;
    SLOT_1_AXI_wready : in STD_LOGIC;
    SLOT_1_AXI_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    SLOT_1_AXI_wvalid : in STD_LOGIC;
    clk : in STD_LOGIC;
    resetn : in STD_LOGIC
  );
end bd_b04d_wrapper;

architecture STRUCTURE of bd_b04d_wrapper is
  component bd_b04d is
  port (
    clk : in STD_LOGIC;
    resetn : in STD_LOGIC;
    SLOT_0_AXIS_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    SLOT_0_AXIS_tkeep : in STD_LOGIC_VECTOR ( 3 downto 0 );
    SLOT_0_AXIS_tlast : in STD_LOGIC;
    SLOT_0_AXIS_tvalid : in STD_LOGIC;
    SLOT_0_AXIS_tready : in STD_LOGIC;
    SLOT_1_AXI_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    SLOT_1_AXI_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    SLOT_1_AXI_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    SLOT_1_AXI_awvalid : in STD_LOGIC;
    SLOT_1_AXI_awready : in STD_LOGIC;
    SLOT_1_AXI_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    SLOT_1_AXI_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    SLOT_1_AXI_wlast : in STD_LOGIC;
    SLOT_1_AXI_wvalid : in STD_LOGIC;
    SLOT_1_AXI_wready : in STD_LOGIC;
    SLOT_1_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    SLOT_1_AXI_bvalid : in STD_LOGIC;
    SLOT_1_AXI_bready : in STD_LOGIC;
    SLOT_1_AXI_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    SLOT_1_AXI_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    SLOT_1_AXI_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    SLOT_1_AXI_arvalid : in STD_LOGIC;
    SLOT_1_AXI_arready : in STD_LOGIC;
    SLOT_1_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    SLOT_1_AXI_rlast : in STD_LOGIC;
    SLOT_1_AXI_rvalid : in STD_LOGIC;
    SLOT_1_AXI_rready : in STD_LOGIC
  );
  end component bd_b04d;
begin
bd_b04d_i: component bd_b04d
     port map (
      SLOT_0_AXIS_tdata(31 downto 0) => SLOT_0_AXIS_tdata(31 downto 0),
      SLOT_0_AXIS_tkeep(3 downto 0) => SLOT_0_AXIS_tkeep(3 downto 0),
      SLOT_0_AXIS_tlast => SLOT_0_AXIS_tlast,
      SLOT_0_AXIS_tready => SLOT_0_AXIS_tready,
      SLOT_0_AXIS_tvalid => SLOT_0_AXIS_tvalid,
      SLOT_1_AXI_araddr(31 downto 0) => SLOT_1_AXI_araddr(31 downto 0),
      SLOT_1_AXI_arlen(7 downto 0) => SLOT_1_AXI_arlen(7 downto 0),
      SLOT_1_AXI_arready => SLOT_1_AXI_arready,
      SLOT_1_AXI_arsize(2 downto 0) => SLOT_1_AXI_arsize(2 downto 0),
      SLOT_1_AXI_arvalid => SLOT_1_AXI_arvalid,
      SLOT_1_AXI_awaddr(31 downto 0) => SLOT_1_AXI_awaddr(31 downto 0),
      SLOT_1_AXI_awlen(7 downto 0) => SLOT_1_AXI_awlen(7 downto 0),
      SLOT_1_AXI_awready => SLOT_1_AXI_awready,
      SLOT_1_AXI_awsize(2 downto 0) => SLOT_1_AXI_awsize(2 downto 0),
      SLOT_1_AXI_awvalid => SLOT_1_AXI_awvalid,
      SLOT_1_AXI_bready => SLOT_1_AXI_bready,
      SLOT_1_AXI_bresp(1 downto 0) => SLOT_1_AXI_bresp(1 downto 0),
      SLOT_1_AXI_bvalid => SLOT_1_AXI_bvalid,
      SLOT_1_AXI_rdata(31 downto 0) => SLOT_1_AXI_rdata(31 downto 0),
      SLOT_1_AXI_rlast => SLOT_1_AXI_rlast,
      SLOT_1_AXI_rready => SLOT_1_AXI_rready,
      SLOT_1_AXI_rvalid => SLOT_1_AXI_rvalid,
      SLOT_1_AXI_wdata(31 downto 0) => SLOT_1_AXI_wdata(31 downto 0),
      SLOT_1_AXI_wlast => SLOT_1_AXI_wlast,
      SLOT_1_AXI_wready => SLOT_1_AXI_wready,
      SLOT_1_AXI_wstrb(3 downto 0) => SLOT_1_AXI_wstrb(3 downto 0),
      SLOT_1_AXI_wvalid => SLOT_1_AXI_wvalid,
      clk => clk,
      resetn => resetn
    );
end STRUCTURE;
