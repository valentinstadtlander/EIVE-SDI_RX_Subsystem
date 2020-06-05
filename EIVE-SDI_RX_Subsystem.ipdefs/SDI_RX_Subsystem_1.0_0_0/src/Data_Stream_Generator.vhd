----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.05.2020 14:52:45
-- Design Name: 
-- Module Name: Data_Stream_Generator - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Data_Stream_Generator is
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
end Data_Stream_Generator;

architecture Behavioral of Data_Stream_Generator is
    
begin
    process(ref_clk) is
        variable counter : integer range 0 to 1024;
    begin
        if rising_edge(ref_clk) then
           tx_rst_in <= '0';
           tx_ce_in <= '1';
            tx_sd_ce_in <= '1';
            tx_edh_ce_in <= '0';
            tx_mode_in <= "00";
            tx_m_in <= '1';
            tx_insert_crc_in <= '0';
            tx_insert_ln_in <= '0';
            tx_insert_st352_in <= '0';
            tx_overwrite_st352_in <= '0';
            tx_insert_edh_in <= '0';
            tx_mux_pattern_in <= "000";
            tx_insert_sync_bit_in <= '0';
    
        
            tx_line_0_in <= std_logic_vector(to_unsigned(counter, 11));
            --tx_line_1_in <= std_logic_vector(to_unsigned(counter, 11));
            tx_line_1_in <= (others => '0');
            
            tx_st352_line_f1_in <= (others => '0');
            tx_st352_line_f2_in <= (others => '0');
            tx_st352_f2_en_in <= '0';
       
            
            tx_st352_data_0_in <= (others => '0');
            tx_st352_data_1_in <= (others => '0');
            
            tx_ds1_in <= std_logic_vector(to_unsigned(counter, 10));
            tx_ds2_in <= std_logic_vector(to_unsigned(counter, 10));
    
            counter := counter + 1;
       
        end if;
    end process;

end Behavioral;
