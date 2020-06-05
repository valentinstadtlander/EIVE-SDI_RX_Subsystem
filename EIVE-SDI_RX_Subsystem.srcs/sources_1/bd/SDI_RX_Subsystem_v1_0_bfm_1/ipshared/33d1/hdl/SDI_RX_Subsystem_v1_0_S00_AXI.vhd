-- Project: EIVE - Camera Subsystem
-- Module:  SDI_RX_Subsystem_v1_0_S00_AXI.vhd
-- Author:  Florian Wiewel
-- Date: 05.03.2020
-- Description: 
-- Automatically generated AXI4-Lite Slave logic including SDI RX receiver logic.
Library xpm;
use xpm.vcomponents.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library xil_defaultlib;
use xil_defaultlib.all;

entity SDI_RX_Subsystem_v1_0_S00_AXI is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line

		-- Width of S_AXI data bus
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		-- Width of S_AXI address bus
		C_S_AXI_ADDR_WIDTH	: integer	:= 6
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

		-- Global Clock Signal
		S_AXI_ACLK	: in std_logic;
		-- Global Reset Signal. This Signal is Active LOW
		S_AXI_ARESETN	: in std_logic;
		-- Write address (issued by master, acceped by Slave)
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		-- Write channel Protection type. This signal indicates the
    		-- privilege and security level of the transaction, and whether
    		-- the transaction is a data access or an instruction access.
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		-- Write address valid. This signal indicates that the master signaling
    		-- valid write address and control information.
		S_AXI_AWVALID	: in std_logic;
		-- Write address ready. This signal indicates that the slave is ready
    		-- to accept an address and associated control signals.
		S_AXI_AWREADY	: out std_logic;
		-- Write data (issued by master, acceped by Slave) 
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		-- Write strobes. This signal indicates which byte lanes hold
    		-- valid data. There is one write strobe bit for each eight
    		-- bits of the write data bus.    
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		-- Write valid. This signal indicates that valid write
    		-- data and strobes are available.
		S_AXI_WVALID	: in std_logic;
		-- Write ready. This signal indicates that the slave
    		-- can accept the write data.
		S_AXI_WREADY	: out std_logic;
		-- Write response. This signal indicates the status
    		-- of the write transaction.
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		-- Write response valid. This signal indicates that the channel
    		-- is signaling a valid write response.
		S_AXI_BVALID	: out std_logic;
		-- Response ready. This signal indicates that the master
    		-- can accept a write response.
		S_AXI_BREADY	: in std_logic;
		-- Read address (issued by master, acceped by Slave)
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		-- Protection type. This signal indicates the privilege
    		-- and security level of the transaction, and whether the
    		-- transaction is a data access or an instruction access.
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		-- Read address valid. This signal indicates that the channel
    		-- is signaling valid read address and control information.
		S_AXI_ARVALID	: in std_logic;
		-- Read address ready. This signal indicates that the slave is
    		-- ready to accept an address and associated control signals.
		S_AXI_ARREADY	: out std_logic;
		-- Read data (issued by slave)
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		-- Read response. This signal indicates the status of the
    		-- read transfer.
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		-- Read valid. This signal indicates that the channel is
    		-- signaling the required read data.
		S_AXI_RVALID	: out std_logic;
		-- Read ready. This signal indicates that the master can
    		-- accept the read data and response information.
		S_AXI_RREADY	: in std_logic
	);
end SDI_RX_Subsystem_v1_0_S00_AXI;

