-- Engineer: Mnyar Hees
--

-- Description:
-- This testbench is written to verify the functionality of the
-- 'vga_controller' VHDL design. It generates a 50 MHz clock, applies
-- a reset sequence, and drives different KEY input combinations to
-- test the RGB output areas.
--
-- The testbench performs the following:
-- 1. Generates a 50 MHz clock (20 ns period)
-- 2. Applies an active-low reset pulse
-- 3. Activates each color individually:
--        KEY = "001" → Red area
--        KEY = "010" → Green area
--        KEY = "100" → Blue area
-- 4. Activates all colors simultaneously:
--        KEY = "111"
-- 5. Allows the simulation to run so that VGA_HS, VGA_VS, and RGB
--    signals can be observed in ModelSim.
--
-- This file contains no timing checks on VGA protocol; it simply
-- verifies that the internal logic reacts correctly to button inputs.
--
-- The testbench has no ports and does not require a clock enable
-- since all signals are locally generated.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Testbench entity (no ports)
ENTITY vga_controller_tb IS
END vga_controller_tb;

ARCHITECTURE behavior OF vga_controller_tb IS

    --------------------------------------------------------------------
    -- Signal declarations for the Unit Under Test (UUT)
    --------------------------------------------------------------------
    SIGNAL CLOCK_50 : STD_LOGIC := '0';
    SIGNAL RESET_N  : STD_LOGIC := '0';
    SIGNAL KEY      : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');

    SIGNAL VGA_R  : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL VGA_G  : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL VGA_B  : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL VGA_HS : STD_LOGIC;
    SIGNAL VGA_VS : STD_LOGIC;

    --------------------------------------------------------------------
    -- Component declaration for the Unit Under Test (UUT)
   
    --------------------------------------------------------------------
    COMPONENT vga_controller
        PORT (
            CLOCK_50  : IN STD_LOGIC;
            RESET_N   : IN STD_LOGIC;
            KEY       : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            VGA_HS    : OUT STD_LOGIC;
            VGA_VS    : OUT STD_LOGIC;
            VGA_R     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            VGA_G     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            VGA_B     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

BEGIN

    --------------------------------------------------------------------
    -- Instantiate the Unit Under Test (UUT)
    --------------------------------------------------------------------
    uut : vga_controller
        PORT MAP (
            CLOCK_50 => CLOCK_50,
            RESET_N  => RESET_N,
            KEY      => KEY,
            VGA_HS   => VGA_HS,
            VGA_VS   => VGA_VS,
            VGA_R    => VGA_R,
            VGA_G    => VGA_G,
            VGA_B    => VGA_B
        );

    --------------------------------------------------------------------
    -- Clock generation: 50 MHz clock (20 ns period)
    --------------------------------------------------------------------
    clk_process : PROCESS
    BEGIN
        CLOCK_50 <= '0';
        WAIT FOR 10 ns;
        CLOCK_50 <= '1';
        WAIT FOR 10 ns;
    END PROCESS clk_process;

    --------------------------------------------------------------------
    -- Test sequences for the VGA controller
    --------------------------------------------------------------------
    stim_process : PROCESS
    BEGIN

        -- Apply reset (active low)
        RESET_N <= '0';
        WAIT FOR 100 ns;
        RESET_N <= '1';

        -- Test red output area
        KEY <= "001";        -- Select red
        WAIT FOR 1 ms;

        -- Test green output area
        KEY <= "010";        -- Select green
        WAIT FOR 1 ms;

        -- Test blue output area
        KEY <= "100";        -- Select blue
        WAIT FOR 1 ms;

        -- Test all colors at once
        KEY <= "111";
        WAIT FOR 1 ms;

        -- Wait to observe sync signals
        WAIT FOR 2 ms;

        WAIT;  -- End simulation
    END PROCESS stim_process;

END behavior;

