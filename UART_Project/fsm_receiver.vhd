library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm_receiver is
    Port (
			i_clock		: IN STD_LOGIC;
			i_reset		: IN STD_LOGIC;
			i_RxD			: IN STD_LOGIC;
			i_RDRF		: IN STD_LOGIC;
			o_RSRShift	: OUT STD_LOGIC;
			o_RDRLoad	: OUT STD_LOGIC;
			o_count1		: OUT STD_LOGIC_VECTOR(3 downto 0);
			o_count2		: OUT STD_LOGIC_VECTOR(3 downto 0);
			o_q1, o_q0	: OUT STD_LOGIC
    );
end fsm_receiver;

architecture struct of fsm_receiver is
   signal int_q1, int_q1Bar, int_q0, int_q0Bar, int_d1, int_d0: std_logic;
	signal int_count1, int_count2 : STD_LOGIC_VECTOR(3 downto 0);
	signal int_count1Exp, int_count2Exp, int_count1_4 : STD_LOGIC;
		
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
	 
	COMPONENT counter_4bit
		PORT (
			i_clock, i_reset: in std_logic;
			i_enable: in std_logic;
			o_count: out std_logic_vector(3 downto 0)
		);
	END COMPONENT;

begin

int_count1_4 <= int_q1Bar and int_q0;

int_count1Exp <= (int_count1_4 and int_count1(1) and int_count1(0)) or (not(int_count1_4) and int_count1(2) and int_count1(1) and int_count1(0));

counter1_8or4: counter_4bit
	PORT MAP(i_clock, i_reset or (int_count1_4 and int_count1(2)) or (not(int_count1_4) and int_count1(3)), int_q1 or int_q0, int_count1);
o_count1 <= int_count1;
	
int_count2Exp <= int_count2(3);

counter2_9: counter_4bit
	PORT MAP(i_clock, i_reset or (int_count2(3) and int_count2(0)), int_q1 and int_q0, int_count2);
o_count2 <= int_count2;
	
int_d1 <= (int_q1 and int_q0Bar) or (int_q1 and not(int_count2Exp)) or (int_q1Bar and int_q0 and int_count1Exp);
int_d0 <= (not(i_RxD) and int_q1Bar and not(int_count1Exp)) or (not(i_RxD) and int_q0Bar and int_count1Exp) or (int_q1Bar and int_q0 and not(int_count1Exp)) or (int_q1 and int_q0Bar and int_count1Exp);

DFF1: enDFF port map(i_d => int_d1, i_clock => i_clock, i_enable => '1', i_reset => i_reset, o_q => int_q1, o_qBar => int_q1Bar);
DFF0: enDFF port map(i_d => int_d0, i_clock => i_clock, i_enable => '1', i_reset => i_reset, o_q => int_q0, o_qBar => int_q0Bar);
o_q1 <= int_q1;
o_q0 <= int_q0;
		
o_RSRShift <= int_q1 and int_q0 and not(int_count2Exp);
o_RDRLoad <= int_q1Bar and int_q0Bar and not(i_RDRF);

end struct;
