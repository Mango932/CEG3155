LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux_8x3_1bit IS
	PORT (
		i_Value		: IN	STD_LOGIC_VECTOR(7 downto 0);
		i_Select		: IN	STD_LOGIC_VECTOR(2 downto 0);
		o_y       : OUT STD_LOGIC
	);
END mux_8x3_1bit;

ARCHITECTURE rtl OF mux_8x3_1bit IS
	SIGNAL int_a : STD_LOGIC;
	SIGNAL int_b : STD_LOGIC;
			
		COMPONENT mux_4x2_1bit
			PORT(
				i_Value		: IN	STD_LOGIC_VECTOR(3 downto 0);
				i_Select		: IN	STD_LOGIC_VECTOR(1 downto 0);
				o_y       : OUT STD_LOGIC
			);
		END COMPONENT;
		
		COMPONENT mux_2x1_1bit
			PORT(
				i_a : IN STD_LOGIC;
				i_b : IN STD_LOGIC;
				i_select : IN  STD_LOGIC;
				o_y       : OUT STD_LOGIC
			);
		END COMPONENT;
BEGIN

	mult1: mux_4x2_1bit
	PORT MAP (
		i_Value => i_Value(7 downto 4),
		i_select => i_Select(1 downto 0),
		o_y => int_a
	);
	
	mult2: mux_4x2_1bit
	PORT MAP (
		i_Value => i_Value(3 downto 0),
		i_select => i_Select(1 downto 0),
		o_y => int_b
	);
	
	mult3: mux_2x1_1bit
	PORT MAP (
		i_a => int_a,
		i_b => int_b,
		i_select => i_Select(2),
		o_y => o_y
	);
	
END rtl;