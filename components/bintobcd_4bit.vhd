LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY bintobcd_4bit IS
PORT (i_D       : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);  -- BIN input
      o_S       : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)); -- BCD Outputs
END bintobcd_4bit;
ARCHITECTURE display OF bintobcd_4bit IS
BEGIN
o_s <=  "00000000" WHEN i_d = "0000" ELSE -- H"40"
      "00000001" WHEN i_d = "0001" ELSE -- H"79"
      "00000010" WHEN i_d = "0010" ELSE -- H"24"
      "00000011" WHEN i_d = "0011" ELSE -- H"30"
      "00000100" WHEN i_d = "0100" ELSE -- H"19"
      "00000101" WHEN i_d = "0101" ELSE -- H"12"
      "00000110" WHEN i_d = "0110" ELSE -- H"02"
      "00000111" WHEN i_d = "0111" ELSE -- H"78"
      "00001000" WHEN i_d = "1000" ELSE -- H"00"
      "00001001" WHEN i_d = "1001" ELSE -- H"10"
      "00010000" WHEN i_d = "1010" ELSE -- H"08"
      "00010001" WHEN i_d = "1011" ELSE -- H"03"
      "00010010" WHEN i_d = "1100" ELSE -- H"46"
      "00010011" WHEN i_d = "1101" ELSE -- H"21"
      "00010100" WHEN i_d = "1110" ELSE -- H"06"
      "00010101";                     -- H"0E"
END display;