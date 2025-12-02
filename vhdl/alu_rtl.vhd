-----------------------------------------------------------
--               FHTW CHIP DESIGN PROJECT                --
-----------------------------------------------------------
--  Author   : Hasan Denisultanov                        --
--  Date     : 30.05.2022                                --
--  Class    : BEL4                                      --
--  Filename : alu_rtl.vhd                               --
--  Variant  : B                                         --
--  Optypes  : Add, Square, logical not, logical xor     --
-----------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture rtl of alu is

	signal s_finished  : std_logic;
	signal s_sign      : std_logic;
	signal s_error     : std_logic;
	signal s_overflow  : std_logic;
	signal s_result    : unsigned(16 downto 0); -- can't be negative with the given arith. operations -> unsigned
	signal downcounter : unsigned(16 downto 0);
	signal cnt_flag    : std_logic; -- used like state type for square operation

begin
	-------------------------------------------------------------
	-- Calculate result with given operands and operation type --
	-------------------------------------------------------------
 
	p_calculate : process (clk_i, reset_i)
		variable op1_17bit : unsigned(16 downto 0); -- signal for op1 with the same length as s_result
		variable op2_17bit : unsigned(16 downto 0); -- signal for op2 with the same length as s_result
	begin
		if (reset_i = '1') then -- asynchronous reset (active high)
			s_finished  <= '0';
			s_sign      <= '0';
			s_error     <= '0';
			s_overflow  <= '0';
			s_result    <= (others => '0');
			downcounter <= (others => '0');
			cnt_flag    <= '0';
			op1_17bit := (others => '0');
			op2_17bit := (others => '0');
 
		elsif clk_i'EVENT and clk_i = '1' then --rising clock edge
			if (s_finished = '0') then
				if (start_i = '1') then
				    -- 17bit signals with same value as 12bit operands
					op1_17bit(11 downto 0)  := unsigned(op1_i(11 downto 0));
					op1_17bit(16 downto 12) := "00000";
					op2_17bit(11 downto 0)  := unsigned(op2_i(11 downto 0));
					op2_17bit(16 downto 12) := "00000";
					case(optype_i)is
						when "0000" => --Add
							s_result   <= unsigned(op1_17bit) + unsigned(op2_17bit);
							s_overflow <= '0'; -- result can't have overflow
							s_sign     <= '0'; -- result can't be negative
							s_finished <= '1';
							s_error    <= '0'; -- operation was successful
						when "0101" => --Square
							if (cnt_flag = '0') then
								downcounter <= op1_17bit;
								s_result    <= (others => '0');
								cnt_flag    <= '1';
							end if;
						when "1000" => --logical not
							s_result   <= not op1_17bit;
							s_overflow <= '0'; -- result can't have overflow
							s_sign     <= '0'; -- result can't be negative
							s_finished <= '1';
							s_error    <= '0'; -- operation was successful
						when "1011" => -- logical ex-or
							s_result   <= op1_17bit xor op2_17bit;
							s_overflow <= '0'; -- result can't have overflow
							s_sign     <= '0'; -- result can't be negative
							s_finished <= '1';
							s_error    <= '0'; -- operation was successful
						when others => 
							s_error    <= '1'; -- given operation is not supported
							s_finished <= '1';
							s_sign     <= '0';
							s_overflow <= '0';
							s_result   <= (others => '0');
					end case;
				elsif (cnt_flag = '1') then -- if cnt_flag is '1' start downcounter for square operation
					if ((s_result <= x"FFFF") and (downcounter > 0)) then
					    -- add op1 to result op1-times (=until downcounter is 0) 
						s_result    <= (unsigned (s_result)) + (unsigned (op1_17bit));
						downcounter <= (unsigned (downcounter)) - x"01";
					elsif (s_result > x"FFFF") then
						s_overflow <= '1'; -- result is bigger than 16bit => overflow
						s_sign     <= '0'; -- result can't be negative
						s_finished <= '1';
						s_error    <= '0'; -- operation was successful
						cnt_flag   <= '0'; -- stop counting
					elsif (downcounter = 0) then
						s_overflow <= '0';
						s_sign     <= '0'; -- result can't be negative
						s_finished <= '1';
						s_error    <= '0'; -- operation was successful
						cnt_flag   <= '0'; -- stop counting
					end if;
 
				end if; 
			else
				s_finished <= '0'; -- this ensures that s_finished is 'high' for only 1 clock cycle
			end if;
		end if;

	end process;
 
	finished_o <= s_finished;
	result_o   <= std_logic_vector(s_result(15 downto 0));
	sign_o     <= s_sign;
	error_o    <= s_error;
	overflow_o <= s_overflow;
end rtl;