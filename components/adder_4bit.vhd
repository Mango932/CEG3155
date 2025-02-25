LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY adder_4bit IS
	PORT(
		i_x 				: IN  STD_LOGIC_VECTOR(3 downto 0);
		i_y 				: IN  STD_LOGIC_VECTOR(3 downto 0);
		i_addSubControl: IN	STD_LOGIC;
		o_s				: OUT	STD_LOGIC_VECTOR(3 downto 0);
		o_carry			: OUT STD_LOGIC;
		o_overflow 		: OUT STD_LOGIC
	);
END adder_4bit;

ARCHITECTURE rtl OF adder_4bit IS
	SIGNAL int_carry: STD_LOGIC_VECTOR(3 downto 0);
	

	COMPONENT adder_1bit
		PORT(
		i_carry			: IN	STD_LOGIC;
		i_x 				: IN  STD_LOGIC;
		i_y 				: IN  STD_LOGIC;
		o_s				: OUT	STD_LOGIC;
		o_carry 		: OUT STD_LOGIC);
	END COMPONENT;

BEGIN

o_overflow <= int_carry(3) xor int_carry(2);
o_carry <= int_carry(3);

most_sb_adder: adder_1bit
	PORT MAP (
		i_carry => int_carry(2),
		i_x => i_x(3),
		i_y => i_y(3) xor i_addSubControl,
		o_s => o_s(3),
		o_carry => int_carry(3)
	);
	
third_sb_adder: adder_1bit
	PORT MAP (
		i_carry => int_carry(1),
		i_x => i_x(2),
		i_y => i_y(2)  xor i_addSubControl,
		o_s => o_s(2),
		o_carry => int_carry(2)
	);
	
second_sb_adder: adder_1bit
	PORT MAP (
		i_carry => int_carry(0),
		i_x => i_x(1),
		i_y => i_y(1)  xor i_addSubControl,
		o_s => o_s(1),
		o_carry => int_carry(1)
	);
	
least_sb_adder: adder_1bit
	PORT MAP (
		i_carry => i_addSubControl,
		i_x => i_x(0),
		i_y => i_y(0)  xor i_addSubControl,
		o_s => o_s(0),
		o_carry => int_carry(0)
	);
end rtl;