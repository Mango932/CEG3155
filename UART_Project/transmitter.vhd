LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY transmitter IS
	PORT(
		i_clock			: IN	STD_LOGIC;
		i_reset			: IN	STD_LOGIC;
		i_TDR				: IN 	STD_LOGIC_VECTOR(7 downto 0);
		i_StopBitReset : IN  STD_LOGIC;
		i_TSRLoad		: IN	STD_LOGIC;
		i_TSRShift		: IN 	STD_LOGIC;
		o_TxD				: OUT	STD_LOGIC
	);
END transmitter;

ARCHITECTURE rtl OF transmitter IS
	signal int_msb: STD_LOGIC;
	signal int_TSROut : STD_LOGIC_VECTOR(7 downto 0);
	
	COMPONENT right_SR_8bit_WithInput
		PORT(
			i_clock			: IN	STD_LOGIC;
			i_load 			: IN  STD_LOGIC;
			i_enable 		: IN  STD_LOGIC;
			i_Value			: IN	STD_LOGIC_VECTOR(7 downto 0);
			i_shift			: IN STD_LOGIC;
			i_reset			: IN STD_LOGIC;
			o_Value			: OUT	STD_LOGIC_VECTOR(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT enDFF
		PORT(
			i_reset 		: IN  STD_LOGIC;
			i_preset 	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			i_d			: IN	STD_LOGIC;
			i_enable 	: IN  STD_LOGIC;
			o_q			: OUT	STD_LOGIC
		);
	END COMPONENT;

BEGIN

TSR:right_SR_8bit_WithInput
	PORT MAP(i_clock, i_TSRLoad, i_TSRShift, i_TDR, '1', i_reset, int_TSROut);
	
msb:enDFF
	PORT MAP(i_StopBitReset or i_reset, '0', i_clock, int_TSROut(0), i_TSRShift, int_msb);
	
txd:enDFF
	PORT MAP('0', i_StopBitReset or i_reset, i_clock, int_msb, i_TSRShift, o_TxD);

END rtl;
