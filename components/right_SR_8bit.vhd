LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY right_SR_8bit IS
	PORT(
		i_clock			: IN	STD_LOGIC;
		i_load 			: IN  STD_LOGIC;
		i_enable 		: IN  STD_LOGIC;
		i_Value			: IN	STD_LOGIC_VECTOR(7 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(7 downto 0));
END right_SR_8bit;

ARCHITECTURE rtl OF right_SR_8bit IS
	signal DFF_Q : STD_LOGIC_VECTOR(7 downto 0);
	signal DFF_D : STD_LOGIC_VECTOR(7 downto 0);
	signal int_enable : STD_LOGIC;
	

	COMPONENT enDFF
		PORT(
			i_d			: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			i_enable 	: IN  STD_LOGIC;
			o_q			: OUT	STD_LOGIC);
	END COMPONENT;
	
	COMPONENT mux_2x1_1bit
		PORT(
			i_a		: IN	STD_LOGIC;
			i_b	: IN	STD_LOGIC;
			i_select		: IN	STD_LOGIC;
			o_y: OUT	STD_LOGIC);
	END COMPONENT;

BEGIN
int_enable <= i_enable or i_load;

most_sb_mult: mux_2x1_1bit
	PORT MAP (
		i_a => DFF_Q(0),
		i_b => i_Value(7),
		i_select => i_load,
		o_y => DFF_D(7)
	);
	
most_sb_ff: enDFF
	PORT MAP (
			  i_d => DFF_D(7),
			  i_clock => i_clock,
			  i_enable => int_enable,
			  o_q => DFF_Q(7)
	);
	o_Value(7) <= DFF_Q(7);

seventh_sb_mult: mux_2x1_1bit
	PORT MAP (
		i_a => DFF_Q(7),
		i_b => i_Value(6),
		i_select => i_load,
		o_y => DFF_D(6)
	);
				 
seventh_sb_ff: enDFF                                                                      
	PORT MAP (
			  i_d => DFF_D(6),
			  i_clock => i_clock,
			  i_enable => int_enable,
			  o_q => DFF_Q(6)
	);
	o_Value(6) <= DFF_Q(6);

sixth_sb_mult: mux_2x1_1bit
	PORT MAP (
		i_a => DFF_Q(6),
		i_b => i_Value(5),
		i_select => i_load,
		o_y => DFF_D(5)
	);
			  
sixth_sb_ff: enDFF                                                                      
	PORT MAP (
			  i_d => DFF_D(5),
			  i_clock => i_clock,
			  i_enable => int_enable,
			  o_q => DFF_Q(5)
	);
	o_Value(5) <= DFF_Q(5);

fifth_sb_mult: mux_2x1_1bit
	PORT MAP (
		i_a => DFF_Q(5),
		i_b => i_Value(4),
		i_select => i_load,
		o_y => DFF_D(4)
	);
			  
fifth_sb_ff: enDFF                                                                      
	PORT MAP (
			  i_d => DFF_D(4),
			  i_clock => i_clock,
			  i_enable => int_enable,
			  o_q => DFF_Q(4)
	);
	o_Value(4) <= DFF_Q(4);

fourth_sb_mult: mux_2x1_1bit
	PORT MAP (
		i_a => DFF_Q(4),
		i_b => i_Value(3),
		i_select => i_load,
		o_y => DFF_D(3)
	);
				 
fourth_sb_ff: enDFF                                                                      
	PORT MAP (
			  i_d => DFF_D(3),
			  i_clock => i_clock,
			  i_enable => int_enable,
			  o_q => DFF_Q(3)
	);
	o_Value(3) <= DFF_Q(3);

third_sb_mult: mux_2x1_1bit
	PORT MAP (
		i_a => DFF_Q(3),
		i_b => i_Value(2),
		i_select => i_load,
		o_y => DFF_D(2)
	);
	
third_sb_ff: enDFF                                                                      
	PORT MAP (
			  i_d => DFF_D(2),
			  i_clock => i_clock,
			  i_enable => int_enable,
			  o_q => DFF_Q(2)
	);
	o_Value(2) <= DFF_Q(2);

second_sb_mult: mux_2x1_1bit
	PORT MAP (
		i_a => DFF_Q(2),
		i_b => i_Value(1),
		i_select => i_load,
		o_y => DFF_D(1)
	);
	
second_sb_ff: enDFF
	PORT MAP (
			  i_d => DFF_D(1),
			  i_clock => i_clock,
			  i_enable => int_enable,
			  o_q => DFF_Q(1)
	);
	o_Value(1) <= DFF_Q(1);

least_sb_mult: mux_2x1_1bit
	PORT MAP (
		i_a => DFF_Q(1),
		i_b => i_Value(0),
		i_select => i_load,
		o_y => DFF_D(0)
	);
	
least_sb_ff: enDFF
	PORT MAP (
			  i_d => DFF_D(0),
			  i_clock => i_clock,
			  i_enable => int_enable,
			  o_q => DFF_Q(0)
	);
	o_Value(0) <= DFF_Q(0);

END rtl;
