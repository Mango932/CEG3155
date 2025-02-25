library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter_4bit is
    Port (
        CLK: in std_logic;
        LOADC, ENC: in std_logic;
        count: out std_logic_vector(3 downto 0)
    );
end counter_4bit;

architecture struct of counter_4bit is
    signal Y3_i, Y2_i, Y1_i, Y0_i: std_logic;
    signal y3, y2, y1, y0: std_logic; 
    signal y3Bar, y2Bar, y1Bar, y0Bar: std_logic;

    COMPONENT enDFF
        PORT(
            i_d     : IN  STD_LOGIC;
            i_clock : IN  STD_LOGIC;
            i_enable: IN  STD_LOGIC;
            o_q     : OUT STD_LOGIC;
            o_qBar  : OUT STD_LOGIC
        );
    END COMPONENT;

begin

   
		Y3_i <= (y3 or (y2 and y1 and y0)) and (not(LOADC) and ENC);
    Y2_i <= ((y2 and y1Bar) or (y2 and y0Bar) or (y3 and y2) or (y2Bar and y1 and y0)) and (not(LOADC) and ENC);
    Y1_i <= ((y1Bar and y0) or (y1 and y0Bar) or (y3 and y2 and y0)) and (not(LOADC) and ENC);
    Y0_i <= (y0Bar or (y3 and y2 and y1)) and (not(LOADC) and ENC);

    DFF3: enDFF port map(i_d => Y3_i, i_clock => CLK, i_enable => '1', o_q => y3, o_qBar => y3Bar);
    DFF2: enDFF port map(i_d => Y2_i, i_clock => CLK, i_enable => '1', o_q => y2, o_qBar => y2Bar);
    DFF1: enDFF port map(i_d => Y1_i, i_clock => CLK, i_enable => '1', o_q => y1, o_qBar => y1Bar);
    DFF0: enDFF port map(i_d => Y0_i, i_clock => CLK, i_enable => '1', o_q => y0, o_qBar => y0Bar);

    count(3) <= y3;
    count(2) <= y2;
    count(1) <= y1;
    count(0) <= y0;

end struct;