architecture arch_imp of SDI_RX_Subsystem_v1_0_S00_AXI is

    -- Component declaration
    component kugth_uhdsdi_3g_wrapper_support is 
        generic(
            TXPLLCLKSEL_TX_M_0              : std_logic_vector(1 downto 0) := "11";         -- Value to output on TXPLLCLKSEL when tx_m is 0; --CPLL=00, QPLL0=11, QPLL1=10 
            TXPLLCLKSEL_TX_M_1              : std_logic_vector(1 downto 0) := "10";        -- Value to output on TXPLLCLKSEL when tx_m is 1; --CPLL=00, QPLL0=11, QPLL1=10 
            RX_FXDCLK_FREQ                  : integer := 27000000;                          -- Frequency, in hertz, of fxdclk
            RXPLLCLKSEL_RX_M_0              : std_logic_vector(1 downto 0) := "11";         -- Value to output on RXPLLCLKSEL when rx_m is 0; --CPLL=00, QPLL0=11, QPLL1=10 
            RXPLLCLKSEL_RX_M_1              : std_logic_vector(1 downto 0) := "10";         -- Value to output on RXPLLCLKSEL when rx_m is 1; --CPLL=00, QPLL0=11, QPLL1=10 
            XY_SITE                         : string := "x1y4";                            -- GTH Location
            EN_HOT_PLUG_LOGIC               : integer := 0                                  -- Enable Hot-Plug logic    
            );
        port(
            -- RX ports
            rx_fxdclk_in            : in  std_logic;-- fixed frequency clock SDI RX bit rate detection
            rx_rst_in               : in  std_logic;-- sync reset for SDI RX data path
            rx_fabric_rst_out       : out std_logic;-- RX fabric reset
            rx_usrclk_out           : out std_logic;-- rxusrclk input
            rx_mode_detect_rst_in   : in  std_logic;-- synchronous reset for SDI mode detection function 
            rx_mode_en_in           : in  std_logic_vector(2 downto 0);-- unary enable bits for SDI mode search {3G, SD, HD} 1=enable, 0=disable
            rx_mode_detect_en_in    : in  std_logic;-- 1 enables SDI mode detection      
            rx_forced_mode_in       : in  std_logic_vector(1 downto 0); -- if mode_detect_en=0, this port specifies the SDI mode of the RX
            rx_mode_out             : out std_logic_vector(1 downto 0);-- 00=HD, 01=SD, 10=3G
            rx_mode_hd_out          : out std_logic;-- 1 = HD mode      
            rx_mode_sd_out          : out std_logic;-- 1 = SD mode
            rx_mode_3g_out          : out std_logic;-- 1 = 3G mode
            rx_mode_locked_out      : out std_logic;-- auto mode detection locked
            rx_bit_rate_out         : out std_logic;-- 0 = 1000/1000, 1 = 1000/1001
            rx_t_locked_out         : out std_logic;-- transport format detection locked
            rx_t_family_out         : out std_logic_vector(3 downto 0);-- transport format family
            rx_t_rate_out           : out std_logic_vector(3 downto 0);-- transport frame rate
            rx_t_scan_out           : out std_logic;-- transport scan: 0=interlaced, 1=progressive
            rx_level_b_3g_out       : out std_logic;-- 0 = level A, 1 = level B
            rx_ce_out               : out std_logic;-- clock enable 
            rx_active_streams_out   : out std_logic_vector(2 downto 0);-- 2^active_streams = number of active streams
            rx_line_0_out           : out std_logic_vector(10 downto 0);-- line number for data stream 1
            rx_line_1_out           : out std_logic_vector(10 downto 0);-- line number for data stream 3
            rx_st352_0_out          : out std_logic_vector(31 downto 0);-- video payload ID packet ds1 (for 3G-SDI level A, Y VPID)
            rx_st352_0_valid_out    : out std_logic;-- 1 = st352_0 is valid
            rx_st352_1_out          : out std_logic_vector(31 downto 0);-- video payload ID packet ds3 (ds2 for 3G-SDI level A, C VPID) 
            rx_st352_1_valid_out    : out std_logic;-- 1 = st352_1 is valid
            rx_crc_err_out          : out std_logic_vector(3 downto 0);-- CRC error signals for all 4 data streams [ds4:ds1]
            rx_ds1_out              : out std_logic_vector(9 downto 0);-- SD=Y/C, HD=Y, 3GA=ds1, 3GB=Y link A, 6G/12G=ds1
            rx_ds2_out              : out std_logic_vector(9 downto 0);-- HD=C, 3GA=ds2, 3GB=C link A, 6G/12G=ds2
            rx_ds3_out              : out std_logic_vector(9 downto 0);-- 3GB=Y link B, 6G/12G=ds3
            rx_ds4_out              : out std_logic_vector(9 downto 0);-- 3GB=C link B, 6G/12G=ds4
            rx_eav_out              : out std_logic;-- 1 during XYZ word of EAV
            rx_sav_out              : out std_logic;-- 1 during XYZ word of SAV
            rx_trs_out              : out std_logic;-- 1 during all 4 words of EAV and SAV
            rx_edh_errcnt_en_in     : in  std_logic_vector(15 downto 0);-- enables various errors to increment rx_edh_errcnt
            rx_edh_clr_errcnt_in    : in  std_logic;-- clears rx_edh_errcnt
            rx_edh_ap_out           : out std_logic;-- 1 = AP CRC error detected previous field
            rx_edh_ff_out           : out std_logic;-- 1 = FF CRC error detected previous field
            rx_edh_anc_out          : out std_logic;-- 1 = ANC checksum error detected
            rx_edh_ap_flags_out     : out std_logic_vector(4 downto 0);-- EDH AP flags received in last EDH packet
            rx_edh_ff_flags_out     : out std_logic_vector(4 downto 0);-- EDH FF flags received in last EDH packet
            rx_edh_anc_flags_out    : out std_logic_vector(4 downto 0);-- EDH ANC flags received in last EDH packet
            rx_edh_packet_flags_out : out std_logic_vector(3 downto 0);-- EDH packet error condition flags
            rx_edh_errcnt_out       : out std_logic_vector(15 downto 0);-- EDH error counter
            rx_change_done_out      : out std_logic;-- 1 when rx_mode change has completed successfully                         (drpclk)
            rx_change_fail_out      : out std_logic;-- 1 when rx_mode change failed                                             (drpclk)
            rx_change_fail_code_out : out std_logic_vector(2 downto 0);-- failure code when rx_change_fail = 1                                     (drpclk)
        
        -- TX ports                                                (clock domain)
            tx_rst_in               : in  std_logic;-- sync reset for SDI TX data path
            tx_fabric_rst_out       : out std_logic;-- TX fabric reset
            tx_usrclk_out           : out std_logic;-- clock input
            tx_ce_in                : in  std_logic;-- clock enable 
            tx_sd_ce_in             : in  std_logic;-- SD-SDI clock enable, must be High in all other modes
            tx_edh_ce_in            : in  std_logic;-- EDH clock enable, recommended Low in all modes except SD-SDI
            tx_mode_in              : in  std_logic_vector(1 downto 0);-- 00=HD, 01=SD, 10=3G
            tx_m_in                 : in  std_logic;-- 0 = select 148.35 MHz refclk, 1 = select 148.5 MHz refclk                (async)
            tx_insert_crc_in        : in  std_logic;-- 1 = insert CRC for HD and 3G
            tx_insert_ln_in         : in  std_logic;-- 1 = insert LN for HD and 3G
            tx_insert_st352_in      : in  std_logic;-- 1 = enable ST352 PID packet insert
            tx_overwrite_st352_in   : in  std_logic;-- 1 = overwrite existing ST352 packets
            tx_insert_edh_in        : in  std_logic;-- 1 = generate & insert EDH for SD 
            tx_mux_pattern_in       : in  std_logic_vector(2 downto 0);-- specifies the multiplex interleave pattern of data streams 
            tx_insert_sync_bit_in   : in  std_logic;-- 1 enables sync bit insertion
            tx_line_0_in            : in  std_logic_vector(10 downto 0);-- current line number for ds1 & ds2
            tx_line_1_in            : in  std_logic_vector(10 downto 0);-- current line number for ds3 & ds4
            tx_st352_line_f1_in     : in  std_logic_vector(10 downto 0);-- insert ST352 packet on this line in field 1
            tx_st352_line_f2_in     : in  std_logic_vector(10 downto 0);-- insert ST352 packet on this line in field 2
            tx_st352_f2_en_in       : in  std_logic;-- enable ST352 packet insertion in field 2
            tx_st352_data_0_in      : in  std_logic_vector(31 downto 0);-- ST352 data bytes for ds1 {byte4, byte3, byte2, byte1} 
            tx_st352_data_1_in      : in  std_logic_vector(31 downto 0);-- ST352 data bytes for ds3 (and ds2 in 3GA mode) {byte4, byte3, byte2, byte1} 
            tx_ds1_in               : in  std_logic_vector(9 downto 0);-- data stream 1 (Y) in -- only active ds in SD, Y for HD & 3GA, AY for 3GB
            tx_ds2_in               : in  std_logic_vector(9 downto 0);-- data stream 2 (C) in -- C for HD & 3GA, AC for 3GB
            tx_ds3_in               : in  std_logic_vector(9 downto 0);-- data stream 3 (Y) in -- BY for 3GB
            tx_ds4_in               : in  std_logic_vector(9 downto 0);-- data stream 4 (C) in -- BC for 3GB
            tx_ds1_st352_out        : out std_logic_vector(9 downto 0);-- data stream 1 after ST352 insertion
            tx_ds2_st352_out        : out std_logic_vector(9 downto 0);-- data stream 2 after ST352 insertion
            tx_ds3_st352_out        : out std_logic_vector(9 downto 0);-- data stream 3 after ST352 insertion
            tx_ds4_st352_out        : out std_logic_vector(9 downto 0);-- data stream 4 after ST352 insertion
            tx_ds1_anc_in           : in  std_logic_vector(9 downto 0);-- data stream 1 after ANC insertion input
            tx_ds2_anc_in           : in  std_logic_vector(9 downto 0);-- data stream 2 after ANC insertion input
            tx_ds3_anc_in           : in  std_logic_vector(9 downto 0);-- data stream 3 after ANC insertion input
            tx_ds4_anc_in           : in  std_logic_vector(9 downto 0);-- data stream 4 after ANC insertion input
            tx_use_anc_in           : in  std_logic;-- use the dsX_anc_in ports
            tx_ce_align_err_out     : out std_logic;-- 1 if ce 5/6/5/6 cadence is broken in SD-SDI mode
            tx_slew_out             : out std_logic;-- slew rate control signal for SDI cable driver
            tx_change_done_out      : out std_logic;-- 1 when txrate or txsysclksel changes complete successfully               (drpclk)
            tx_change_fail_out      : out std_logic;-- 1 when txrate or txsysclksel changes fail                                (drpclk)
            tx_change_fail_code_out : out std_logic_vector(2 downto 0);-- failure code when tx_change_fail = 1                                     (drpclk)
        
        -- DRP Controller Ports
            drp_fail_out            : out std_logic;-- DRP Controller Fail Indicator
            drp_fail_cnt_out        : out std_logic_vector(7 downto 0);-- DRP Controller Fail Count
                                 
        -- GTH Ports      
            gth_wiz_reset_all_in                    : in  std_logic;-- GTH RX and TX full reset    
            gth_wiz_reset_tx_pll_and_datapath_in    : in  std_logic;-- GTH TX datapath and PLL reset    
            gth_wiz_reset_rx_pll_and_datapath_in    : in  std_logic;-- GTH RX datapath and PLL reset    
            gth_wiz_txresetdone_out                 : out std_logic;-- GTH TXP Output
            gth_wiz_rxresetdone_out                 : out std_logic;-- GTH TXP Output
            gth_drpclk_in                           : in  std_logic;-- GTH DRP Ref Clock Input
            gth_qpll0_refclk_p_in                   : in  std_logic;-- GTH QPLL0 Ref Clock P Input
            gth_qpll0_refclk_n_in                   : in  std_logic;-- GTH QPLL0 Ref Clock N Input
            gth_qpll0_reset_in                      : in  std_logic;-- GTH QPLL0 Ref Clock Reset Input
            gth_qpll0_clk_out                       : out std_logic;-- GTH CHANNEL QPLL0 Clock Output
            gth_qpll0_refclk_out                    : out std_logic;-- GTH CHANNEL QPLL0 Ref Clock Output
            gth_qpll0_lock_out                      : out std_logic;-- GTH CHANNEL QPLL0 Lock Output
            gth_qpll1_refclk_p_in                   : in  std_logic;-- GTH QPLL1 Ref Clock P Input
            gth_qpll1_refclk_n_in                   : in  std_logic;-- GTH QPLL1 Ref Clock N Input
            gth_qpll1_reset_in                      : in  std_logic;-- GTH QPLL1 Ref Clock Reset Input
            gth_qpll1_clk_out                       : out std_logic;-- GTH CHANNEL QPLL1 Clock Output
            gth_qpll1_refclk_out                    : out std_logic;-- GTH CHANNEL QPLL1 Ref Clock Output
            gth_qpll1_lock_out                      : out std_logic;-- GTH CHANNEL QPLL1 Lock Output
            gth_cpll_refclk_p_in                    : in  std_logic;-- GTH CPLL Ref Clock P Input
            gth_cpll_refclk_n_in                    : in  std_logic;-- GTH CPLL Ref Clock N Input
            gth_cpll_refclk_out                     : out std_logic;-- GTH CPLL Ref Clock Output
            gth_cpll_lock_out                       : out std_logic;-- GTH CPLL Lock Output
            gth_rxn_in                              : in  std_logic;-- GTH RXN Input
            gth_rxp_in                              : in  std_logic;-- GTH RXP Input
            gth_txn_out                             : out std_logic;-- GTH TXN Output
            gth_txp_out                             : out std_logic-- GTH TXP Output
        );
    end component; 
    
    --TX Loopback Generator component
    component Data_Stream_Generator is
        Port ( ref_clk : in STD_LOGIC;
               tx_rst_in : out STD_LOGIC;
               tx_ce_in : out STD_LOGIC;
               tx_sd_ce_in : out STD_LOGIC;
               tx_edh_ce_in : out STD_LOGIC;
               tx_mode_in : out STD_LOGIC_VECTOR (1 downto 0);
               tx_m_in : out STD_LOGIC;
               tx_insert_crc_in : out STD_LOGIC;
               tx_insert_ln_in : out STD_LOGIC;
               tx_insert_st352_in : out STD_LOGIC;
               tx_overwrite_st352_in : out STD_LOGIC;
               tx_insert_edh_in : out STD_LOGIC;
               tx_mux_pattern_in : out STD_LOGIC_VECTOR (2 downto 0);
               tx_insert_sync_bit_in : out STD_LOGIC;
               tx_line_0_in : out STD_LOGIC_VECTOR (10 downto 0);
               tx_line_1_in : out STD_LOGIC_VECTOR (10 downto 0);
               tx_st352_line_f1_in : out STD_LOGIC_VECTOR (10 downto 0);
               tx_st352_line_f2_in : out STD_LOGIC_VECTOR (10 downto 0);
               tx_st352_f2_en_in : out STD_LOGIC;
               tx_st352_data_0_in : out STD_LOGIC_VECTOR (31 downto 0);
               tx_st352_data_1_in : out STD_LOGIC_VECTOR (31 downto 0);
               tx_ds1_in : out STD_LOGIC_VECTOR (9 downto 0);
               tx_ds2_in : out STD_LOGIC_VECTOR (9 downto 0));
    end component Data_Stream_Generator;
    
    --UHDSDI_VIDGEN Component
    component uhdsdi_vidgen is
        port(
            clk:                        in std_logic;                       -- free running clock
            tx_usrclk_in:               in std_logic;                       -- txusrclk from MGT
            tx_change_done_in:          in std_logic;                       -- MGT TX change done
            tx_change_fail_in:          in std_logic;                       -- TX controller fail
            tx_change_fail_code_in:     in std_logic_vector(2 downto 0);    -- TX controller fail code
            tx_gttxreset_out:           out std_logic;                      -- gttxreset out
            tx_full_reset_out:          out std_logic;                      -- GTX full reset
            tx_fabric_rst_in:           in std_logic;                       -- TX fabric reset
            tx_txen_out:                out std_logic;                      -- tx cable driver enable
            tx_ce_out:                  out std_logic;                      -- tx_ce to UHD-SDI core
            tx_sd_ce_out:               out std_logic;                      -- tx_sd_ce to UHD-SDI core
            tx_edh_ce_out:              out std_logic;                      -- tx_edh_ce to UHD-SDI core   
            tx_mux_pattern_out:         out std_logic_vector(2 downto 0);   -- tx_mux_pattern
            tx_mode_out:                out std_logic_vector(2 downto 0);   -- tx_mode valid modes
            tx_m_out:                   out std_logic;                      -- tx_m for valid modes
            tx_m_in:                    in std_logic;                       -- tx_m input for ST 352 generation
            tx_c_out:                   out std_logic_vector(9 downto 0);   -- tx chroma component
            tx_y_out:                   out std_logic_vector(9 downto 0);   -- tx luma component
            tx_line_out:                out std_logic_vector(10 downto 0);  -- tx line number out
            tx_insert_vpid_out:         out std_logic;                      -- tx insert VPID enable
            tx_st352_data_out:          out std_logic_vector(31 downto 0);  -- ST 352 data
            tx_st352_line_f1_out:       out std_logic_vector(10 downto 0);  -- ST 352 line in field 1
            tx_st352_line_f2_out:       out std_logic_vector(10 downto 0);   -- ST 352 line in field 2
            tx_st352_line_f2_en_out:    out std_logic;                      -- ST 352 field 2 enable
            tx_insert_sync_bit_out:     out std_logic                       -- tx insert sync bit enable
      );
    end component uhdsdi_vidgen;
    
    -- GTH RX/TX Loopback signals
    signal gth_n : std_logic;
    signal gth_p : std_logic;
    -- GTH Refclok signal
    --signal gth_cpll_refclk: std_logic;
    --signals for vidgen
    signal tx_change_fail_code_out: std_logic_vector(2 downto 0);
    signal tx_change_done_out: std_logic;
    signal tx_change_fail_out: std_logic;
    signal tx_fabric_rst_out: std_logic;
    
    --signals for slv_reg0 which come from vidgen
    signal gttx_reset_in: std_logic;
    
    --signals for GTH for simulation
    signal gth_txn_out: std_logic;
    signal gth_txp_out: std_logic;
    
        -- SDI Loopback TX Ports
        signal tx_rst_in : STD_LOGIC;
        signal tx_ce_in : STD_LOGIC;
        signal tx_sd_ce_in : STD_LOGIC;
        signal tx_edh_ce_in : STD_LOGIC;
        signal tx_mode_in : STD_LOGIC_VECTOR (1 downto 0);
        signal tx_m_in : STD_LOGIC;
        signal tx_insert_crc_in : STD_LOGIC;
        signal tx_insert_ln_in : STD_LOGIC;
        signal tx_insert_st352_in : STD_LOGIC;
        signal tx_overwrite_st352_in : STD_LOGIC;
        signal tx_insert_edh_in : STD_LOGIC;
        signal tx_mux_pattern_in : STD_LOGIC_VECTOR (2 downto 0);
        signal tx_insert_sync_bit_in : STD_LOGIC;
        signal tx_line_0_in : STD_LOGIC_VECTOR (10 downto 0);
        signal tx_line_1_in : STD_LOGIC_VECTOR (10 downto 0);
        signal tx_st352_line_f1_in : STD_LOGIC_VECTOR (10 downto 0);
        signal tx_st352_line_f2_in : STD_LOGIC_VECTOR (10 downto 0);
        signal tx_st352_f2_en_in : STD_LOGIC;
        signal tx_st352_data_0_in : STD_LOGIC_VECTOR (31 downto 0);
        signal tx_st352_data_1_in : STD_LOGIC_VECTOR (31 downto 0);
        signal tx_ds1_in : STD_LOGIC_VECTOR (9 downto 0);
        signal tx_ds2_in : STD_LOGIC_VECTOR (9 downto 0);
    
	-- AXI4LITE signals
	signal axi_awaddr	: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	signal axi_awready	: std_logic;
	signal axi_wready	: std_logic;
	signal axi_bresp	: std_logic_vector(1 downto 0);
	signal axi_bvalid	: std_logic;
	signal axi_araddr	: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	signal axi_arready	: std_logic;
	signal axi_rdata	: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal axi_rresp	: std_logic_vector(1 downto 0);
	signal axi_rvalid	: std_logic;

	-- Example-specific design signals
	-- local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
	-- ADDR_LSB is used for addressing 32/64 bit registers/memories
	-- ADDR_LSB = 2 for 32 bits (n downto 2)
	-- ADDR_LSB = 3 for 64 bits (n downto 3)
	constant ADDR_LSB  : integer := (C_S_AXI_DATA_WIDTH/32)+ 1;
	constant OPT_MEM_ADDR_BITS : integer := 3;
	------------------------------------------------
	---- Signals for user logic register space example
	--------------------------------------------------
	---- Number of Slave Registers 16
	signal slv_reg0	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg1	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg2	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg3	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg3_rxclk	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg4	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg5	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg6	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg7	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg8	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg9	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg10	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg11	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg12	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg13	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg14	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg15	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg_rden	: std_logic;
	signal slv_reg_wren	: std_logic;
	signal reg_data_out	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal byte_index	: integer;
	signal aw_en	: std_logic;
	signal rx_usrclk	: std_logic;

