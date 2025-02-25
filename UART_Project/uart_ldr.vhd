library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity uart_ldr is
    Port (
			i_clock	: IN STD_LOGIC;
			i_reset	: IN STD_LOGIC;
			i_INC		: IN STD_LOGIC;
			i_Y		: IN STD_LOGIC_VECTOR(1 downto 0);
			DATABUS	: OUT STD_LOGIC_VECTOR(7 downto 0)
    );
end uart_ldr;

architecture struct of uart_ldr is
	 signal int_count: std_logic_vector(3 downto 0);
	 signal int_state0, int_state1, int_state2, int_state3, int_asciiSelect: std_logic_vector(7 downto 0);
	 signal int_y1, int_y0, int_changeDetected: STD_LOGIC;
	 
	COMPONENT counter_4bit
		PORT (
			i_clock, i_reset: in std_logic;
			i_enable: in std_logic;
			o_count: out std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
	COMPONENT mux_8x3_8bit
		PORT(
			i_Value0		: IN	STD_LOGIC_VECTOR(7 downto 0);
			i_Value1		: IN	STD_LOGIC_VECTOR(7 downto 0);
			i_Value2		: IN	STD_LOGIC_VECTOR(7 downto 0);
			i_Value3		: IN	STD_LOGIC_VECTOR(7 downto 0);
			i_Value4		: IN	STD_LOGIC_VECTOR(7 downto 0);
			i_Value5		: IN	STD_LOGIC_VECTOR(7 downto 0);
			i_Value6		: IN	STD_LOGIC_VECTOR(7 downto 0);
			i_Value7		: IN	STD_LOGIC_VECTOR(7 downto 0);
			i_select    : IN	STD_LOGIC_VECTOR(2 downto 0);
			o_y			: OUT	STD_LOGIC_VECTOR(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT mux_4x2_8bit
		PORT(
			i_Value3		: IN	STD_LOGIC_VECTOR(7 downto 0);
			i_Value2		: IN	STD_LOGIC_VECTOR(7 downto 0);
			i_Value1		: IN	STD_LOGIC_VECTOR(7 downto 0);
			i_Value0		: IN	STD_LOGIC_VECTOR(7 downto 0);
			i_select    : IN	STD_LOGIC_VECTOR(1 downto 0);
			o_y			: OUT	STD_LOGIC_VECTOR(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT enDFF
      PORT(
			i_d     : IN  STD_LOGIC;
         i_enable: IN  STD_LOGIC;
         i_clock : IN  STD_LOGIC;
			i_reset: IN STD_LOGIC;
         o_q     : OUT STD_LOGIC
		);
   END COMPONENT;
	
	COMPONENT mux_2x1_8bit IS
		PORT(
			i_a			: IN	STD_LOGIC_VECTOR(7 downto 0);
			i_b			: IN	STD_LOGIC_VECTOR(7 downto 0);
			i_select  : IN  STD_LOGIC;
			o_y			: OUT	STD_LOGIC_VECTOR(7 downto 0)
		);
	END COMPONENT;

begin

y1: enDFF
	PORT MAP(i_Y(1), '1', i_clock, i_reset, int_y1);
y0: enDFF
	PORT MAP(i_Y(0), '1', i_clock, i_reset, int_y0);
int_changeDetected <= (i_Y(1) xor int_y1) or (i_Y(0) xor int_y0);

counter6: counter_4bit
	PORT MAP(i_clock, i_reset or (int_changeDetected and int_count(3)), i_INC and (not(int_count(3))), int_count);		
		
state0: mux_8x3_8bit
	PORT MAP("00001101","01110010","01010011","01011111","01100111","01001101", "00100000", "00100000",int_count(2 downto 0), int_state0);
			
state1: mux_8x3_8bit
	PORT MAP("00001101","01110010","01010011","01011111","01111001","01001101", "00100000", "00100000",int_count(2 downto 0), int_state1);
			
state2: mux_8x3_8bit
	PORT MAP("00001101","01100111","01010011","01011111","01110010","01001101", "00100000", "00100000",int_count(2 downto 0), int_state2);
			
state3: mux_8x3_8bit
	PORT MAP("00001101","01111001","01010011","01011111","01110010","01001101", "00100000", "00100000",int_count(2 downto 0), int_state3);
			
stateSelector: mux_4x2_8bit
	PORT MAP(int_state0, int_state1, int_state2, int_state3, i_Y, int_asciiSelect);
	
showZero: mux_2x1_8bit
	PORT MAP(int_asciiSelect, "00000000", int_count(3),DATABUS);
			
end struct;
