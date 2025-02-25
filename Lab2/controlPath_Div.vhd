LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY controlPath_Div IS
	PORT (
		GReset : IN STD_LOGIC;
		i_clock: IN STD_LOGIC;
		i_OVF: IN STD_LOGIC;
		i_count: IN STD_LOGIC;
		
		o_reset: OUT STD_LOGIC;
		o_RemL_7_downto_4: OUT STD_LOGIC;
		o_RemLS: OUT STD_LOGIC;
		o_OutRL: OUT STD_LOGIC;
		o_OutL: OUT STD_LOGIC
	);
END controlPath_Div;

ARCHITECTURE rtl of controlPath_Div IS

	SIGNAL s0, s1, s2, s3, s4 : STD_LOGIC;
	
	COMPONENT enDFF
		PORT(
			i_d			: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			i_enable 	: IN  STD_LOGIC;
			i_reset		: IN STD_LOGIC;
			i_preset		: IN STD_LOGIC;
			o_q			: OUT	STD_LOGIC
		);
	END COMPONENT;

BEGIN

s0_ff: enDFF
	PORT MAP (
		i_d => '0',
		i_clock => i_clock,
		i_enable => '1',
		i_reset => '0',
		i_preset => GReset,
		o_q => s0
	);
o_reset <= s0;
	
s1_ff: enDFF
	PORT MAP (
		i_d => s4 and i_count,
		i_clock => i_clock,
		i_enable => '1',
		i_reset => GReset,
		i_preset => '0',
		o_q => s1
	);

o_OutRL <= s1;
o_OutL <= s1;
	
s2_ff: enDFF
	PORT MAP (
		i_d => (s4 or s0) and not(i_count) and i_OVF,
		i_clock => i_clock,
		i_enable => '1',
		i_reset => GReset,
		i_preset => '0',
		o_q => s2
	);
o_RemL_7_downto_4 <= s2 or s0;
	
s3_ff: enDFF
	PORT MAP (
		i_d => s0 or s2 or (s4 and not(i_count) and not(i_OVF)),
		i_clock => i_clock,
		i_enable => '1',
		i_reset => GReset,
		i_preset => '0',
		o_q => s3
	);

o_RemLS <= s3;

delay_ff: enDFF
	PORT MAP (
		i_d => s3,
		i_clock => i_clock,
		i_enable => '1',
		i_reset => GReset,
		i_preset => '0',
		o_q => s4
	);




		
END rtl;