LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY isZero_8bit IS
	PORT(
		i_value 				: IN  STD_LOGIC_VECTOR(7 downto 0);
		o_isZero 				: OUT  STD_LOGIC
	);
END isZero_8bit;

ARCHITECTURE rtl OF isZero_8bit IS
BEGIN
o_isZero <= not(i_value(7) or i_value(6) or i_value(5) or i_value(4) or i_value(3) or i_value(2) or i_value(1) or i_value(0));
end rtl;