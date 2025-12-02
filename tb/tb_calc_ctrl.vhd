-----------------------------------------------------------
--               FHTW CHIP DESIGN PROJECT                --
-----------------------------------------------------------
--  Author   : Hasan Denisultanov                        --
--  Date     : 30.05.2022                                --
--  Class    : BEL4                                      --
--  Filename : tb_calc_ctrl.vhd                          --
--  Variant  : B                                         --
--  Optypes  : Add, Square, logical not, logical xor     --
-----------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_calc_ctrl is end tb_calc_ctrl;
architecture sim of tb_calc_ctrl is

	component calc_ctrl
		port 
		(
			clk_i      : in std_logic; --System clock(100MHz)
			reset_i    : in std_logic; --Asynchronoushigh active reset(connected to push button BTNU)
			finished_i : in std_logic; --ALU indicates that calculation of an arithmetic/logic operation is finished
			result_i   : in std_logic_vector(15 downto 0); --16-bit result of an arithmetic/logic operation coming from the ALU
			overflow_i : in std_logic; --Indicates that the result of an operation exceeds 16 bits
			sign_i     : in std_logic; --Sign bit of the result (0=positive, 1=negative)
			error_i    : in std_logic; --Indicates that an error occurred during processing of the operation
			swsync_i   : in std_logic_vector(15 downto 0); --State of 16 debounced switches (from IO control unit)
			pbsync_i   : in std_logic_vector(3 downto 0); --State of 4 debounced push buttons (from IO control unit)
			dig0_o     : out std_logic_vector (7 downto 0); --State of 7 segments anddecimal point of Digit 0 (to IO control unit)
			dig1_o     : out std_logic_vector (7 downto 0); --State of 7 segments anddecimal point of Digit 1 (to IO control unit)
			dig2_o     : out std_logic_vector (7 downto 0); --State of 7 segments anddecimal point of Digit 2 (to IO control unit)
			dig3_o     : out std_logic_vector (7 downto 0); --State of 7 segments anddecimal point of Digit 3 (to IO control unit)
			led_o      : out std_logic_vector(15 downto 0); --Connected to 16 LEDs (to IO control unit)
			start_o    : out std_logic; -- Instructs the ALU to start a new calculation
			optype_o   : out std_logic_vector (3 downto 0); --Defines the type of arithmetic/logic operation for the ALU
			op1_o      : out std_logic_vector (11 downto 0); --Operand OP1 for the ALU
			op2_o      : out std_logic_vector (11 downto 0) --Operand OP1 for the ALU
		);
	end component;

	signal clk_i      : std_logic; 
	signal reset_i    : std_logic; 
	signal finished_i : std_logic; 
	signal result_i   : std_logic_vector(15 downto 0); 
	signal overflow_i : std_logic; 
	signal sign_i     : std_logic; 
	signal error_i    : std_logic; 
	signal swsync_i   : std_logic_vector(15 downto 0); 
	signal pbsync_i   : std_logic_vector(3 downto 0); 
	signal dig0_o     : std_logic_vector (7 downto 0); 
	signal dig1_o     : std_logic_vector (7 downto 0); 
	signal dig2_o     : std_logic_vector (7 downto 0); 
	signal dig3_o     : std_logic_vector (7 downto 0); 
	signal led_o      : std_logic_vector(15 downto 0); 
	signal start_o    : std_logic; 
	signal optype_o   : std_logic_vector (3 downto 0); 
	signal op1_o      : std_logic_vector(11 downto 0); 
	signal op2_o      : std_logic_vector(11 downto 0);


begin
	-- Instantiate the design under test
	i_calc_ctrl : calc_ctrl
	port map
	(
		clk_i      => clk_i, 
		reset_i    => reset_i, 
		finished_i => finished_i, 
		result_i   => result_i, 
		overflow_i => overflow_i, 
		sign_i     => sign_i, 
		error_i    => error_i, 
		swsync_i   => swsync_i, 
		pbsync_i   => pbsync_i, 
		dig0_o     => dig0_o, 
		dig1_o     => dig1_o, 
		dig2_o     => dig2_o, 
		dig3_o     => dig3_o, 
		led_o      => led_o, 
		start_o    => start_o, 
		optype_o   => optype_o, 
		op1_o      => op1_o, 
		op2_o      => op2_o
	);

    -- 100Mhz clk signal
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
	
	-- testing the design by simulating inputs
	p_test : process
	begin
		-- after reset
		pbsync_i   <= "0000";
		swsync_i   <= x"0000";
		finished_i <= '0';
		overflow_i <= '0';
		error_i    <= '0';
		sign_i     <= '0';
		result_i   <= x"0000";
		wait for 2 ms;
		finished_i <= '1';
		wait for 10 ns;
		finished_i <= '0';
		wait for 2 ms;
		
		pbsync_i   <= "1000"; --BTNL is pressed => enter op1
		wait for 1 ms; 
		pbsync_i   <= "0000";
		swsync_i   <= x"0005";
		wait for 2 ms; 
		
		pbsync_i   <= "0100"; --BTNC is pressed => enter op2
		wait for 1 ms; 
		pbsync_i   <= "0000";
		swsync_i   <= x"0008";
		wait for 2 ms; 
		
		pbsync_i   <= "0010"; --BTNR is pressed => enter optype
		wait for 1 ms; 
		pbsync_i   <= "0000";
		swsync_i   <= "1000" & x"008";
		wait for 2 ms; 
		
		pbsync_i   <= "0001"; --BTND is pressed => enter calculate
		wait for 1 ms; 

		finished_i <= '1'; -- inputs from alu after calculation is complete
		error_i    <= '0';
		sign_i     <= '0';
		result_i   <= x"000A";

		wait for 10 ns;
		pbsync_i   <= "0000";
		finished_i <= '0';
		wait for 5 ms; 
		
		pbsync_i   <= "0100"; --BTNC is pressed => enter op2
		wait for 1 ms;
		pbsync_i   <= "0000";
		wait;
		
		assert false report "END OF SIMULATION" severity error; 
	end process p_test;
end sim;
		