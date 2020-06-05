-- Project: EIVE - Camera Subsystem
-- Module:  SDI_RX_Subsystem_v1_0.vhd
-- Author:  Florian Wiewel
-- Date: 05.03.2020
-- Description: 
-- Automatically generated Wrapper for AXI4-Lite Slave.


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SDI_RX_Subsystem_v1_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 6
	);
	port (
		-- Users to add ports here
        -- SDI RX ports
        rx_fabric_rst_out       : out std_logic;    -- RX fabric reset
        rx_usrclk_out           : out std_logic;    -- rxusrclk input
        rx_line_0_out           : out std_logic_vector(10 downto 0);-- line number for data stream 1
        rx_line_1_out           : out std_logic_vector(10 downto 0);-- line number for data stream 3
        rx_st352_0_out          : out std_logic_vector(31 downto 0);-- video payload ID packet ds1 (for 3G-SDI level A, Y VPID)
        rx_st352_0_valid_out    : out std_logic;-- 1 = st352_0 is valid
        rx_st352_1_out          : out std_logic_vector(31 downto 0);-- video payload ID packet ds3 (ds2 for 3G-SDI level A, C VPID) 
        rx_st352_1_valid_out    : out std_logic;-- 1 = st352_1 is valid
        rx_ds1_out              : out std_logic_vector(9 downto 0);-- SD=Y/C, HD=Y, 3GA=ds1, 3GB=Y link A, 6G/12G=ds1
        rx_ds2_out              : out std_logic_vector(9 downto 0);-- HD=C, 3GA=ds2, 3GB=C link A, 6G/12G=ds2
        rx_eav_out              : out std_logic;-- 1 during XYZ word of EAV
        rx_sav_out              : out std_logic;-- 1 during XYZ word of SAV
        rx_trs_out              : out std_logic;-- 1 during all 4 words of EAV and SAV
        -- GTH ports
        gth_cpll_refclk_p_in                    : in  std_logic;-- GTH CPLL Ref Clock P Input
        gth_cpll_refclk_n_in                    : in  std_logic;-- GTH CPLL Ref Clock N Input
        gth_rxn_in                              : in  std_logic;-- GTH RXN Input
        gth_rxp_in                              : in  std_logic;-- GTH RXP Input
		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic
	);
end SDI_RX_Subsystem_v1_0;

architecture arch_imp of SDI_RX_Subsystem_v1_0 is

	-- component declaration
	component SDI_RX_Subsystem_v1_0_S00_AXI is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 6
		);
		port (
		-- SDI RX ports
        rx_fabric_rst_out       : out std_logic;    -- RX fabric reset
        rx_usrclk_out           : out std_logic;    -- rxusrclk input
        rx_line_0_out           : out std_logic_vector(10 downto 0);-- line number for data stream 1
        rx_line_1_out           : out std_logic_vector(10 downto 0);-- line number for data stream 3
        rx_st352_0_out          : out std_logic_vector(31 downto 0);-- video payload ID packet ds1 (for 3G-SDI level A, Y VPID)
        rx_st352_0_valid_out    : out std_logic;-- 1 = st352_0 is valid
        rx_st352_1_out          : out std_logic_vector(31 downto 0);-- video payload ID packet ds3 (ds2 for 3G-SDI level A, C VPID) 
        rx_st352_1_valid_out    : out std_logic;-- 1 = st352_1 is valid
        rx_ds1_out              : out std_logic_vector(9 downto 0);-- SD=Y/C, HD=Y, 3GA=ds1, 3GB=Y link A, 6G/12G=ds1
        rx_ds2_out              : out std_logic_vector(9 downto 0);-- HD=C, 3GA=ds2, 3GB=C link A, 6G/12G=ds2
        rx_eav_out              : out std_logic;-- 1 during XYZ word of EAV
        rx_sav_out              : out std_logic;-- 1 during XYZ word of SAV
        rx_trs_out              : out std_logic;-- 1 during all 4 words of EAV and SAV
        -- GTH ports
        gth_cpll_refclk_p_in                    : in  std_logic;-- GTH CPLL Ref Clock P Input
        gth_cpll_refclk_n_in                    : in  std_logic;-- GTH CPLL Ref Clock N Input
        gth_rxn_in                              : in  std_logic;-- GTH RXN Input
        gth_rxp_in                              : in  std_logic;-- GTH RXP Input
       
        
        
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component SDI_RX_Subsystem_v1_0_S00_AXI;

begin

-- Instantiation of Axi Bus Interface S00_AXI
SDI_RX_Subsystem_v1_0_S00_AXI_inst : SDI_RX_Subsystem_v1_0_S00_AXI
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
	    -- SDI RX ports
	    rx_fabric_rst_out       => rx_fabric_rst_out,    -- RX fabric reset
	    rx_usrclk_out           => rx_usrclk_out,    -- rxusrclk input
	    rx_line_0_out           => rx_line_0_out,-- line number for data stream 1
	    rx_line_1_out           => rx_line_1_out,-- line number for data stream 3
	    rx_st352_0_out          => rx_st352_0_out,-- video payload ID packet ds1 (for 3G-SDI level A, Y VPID)
	    rx_st352_0_valid_out    => rx_st352_0_valid_out,-- 1 = st352_0 is valid
	    rx_st352_1_out          => rx_st352_1_out,-- video payload ID packet ds3 (ds2 for 3G-SDI level A, C VPID) 
	    rx_st352_1_valid_out    => rx_st352_1_valid_out,-- 1 = st352_1 is valid
	    rx_ds1_out              => rx_ds1_out,-- SD=Y/C, HD=Y, 3GA=ds1, 3GB=Y link A, 6G/12G=ds1
	    rx_ds2_out              => rx_ds2_out,-- HD=C, 3GA=ds2, 3GB=C link A, 6G/12G=ds2
	    rx_eav_out              => rx_eav_out,-- 1 during XYZ word of EAV
	    rx_sav_out              => rx_sav_out,-- 1 during XYZ word of SAV
	    rx_trs_out              => rx_trs_out,-- 1 during all 4 words of EAV and SAV
	    -- GTH ports
	    gth_cpll_refclk_p_in                    => gth_cpll_refclk_p_in,-- GTH CPLL Ref Clock P Input
        gth_cpll_refclk_n_in                    => gth_cpll_refclk_n_in,-- GTH CPLL Ref Clock N Input
	    gth_rxn_in                              => gth_rxn_in,-- GTH RXN Input
	    gth_rxp_in                              => gth_rxp_in,-- GTH RXP Input

		S_AXI_ACLK	=> s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA	=> s00_axi_wdata,
		S_AXI_WSTRB	=> s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP	=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA	=> s00_axi_rdata,
		S_AXI_RRESP	=> s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready
	);

	-- Add user logic here
	-- User logic ends

end arch_imp;
