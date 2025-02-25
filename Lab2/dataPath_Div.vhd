LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY dataPath_Div IS
	PORT (
		i_clock: IN STD_LOGIC;
		i_Input1: IN STD_LOGIC_VECTOR(3 downto 0);
		i_Input2: IN STD_LOGIC_VECTOR(3 downto 0);
		i_counterL: IN STD_LOGIC;
		i_OVFL : IN STD_LOGIC;
		i_SignL: IN STD_LOGIC;
		i_QL: IN STD_LOGIC;
		i_RemL_3_downto_0: IN STD_LOGIC;
		i_RemClear_7_downto_4: IN STD_LOGIC;
		i_RemL_7_downto_4: IN STD_LOGIC;
		i_RemLS: IN STD_LOGIC;
		i_OutRL: IN STD_LOGIC;
		i_OutL: IN STD_LOGIC;
		o_OVF: OUT STD_LOGIC;
		o_count: OUT STD_LOGIC;
		o_Out: OUT STD_LOGIC_VECTOR(7 downto 0)
	);
END dataPath_Div;

ARCHITECTURE rtl OF dataPath_Div IS

	COMPONENT left_SR_8bit_for_division
		PORT (
			i_clock					: IN	STD_LOGIC;
			i_load_7_downto_4 	: IN  STD_LOGIC;
			i_load_3_downto_0 	: IN  STD_LOGIC;
			i_enable 				: IN  STD_LOGIC;
			i_Value					: IN	STD_LOGIC_VECTOR(7 downto 0);
			i_shift_value			: IN  STD_LOGIC;
			o_Value					: OUT	STD_LOGIC_VECTOR(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT adder_4bit
		PORT (
			i_x 				: IN  STD_LOGIC_VECTOR(3 downto 0);
			i_y 				: IN  STD_LOGIC_VECTOR(3 downto 0);
			i_addSubControl: IN	STD_LOGIC;
			o_s				: OUT	STD_LOGIC_VECTOR(3 downto 0);
			o_carry		: OUT STD_LOGIC
		);
	END COMPONENT;
	
	COMPONENT register_4bit
		PORT (
			i_d			:IN STD_LOGIC_VECTOR(3 downto 0);
			i_load		: IN STD_LOGIC;
			i_clock		: IN STD_LOGIC;
			o_q			: OUT STD_LOGIC_VECTOR(3 downto 0)
		);
	END COMPONENT;
	
	COMPONENT enDFF
		PORT (
			i_d 		: IN STD_LOGIC;
			i_clock 	: IN STD_LOGIC;
			i_enable	: IN STD_LOGIC;
			i_reset  : IN STD_LOGIC;
			o_q 		: OUT STD_LOGIC
		);
	END COMPONENT;
	
	COMPONENT mux_2x1_4bit
		PORT(
			i_a		: IN	STD_LOGIC_VECTOR(3 downto 0);
			i_b	: IN	STD_LOGIC_VECTOR(3 downto 0);
			i_select		: IN	STD_LOGIC;
			o_y: OUT	STD_LOGIC_VECTOR(3 downto 0)
		);
	END COMPONENT;
	
	COMPONENT left_SR_4bit_Circle
		PORT(
			i_clock			: IN	STD_LOGIC;
			i_load 			: IN  STD_LOGIC;
			i_enable 		: IN  STD_LOGIC;
			i_Value			: IN	STD_LOGIC_VECTOR(4 downto 0);
			o_Value			: OUT	STD_LOGIC_VECTOR(4 downto 0)
		);
	END COMPONENT;
	
	SIGNAL int_Quotient_Add, int_Quotient, int_Divisor_Add : STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL int_Main, int_Main_Mux, int_Res_Add : STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL int_ResRem	: STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL int_Main_OVF, int_OVF_dff, int_Sign : STD_LOGIC;

BEGIN

counter: left_SR_4bit_Circle
	PORT MAP(
		i_clock => i_clock,
		i_load => i_counterL,
		i_enable => i_RemLS,
		i_Value => "00001",
		o_Value(4) => o_count
	);

quotient_Add: adder_4bit
	PORT MAP (
		i_x => "0000",
		i_y => i_input2,
		i_addSubControl => i_input2(3),
		o_s => int_Quotient_Add
	);
	
quotient_Reg: register_4bit
	PORT MAP(
		i_d => int_Quotient_Add,
		i_load => i_QL,
		i_clock => i_clock,
		o_q => int_Quotient
	);

divisor_Add: adder_4bit
	PORT MAP (
		i_x => "0000",
		i_y => i_input1,
		i_addSubControl => i_input1(3),
		o_s => int_Divisor_Add
	);

main_Add: adder_4bit
	PORT MAP (
		i_x => int_ResRem(7 downto 4),
		i_y => int_Quotient,
		i_addSubControl => '1',
		o_s => int_Main,
		o_carry => int_Main_OVF
	);
o_OVF <= int_Main_OVF;
	
main_OVF_dff: enDFF
	PORT MAP (
		i_d => int_Main_OVF,
		i_clock => i_clock,
		i_enable => '1',
		i_reset => i_OVFL,
		o_q => int_OVF_dff
	);
	
main_mux: mux_2x1_4bit	
	PORT MAP (
		i_a => int_Main,
		i_b => "0000",
		i_select => i_RemClear_7_downto_4,
		o_y => int_Main_Mux
	);

remainder_Sreg: left_SR_8bit_for_division
	PORT MAP (
		i_clock => i_clock,
		i_load_7_downto_4 => i_RemL_7_downto_4,
		i_load_3_downto_0 => i_RemL_3_downto_0,
		i_enable => i_RemLS,
		i_Value => int_Main_Mux & int_Divisor_Add(2 downto 0) & '0',
		i_shift_value => int_OVF_dff,
		o_Value => int_ResRem
	);
	
remainder_output_reg: register_4bit
	PORT MAP (
		i_d => '0' & int_ResRem(7 downto 5),
		i_load => i_OutRL,
		i_clock => i_clock,
		o_q => o_Out(7 downto 4)
	);
	
sign_dff: enDFF
	PORT MAP (
		i_d => i_input1(3) xor i_input2(3),
		i_clock => i_clock,
		i_enable => i_signL,
		i_reset => '0',
		o_q => int_Sign
	);
	
output_adder: adder_4bit
	PORT MAP (
		i_x => "0000",
		i_y => int_ResRem(3 downto 0),
		i_addSubControl => int_Sign,
		o_s => int_Res_Add
	);
	
output_reg: register_4bit
	PORT MAP (
		i_d => int_Res_Add,
		i_load => i_OutL,
		i_clock => i_clock,
		o_q => o_Out(3 downto 0)
	);
END rtl;