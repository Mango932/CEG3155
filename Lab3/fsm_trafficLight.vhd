library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm_trafficLight is
    Port (
			i_clock: in std_logic;
			i_reset: in std_logic;
			i_SSCS: in std_logic;
			i_C_Zero: in std_logic;
			o_y: out std_logic_vector(2 downto 0);
			o_z: out std_logic_vector(2 downto 0);
			o_w: out std_logic_vector(1 downto 0)
    );
end fsm_trafficLight;

architecture struct of fsm_trafficLight is
    signal int_q1, int_q1Bar, int_q0, int_q0Bar, int_d1, int_d0: std_logic;

    COMPONENT enDFF
        PORT(
            i_d     : IN  STD_LOGIC;
            i_clock : IN  STD_LOGIC;
            i_enable: IN  STD_LOGIC;
				i_reset: IN STD_LOGIC;
            o_q     : OUT STD_LOGIC;
            o_qBar  : OUT STD_LOGIC
        );
    END COMPONENT;

begin

		int_d1 <= (int_q1Bar and int_q0) or (int_q1 and int_q0Bar);
		int_d0 <= (int_q1 and int_q0Bar and i_C_Zero) or (int_q0Bar and i_SSCS and i_C_Zero);

		DFF1: enDFF port map(i_d => int_d1, i_clock => i_clock, i_enable => '1', i_reset => i_reset, o_q => int_q1, o_qBar => int_q1Bar);
		DFF0: enDFF port map(i_d => int_d0, i_clock => i_clock, i_enable => '1', i_reset => i_reset, o_q => int_q0, o_qBar => int_q0Bar);
		
		o_y(2) <= int_q1Bar and int_q0Bar;
		o_y(1) <= int_q1Bar and int_q0;
		o_y(0) <= int_q1;
		
		o_z(2) <= int_q1 and int_q0Bar;
		o_z(1) <= int_q1 and int_q0;
		o_z(0) <= int_q1Bar;
		
		o_w(1) <= int_q1Bar and int_q0Bar;
		o_w(0) <= int_q1 and int_q0Bar;

end struct;
