-----------------------------------------------------------
--               FHTW CHIP DESIGN PROJECT                --
-----------------------------------------------------------
--  Author   : Hasan Denisultanov                        --
--  Date     : 30.05.2022                                --
--  Class    : BEL4                                      --
--  Filename : calc_ctrl.vhd                             --
--  Variant  : B                                         --
--  Optypes  : Add, Square, logical not, logical xor     --
-----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity calc_ctrl is
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
end calc_ctrl;