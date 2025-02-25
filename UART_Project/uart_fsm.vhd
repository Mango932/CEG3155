library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity uart_fsm is
    Port (
			i_clock: in std_logic;
			i_reset: in std_logic;
			i_TDRE: in std_logic;
			i_RDRF: in std_logic;
			ADDR: out std_logic_vector(1 downto 0);
			o_INCStr: out std_logic;
			o_INCLdr: out std_logic
    );
end uart_fsm;

architecture struct of uart_fsm is
    signal int_q1, int_q1Bar, int_q0, int_q0Bar, int_d1, int_d0: std_logic;

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

begin

		int_d1 <= (int_q0 and i_RDRF) or (int_q1Bar and not(i_TDRE) and i_RDRF);
		int_d0 <= int_q0Bar and i_TDRE;

		DFF1: enDFF port map(i_d => int_d1, i_clock => i_clock, i_enable => '1', i_reset => i_reset, o_q => int_q1, o_qBar => int_q1Bar);
		DFF0: enDFF port map(i_d => int_d0, i_clock => i_clock, i_enable => '1', i_reset => i_reset, o_q => int_q0, o_qBar => int_q0Bar);
		
		ADDR <= int_q1 & int_q0;
		o_INCStr <= int_q1;
		o_INCLdr <= int_q0;
			
end struct;
