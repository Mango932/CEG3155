LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY enDFF IS
    PORT(
        i_reset    : IN    STD_LOGIC;
        i_d        : IN    STD_LOGIC;
        i_enable    : IN    STD_LOGIC;
        i_clock        : IN    STD_LOGIC;
        o_q, o_qBar    : OUT    STD_LOGIC);
END enDFF;

ARCHITECTURE struct OF enDFF IS
    SIGNAL int_q : STD_LOGIC;

BEGIN

    oneBitRegister:
    PROCESS(i_reset, i_clock)
    BEGIN
        IF ((int_q /= '0') and (int_q /= '1')) THEN
            int_q    <= '0';
        ELSIF (i_clock'EVENT and i_clock = '1') THEN
            IF (i_enable = '1') THEN
                int_q    <=    i_d;
            END IF;
        END IF;
    END PROCESS oneBitRegister;

    --  Output Driver

    o_q        <=    int_q;
    o_qBar        <=    not(int_q);

END struct;