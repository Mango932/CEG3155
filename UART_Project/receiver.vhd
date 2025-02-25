LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY receiver IS
	PORT(
		i_clock			: IN	STD_LOGIC;
		i_reset			: IN	STD_LOGIC;
		i_RxD				: IN 	STD_LOGIC;
		i_RDRClear 		: IN  STD_LOGIC;
		i_RDRLoad		: IN 	STD_LOGIC;
		i_RSRShift		: IN	STD_LOGIC;
		o_RDRF			: OUT 	STD_LOGIC;
		o_RDR				: OUT	STD_LOGIC_VECTOR(7 downto 0)
	);
END receiver;

ARCHITECTURE rtl OF receiver IS
	signal int_isZero: STD_LOGIC;
	signal int_RSROut, int_RDROut : STD_LOGIC_VECTOR(7 downto 0);
	
	COMPONENT right_SR_8bit_WithInput
		PORT(
			i_clock			: IN	STD_LOGIC;
			i_enable 		: IN  STD_LOGIC;
			i_shift			: IN STD_LOGIC;
			i_reset			: IN STD_LOGIC;
			o_Value			: OUT	STD_LOGIC_VECTOR(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT register_8bit
		PORT (
			i_clock	: 	IN STD_LOGIC;
			i_reset	: 	IN STD_LOGIC;
			i_d		:	IN STD_LOGIC_VECTOR(7 downto 0);
			i_load	: 	IN STD_LOGIC;
			o_q		: 	OUT STD_LOGIC_VECTOR(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT isZero_8bit
		PORT(
			i_value 	: IN  STD_LOGIC_VECTOR(7 downto 0);
			o_isZero : OUT  STD_LOGIC
		);
	END COMPONENT;

BEGIN

RSR:right_SR_8bit_WithInput
	PORT MAP(i_clock, i_RSRShift, i_RxD, i_reset or i_RDRClear, int_RSROut);
	
TDR: register_8bit
	PORT MAP(i_clock, i_reset or i_RDRClear, int_RSROut, i_RDRLoad, int_RDROut);
o_RDR <= int_RDROut;

RDRF: isZero_8bit
	PORT MAP(int_RDROut, int_isZero);
o_RDRF <= not int_isZero;
	
END rtl;
