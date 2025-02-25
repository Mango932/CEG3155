LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux_4x2_8bit IS
	
	PORT(
		i_Value3		: IN	STD_LOGIC_VECTOR(7 downto 0);
		i_Value2		: IN	STD_LOGIC_VECTOR(7 downto 0);
		i_Value1		: IN	STD_LOGIC_VECTOR(7 downto 0);
		i_Value0		: IN	STD_LOGIC_VECTOR(7 downto 0);
		i_select    : IN	STD_LOGIC_VECTOR(1 downto 0);
		o_y			: OUT	STD_LOGIC_VECTOR(7 downto 0)
	);
END mux_4x2_8bit;

ARCHITECTURE rtl OF mux_4x2_8bit IS
	
	COMPONENT mux_4x2_1bit
		PORT(
			i_Value		: IN	STD_LOGIC_VECTOR(3 downto 0);
			i_Select		: IN	STD_LOGIC_VECTOR(1 downto 0);
			o_y       : OUT STD_LOGIC
		);
	END COMPONENT;

BEGIN

most_sb_mult: mux_4x2_1bit
	PORT MAP (
		i_Value(3) => i_Value3(7),
		i_Value(2) => i_Value2(7),
		i_Value(1) => i_Value1(7),
		i_Value(0) => i_Value0(7),
		i_select => i_select,
		o_y => o_y(7)
	);

seventh_sb_mult: mux_4x2_1bit
	PORT MAP (
		i_Value(3) => i_Value3(6),
		i_Value(2) => i_Value2(6),
		i_Value(1) => i_Value1(6),
		i_Value(0) => i_Value0(6),
		i_select => i_select,
		o_y => o_y(6)
	);
	
sixth_sb_mult: mux_4x2_1bit
	PORT MAP (
		i_Value(3) => i_Value3(5),
		i_Value(2) => i_Value2(5),
		i_Value(1) => i_Value1(5),
		i_Value(0) => i_Value0(5),
		i_select => i_select,
		o_y => o_y(5)
	);
fifth_sb_mult: mux_4x2_1bit
	PORT MAP (
		i_Value(3) => i_Value3(4),
		i_Value(2) => i_Value2(4),
		i_Value(1) => i_Value1(4),
		i_Value(0) => i_Value0(4),
		i_select => i_select,
		o_y => o_y(4)
	);
	
fourth_sb_mult: mux_4x2_1bit
	PORT MAP (
		i_Value(3) => i_Value3(3),
		i_Value(2) => i_Value2(3),
		i_Value(1) => i_Value1(3),
		i_Value(0) => i_Value0(3),
		i_select => i_select,
		o_y => o_y(3)
	);
	
third_sb_mult: mux_4x2_1bit
	PORT MAP (
		i_Value(3) => i_Value3(2),
		i_Value(2) => i_Value2(2),
		i_Value(1) => i_Value1(2),
		i_Value(0) => i_Value0(2),
		i_select => i_select,
		o_y => o_y(2)
	);
	
second_sb_mult: mux_4x2_1bit
	PORT MAP (
		i_Value(3) => i_Value3(1),
		i_Value(2) => i_Value2(1),
		i_Value(1) => i_Value1(1),
		i_Value(0) => i_Value0(1),
		i_select => i_select,
		o_y => o_y(1)
	);
	
least_sb_mult: mux_4x2_1bit
	PORT MAP (
		i_Value(3) => i_Value3(0),
		i_Value(2) => i_Value2(0),
		i_Value(1) => i_Value1(0),
		i_Value(0) => i_Value0(0),
		i_select => i_select,
		o_y => o_y(0)
	);
END rtl;