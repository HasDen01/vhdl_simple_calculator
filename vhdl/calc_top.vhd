-----------------------------------------------------------
--               FHTW CHIP DESIGN PROJECT                --
-----------------------------------------------------------
--  Author   : Hasan Denisultanov                        --
--  Date     : 30.05.2022                                --
--  Class    : BEL4                                      --
--  Filename : calc_top.vhd                              --
--  Variant  : B                                         --
--  Optypes  : Add, Square, logical not, logical xor     --
-----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity calc_top is

	port 
	(
		clk_i    : in std_logic; -- System clock(100MHz)
		reset_i  : in std_logic; -- Asynchronoushigh active reset(connected to push button BTNU)
		sw_i     : in std_logic_vector (15 downto 0); -- Connected to 16 switches SW0-SW15
		pb_i     : in std_logic_vector (3 downto 0); -- Connected to the 4 push buttons BTNL, BTNC, BNTR and BTND
		ss_o     : out std_logic_vector (7 downto 0); -- Contain the value for all four 7-segmentdigits(including the decimal point)
		ss_sel_o : out std_logic_vector (3 downto 0); -- Select one out of four 7-segment digits
		led_o    : out std_logic_vector (15 downto 0) -- Connected to 16 LEDs
	);
end calc_top;