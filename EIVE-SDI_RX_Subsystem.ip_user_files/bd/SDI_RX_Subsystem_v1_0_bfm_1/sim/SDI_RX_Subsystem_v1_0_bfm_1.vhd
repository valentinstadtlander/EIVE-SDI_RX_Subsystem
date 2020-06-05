--Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
--Date        : Fri May 29 17:04:59 2020
--Host        : DESKTOP-URKU7BU running 64-bit major release  (build 9200)
--Command     : generate_target SDI_RX_Subsystem_v1_0_bfm_1.bd
--Design      : SDI_RX_Subsystem_v1_0_bfm_1
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity SDI_RX_Subsystem_v1_0_bfm_1 is
  port (
    ACLK : in STD_LOGIC;
    ARESETN : in STD_LOGIC
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of SDI_RX_Subsystem_v1_0_bfm_1 : entity is "SDI_RX_Subsystem_v1_0_bfm_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=SDI_RX_Subsystem_v1_0_bfm_1,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=3,numReposBlks=3,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of SDI_RX_Subsystem_v1_0_bfm_1 : entity is "SDI_RX_Subsystem_v1_0_bfm_1.hwdef";
end SDI_RX_Subsystem_v1_0_bfm_1;

architecture STRUCTURE of SDI_RX_Subsystem_v1_0_bfm_1 is
  component SDI_RX_Subsystem_v1_0_bfm_1_master_0_0 is
  port (
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    m_axi_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_awvalid : out STD_LOGIC;
    m_axi_awready : in STD_LOGIC;
    m_axi_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_wvalid : out STD_LOGIC;
    m_axi_wready : in STD_LOGIC;
    m_axi_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_bvalid : in STD_LOGIC;
    m_axi_bready : out STD_LOGIC;
    m_axi_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_arvalid : out STD_LOGIC;
    m_axi_arready : in STD_LOGIC;
    m_axi_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_rvalid : in STD_LOGIC;
    m_axi_rready : out STD_LOGIC
  );
  end component SDI_RX_Subsystem_v1_0_bfm_1_master_0_0;
  component SDI_RX_Subsystem_v1_0_bfm_1_sim_clk_gen_0_1 is
  port (
    clk_n : out STD_LOGIC;
    clk_p : out STD_LOGIC
  );
  end component SDI_RX_Subsystem_v1_0_bfm_1_sim_clk_gen_0_1;
  component SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0 is
  port (
    rx_fabric_rst_out : out STD_LOGIC;
    rx_usrclk_out : out STD_LOGIC;
    rx_line_0_out : out STD_LOGIC_VECTOR ( 10 downto 0 );
    rx_line_1_out : out STD_LOGIC_VECTOR ( 10 downto 0 );
    rx_st352_0_out : out STD_LOGIC_VECTOR ( 31 downto 0 );
    rx_st352_0_valid_out : out STD_LOGIC;
    rx_st352_1_out : out STD_LOGIC_VECTOR ( 31 downto 0 );
    rx_st352_1_valid_out : out STD_LOGIC;
    rx_ds1_out : out STD_LOGIC_VECTOR ( 9 downto 0 );
    rx_ds2_out : out STD_LOGIC_VECTOR ( 9 downto 0 );
    rx_eav_out : out STD_LOGIC;
    rx_sav_out : out STD_LOGIC;
    rx_trs_out : out STD_LOGIC;
    gth_cpll_refclk_p_in : in STD_LOGIC;
    gth_cpll_refclk_n_in : in STD_LOGIC;
    gth_rxn_in : in STD_LOGIC;
    gth_rxp_in : in STD_LOGIC;
    s00_axi_awaddr : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s00_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_awvalid : in STD_LOGIC;
    s00_axi_awready : out STD_LOGIC;
    s00_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_wvalid : in STD_LOGIC;
    s00_axi_wready : out STD_LOGIC;
    s00_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_bvalid : out STD_LOGIC;
    s00_axi_bready : in STD_LOGIC;
    s00_axi_araddr : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s00_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_arvalid : in STD_LOGIC;
    s00_axi_arready : out STD_LOGIC;
    s00_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_rvalid : out STD_LOGIC;
    s00_axi_rready : in STD_LOGIC;
    s00_axi_aclk : in STD_LOGIC;
    s00_axi_aresetn : in STD_LOGIC
  );
  end component SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0;
  signal aclk_net : STD_LOGIC;
  signal aresetn_net : STD_LOGIC;
  signal master_0_M_AXI_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal master_0_M_AXI_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal master_0_M_AXI_ARREADY : STD_LOGIC;
  signal master_0_M_AXI_ARVALID : STD_LOGIC;
  signal master_0_M_AXI_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal master_0_M_AXI_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal master_0_M_AXI_AWREADY : STD_LOGIC;
  signal master_0_M_AXI_AWVALID : STD_LOGIC;
  signal master_0_M_AXI_BREADY : STD_LOGIC;
  signal master_0_M_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal master_0_M_AXI_BVALID : STD_LOGIC;
  signal master_0_M_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal master_0_M_AXI_RREADY : STD_LOGIC;
  signal master_0_M_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal master_0_M_AXI_RVALID : STD_LOGIC;
  signal master_0_M_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal master_0_M_AXI_WREADY : STD_LOGIC;
  signal master_0_M_AXI_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal master_0_M_AXI_WVALID : STD_LOGIC;
  signal sim_clk_gen_0_clk_n : STD_LOGIC;
  signal sim_clk_gen_0_clk_p : STD_LOGIC;
  signal NLW_SDI_RX_Subsystem_0_rx_eav_out_UNCONNECTED : STD_LOGIC;
  signal NLW_SDI_RX_Subsystem_0_rx_fabric_rst_out_UNCONNECTED : STD_LOGIC;
  signal NLW_SDI_RX_Subsystem_0_rx_sav_out_UNCONNECTED : STD_LOGIC;
  signal NLW_SDI_RX_Subsystem_0_rx_st352_0_valid_out_UNCONNECTED : STD_LOGIC;
  signal NLW_SDI_RX_Subsystem_0_rx_st352_1_valid_out_UNCONNECTED : STD_LOGIC;
  signal NLW_SDI_RX_Subsystem_0_rx_trs_out_UNCONNECTED : STD_LOGIC;
  signal NLW_SDI_RX_Subsystem_0_rx_usrclk_out_UNCONNECTED : STD_LOGIC;
  signal NLW_SDI_RX_Subsystem_0_rx_ds1_out_UNCONNECTED : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal NLW_SDI_RX_Subsystem_0_rx_ds2_out_UNCONNECTED : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal NLW_SDI_RX_Subsystem_0_rx_line_0_out_UNCONNECTED : STD_LOGIC_VECTOR ( 10 downto 0 );
  signal NLW_SDI_RX_Subsystem_0_rx_line_1_out_UNCONNECTED : STD_LOGIC_VECTOR ( 10 downto 0 );
  signal NLW_SDI_RX_Subsystem_0_rx_st352_0_out_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_SDI_RX_Subsystem_0_rx_st352_1_out_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of ACLK : signal is "xilinx.com:signal:clock:1.0 CLK.ACLK CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of ACLK : signal is "XIL_INTERFACENAME CLK.ACLK, ASSOCIATED_RESET ARESETN, CLK_DOMAIN SDI_RX_Subsystem_v1_0_bfm_1_ACLK, FREQ_HZ 100000000, PHASE 0.000";
  attribute X_INTERFACE_INFO of ARESETN : signal is "xilinx.com:signal:reset:1.0 RST.ARESETN RST";
  attribute X_INTERFACE_PARAMETER of ARESETN : signal is "XIL_INTERFACENAME RST.ARESETN, POLARITY ACTIVE_LOW";
begin
  aclk_net <= ACLK;
  aresetn_net <= ARESETN;
SDI_RX_Subsystem_0: component SDI_RX_Subsystem_v1_0_bfm_1_SDI_RX_Subsystem_0_0
     port map (
      gth_cpll_refclk_n_in => sim_clk_gen_0_clk_n,
      gth_cpll_refclk_p_in => sim_clk_gen_0_clk_p,
      gth_rxn_in => '0',
      gth_rxp_in => '0',
      rx_ds1_out(9 downto 0) => NLW_SDI_RX_Subsystem_0_rx_ds1_out_UNCONNECTED(9 downto 0),
      rx_ds2_out(9 downto 0) => NLW_SDI_RX_Subsystem_0_rx_ds2_out_UNCONNECTED(9 downto 0),
      rx_eav_out => NLW_SDI_RX_Subsystem_0_rx_eav_out_UNCONNECTED,
      rx_fabric_rst_out => NLW_SDI_RX_Subsystem_0_rx_fabric_rst_out_UNCONNECTED,
      rx_line_0_out(10 downto 0) => NLW_SDI_RX_Subsystem_0_rx_line_0_out_UNCONNECTED(10 downto 0),
      rx_line_1_out(10 downto 0) => NLW_SDI_RX_Subsystem_0_rx_line_1_out_UNCONNECTED(10 downto 0),
      rx_sav_out => NLW_SDI_RX_Subsystem_0_rx_sav_out_UNCONNECTED,
      rx_st352_0_out(31 downto 0) => NLW_SDI_RX_Subsystem_0_rx_st352_0_out_UNCONNECTED(31 downto 0),
      rx_st352_0_valid_out => NLW_SDI_RX_Subsystem_0_rx_st352_0_valid_out_UNCONNECTED,
      rx_st352_1_out(31 downto 0) => NLW_SDI_RX_Subsystem_0_rx_st352_1_out_UNCONNECTED(31 downto 0),
      rx_st352_1_valid_out => NLW_SDI_RX_Subsystem_0_rx_st352_1_valid_out_UNCONNECTED,
      rx_trs_out => NLW_SDI_RX_Subsystem_0_rx_trs_out_UNCONNECTED,
      rx_usrclk_out => NLW_SDI_RX_Subsystem_0_rx_usrclk_out_UNCONNECTED,
      s00_axi_aclk => aclk_net,
      s00_axi_araddr(5 downto 0) => master_0_M_AXI_ARADDR(5 downto 0),
      s00_axi_aresetn => aresetn_net,
      s00_axi_arprot(2 downto 0) => master_0_M_AXI_ARPROT(2 downto 0),
      s00_axi_arready => master_0_M_AXI_ARREADY,
      s00_axi_arvalid => master_0_M_AXI_ARVALID,
      s00_axi_awaddr(5 downto 0) => master_0_M_AXI_AWADDR(5 downto 0),
      s00_axi_awprot(2 downto 0) => master_0_M_AXI_AWPROT(2 downto 0),
      s00_axi_awready => master_0_M_AXI_AWREADY,
      s00_axi_awvalid => master_0_M_AXI_AWVALID,
      s00_axi_bready => master_0_M_AXI_BREADY,
      s00_axi_bresp(1 downto 0) => master_0_M_AXI_BRESP(1 downto 0),
      s00_axi_bvalid => master_0_M_AXI_BVALID,
      s00_axi_rdata(31 downto 0) => master_0_M_AXI_RDATA(31 downto 0),
      s00_axi_rready => master_0_M_AXI_RREADY,
      s00_axi_rresp(1 downto 0) => master_0_M_AXI_RRESP(1 downto 0),
      s00_axi_rvalid => master_0_M_AXI_RVALID,
      s00_axi_wdata(31 downto 0) => master_0_M_AXI_WDATA(31 downto 0),
      s00_axi_wready => master_0_M_AXI_WREADY,
      s00_axi_wstrb(3 downto 0) => master_0_M_AXI_WSTRB(3 downto 0),
      s00_axi_wvalid => master_0_M_AXI_WVALID
    );
master_0: component SDI_RX_Subsystem_v1_0_bfm_1_master_0_0
     port map (
      aclk => aclk_net,
      aresetn => aresetn_net,
      m_axi_araddr(31 downto 0) => master_0_M_AXI_ARADDR(31 downto 0),
      m_axi_arprot(2 downto 0) => master_0_M_AXI_ARPROT(2 downto 0),
      m_axi_arready => master_0_M_AXI_ARREADY,
      m_axi_arvalid => master_0_M_AXI_ARVALID,
      m_axi_awaddr(31 downto 0) => master_0_M_AXI_AWADDR(31 downto 0),
      m_axi_awprot(2 downto 0) => master_0_M_AXI_AWPROT(2 downto 0),
      m_axi_awready => master_0_M_AXI_AWREADY,
      m_axi_awvalid => master_0_M_AXI_AWVALID,
      m_axi_bready => master_0_M_AXI_BREADY,
      m_axi_bresp(1 downto 0) => master_0_M_AXI_BRESP(1 downto 0),
      m_axi_bvalid => master_0_M_AXI_BVALID,
      m_axi_rdata(31 downto 0) => master_0_M_AXI_RDATA(31 downto 0),
      m_axi_rready => master_0_M_AXI_RREADY,
      m_axi_rresp(1 downto 0) => master_0_M_AXI_RRESP(1 downto 0),
      m_axi_rvalid => master_0_M_AXI_RVALID,
      m_axi_wdata(31 downto 0) => master_0_M_AXI_WDATA(31 downto 0),
      m_axi_wready => master_0_M_AXI_WREADY,
      m_axi_wstrb(3 downto 0) => master_0_M_AXI_WSTRB(3 downto 0),
      m_axi_wvalid => master_0_M_AXI_WVALID
    );
sim_clk_gen_0: component SDI_RX_Subsystem_v1_0_bfm_1_sim_clk_gen_0_1
     port map (
      clk_n => sim_clk_gen_0_clk_n,
      clk_p => sim_clk_gen_0_clk_p
    );
end STRUCTURE;
