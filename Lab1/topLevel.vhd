LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY topLevel IS 
	PORT(
		i_GClock: IN STD_LOGIC;
		i_GReset: IN STD_LOGIC;
		i_Right: IN STD_LOGIC; 
		i_Left : IN STD_LOGIC;
		o_Display: OUT	STD_LOGIC_VECTOR(7 downto 0)
	);
	  
END topLevel;

ARCHITECTURE rtl of topLevel IS
	SIGNAL int_LSRE, int_RSRE, int_LSRL, int_RSRL : STD_LOGIC;
	SIGNAL int_MUXS: STD_LOGIC_VECTOR(1 downto 0);
	
		COMPONENT controlPath
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
		END COMPONENT;
		
		COMPONENT dataPath
			PORT(
				i_LSRL		: IN STD_LOGIC;
				i_LSRE		: IN STD_LOGIC;
				i_RSRL		: IN STD_LOGIC;
				i_RSRE		: IN STD_LOGIC;
				i_MUXS		: IN STD_LOGIC_VECTOR(1 downto 0);
				i_Clock	: IN STD_LOGIC;
				o_Display	: OUT	STD_LOGIC_VECTOR(7 downto 0)
			);
		END COMPONENT;
		
	BEGIN
	
	controlPath1: controlPath
		PORT MAP (
			i_Clock => i_GClock,
			i_GReset => i_GReset,
			i_Right => i_Right,
			i_Left => i_Left,
			o_LSRE => int_LSRE,
			o_RSRE => int_RSRE,
			o_LSRL => int_LSRL,
			o_RSRL => int_RSRL,
			o_MUXS => int_MUXS
		);
		
		dataPath1: dataPath
			PORT MAP(
				i_LSRL => int_LSRL,
				i_LSRE => int_LSRE,
				i_RSRL => int_RSRL,
				i_RSRE => int_RSRE,
				i_MUXS => int_MUXS,
				i_Clock => i_GClock,
				o_Display => o_Display
			);
end rtl;