LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY baud_rate_generator IS
	PORT(
		i_clock  : in std_logic;
      i_reset   : in std_logic;
      i_select     : in std_logic_vector(2 downto 0);
      o_BclkX8  : buffer std_logic;
      o_Bclk    : out std_logic
	);
END baud_rate_generator;

ARCHITECTURE rtl OF baud_rate_generator IS
	SIGNAL int_count41, int_count256, int_count8: STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL int_divide41, int_muxOut, int_divide8: STD_LOGIC;
	

	COMPONENT counter_8bit
		PORT (
			i_clock, i_reset: in std_logic;
			i_enable: in std_logic;
			o_count: out std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT mux_8x3_1bit
		PORT (
			i_Value		: IN	STD_LOGIC_VECTOR(7 downto 0);
			i_Select		: IN	STD_LOGIC_VECTOR(2 downto 0);
			o_y       : OUT STD_LOGIC
		);
	END COMPONENT;
	
	 COMPONENT enDFF
        PORT(
            i_clock : IN  STD_LOGIC;
				i_reset	: IN STD_LOGIC;
				i_enable: IN  STD_LOGIC;
            i_d     : IN  STD_LOGIC;
            o_q     : OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN

counter41: counter_8bit
	PORT MAP(i_clock, i_reset or (int_count41(5) and int_count41(3) and int_count41(0)), '1', int_count41);

divide41: enDFF
	PORT MAP(
		i_clock,
		i_reset, 
		'1', 
		int_divide41 xor ((int_count41(5) and int_count41(3)) or (not(int_count41(0)) and not(int_count41(1)) and int_count41(2) and not(int_count41(3)) and int_count41(3))), 
		int_divide41
	);
	
counter256: counter_8bit
	PORT MAP(int_divide41, i_reset, '1', int_count256);

counterMux:  mux_8x3_1bit
	PORT MAP(int_count256(0) & int_count256(1) & int_count256(2) & int_count256(3) & int_count256(4) & int_count256(5) & int_count256(6) & int_count256(7), i_select, int_muxOut);

o_BclkX8 <= int_muxOut;

counter8: counter_8bit
	PORT MAP(int_muxOut, i_reset and int_count8(2), '1', int_count8);

divide8: enDFF
	PORT MAP(
		int_muxOut,
		i_reset, 
		'1', 
		int_divide8 xor (int_count8(1) and int_count8(0)), 
		int_divide8
	);
	
o_Bclk <= int_divide8;

end rtl;