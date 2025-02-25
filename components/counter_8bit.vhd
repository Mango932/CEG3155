library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter_8bit is
    Port (
        i_clock, i_reset: in std_logic;
        i_enable: in std_logic;
        o_count: out std_logic_vector(7 downto 0)
    );
end counter_8bit;

architecture struct of counter_8bit is

signal int_counter3to0: STD_LOGIC_VECTOR(3 downto 0);

	COMPONENT counter_4bit
		PORT (
			i_clock, i_reset: in std_logic;
			i_enable: in std_logic;
			o_count: out std_logic_vector(3 downto 0)
		);
	END COMPONENT;

begin

counter7to4: counter_4bit
	PORT MAP(i_clock, i_reset, i_enable and int_counter3to0(3) and int_counter3to0(2) and int_counter3to0(1) and int_counter3to0(0), o_count(7 downto 4));
	
counter3to0: counter_4bit
	PORT MAP(i_clock, i_reset, i_enable, int_counter3to0);
	
o_count(3 downto 0) <= int_counter3to0;

end struct;
