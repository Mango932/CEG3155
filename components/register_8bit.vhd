LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY register_8bit IS
	PORT (
		i_clock	: 	IN STD_LOGIC;
		i_reset	: 	IN STD_LOGIC;
		i_d		:	IN STD_LOGIC_VECTOR(7 downto 0);
		i_load	: 	IN STD_LOGIC;
		o_q		: 	OUT STD_LOGIC_VECTOR(7 downto 0)
	);
END register_8bit;

ARCHITECTURE rtl OF register_8bit IS
	
	COMPONENT enDFF
		PORT(
			i_d			: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			i_enable 	: IN  STD_LOGIC;
			i_reset		: IN STD_LOGIC;
			o_q			: OUT	STD_LOGIC
		);
	END COMPONENT;

BEGIN 

most_sb_ff: enDFF
	PORT MAP (
		i_d => i_d(7),
		i_clock => i_clock,
		i_enable => i_load,
		o_q => o_q(7),
		i_reset => i_reset
	);

seventh_sb_ff: enDFF
	PORT MAP (
		i_d => i_d(6),
		i_clock => i_clock,
		i_enable => i_load,
		o_q => o_q(6),
		i_reset => i_reset
	);

sixth_sb_ff: enDFF
	PORT MAP (
		i_d => i_d(5),
		i_clock => i_clock,
		i_enable => i_load,
		o_q => o_q(5),
		i_reset => i_reset
	);

fifth_sb_ff: enDFF
	PORT MAP (
		i_d => i_d(4),
		i_clock => i_clock,
		i_enable => i_load,
		o_q => o_q(4),
		i_reset => i_reset
	);

fourth_sb_ff: enDFF
	PORT MAP (
		i_d => i_d(3),
		i_clock => i_clock,
		i_enable => i_load,
		o_q => o_q(3),
		i_reset => i_reset
	);

third_sb_ff: enDFF
	PORT MAP (
		i_d => i_d(2),
		i_clock => i_clock,
		i_enable => i_load,
		o_q => o_q(2),
		i_reset => i_reset
	);

second_sb_ff: enDFF
	PORT MAP (
		i_d => i_d(1),
		i_clock => i_clock,
		i_enable => i_load,
		o_q => o_q(1),
		i_reset => i_reset
	);

least_sb_ff: enDFF
	PORT MAP (
		i_d => i_d(0),
		i_clock => i_clock,
		i_enable => i_load,
		o_q => o_q(0),
		i_reset => i_reset
	);
END rtl;