LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux_2x1_4bit IS
	PORT(
		i_a			: IN	STD_LOGIC_VECTOR(3 downto 0);
		i_b			: IN	STD_LOGIC_VECTOR(3 downto 0);
		i_select  : IN  STD_LOGIC;
		o_y			: OUT	STD_LOGIC_VECTOR(3 downto 0));
END mux_2x1_4bit;

ARCHITECTURE rtl OF mux_2x1_4bit IS
	
	COMPONENT mux_2x1_1bit
		PORT(
			i_a		: IN	STD_LOGIC;
			i_b	: IN	STD_LOGIC;
			i_select		: IN	STD_LOGIC;
			o_y: OUT	STD_LOGIC);
	END COMPONENT;

BEGIN

most_sb_mult: mux_2x1_1bit
	PORT MAP (
		i_a => i_a(3),
		i_b => i_b(3),
		i_select => i_select,
		o_y => o_y(3)
	);
	
third_sb_mult: mux_2x1_1bit
	PORT MAP (
		i_a => i_a(2),
		i_b => i_b(2),
		i_select => i_select,
		o_y => o_y(2)
	);
	
second_sb_mult: mux_2x1_1bit
	PORT MAP (
		i_a => i_a(1),
		i_b => i_b(1),
		i_select => i_select,
		o_y => o_y(1)
	);
	
least_sb_mult: mux_2x1_1bit
	PORT MAP (
		i_a => i_a(0),
		i_b => i_b(0),
		i_select => i_select,
		o_y => o_y(0)
	);
END rtl;