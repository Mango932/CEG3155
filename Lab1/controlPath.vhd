LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY controlPath IS 
	PORT(
		i_Clock: IN STD_LOGIC;
		i_GReset: IN STD_LOGIC;
		i_Right: IN STD_LOGIC; 
		i_Left : IN STD_LOGIC;
		o_LSRE : OUT STD_LOGIC;
		o_RSRE : OUT STD_LOGIC;
		o_LSRL : OUT STD_LOGIC;
		o_RSRL : OUT STD_LOGIC;
		o_MUXS : OUT STD_LOGIC_VECTOR(1 downto 0)
	);
	  
END controlPath;

ARCHITECTURE rtl of controlPath IS
	SIGNAL s0, s1, s2, s3: STD_LOGIC;

		COMPONENT enDFF
			PORT(
				i_d						: IN STD_LOGIC;
				i_enable					: IN STD_LOGIC;
				i_clock 					: IN STD_LOGIC;
				i_reset, i_preset 	: IN STD_LOGIC;
				o_q 						: OUT STD_LOGIC
			);
		END COMPONENT;
	BEGIN
	
	StateZero : enDFF	
		PORT MAP(
			i_d => '0',
			i_enable => '1',
			i_clock => i_Clock,
			o_q => s0,
			i_preset => i_GReset,
			i_reset => '0'
		);
		
	StateOne : enDFF	
		PORT MAP(
			i_d => i_Left and i_Right,
			i_enable => '1',
			i_clock => i_Clock,
			o_q => s1,
			i_reset => i_GReset,
			i_preset => '0'
		);
		
	StateTwo : enDFF	
		PORT MAP(
			i_d => i_Left and not(i_Right),
			i_enable => '1',
			i_clock => i_Clock,
			o_q => s2,
			i_reset => i_GReset,
			i_preset => '0'
		);
		
	StateThree : enDFF
		PORT MAP(
			i_d => not(i_Left) and i_Right,
			i_enable => '1',
			i_clock => i_Clock,
			o_q => s3,
			i_reset => i_GReset,
			i_preset => '0'
		);
	o_LSRE <= s1 or s2;
	o_RSRE <= s1 or s3;
	o_LSRL <= s0;
	o_RSRL <= s0;
	o_MUXS(1) <= s1 or s2;
	o_MUXS(0) <= s1 or s3;
end rtl;							