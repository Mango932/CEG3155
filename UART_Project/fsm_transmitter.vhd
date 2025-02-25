library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm_transmitter is
    Port (
			i_clock: IN STD_LOGIC;
			i_reset: IN STD_LOGIC;
			i_TDRE: IN STD_LOGIC;
			o_StopBitReset : OUT STD_LOGIC;
			o_TSRload: OUT STD_LOGIC;
			o_TSRshift: OUT STD_LOGIC;
			o_TDRClear: OUT STD_LOGIC;
			o_count		: OUT STD_LOGIC_VECTOR(7 downto 0)
    );
end fsm_transmitter;

architecture struct of fsm_transmitter is
   signal int_q1, int_q1Bar, int_q0, int_q0Bar, int_d1, int_d0: std_logic;
	signal int_count : STD_LOGIC_VECTOR(7 downto 0);
	signal int_count18 : STD_LOGIC;
		
   COMPONENT enDFF
      PORT(
			i_d     : IN  STD_LOGIC;
         i_enable: IN  STD_LOGIC;
         i_clock : IN  STD_LOGIC;
			i_reset: IN STD_LOGIC;
         o_q     : OUT STD_LOGIC;
         o_qBar  : OUT STD_LOGIC
		);
   END COMPONENT;
	 
	COMPONENT counter_8bit
		PORT (
			i_clock, i_reset: in std_logic;
			i_enable: in std_logic;
			o_count: out std_logic_vector(7 downto 0)
		);
	END COMPONENT;

begin

int_count18 <= int_count(4) and int_count(2);


counter18: counter_8bit
	PORT MAP(i_clock, i_reset or (int_count(4) and int_count(2) and int_count(0)), '1', int_count);
o_count <= int_count;
	
int_d1 <= (int_q1Bar and int_q0) or (int_q1 and int_q0Bar) or (int_q1 and not(int_count18));
int_d0 <= (int_q1 and not(i_TDRE)) or (int_q1 and not(int_count18)) or (int_q0Bar and not(i_TDRE)) or (int_q1 and int_q0Bar);

DFF1: enDFF port map(i_d => int_d1, i_clock => i_clock, i_enable => '1', i_reset => i_reset, o_q => int_q1, o_qBar => int_q1Bar);
DFF0: enDFF port map(i_d => int_d0, i_clock => i_clock, i_enable => '1', i_reset => i_reset, o_q => int_q0, o_qBar => int_q0Bar);
		
o_TSRload <= int_q1Bar and int_q0;
o_TSRshift <= int_q1;
o_StopBitReset <= int_q1Bar;
o_TDRClear <= int_q1 and int_q0Bar;

end struct;
