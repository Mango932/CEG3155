LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY controlPath_Mult IS
	PORT (
		GReset : IN STD_LOGIC;
		i_clock: IN STD_LOGIC;
		i_SN2: IN STD_LOGIC;
		i_SN3: IN STD_LOGIC;
		i_eq0: IN STD_LOGIC;
		o_FRS: OUT STD_LOGIC;
		o_FL: OUT STD_LOGIC;
		o_SLS: OUT STD_LOGIC;
		o_SL: OUT STD_LOGIC;
		o_sub: OUT STD_LOGIC;
		o_PL: OUT STD_LOGIC;
		o_PCL: OUT STD_LOGIC;
		o_OL: OUT STD_LOGIC
	);
END controlPath_Mult;

ARCHITECTURE rtl of controlPath_Mult IS

	SIGNAL s0, s1, s2, s3, s4, s5 : STD_LOGIC;
	
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
o_FL <= s0;
o_SL <= s0;
o_PCL <= s0;
	
s1_ff: enDFF
	PORT MAP (
		i_d => s0 and i_SN3,
		i_clock => i_clock,
		i_enable => '1',
		i_reset => GReset,
		i_preset => '0',
		o_q => s1
	);

o_sub <= s1;
	
s2_ff: enDFF
	PORT MAP (
		i_d => s1 or (s0 and not(i_SN3)),
		i_clock => i_clock,
		i_enable => '1',
		i_reset => GReset,
		i_preset => '0',
		o_q => s2
	);
	
s3_ff: enDFF
	PORT MAP (
		i_d => i_eq0 and (s2 or s5),
		i_clock => i_clock,
		i_enable => '1',
		i_reset => GReset,
		i_preset => '0',
		o_q => s3
	);

o_OL <= s3;

	
s4_ff: enDFF
	PORT MAP (
		i_d => not(i_eq0) and i_SN2 and (s2 or s5),
		i_clock => i_clock,
		i_enable => '1',
		i_reset => GReset,
		i_preset => '0',
		o_q => s4
	);
		
s5_ff: enDFF
	PORT MAP (
		i_d => s4 or (not(i_eq0) and not(i_SN2) and (s2 or s5)),
		i_clock => i_clock,
		i_enable => '1',
		i_reset => GReset,
		i_preset => '0',
		o_q => s5
	);

o_FRS <= s2 or s5;
o_SLS <= s2 or s5;
o_PL <= s1 or s4;




		
END rtl;