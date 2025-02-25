LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY adder_1bit IS
	PORT(
		i_carry			: IN	STD_LOGIC;
		i_x 				: IN  STD_LOGIC;
		i_y 				: IN  STD_LOGIC;
		o_s				: OUT	STD_LOGIC;
		o_carry 		: OUT STD_LOGIC
	);
END adder_1bit;

ARCHITECTURE rtl OF adder_1bit IS
BEGIN
	o_s <= (i_x xor i_y) xor i_carry;
	o_carry <= (i_x and i_y) or (i_carry and (i_x xor i_y));

END rtl;
