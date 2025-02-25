LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY enabledSRLatch IS
	PORT(
	i_s, i_r 				: IN STD_LOGIC;
	i_enable 				: IN STD_LOGIC;
	i_reset, i_preset 	: IN STD_LOGIC;
	o_q, o_qBar 			: OUT STD_LOGIC);
END enabledSRLatch;

ARCHITECTURE rtl OF enabledSRLatch IS
		SIGNAL int_q, int_qBar : STD_LOGIC;
		SIGNAL int_sSignal, int_rSignal : STD_LOGIC;
	BEGIN
		int_sSignal <= i_s nand i_enable;
		int_rSignal <= i_enable nand i_r;
		int_q <= not(int_sSignal and int_qBar and i_preset);
		int_qBar <= not(int_q and int_rSignal and i_reset);

		o_q <= int_q;
		o_qBar <= int_qBar;
END rtl;
