-----------------------------------------------------------
--               FHTW CHIP DESIGN PROJECT                --
-----------------------------------------------------------
--  Author   : Hasan Denisultanov                        --
--  Date     : 30.05.2022                                --
--  Class    : BEL4                                      --
--  Filename : alu.vhd                                   --
--  Variant  : B                                         --
--  Optypes  : Add, Square, logical not, logical xor     --
-----------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity alu is
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
end alu;