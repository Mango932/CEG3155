LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY lcd_controller IS
	PORT (
		i_clock, i_reset: IN STD_LOGIC;
		i_RDR : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		i_RDRF: IN STD_LOGIC;
		o_RDRClear: OUT STD_LOGIC;
		LCD_DATA: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		LCD_RW, LCD_EN, LCD_RS: OUT STD_LOGIC;
		LCD_ON, LCD_BLON: OUT STD_LOGIC
	);
END lcd_controller;

ARCHITECTURE FSMD OF lcd_controller IS
	TYPE state_type IS (s1,s2,s10,s11,s12,s13);
	SIGNAL state: state_type;
	CONSTANT max: INTEGER := 50000;
	SUBTYPE ascii IS STD_LOGIC_VECTOR(7 DOWNTO 0);
	TYPE charArray IS array(1 to 16) OF ascii;
	TYPE initArray IS array(1 to 7) OF ascii;
	-- LCD initialization sequence codes
	-- 0x38 init four times
	-- 0x06 Entry mode set: Increment One; No Shift
	-- 0x0F Display control: Display ON; Cursor ON; Blink ON
	-- 0x01 Display clear
	SIGNAL count: integer;
	CONSTANT initcode: initArray := (x"38",x"38",x"38",x"38",x"06",x"0F",x"01");
BEGIN
    LCD_ON <= '1';
    LCD_BLON <= '1';
    lcd_control: PROCESS(i_clock, i_reset)
        BEGIN
            IF(i_reset = '1') THEN
                count <= 1;
                state <= s1;
            ELSIF(i_clock'EVENT AND i_clock = '1') THEN
                CASE state IS
                -- LCD initialization sequence
                   -- The LCD_DATA is written to the LCD at the falling edge of the E line
                   -- therefore we need to toggle the E line for each data write
                    WHEN s1 =>
                        LCD_DATA <= initcode(count);
                        LCD_EN <= '1'; -- EN=1;
                        LCD_RS <= '0'; -- RS=0; an instruction
                        LCD_RW <= '0'; -- R/W'=0; write
                        state <= s2;
                    WHEN s2 =>
                        LCD_EN <= '0'; -- set EN=0;
                        count <= count + 1;
                        IF count + 1 <= 7 THEN
                            state <= s1;
                        ELSE
                            state <= s10;
                        END IF;
                        -- move cursor to first line of display 
                    WHEN s10 =>
                        LCD_DATA <= x"80"; -- x80 is address of 1st position on first line
                        LCD_EN <= '1'; -- EN=1;
                        LCD_RS <= '0'; -- RS=0; an instruction
                        LCD_RW <= '0'; -- R/W'=0; write
                        state <= s11;
                    WHEN s11 =>
                        LCD_EN <= '0'; -- EN=0; toggle EN
                        count <= 1;
                        state <= s12;
                    -- write 1st line text
                    WHEN s12 =>
								IF i_RDRF = '1' THEN
									LCD_DATA <= i_RDR;
									LCD_EN <= '1'; -- EN=1;
									LCD_RS <= '1'; -- RS=1; data
									LCD_RW <= '0'; -- R/W'=0; write
									state <= s13;
									o_RDRClear <= '1';
								END IF;
                    WHEN s13 =>
                        LCD_EN <= '0'; -- EN=0; toggle EN
								o_RDRClear <= '0';
                        count <= count + 1;
                        IF count + 1 <= 8 THEN
                            state <= s12;
                        ELSE
                            state <= s10;
                        END IF;
                END CASE;
            END IF;
        END PROCESS;

END FSMD;