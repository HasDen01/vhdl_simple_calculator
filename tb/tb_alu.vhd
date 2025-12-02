-----------------------------------------------------------
--               FHTW CHIP DESIGN PROJECT                --
-----------------------------------------------------------
--  Author   : Hasan Denisultanov                        --
--  Date     : 30.05.2022                                --
--  Class    : BEL4                                      --
--  Filename : tb_alu.vhd                                --
--  Variant  : B                                         --
--  Optypes  : Add, Square, logical not, logical xor     --
-----------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity tb_alu is end tb_alu;
architecture sim of tb_alu is

	component alu
		port 
		(
			clk_i      : in std_logic; --System clock(100MHz)
			reset_i    : in std_logic; --Asynchronoushigh active reset(connected to push button BTNU)
			op1_i      : in std_logic_vector (11 downto 0); --Operand OP1 fromthe Calculator Control Unit
			op2_i      : in std_logic_vector (11 downto 0); --Operand OP2 from the Calculator Control Unit
			optype_i   : in std_logic_vector (3 downto 0); --Type of arithmetic/logic operation (see Table 1)from the Calculator Control Unit
			start_i    : in std_logic; -- Instructs the ALU to start a new calculation
			finished_o : out std_logic; --ALU indicates that calculation of an arithmetic/logic operation is finished
			result_o   : out std_logic_vector (15 downto 0); --16-bit result of an arithmetic/logic operation coming from the ALU
			sign_o     : out std_logic; --Sign bit of the result (0=positive, 1=negative)
			error_o    : out std_logic; --Indicates that an error occurred during processing of the operation
			overflow_o : out std_logic --Indicates that the result of an operation exceeds 16 bits
		);
	end component;

	signal clk_i      : std_logic; 
	signal reset_i    : std_logic; 
	signal op1_i      : std_logic_vector (11 downto 0); 
	signal op2_i      : std_logic_vector (11 downto 0); 
	signal optype_i   : std_logic_vector (3 downto 0); 
	signal start_i    : std_logic; 
	signal finished_o : std_logic; 
	signal result_o   : std_logic_vector (15 downto 0); 
	signal sign_o     : std_logic; 
	signal error_o    : std_logic; 
	signal overflow_o : std_logic;

begin
	-- Instantiate the design under test
	i_alu : alu
	port map
	(
	clk_i      => clk_i, 
	reset_i    => reset_i, 
	op1_i      => op1_i, 
	op2_i      => op2_i, 
	optype_i   => optype_i, 
	start_i    => start_i, 
	finished_o => finished_o, 
	result_o   => result_o, 
	sign_o     => sign_o, 
	error_o    => error_o, 
	overflow_o => overflow_o
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
	p_test : process
	begin
	
		-- after reset 
	    op1_i    <= x"000";
		op2_i    <= x"000";
		optype_i <= "0000"; -- Add
		start_i  <= '0';
		wait for 2 ms;
		wait for 20 ns;
		start_i  <= '1';
		wait for 10 ns;
		start_i  <= '0';
		
		wait for 3 ms;
		
		-- add operation
		op1_i    <= x"005";
		op2_i    <= x"008";
		optype_i <= "0000"; -- Add
		start_i  <= '1';
		wait for 10 ns;
		start_i  <= '0';
		wait for 1 ms;
		
		-- square operation
		op1_i    <= x"005";
		op2_i    <= x"008";
		optype_i <= "0101"; -- square
		start_i  <= '1';
		wait for 10 ns;
		start_i  <= '0';
		wait for 1 ms;
		
		-- logical not operation
		op1_i    <= x"005";
		op2_i    <= x"008";
		optype_i <= "1000"; -- logical not
		start_i  <= '1';
		wait for 10 ns;
		start_i  <= '0';
		wait for 1 ms;
		
		-- logical xor operation
		op1_i    <= x"005";
		op2_i    <= x"008";
		optype_i <= "1011"; -- logical xor
		start_i  <= '1';
		wait for 10 ns;
		start_i  <= '0';
		wait for 3 ms;
		
		
		----------------- ERROR Testing ------------------
		
		--operation with not supported optype
		op1_i    <= x"005";
		op2_i    <= x"008";
		optype_i <= "1111"; -- not supported optype
		start_i  <= '1';
		wait for 10 ns;
		start_i  <= '0';
		wait for 1 ms;
		
		-- add with large numbers
		op1_i    <= x"FFF";
		op2_i    <= x"FFF";
		optype_i <= "0000"; --add
		start_i  <= '1';
		wait for 10 ns;
		start_i  <= '0';
		wait for 1 ms;
		
		-- square with large numbers
		op1_i    <= x"FFF";
		op2_i    <= x"FFF";
		optype_i <= "0101"; -- square
		start_i  <= '1';
		wait for 10 ns;
		start_i  <= '0';
		wait for 1 ms;
		
		-- logical not with large numbers
		op1_i    <= x"FFF";
		op2_i    <= x"FFF";
		optype_i <= "1000"; -- logical
		start_i  <= '1';
		wait for 10 ns;
		start_i  <= '0';
		wait for 1 ms;
		
		-- logical xor with large numbers
		op1_i    <= x"FFF";
		op2_i    <= x"FFF";
		optype_i <= "1011"; -- logical
		start_i  <= '1';
		wait for 10 ns;
		start_i  <= '0';
		wait;
		assert false report "END OF SIMULATION" severity error;
	end process p_test;
end sim;
			