LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY dataPath_Mult IS
	PORT (
		i_clock: IN STD_LOGIC;
		i_Input1: IN STD_LOGIC_VECTOR(3 downto 0);
		i_Input2: IN STD_LOGIC_VECTOR(3 downto 0);
		i_FRS: IN STD_LOGIC;
		i_FL: IN STD_LOGIC;
		i_SLS: IN STD_LOGIC;
		i_SL: IN STD_LOGIC;
		i_sub: IN STD_LOGIC;
		i_PL: IN STD_LOGIC;
		i_PCL: IN STD_LOGIC;
		i_OL: IN STD_LOGIC;
		o_eq0: OUT STD_LOGIC;
		o_SN2: OUT STD_LOGIC;
		o_SN3: OUT STD_LOGIC;
		o_output: OUT STD_LOGIC_VECTOR(7 downto 0)
	);
END dataPath_Mult;

ARCHITECTURE rtl OF dataPath_Mult IS

	SIGNAL out_FN : STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL out_SN : STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL out_adder : STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL out_product : STD_LOGIC_VECTOR(7 downto 0);

	COMPONENT right_SR_8bit_WithInput
		PORT (
			i_clock			: IN	STD_LOGIC;
			i_load 			: IN  STD_LOGIC;
			i_enable 		: IN  STD_LOGIC;
			i_Value			: IN	STD_LOGIC_VECTOR(7 downto 0);
			i_shift			: IN STD_LOGIC := '0';
			o_Value			: OUT	STD_LOGIC_VECTOR(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT left_SR_4bit_WithInput
		PORT (
			i_clock			: IN	STD_LOGIC;
			i_load 			: IN  STD_LOGIC;
			i_enable 		: IN  STD_LOGIC;
			i_Value			: IN	STD_LOGIC_VECTOR(3 downto 0);
			o_Value			: OUT	STD_LOGIC_VECTOR(3 downto 0)
		);
	END COMPONENT;
	
	COMPONENT adder_8bit_for_sign_mult
		PORT (
			i_x 				: IN  STD_LOGIC_VECTOR(7 downto 0);
			i_y 				: IN  STD_LOGIC_VECTOR(7 downto 0);
			i_addSubControl: IN	STD_LOGIC;
			o_s				: OUT	STD_LOGIC_VECTOR(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT register_8bit
		PORT (
			i_d			:IN STD_LOGIC_VECTOR(7 downto 0);
			i_load		: IN STD_LOGIC;
			i_clear		: IN STD_LOGIC;
			i_clock		: IN STD_LOGIC;
			o_q			: OUT STD_LOGIC_VECTOR(7 downto 0)
		);
	END COMPONENT;
	
BEGIN

firstNum: right_SR_8bit_WithInput
	PORT MAP (
		i_clock => i_clock,
		i_load => i_FL,
		i_enable => i_FRS,
		i_Value => i_Input1(3) & i_Input1(3 downto 0) & "000",
		i_shift => i_Input1(3),
		o_Value => out_FN
	);
	
secondNum: left_SR_4bit_WithInput
	PORT MAP (
		i_clock => i_clock,
		i_load => i_SL,
		i_enable => i_SLS,
		i_Value => i_Input2,
		o_Value => out_SN
	);
o_SN2 <= out_SN(2);
o_SN3 <= out_SN(3);

adder: adder_8bit_for_sign_mult
	PORT MAP (
		i_x => out_product,
		i_y => out_FN,
		i_addSubControl => i_sub,
		o_s => out_adder
	);
	
product: register_8bit
	PORT MAP (
		i_d => out_adder,
		i_load => i_PL,
		i_clear => i_PCL,
		i_clock => i_clock,
		o_q => out_product
	);
	
output: register_8bit
	PORT MAP (
		i_d => out_product,
		i_load => i_OL,
		i_clear => '0',
		i_clock => i_clock,
		o_q => o_output
	);
	o_eq0 <= not(out_SN(2) or out_SN(1) or out_SN(0));
END rtl;