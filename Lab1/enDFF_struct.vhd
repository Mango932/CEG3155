LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY enDFF_struct IS
	PORT(
	i_d 		: IN STD_LOGIC;
	i_clock 	: IN STD_LOGIC;
	i_enable	: IN STD_LOGIC;
	i_reset, i_preset 	: IN STD_LOGIC;
	o_q 		: OUT STD_LOGIC);
END enDFF_struct;

ARCHITECTURE rtl OF enDFF_struct IS
	SIGNAL int_q : STD_LOGIC;
		
	COMPONENT enabledSRLatch
		PORT(
			i_s, i_r : IN STD_LOGIC;
			i_enable : IN STD_LOGIC;
			i_reset, i_preset 	: IN STD_LOGIC;
			o_q, o_qBar : OUT STD_LOGIC
		);
	END COMPONENT;
	BEGIN
	
	masterLatch: enabledSRLatch
		PORT MAP ( 
			i_s => i_d,
			i_r => not(i_d),
			i_enable => (not(i_clock) and i_enable),
			i_reset => not(i_reset),
			i_preset => not(i_preset),
			o_q => int_q
			
		);
		
	slaveLatch: enabledSRLatch
		PORT MAP ( 
			i_s => int_q,
			i_r => not(int_q),
			i_enable => (i_clock and i_enable),
			i_reset => not(i_reset),
			i_preset => not(i_preset),
			o_q => o_q
		);
			
END rtl;
