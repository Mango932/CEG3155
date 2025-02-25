LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY isZero_4bit IS
	PORT(
		i_value 		: IN  STD_LOGIC_VECTOR(3 downto 0);
		o_isZero 	: OUT  STD_LOGIC
	);
END isZero_4bit;

ARCHITECTURE rtl OF isZero_4bit IS
BEGIN
o_isZero <= not(i_value(3) or i_value(2) or i_value(1) or i_value(0));
end rtl;