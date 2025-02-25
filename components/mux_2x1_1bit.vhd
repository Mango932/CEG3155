LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux_2x1_1bit IS
	PORT (
		i_a    	 : IN  STD_LOGIC; --If select is 0
		i_b    	 : IN  STD_LOGIC; --If select is 1
		i_select  : IN  STD_LOGIC;
		o_y       : OUT STD_LOGIC
	);
END mux_2x1_1bit;

ARCHITECTURE rtl OF mux_2x1_1bit IS
BEGIN
	o_y <= ((i_a and not(i_select)) or (i_b and i_select));
END rtl;