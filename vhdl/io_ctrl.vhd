-----------------------------------------------------------
--               FHTW CHIP DESIGN PROJECT                --
-----------------------------------------------------------
--  Author   : Hasan Denisultanov                        --
--  Date     : 30.05.2022                                --
--  Class    : BEL4                                      --
--  Filename : io_ctrl.vhd                               --
--  Variant  : B                                         --
--  Optypes  : Add, Square, logical not, logical xor     --
-----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity io_ctrl is
	port
	(
		clk_i    : in std_logic; --System clock(100MHz)
		reset_i  : in std_logic; --Asynchronoushigh active reset(connected to push button BTNU)
		sw_i     : in std_logic_vector (15 downto 0); -- Connected to 16switchesSW0-SW15
		pb_i     : in std_logic_vector (3 downto 0); --Connected to the 4 push buttonsBTNL, BTNC, BNTR and BTND
		dig0_i   : in std_logic_vector (7 downto 0); --State of 7 segments and decimal point of Digit0 (from FPGA-internal logic)
		dig1_i   : in std_logic_vector (7 downto 0); --State of 7 segments and decimal point of Digit1 (from FPGA-internal logic)
		dig2_i   : in std_logic_vector (7 downto 0); --State of 7 segments and decimal point of Digit2 (from FPGA-internal logic)
		dig3_i   : in std_logic_vector (7 downto 0); --State of 7 segments and decimal point of Digit3 (from FPGA-internal logic)
		led_i    : in std_logic_vector(15 downto 0); --State of 16 LEDs (from FPGA-internal logic)
		ss_o     : out std_logic_vector (7 downto 0); -- Contain the value for all four 7-segmentdigits(including the decimal point)
		ss_sel_o : out std_logic_vector (3 downto 0); --Select one out of four 7-segment digits
		led_o    : out std_logic_vector(15 downto 0); --Connected to 16 LEDs
		swsync_o : out std_logic_vector(15 downto 0); --State of 4 debounced switches (to FPGA-internal logic)
		pbsync_o : out std_logic_vector(3 downto 0) --State of 4 debounced push buttons (to FPGA-internal logic)
	);
end io_ctrl;