LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY dataPath IS
	PORT (
		i_LSRL		: IN STD_LOGIC;
		i_LSRE		: IN STD_LOGIC;
		i_RSRL		: IN STD_LOGIC;
		i_RSRE		: IN STD_LOGIC;
		i_MUXS		: IN STD_LOGIC_VECTOR(1 downto 0);
		i_Clock	: IN STD_LOGIC;
		o_Display	: OUT	STD_LOGIC_VECTOR(7 downto 0)
	);
END dataPath;

ARCHITECTURE rtl OF dataPath IS
	signal int_LSRO : STD_LOGIC_VECTOR(7 downto 0);
	signal int_RSRO : STD_LOGIC_VECTOR(7 downto 0);
	
	COMPONENT left_SR_8bit
		PORT (
			i_clock			: IN	STD_LOGIC;
			i_load 			: IN  STD_LOGIC;
			i_enable 		: IN  STD_LOGIC;
			i_Value			: IN	STD_LOGIC_VECTOR(7 downto 0);
			o_Value			: OUT	STD_LOGIC_VECTOR(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT right_SR_8bit
		PORT (
			i_clock			: IN	STD_LOGIC;
			i_load 			: IN  STD_LOGIC;
			i_enable 		: IN  STD_LOGIC;
			i_Value			: IN	STD_LOGIC_VECTOR(7 downto 0);
			o_Value			: OUT	STD_LOGIC_VECTOR(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT mux_4x2_8bit
		PORT(
			i_Value3		: IN	STD_LOGIC_VECTOR(7 downto 0);
			i_Value2		: IN	STD_LOGIC_VECTOR(7 downto 0);
			i_Value1		: IN	STD_LOGIC_VECTOR(7 downto 0);
			i_Value0		: IN	STD_LOGIC_VECTOR(7 downto 0);
			i_select    : IN	STD_LOGIC_VECTOR(1 downto 0);
			o_y			: OUT	STD_LOGIC_VECTOR(7 downto 0)
	);
	END COMPONENT;
	
BEGIN
	
left_SR: left_SR_8bit
	PORT MAP (
		i_clock => i_Clock,
		i_load => i_LSRL,
		i_enable => i_LSRE,
		i_Value => "00000001",
		o_Value => int_LSRO
	);
		
right_SR: right_SR_8bit
	PORT MAP (
		i_clock => i_Clock,
		i_load => i_RSRL,
		i_enable => i_RSRE,
		i_Value => "10000000",
		o_Value => int_RSRO
	);
		
mux: mux_4x2_8bit
	PORT MAP (
		i_Value3 => "00000000",
		i_Value2 => int_RSRO,
		i_Value1	=> int_LSRO,
		i_Value0	=> int_RSRO or int_LSRO,
		i_select => i_MUXS,
		o_y => o_Display
		);
END rtl;