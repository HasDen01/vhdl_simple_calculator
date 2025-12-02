-----------------------------------------------------------
--               FHTW CHIP DESIGN PROJECT                --
-----------------------------------------------------------
--  Author   : Hasan Denisultanov                        --
--  Date     : 30.05.2022                                --
--  Class    : BEL4                                      --
--  Filename : tb_calc_top.vhd                           --
--  Variant  : B                                         --
--  Optypes  : Add, Square, logical not, logical xor     --
-----------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_calc_top is end tb_calc_top;
architecture sim of tb_calc_top is

	component calc_top
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
	end component;
	
	signal clk_i    :  std_logic;
	signal reset_i  :  std_logic;
	signal sw_i     :  std_logic_vector (15 downto 0);
	signal pb_i     :  std_logic_vector (3 downto 0);
	signal ss_o     :  std_logic_vector (7 downto 0);
	signal ss_sel_o :  std_logic_vector (3 downto 0);
	signal led_o    :  std_logic_vector (15 downto 0);
		
begin
	-- Instantiate the design under test
	i_calc_top : calc_top
	port map
	(
		clk_i     => clk_i,
		reset_i   => reset_i,
		sw_i      => sw_i,
		pb_i      => pb_i,
		ss_o      => ss_o,
		ss_sel_o  => ss_sel_o,
		led_o     => led_o
	);
	
	-- 100 Mhz clock signal
	p_clk_i : process
	begin
		clk_i <= '0';
		wait for 5 ns;
		clk_i <= '1';
		wait for 5 ns;
	end process p_clk_i;

	-- 2ms reset
	p_reset_i : process
	begin
		reset_i <= '1';
		wait for 2 ms;
		reset_i <= '0';
		wait;
	end process p_reset_i;
	
	-- testing the design by simulating inputs
	p_test  : process
	begin 
		sw_i <= x"0000";
		pb_i <= "0000";
		
		-- button bouncing
		wait for 2 ms;
		pb_i <= "1000"; -- BTNL -> input Op1
		wait for 1 ms;
		pb_i <= "0000";
		wait for 1 ms;
		pb_i <= "1000";
		wait for 1 ms;
		pb_i <= "0000";
		wait for 1 ms;
		pb_i <= "1000";
		wait for 30 ms;
		pb_i <= "0000";
		
		-- switch bouncing
		wait for 10 ms;
		sw_i <= x"0004"; -- Op1 -> 4
		wait for 1 ms;
		sw_i <= x"0000";
		wait for 1 ms;
		sw_i <= x"0004";
		wait for 1 ms;
		sw_i <= x"0000";
		wait for 1 ms;
		sw_i <= x"0004";
		wait for 30 ms;
		
		-- button bouncing
		pb_i <= "0010"; -- BTNR -> input Optype
		wait for 1 ms;
		pb_i <= "0000";
		wait for 1 ms;
		pb_i <= "0010";
		wait for 1 ms;
		pb_i <= "0000";
		wait for 1 ms;
		pb_i <= "0010";
		wait for 30 ms;
		pb_i <= "0000";
		
		-- switch bouncing
		wait for 10 ms;
		sw_i <= "0101" & x"004"; -- Optype -> Square
		wait for 1 ms;
		sw_i <= x"0000";
		wait for 1 ms;
		sw_i <= "0101" & x"004";
		wait for 1 ms;
		sw_i <= x"0000";
		wait for 1 ms;
		sw_i <= "0101" & x"004";
		wait for 30 ms;
		
		-- button bouncing
		pb_i <= "0001"; -- BTND -> Calculate & show result
		wait for 1 ms;
		pb_i <= "0000";
		wait for 1 ms;
		pb_i <= "0001";
		wait for 1 ms;
		pb_i <= "0000";
		wait for 1 ms;
		pb_i <= "0001";
		wait for 30 ms;
		pb_i <= "0000";
		
		wait;
		assert false report "END OF SIMULATION" severity error;
	end process p_test;
end sim;