begin
	-- I/O Connections assignments

	S_AXI_AWREADY	<= axi_awready;
	S_AXI_WREADY	<= axi_wready;
	S_AXI_BRESP	<= axi_bresp;
	S_AXI_BVALID	<= axi_bvalid;
	S_AXI_ARREADY	<= axi_arready;
	S_AXI_RDATA	<= axi_rdata;
	S_AXI_RRESP	<= axi_rresp;
	S_AXI_RVALID	<= axi_rvalid;
	-- Implement axi_awready generation
	-- axi_awready is asserted for one S_AXI_ACLK clock cycle when both
	-- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
	-- de-asserted when reset is low.

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_awready <= '0';
	      aw_en <= '1';
	    else
	      if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1' and aw_en = '1') then
	        -- slave is ready to accept write address when
	        -- there is a valid write address and write data
	        -- on the write address and data bus. This design 
	        -- expects no outstanding transactions. 
	        axi_awready <= '1';
	        elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then
	            aw_en <= '1';
	        	axi_awready <= '0';
	      else
	        axi_awready <= '0';
	      end if;
	    end if;
	  end if;
	end process;

	-- Implement axi_awaddr latching
	-- This process is used to latch the address when both 
	-- S_AXI_AWVALID and S_AXI_WVALID are valid. 

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_awaddr <= (others => '0');
	    else
	      if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1' and aw_en = '1') then
	        -- Write Address latching
	        axi_awaddr <= S_AXI_AWADDR;
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_wready generation
	-- axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	-- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
	-- de-asserted when reset is low. 

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_wready <= '0';
	    else
	      if (axi_wready = '0' and S_AXI_WVALID = '1' and S_AXI_AWVALID = '1' and aw_en = '1') then
	          -- slave is ready to accept write data when 
	          -- there is a valid write address and write data
	          -- on the write address and data bus. This design 
	          -- expects no outstanding transactions.           
	          axi_wready <= '1';
	      else
	        axi_wready <= '0';
	      end if;
	    end if;
	  end if;
	end process; 

	-- Implement memory mapped register select and write logic generation
	-- The write data is accepted and written to memory mapped registers when
	-- axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
	-- select byte enables of slave registers while writing.
	-- These registers are cleared when reset (active low) is applied.
	-- Slave register write enable is asserted when valid address and data are available
	-- and the slave is ready to accept the write address and write data.
	slv_reg_wren <= axi_wready and S_AXI_WVALID and axi_awready and S_AXI_AWVALID ;

	process (S_AXI_ACLK)
	variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0); 
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      slv_reg0 <= (others => '0');
	      slv_reg3 <= (others => '0');
	      slv_reg6 <= (others => '0');
	      slv_reg7 <= (others => '0');
	      slv_reg8 <= (others => '0');
	      slv_reg9 <= (others => '0');
	      slv_reg10 <= (others => '0');
	      slv_reg11 <= (others => '0');
	      slv_reg12 <= (others => '0');
	      slv_reg13 <= (others => '0');
	      slv_reg14 <= (others => '0');
	      slv_reg15 <= (others => '0');
	    else
	      loc_addr := axi_awaddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
	      if (slv_reg_wren = '1') then
	        case loc_addr is
	          when b"0000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 0
	                slv_reg0(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"0011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 3
	                slv_reg3(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"0110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 6
	                slv_reg6(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"0111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 7
	                slv_reg7(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"1000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 8
	                slv_reg8(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"1001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 9
	                slv_reg9(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"1010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 10
	                slv_reg10(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"1011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 11
	                slv_reg11(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"1100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 12
	                slv_reg12(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"1101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 13
	                slv_reg13(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"1110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 14
	                slv_reg14(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"1111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 15
	                slv_reg15(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when others =>
	            slv_reg0 <= slv_reg0;
	            slv_reg3 <= slv_reg3;
	            slv_reg6 <= slv_reg6;
	            slv_reg7 <= slv_reg7;
	            slv_reg8 <= slv_reg8;
	            slv_reg9 <= slv_reg9;
	            slv_reg10 <= slv_reg10;
	            slv_reg11 <= slv_reg11;
	            slv_reg12 <= slv_reg12;
	            slv_reg13 <= slv_reg13;
	            slv_reg14 <= slv_reg14;
	            slv_reg15 <= slv_reg15;
	        end case;
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement write response logic generation
	-- The write response and response valid signals are asserted by the slave 
	-- when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
	-- This marks the acceptance of address and indicates the status of 
	-- write transaction.

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_bvalid  <= '0';
	      axi_bresp   <= "00"; --need to work more on the responses
	    else
	      if (axi_awready = '1' and S_AXI_AWVALID = '1' and axi_wready = '1' and S_AXI_WVALID = '1' and axi_bvalid = '0'  ) then
	        axi_bvalid <= '1';
	        axi_bresp  <= "00"; 
	      elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then   --check if bready is asserted while bvalid is high)
	        axi_bvalid <= '0';                                 -- (there is a possibility that bready is always asserted high)
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_arready generation
	-- axi_arready is asserted for one S_AXI_ACLK clock cycle when
	-- S_AXI_ARVALID is asserted. axi_awready is 
	-- de-asserted when reset (active low) is asserted. 
	-- The read address is also latched when S_AXI_ARVALID is 
	-- asserted. axi_araddr is reset to zero on reset assertion.

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_arready <= '0';
	      axi_araddr  <= (others => '1');
	    else
	      if (axi_arready = '0' and S_AXI_ARVALID = '1') then
	        -- indicates that the slave has acceped the valid read address
	        axi_arready <= '1';
	        -- Read Address latching 
	        axi_araddr  <= S_AXI_ARADDR;           
	      else
	        axi_arready <= '0';
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_arvalid generation
	-- axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
	-- S_AXI_ARVALID and axi_arready are asserted. The slave registers 
	-- data are available on the axi_rdata bus at this instance. The 
	-- assertion of axi_rvalid marks the validity of read data on the 
	-- bus and axi_rresp indicates the status of read transaction.axi_rvalid 
	-- is deasserted on reset (active low). axi_rresp and axi_rdata are 
	-- cleared to zero on reset (active low).  
	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then
	    if S_AXI_ARESETN = '0' then
	      axi_rvalid <= '0';
	      axi_rresp  <= "00";
	    else
	      if (axi_arready = '1' and S_AXI_ARVALID = '1' and axi_rvalid = '0') then
	        -- Valid read data is available at the read data bus
	        axi_rvalid <= '1';
	        axi_rresp  <= "00"; -- 'OKAY' response
	      elsif (axi_rvalid = '1' and S_AXI_RREADY = '1') then
	        -- Read data is accepted by the master
	        axi_rvalid <= '0';
	      end if;            
	    end if;
	  end if;
	end process;

	-- Implement memory mapped register select and read logic generation
	-- Slave register read enable is asserted when valid address is available
	-- and the slave is ready to accept the read address.
	slv_reg_rden <= axi_arready and S_AXI_ARVALID and (not axi_rvalid) ;

	process (slv_reg0, slv_reg1, slv_reg2, slv_reg3, slv_reg4, slv_reg5, slv_reg6, slv_reg7, slv_reg8, slv_reg9, slv_reg10, slv_reg11, slv_reg12, slv_reg13, slv_reg14, slv_reg15, axi_araddr, S_AXI_ARESETN, slv_reg_rden)
	variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0);
	begin
	    -- Address decoding for reading registers
	    loc_addr := axi_araddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
	    case loc_addr is
	      when b"0000" =>
	        reg_data_out <= slv_reg0;
	      when b"0001" =>
	        reg_data_out <= slv_reg1;
	      when b"0010" =>
	        reg_data_out <= slv_reg2;
	      when b"0011" =>
	        reg_data_out <= slv_reg3;
	      when b"0100" =>
	        reg_data_out <= slv_reg4;
	      when b"0101" =>
	        reg_data_out <= slv_reg5;
	      when b"0110" =>
	        reg_data_out <= slv_reg6;
	      when b"0111" =>
	        reg_data_out <= slv_reg7;
	      when b"1000" =>
	        reg_data_out <= slv_reg8;
	      when b"1001" =>
	        reg_data_out <= slv_reg9;
	      when b"1010" =>
	        reg_data_out <= slv_reg10;
	      when b"1011" =>
	        reg_data_out <= slv_reg11;
	      when b"1100" =>
	        reg_data_out <= slv_reg12;
	      when b"1101" =>
	        reg_data_out <= slv_reg13;
	      when b"1110" =>
	        reg_data_out <= slv_reg14;
	      when b"1111" =>
	        reg_data_out <= slv_reg15;
	      when others =>
	        reg_data_out  <= (others => '0');
	    end case;
	end process; 

	-- Output register or memory read data
	process( S_AXI_ACLK ) is
	begin
	  if (rising_edge (S_AXI_ACLK)) then
	    if ( S_AXI_ARESETN = '0' ) then
	      axi_rdata  <= (others => '0');
	    else
	      if (slv_reg_rden = '1') then
	        -- When there is a valid read address (S_AXI_ARVALID) with 
	        -- acceptance of read address by the slave (axi_arready), 
	        -- output the read dada 
	        -- Read address mux
	          axi_rdata <= reg_data_out;     -- register read data
	      end if;   
	    end if;
	  end if;
	end process;


	-- Add user logic here

    UHD_SDI_Wrapper_Support_inst: kugth_uhdsdi_3g_wrapper_support  
        generic map(
            TXPLLCLKSEL_TX_M_0              => "00",         -- Value to output on TXPLLCLKSEL when tx_m is 0; --CPLL=00, QPLL0=11, QPLL1=10 
            TXPLLCLKSEL_TX_M_1              => "00",        -- Value to output on TXPLLCLKSEL when tx_m is 1; --CPLL=00, QPLL0=11, QPLL1=10 
            RX_FXDCLK_FREQ                  => 50000000, --100000000     -- Frequency, in hertz, of fxdclk
            RXPLLCLKSEL_RX_M_0              => "00",         -- Value to output on RXPLLCLKSEL when rx_m is 0; --CPLL=00, QPLL0=11, QPLL1=10 
            RXPLLCLKSEL_RX_M_1              => "00",         -- Value to output on RXPLLCLKSEL when rx_m is 1; --CPLL=00, QPLL0=11, QPLL1=10 
            XY_SITE                         => "x1y4",       -- GTH Location
            EN_HOT_PLUG_LOGIC               => 0             -- Enable Hot-Plug logic    
            )
        port map(
            -- RX ports
            rx_fxdclk_in            => S_AXI_ACLK,           -- fixed frequency clock SDI RX bit rate detection
            rx_rst_in               => slv_reg0(3),        -- sync reset for SDI RX data path
            rx_fabric_rst_out       => rx_fabric_rst_out,     -- RX fabric reset
            rx_usrclk_out           => rx_usrclk,         -- rxusrclk input
            rx_mode_detect_rst_in   => slv_reg3_rxclk(0),-- synchronous reset for SDI mode detection function 
            rx_mode_en_in           => slv_reg3_rxclk(3 downto 1),-- unary enable bits for SDI mode search {3G, SD, HD} 1=enable, 0=disable
            rx_mode_detect_en_in    => slv_reg3_rxclk(4),-- 1 enables SDI mode detection      
            rx_forced_mode_in       => slv_reg3_rxclk(6 downto 5), -- if mode_detect_en=0, this port specifies the SDI mode of the RX
            rx_mode_out             => slv_reg4(1 downto 0),-- 00=HD, 01=SD, 10=3G
            rx_mode_hd_out          => open,-- 1 = HD mode      
            rx_mode_sd_out          => open,-- 1 = SD mode
            rx_mode_3g_out          => open,-- 1 = 3G mode
            rx_mode_locked_out      => slv_reg4(2),-- auto mode detection locked
            rx_bit_rate_out         => slv_reg4(3),-- 0 = 1000/1000, 1 = 1000/1001
            rx_t_locked_out         => slv_reg4(4),-- transport format detection locked
            rx_t_family_out         => slv_reg4(8 downto 5),-- transport format family
            rx_t_rate_out           => slv_reg4(12 downto 9),-- transport frame rate
            rx_t_scan_out           => slv_reg4(13),-- transport scan: 0=interlaced, 1=progressive
            rx_level_b_3g_out       => slv_reg4(14),-- 0 = level A, 1 = level B
            rx_ce_out               => slv_reg4(15),-- clock enable 
            rx_active_streams_out   => slv_reg4(18 downto 16),-- 2^active_streams = number of active streams
            rx_line_0_out           => rx_line_0_out,-- line number for data stream 1
            rx_line_1_out           => rx_line_1_out,-- line number for data stream 3
            rx_st352_0_out          => rx_st352_0_out,-- video payload ID packet ds1 (for 3G-SDI level A, Y VPID)
            rx_st352_0_valid_out    => rx_st352_0_valid_out,-- 1 = st352_0 is valid
            rx_st352_1_out          => rx_st352_1_out,-- video payload ID packet ds3 (ds2 for 3G-SDI level A, C VPID) 
            rx_st352_1_valid_out    => rx_st352_1_valid_out,-- 1 = st352_1 is valid
            rx_crc_err_out          => open,-- CRC error signals for all 4 data streams [ds4:ds1]
            rx_ds1_out              => rx_ds1_out,-- SD=Y/C, HD=Y, 3GA=ds1, 3GB=Y link A, 6G/12G=ds1
            rx_ds2_out              => rx_ds2_out,-- HD=C, 3GA=ds2, 3GB=C link A, 6G/12G=ds2
            rx_ds3_out              => open,-- 3GB=Y link B, 6G/12G=ds3
            rx_ds4_out              => open,-- 3GB=C link B, 6G/12G=ds4
            rx_eav_out              => rx_eav_out,-- 1 during XYZ word of EAV
            rx_sav_out              => rx_sav_out,-- 1 during XYZ word of SAV
            rx_trs_out              => rx_trs_out,-- 1 during all 4 words of EAV and SAV
            rx_edh_errcnt_en_in     => slv_reg3_rxclk(22 downto 7),-- enables various errors to increment rx_edh_errcnt
            rx_edh_clr_errcnt_in    => slv_reg3_rxclk(23),-- clears rx_edh_errcnt
            rx_edh_ap_out           => open,-- 1 = AP CRC error detected previous field
            rx_edh_ff_out           => open,-- 1 = FF CRC error detected previous field
            rx_edh_anc_out          => open,-- 1 = ANC checksum error detected
            rx_edh_ap_flags_out     => open,-- EDH AP flags received in last EDH packet
            rx_edh_ff_flags_out     => open,-- EDH FF flags received in last EDH packet
            rx_edh_anc_flags_out    => open,-- EDH ANC flags received in last EDH packet
            rx_edh_packet_flags_out => open,-- EDH packet error condition flags
            rx_edh_errcnt_out       => slv_reg5(15 downto 0),-- EDH error counter
            rx_change_done_out      => slv_reg4(19),-- 1 when rx_mode change has completed successfully                         (drpclk)
            rx_change_fail_out      => slv_reg4(20),-- 1 when rx_mode change failed                                             (drpclk)
            rx_change_fail_code_out => slv_reg4(23 downto 21),-- failure code when rx_change_fail = 1                                     (drpclk)
        
        -- TX ports                                                (clock domain)
--            tx_rst_in               => '1',-- sync reset for SDI TX data path
            --tx_fabric_rst_out       => open,-- TX fabric reset
            tx_fabric_rst_out => tx_fabric_rst_out,
            tx_usrclk_out           => open,-- clock input
--            tx_ce_in                => '0',-- clock enable 
--            tx_sd_ce_in             => '0',-- SD-SDI clock enable, must be High in all other modes
--            tx_edh_ce_in            => '0',-- EDH clock enable, recommended Low in all modes except SD-SDI
--            tx_mode_in              => (others => '0'),-- 00=HD, 01=SD, 10=3G
--            tx_m_in                 => '0',-- 0 = select 148.35 MHz refclk, 1 = select 148.5 MHz refclk                (async)
--            tx_insert_crc_in        => '0',-- 1 = insert CRC for HD and 3G
--            tx_insert_ln_in         => '0',-- 1 = insert LN for HD and 3G
--            tx_insert_st352_in      => '0',-- 1 = enable ST352 PID packet insert
--            tx_overwrite_st352_in   => '0',-- 1 = overwrite existing ST352 packets
--            tx_insert_edh_in        => '0',-- 1 = generate & insert EDH for SD 
--            tx_mux_pattern_in       => (others => '0'),-- specifies the multiplex interleave pattern of data streams 
--            tx_insert_sync_bit_in   => '0',-- 1 enables sync bit insertion
--            tx_line_0_in            => (others => '0'),-- current line number for ds1 & ds2
--            tx_line_1_in            => (others => '0'),-- current line number for ds3 & ds4
--            tx_st352_line_f1_in     => (others => '0'),-- insert ST352 packet on this line in field 1
--            tx_st352_line_f2_in     => (others => '0'),-- insert ST352 packet on this line in field 2
--            tx_st352_f2_en_in       => '0',-- enable ST352 packet insertion in field 2
--            tx_st352_data_0_in      => (others => '0'),-- ST352 data bytes for ds1 {byte4, byte3, byte2, byte1} 
--            tx_st352_data_1_in      => (others => '0'),-- ST352 data bytes for ds3 (and ds2 in 3GA mode) {byte4, byte3, byte2, byte1} 
--            tx_ds1_in               => (others => '0'),-- data stream 1 (Y) in -- only active ds in SD, Y for HD & 3GA, AY for 3GB
--            tx_ds2_in               => (others => '0'),-- data stream 2 (C) in -- C for HD & 3GA, AC for 3GB
            tx_ds3_in               => (others => '0'),-- data stream 3 (Y) in -- BY for 3GB
            tx_ds4_in               => (others => '0'),-- data stream 4 (C) in -- BC for 3GB
            tx_ds1_st352_out        => open,-- data stream 1 after ST352 insertion
            tx_ds2_st352_out        => open,-- data stream 2 after ST352 insertion
            tx_ds3_st352_out        => open,-- data stream 3 after ST352 insertion
            tx_ds4_st352_out        => open,-- data stream 4 after ST352 insertion
            tx_ds1_anc_in           => (others => '0'),-- data stream 1 after ANC insertion input
            tx_ds2_anc_in           => (others => '0'),-- data stream 2 after ANC insertion input
            tx_ds3_anc_in           => (others => '0'),-- data stream 3 after ANC insertion input
            tx_ds4_anc_in           => (others => '0'),-- data stream 4 after ANC insertion input
            tx_use_anc_in           => '0',-- use the dsX_anc_in ports
            tx_ce_align_err_out     => open,-- 1 if ce 5/6/5/6 cadence is broken in SD-SDI mode
            tx_slew_out             => open,-- slew rate control signal for SDI cable driver
            
            
            --tx_change_done_out      => open,-- 1 when txrate or txsysclksel changes complete successfully               (drpclk)
            tx_change_done_out => tx_change_done_out,
            --tx_change_fail_out      => open,-- 1 when txrate or txsysclksel changes fail                                (drpclk)
            tx_change_fail_out => tx_change_fail_out,
            --vidgen
            --tx_change_fail_code_out => open,-- failure code when tx_change_fail = 1                                     (drpclk)
            tx_change_fail_code_out => tx_change_fail_code_out,
            -- SDI Loopback TX Ports
                tx_rst_in => slv_reg0(4),
                --tx_rst_in => tx_rst_in,
                tx_ce_in  => slv_reg0(5),
                --tx_ce_in => tx_ce_in,
                tx_sd_ce_in => slv_reg0(6),
                --tx_sd_ce_in => tx_sd_ce_in,
                tx_edh_ce_in => slv_reg0(7),
                --tx_edh_ce_in => tx_edh_ce_in,
                tx_mode_in => (others => '0'),--tx_mode_in,  '00' = HD
                tx_m_in => tx_m_in,
                tx_insert_crc_in => tx_insert_crc_in,
                tx_insert_ln_in => tx_insert_ln_in,
                tx_insert_st352_in => tx_insert_st352_in,
                tx_overwrite_st352_in => tx_overwrite_st352_in,
                tx_insert_edh_in => tx_insert_edh_in,
                tx_mux_pattern_in => tx_mux_pattern_in,
                tx_insert_sync_bit_in => tx_insert_sync_bit_in,
                tx_line_0_in => tx_line_0_in,
                tx_line_1_in => tx_line_1_in,
                tx_st352_line_f1_in => tx_st352_line_f1_in,
                tx_st352_line_f2_in => tx_st352_line_f2_in,
                tx_st352_f2_en_in => tx_st352_f2_en_in,
                tx_st352_data_0_in => tx_st352_data_0_in,
                tx_st352_data_1_in => tx_st352_data_1_in,
                tx_ds1_in => tx_ds1_in,
                tx_ds2_in => tx_ds2_in,
        
        -- DRP Controller Ports
            drp_fail_out            => open,-- DRP Controller Fail Indicator
            drp_fail_cnt_out        => slv_reg2(7 downto 0),-- DRP Controller Fail Count
                                 
        -- GTH Ports      
            gth_wiz_reset_all_in                    => slv_reg0(0),-- GTH RX and TX full reset
            --gth_wiz_reset_all_in                    => gttx_reset_in, --vidgen instead of register    
            gth_wiz_reset_tx_pll_and_datapath_in    => slv_reg0(1),-- GTH TX datapath and PLL reset    
            gth_wiz_reset_rx_pll_and_datapath_in    => slv_reg0(2),-- GTH RX datapath and PLL reset    
            gth_wiz_txresetdone_out                 => slv_reg1(0),-- GTH TXP Output
            gth_wiz_rxresetdone_out                 => slv_reg1(1),-- GTH TXP Output
            gth_drpclk_in                           => S_AXI_ACLK,-- GTH DRP Ref Clock Input
            gth_qpll0_refclk_p_in                   => '0',-- GTH QPLL0 Ref Clock P Input
            gth_qpll0_refclk_n_in                   => '1',-- GTH QPLL0 Ref Clock N Input
            gth_qpll0_reset_in                      => '1',-- GTH QPLL0 Ref Clock Reset Input
            gth_qpll0_clk_out                       => open,-- GTH CHANNEL QPLL0 Clock Output
            gth_qpll0_refclk_out                    => open,-- GTH CHANNEL QPLL0 Ref Clock Output
            gth_qpll0_lock_out                      => open,-- GTH CHANNEL QPLL0 Lock Output
            gth_qpll1_refclk_p_in                   => '0',-- GTH QPLL1 Ref Clock P Input
            gth_qpll1_refclk_n_in                   => '1',-- GTH QPLL1 Ref Clock N Input
            gth_qpll1_reset_in                      => '1',-- GTH QPLL1 Ref Clock Reset Input
            gth_qpll1_clk_out                       => open,-- GTH CHANNEL QPLL1 Clock Output
            gth_qpll1_refclk_out                    => open,-- GTH CHANNEL QPLL1 Ref Clock Output
            gth_qpll1_lock_out                      => open,-- GTH CHANNEL QPLL1 Lock Output
            gth_cpll_refclk_p_in                    => gth_cpll_refclk_p_in,-- GTH CPLL Ref Clock P Input
            gth_cpll_refclk_n_in                    => gth_cpll_refclk_n_in,-- GTH CPLL Ref Clock N Input
            gth_cpll_refclk_out                     => open,-- GTH CPLL Ref Clock Output
            gth_cpll_lock_out                       => slv_reg1(2),-- GTH CPLL Lock Output
            gth_rxn_in                              => gth_rxn_in,-- GTH RXN Input
            gth_rxp_in                              => gth_rxp_in,-- GTH RXP Input
            --gth_txn_out                             => open,-- GTH TXN Output
            --gth_txp_out                             => open -- GTH TXP Output
            
            --GTH signals for simulation
            gth_txn_out                             => gth_txn_out,
            gth_txp_out                             => gth_txp_out

        -- GTH Loopback for IP core test
            --gth_rxn_in                              => gth_n,
            --gth_rxp_in                              => gth_p,
            --gth_txn_out                             => gth_n,
            --gth_txp_out                             => gth_p
        );
    
    rx_usrclk_out <= rx_usrclk;
    
    xpm_cdc_array_single_slv_reg3: xpm_cdc_array_single
          generic map (
            -- Common module generics
            DEST_SYNC_FF   => 4, -- integer; range: 2-10
            INIT_SYNC_FF   => 0, -- integer; 0=disable simulation init values, 1=enable simulation init values
            SIM_ASSERT_CHK => 0, -- integer; 0=disable simulation messages, 1=enable simulation messages
            SRC_INPUT_REG  => 1, -- integer; 0=do not register input, 1=register input
            WIDTH          => 32  -- integer; range: 1-1024
            )
          port map (
            src_clk  => S_AXI_ACLK,  -- optional; required when SRC_INPUT_REG = 1
            src_in   => slv_reg3,
            dest_clk => rx_usrclk,
            dest_out => slv_reg3_rxclk
          );
          
      --Generator: Data_Stream_Generator
                 --port map(        
                    -- SDI Loopback TX Ports
                 --ref_clk => gth_cpll_refclk_p_in,
                 --tx_rst_in => tx_rst_in,
                 --tx_ce_in  => tx_ce_in,
                 --tx_sd_ce_in => tx_sd_ce_in,
                 --tx_edh_ce_in => tx_edh_ce_in,
                 --tx_mode_in => tx_mode_in,
                 --tx_m_in => tx_m_in,
                 --tx_insert_crc_in => tx_insert_crc_in,
                 --tx_insert_ln_in => tx_insert_ln_in,
                 --tx_insert_st352_in => tx_insert_st352_in,
                 --tx_overwrite_st352_in => tx_overwrite_st352_in,
                 --tx_insert_edh_in => tx_insert_edh_in,
                 --tx_mux_pattern_in => tx_mux_pattern_in,
                 --tx_insert_sync_bit_in => tx_insert_sync_bit_in,
                 --tx_line_0_in => tx_line_0_in,
                 --tx_line_1_in => tx_line_1_in,
                 --tx_st352_line_f1_in => tx_st352_line_f1_in,
                 --tx_st352_line_f2_in => tx_st352_line_f2_in,
                 --tx_st352_f2_en_in => tx_st352_f2_en_in,
                 --tx_st352_data_0_in => tx_st352_data_0_in,
                 --tx_st352_data_1_in => tx_st352_data_1_in,
                 --tx_ds1_in => tx_ds1_in,
                 --tx_ds2_in => tx_ds2_in);
 
    uhdsdi_vidgen_inst: uhdsdi_vidgen
        port map(
            --Clocks
            clk => gth_cpll_refclk_p_in, --S_AXI_ACLK,
            tx_usrclk_in => gth_cpll_refclk_p_in,
            --Outputs to wrapper support
            tx_ce_out => tx_ce_in,
            tx_sd_ce_out => tx_sd_ce_in,
            tx_edh_ce_out => tx_edh_ce_in,
            tx_m_out => tx_m_in,
            tx_c_out => tx_ds2_in,
            tx_y_out => tx_ds1_in,
            tx_st352_data_out => tx_st352_data_0_in,
            tx_mux_pattern_out => tx_mux_pattern_in,
            tx_line_out => tx_line_0_in,
            tx_st352_line_f1_out => tx_st352_line_f1_in,
            tx_st352_line_f2_out => tx_st352_line_f2_in,
            tx_st352_line_f2_en_out => tx_st352_f2_en_in,
            tx_insert_sync_bit_out => tx_insert_sync_bit_in,
            tx_insert_vpid_out => tx_insert_st352_in,
            tx_full_reset_out => tx_rst_in,
            --Inputs from wrapper support
            tx_change_done_in => tx_change_done_out,
            tx_change_fail_in => tx_change_fail_out,
            tx_change_fail_code_in => tx_change_fail_code_out,
            tx_fabric_rst_in => tx_fabric_rst_out,
            --Input clock frequency
            tx_m_in => '1', -- 148.5 MHz
            --opens
            tx_txen_out => open,
            tx_mode_out => open,
            --reset gttx
            tx_gttxreset_out => gttx_reset_in
        );
 
 
 
    
	-- User logic ends

end arch_imp;
