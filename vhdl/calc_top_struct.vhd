-----------------------------------------------------------
--               FHTW CHIP DESIGN PROJECT                --
-----------------------------------------------------------
--  Author   : Hasan Denisultanov                        --
--  Date     : 30.05.2022                                --
--  Class    : BEL4                                      --
--  Filename : calc_top_struct.vhd                       --
--  Variant  : B                                         --
--  Optypes  : Add, Square, logical not, logical xor     --
-----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

architecture struct of calc_top is

component io_ctrl  -- component declaration of IO control unit
  port (clk_i    : in std_logic; --System clock(100MHz)
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
end component;


component calc_ctrl  -- component declaration of calculator control unit
    port (
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


component alu  -- component declaration of alu unit
    port (
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

    -- Internal signals
	signal op1      :  std_logic_vector (11 downto 0); 
	signal op2      :  std_logic_vector (11 downto 0); 
	signal optype   :  std_logic_vector (3 downto 0); 
	signal start    :  std_logic; 
	signal finished :  std_logic; 
	signal result   :  std_logic_vector (15 downto 0); 
	signal sign     :  std_logic; 
	signal error    :  std_logic; 
	signal overflow :  std_logic;
	signal swsync   :  std_logic_vector(15 downto 0); 
	signal pbsync   :  std_logic_vector(3 downto 0); 
	signal dig0     :  std_logic_vector (7 downto 0); 
	signal dig1     :  std_logic_vector (7 downto 0); 
	signal dig2     :  std_logic_vector (7 downto 0); 
	signal dig3     :  std_logic_vector (7 downto 0); 
	signal led      :  std_logic_vector(15 downto 0); 
	
begin  -- struct

i_io_ctrl : io_ctrl  -- instantiate IO control unit  
port map
   (    	clk_i    => clk_i, 
			reset_i  => reset_i, 
			sw_i     => sw_i, 
			pb_i     => pb_i, 
			dig0_i   => dig0, 
			dig1_i   => dig1, 
			dig2_i   => dig2, 
			dig3_i   => dig3, 
			led_i    => led, 
			ss_o     => ss_o, 
			ss_sel_o => ss_sel_o, 
			led_o    => led_o, 
			swsync_o => swsync, 
			pbsync_o => pbsync
		);
		
 
i_calc_ctrl : calc_ctrl -- instantiate calculator control unit port map
port map
(
	clk_i       => clk_i, 
	reset_i     => reset_i, 
	finished_i  => finished, 
	result_i    => result, 
	overflow_i  => overflow, 
	sign_i      => sign, 
	error_i     => error, 
	swsync_i    => swsync, 
	pbsync_i    => pbsync, 
	dig0_o      => dig0, 
	dig1_o      => dig1, 
	dig2_o      => dig2, 
	dig3_o      => dig3, 
	led_o       => led, 
	start_o     => start, 
	optype_o    => optype, 
	op1_o       => op1, 
	op2_o       => op2);


i_alu : alu -- instantiate ALU port map
port map
(
	clk_i       => clk_i, 
	reset_i     => reset_i, 
	op1_i       => op1, 
	op2_i       => op2, 
	optype_i    => optype, 
	start_i     => start, 
	finished_o  => finished, 
	result_o    => result, 
	sign_o      => sign, 
	error_o     => error, 
	overflow_o  => overflow);
	
   
 end struct;