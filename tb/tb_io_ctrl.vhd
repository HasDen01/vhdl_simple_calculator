-----------------------------------------------------------
--               FHTW CHIP DESIGN PROJECT                --
-----------------------------------------------------------
--  Author   : Hasan Denisultanov                        --
--  Date     : 30.05.2022                                --
--  Class    : BEL4                                      --
--  Filename : tb_io_ctrl.vhd                            --
--  Variant  : B                                         --
--  Optypes  : Add, Square, logical not, logical xor     --
-----------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_io_ctrl is end tb_io_ctrl;
architecture sim of tb_io_ctrl is

	-- Declaration of the component under test
	component io_ctrl
		port 
		(
			clk_i    : in std_logic; -- System clock (100MHz)
			reset_i  : in std_logic; -- Asynchronous high active reset
			sw_i     : in std_logic_vector (15 downto 0); -- State of 16 switches (from FPGA board)
			pb_i     : in std_logic_vector (3 downto 0); -- State of 4 push buttons (from FPGA board)
			dig0_i   : in std_logic_vector (7 downto 0); -- State of 7 segments and decimal point of Digit0 (from FPGA-internal logic)
			dig1_i   : in std_logic_vector (7 downto 0); -- State of 7 segments and decimal point of Digit1 (from FPGA-internal logic)
			dig2_i   : in std_logic_vector (7 downto 0); -- State of 7 segments and decimal point of Digit2 (from FPGA-internal logic)
			dig3_i   : in std_logic_vector (7 downto 0); -- State of 7 segments and decimal point of Digit3 (from FPGA-internal logic)
			led_i    : in std_logic_vector(15 downto 0); -- State of 16 LEDs (from FPGA-internal logic)
			ss_o     : out std_logic_vector (7 downto 0); -- To 7-segment displayof the FPGA board
			ss_sel_o : out std_logic_vector (3 downto 0); -- Selection of a 7-segment digit on the FPGA board
			led_o    : out std_logic_vector(15 downto 0); -- Connected to 16 LEDs of the FPGA board
			swsync_o : out std_logic_vector(15 downto 0); -- State of 16 debounced switches (to FPGA-internal logic)
			pbsync_o : out std_logic_vector(3 downto 0) -- State of 4 debounced push buttons (to FPGA-internal logic)
		);
	end component;

	signal clk_i    : std_logic;
	signal reset_i  : std_logic;
	signal sw_i     : std_logic_vector (15 downto 0);
	signal pb_i     : std_logic_vector (3 downto 0);
	signal dig0_i   : std_logic_vector (7 downto 0);
	signal dig1_i   : std_logic_vector (7 downto 0);
	signal dig2_i   : std_logic_vector (7 downto 0);
	signal dig3_i   : std_logic_vector (7 downto 0);
	signal led_i    : std_logic_vector(15 downto 0);
	signal ss_o     : std_logic_vector (7 downto 0);
	signal ss_sel_o : std_logic_vector (3 downto 0);
	signal led_o    : std_logic_vector(15 downto 0);
	signal swsync_o : std_logic_vector(15 downto 0);
	signal pbsync_o : std_logic_vector(3 downto 0);

begin
	-- Instantiate the design under test
	i_io_ctrl : io_ctrl
	port map
	(
		clk_i    => clk_i, 
		reset_i  => reset_i, 
		sw_i     => sw_i, 
		pb_i     => pb_i, 
		dig0_i   => dig0_i, 
		dig1_i   => dig1_i, 
		dig2_i   => dig2_i, 
		dig3_i   => dig3_i, 
		led_i    => led_i, 
		ss_o     => ss_o, 
		ss_sel_o => ss_sel_o, 
		led_o    => led_o, 
		swsync_o => swsync_o, 
		pbsync_o => pbsync_o
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
	p_reset : process
	begin
		reset_i <= '1';
		wait for 2 ms;
		reset_i <= '0';
		wait;
	end process p_reset;

	p_dig : process
	begin
		dig0_i <= "10000001";
		dig1_i <= "11000011";
		dig2_i <= "11100111";
		dig3_i <= "11111111";
		wait for 60 ms;
		dig0_i <= "10000000";
		dig1_i <= "01000000";
		dig2_i <= "00100000";
		dig3_i <= "00010000";
		wait;
	end process p_dig;

	-- testing the design by simulating inputs
	test : process
	begin
		sw_i  <= x"0000";
		pb_i  <= x"0";
		led_i <= x"0000";
		
		-- switch bouncing
		wait for 5 ms;
		sw_i <= x"0001";
		wait for 1 ms;
		sw_i <= x"0000";
		wait for 1 ms;
		sw_i <= x"0001";
		wait for 1 ms;
		sw_i <= x"0000";
		wait for 1 ms;
		sw_i <= x"0001";
		wait for 30 ms;
		sw_i <= x"0000";
		wait for 10 ms;

		-- button bouncing
		pb_i <= x"1";
		wait for 5 ms;
		pb_i <= x"0";
		wait for 5 ms;
		pb_i <= x"1";
		wait for 1 ms;
		pb_i <= x"0";
		wait for 1 ms;
		pb_i <= x"1";
		wait for 1 ms;
		pb_i <= x"0";
		wait for 1 ms;
		pb_i <= x"1";
		wait for 30 ms;
		pb_i <= x"0";
		wait for 10 ms;
		
		-- led input
		led_i <= (15 => '1', others => '0');
		wait;
		
		assert false report "END OF SIMULATION" severity error;
	end process test;
end sim;