LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY topLevel_AddSub IS
	PORT (
		i_Input1: IN STD_LOGIC_VECTOR(3 downto 0);
		i_Input2: IN STD_LOGIC_VECTOR(3 downto 0);
		o_Carry: OUT STD_LOGIC;
		o_Overflow: OUT STD_LOGIC;
		o_Add: OUT STD_LOGIC_VECTOR(7 downto 0);
		o_Sub: OUT STD_LOGIC_VECTOR(7 downto 0)
	);
END topLevel_AddSub;

ARCHITECTURE rtl OF topLevel_AddSub IS

	
	COMPONENT adder_4bit
		PORT (
			i_x 				: IN  STD_LOGIC_VECTOR(3 downto 0);
			i_y 				: IN  STD_LOGIC_VECTOR(3 downto 0);
			i_addSubControl: IN	STD_LOGIC;
			o_s				: OUT	STD_LOGIC_VECTOR(3 downto 0);
			o_carry		: OUT STD_LOGIC;
			o_overflow : OUT STD_LOGIC
		);
	END COMPONENT;
	
	SIGNAL int_Add, int_Sub: STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL int_overflow_add, int_overflow_sub: STD_LOGIC;

BEGIN

addition: adder_4bit
	PORT MAP (
		i_x => i_Input1,
		i_y => i_input2,
		i_addSubControl => '0',
		o_s => int_Add,
		o_carry => o_Carry,
		o_overflow => int_overflow_add
	);

o_Add <= "0000" & int_Add;
	
substraction: adder_4bit
	PORT MAP (
		i_x => i_Input1,
		i_y => i_input2,
		i_addSubControl => '1',
		o_s => int_Sub,
		o_overflow => int_overflow_sub
	);

o_Sub <= "0000" & int_Sub;

o_overflow <= int_overflow_add or int_overflow_sub;
	
END rtl;