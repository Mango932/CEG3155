LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY register_4bit IS
	PORT (
		i_d			:IN STD_LOGIC_VECTOR(3 downto 0);
		i_load		: IN STD_LOGIC;
		i_clear		: IN STD_LOGIC;
		i_clock		: IN STD_LOGIC;
		o_q			: OUT STD_LOGIC_VECTOR(3 downto 0)
	);
END register_4bit;

ARCHITECTURE rtl OF register_4bit IS
	
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
		i_d => i_d(3),
		i_clock => i_clock,
		i_enable => i_load,
		o_q => o_q(3),
		i_reset => i_clear
	);

third_sb_ff: enDFF
	PORT MAP (
		i_d => i_d(2),
		i_clock => i_clock,
		i_enable => i_load,
		o_q => o_q(2),
		i_reset => i_clear
	);

second_sb_ff: enDFF
	PORT MAP (
		i_d => i_d(1),
		i_clock => i_clock,
		i_enable => i_load,
		o_q => o_q(1),
		i_reset => i_clear
	);

least_sb_ff: enDFF
	PORT MAP (
		i_d => i_d(0),
		i_clock => i_clock,
		i_enable => i_load,
		o_q => o_q(0),
		i_reset => i_clear
	);
END rtl;