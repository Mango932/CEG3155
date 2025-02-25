LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux_4x2_1bit IS
	PORT (
		i_Value		: IN	STD_LOGIC_VECTOR(3 downto 0);
		i_Select		: IN	STD_LOGIC_VECTOR(1 downto 0);
		o_y       : OUT STD_LOGIC
	);
END mux_4x2_1bit;

ARCHITECTURE rtl OF mux_4x2_1bit IS
	SIGNAL int_a : STD_LOGIC;
	SIGNAL int_b : STD_LOGIC;
			
		COMPONENT mux_2x1_1bit
			PORT(
				i_a : IN STD_LOGIC;
				i_b : IN STD_LOGIC;
				i_select : IN  STD_LOGIC;
				o_y       : OUT STD_LOGIC
			);
		END COMPONENT;
BEGIN

	mult1: mux_2x1_1bit
	PORT MAP (
		i_a => i_Value(3),
		i_b => i_Value(2),
		i_select => i_Select(0),
		o_y => int_a
	);
	
	mult2: mux_2x1_1bit
	PORT MAP (
		i_a => i_Value(1),
		i_b => i_Value(0),
		i_select => i_Select(0),
		o_y => int_b
	);
	
	mult3: mux_2x1_1bit
	PORT MAP (
		i_a => int_a,
		i_b => int_b,
		i_select => i_Select(1),
		o_y => o_y
	);
	
END rtl;