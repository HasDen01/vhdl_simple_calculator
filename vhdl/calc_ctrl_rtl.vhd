-----------------------------------------------------------
--               FHTW CHIP DESIGN PROJECT                --
-----------------------------------------------------------
--  Author   : Hasan Denisultanov                        --
--  Date     : 30.05.2022                                --
--  Class    : BEL4                                      --
--  Filename : calc_ctrl_rtl.vhd                         --
--  Variant  : B                                         --
--  Optypes  : Add, Square, logical not, logical xor     --
-----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture rtl of calc_ctrl is

	signal s_start  : std_logic;
	signal s_op1    : std_logic_vector (11 downto 0);
	signal s_op2    : std_logic_vector (11 downto 0);
	signal s_optype : std_logic_vector (3 downto 0);
	signal s_dig0   : std_logic_vector (7 downto 0);
	signal s_dig1   : std_logic_vector (7 downto 0);
	signal s_dig2   : std_logic_vector (7 downto 0);
	signal s_dig3   : std_logic_vector (7 downto 0);
	signal s_led    : std_logic_vector (15 downto 0);
	signal count    : std_logic; -- 1 clock long count for sending start signal to alu
	type state_type_interface is (enter_op1, enter_op2, enter_optype, calculate, display_result);
	signal state_interface : state_type_interface;

	-- This function returns a given binary or hex number as led values for a ss display
	-- It also checks for overflow and sign signals
	function binary_to_ss(
	four_bits    : std_logic_vector (3 downto 0);
	overflow_val : std_logic;
	sign_val     : std_logic) return std_logic_vector is
	variable var_ss_value  : std_logic_vector (7 downto 0); 
	begin
		if (overflow_val = '1') then
			var_ss_value := "11000101"; -- o
		elsif (sign_val = '1') then
			var_ss_value := "11111101"; -- "-"
		else
			case(four_bits) is
				when x"0" => var_ss_value := "00000011";
				when x"1" => var_ss_value := "10011111";
				when x"2" => var_ss_value := "00100101";
				when x"3" => var_ss_value := "00001101";
				when x"4" => var_ss_value := "10011001";
				when x"5" => var_ss_value := "01001001";
				when x"6" => var_ss_value := "01000001";
				when x"7" => var_ss_value := "00011111";
				when x"8" => var_ss_value := "00000001";
				when x"9" => var_ss_value := "00001001";
				when x"A" => var_ss_value := "00010001";
				when x"B" => var_ss_value := "11000001";
				when x"C" => var_ss_value := "01100011";
				when x"D" => var_ss_value := "10000101";
				when x"E" => var_ss_value := "01100001";
				when x"F" => var_ss_value := "01110001";
				when others => var_ss_value := "11111111";
			end case;
		end if; 
	return var_ss_value;
	end function binary_to_ss;
	
begin
	---------------------------------------
	-- Define the values of the operands --
	---------------------------------------
	p_interface : process (clk_i, reset_i)
	begin
		if (reset_i = '1') then -- asynchronous reset (active high)
			state_interface <= calculate;

		elsif clk_i'EVENT and clk_i = '1' then --rising clock edge
			if ((state_interface = calculate) and (finished_i = '1')) then
				state_interface <= display_result;
			else
				case(pbsync_i) is
					when "1000" => -- when BTNL is pressed
						state_interface <= enter_op1;
					when "0100" => --when BTNC is pressed
						state_interface <= enter_op2;
					when "0010" => --when BTNR is pressed
						state_interface <= enter_optype;
					when "0001" => --when BTND is pressed
						state_interface <= calculate;
					when others => null;
				end case;
			end if;
		end if;
	end process;
 

	p_decode : process (clk_i, reset_i)
	begin
		if (reset_i = '1') then -- asynchronous reset (active high)
			count    <= '0';
			s_led    <= (others => '0');
			s_start  <= '0';
			s_op1    <= (others => '0');
			s_op2    <= (others => '0');
			s_optype <= "0000";
			s_dig0   <= "00000011"; --
			s_dig1   <= "00000011"; --
			s_dig2   <= "00000011"; --
			s_dig3   <= "00000011"; --

		elsif clk_i'EVENT and clk_i = '1' then --rising clock edge
			case(state_interface) is
				when enter_op1 => 
					s_led  <= (others => '0');
					s_op1  <= swsync_i(11 downto 0);
					s_dig0 <= "10011110"; -- 1.
					s_dig1 <= binary_to_ss(swsync_i(11 downto 8), '0', '0');
					s_dig2 <= binary_to_ss(swsync_i(7 downto 4), '0', '0');
					s_dig3 <= binary_to_ss(swsync_i(3 downto 0), '0', '0');
				when enter_op2 => 
					s_led  <= (others => '0');
					s_op2  <= swsync_i(11 downto 0);
					s_dig0 <= "00100100"; -- 2.
					s_dig1 <= binary_to_ss(swsync_i(11 downto 8), '0', '0');
					s_dig2 <= binary_to_ss(swsync_i(7 downto 4), '0', '0');
					s_dig3 <= binary_to_ss(swsync_i(3 downto 0), '0', '0');
				when enter_optype => 
					s_led    <= (others => '0');
					s_optype <= swsync_i(15 downto 12);
					s_dig0   <= "11000100"; -- set dig0 to "o."
					case(s_optype) is
						when "0000" => -- Add
							s_dig1 <= "00010001"; -- A
							s_dig2 <= "10000101"; -- d
							s_dig3 <= "10000101"; -- d
						when "0101" => -- Square
							s_dig1 <= "01001001"; -- S
							s_dig2 <= "00011001"; -- q
							s_dig3 <= "11110101"; -- r
						when "1000" => -- Logical Not
							s_dig1 <= "11010101"; -- n
							s_dig2 <= "11000101"; -- o
							s_dig3 <= "11111111"; --
						when "1011" => -- Logical Ex-Or
							s_dig1 <= "01100001"; -- E
							s_dig2 <= "11000101"; -- o
							s_dig3 <= "11110101"; -- r
						when others => 
							s_dig1 <= "11111111"; --
							s_dig2 <= "11111111"; --
							s_dig3 <= "11111111"; --

				end case;
				when calculate => 
					s_led <= (others => '0');
					if (count = '0') then -- s_start should be "1" for a single clk cycle
						s_start <= '1';
						count   <= '1';
					else
						s_start <= '0';
					end if;
				when display_result =>
					s_start <= '0';
					count <= '0';
					if (error_i = '0') then
						s_dig0 <= binary_to_ss(result_i(15 downto 12), overflow_i, sign_i);
						s_dig1 <= binary_to_ss(result_i(11 downto 8), overflow_i, '0');
						s_dig2 <= binary_to_ss(result_i(7 downto 4), overflow_i, '0');
						s_dig3 <= binary_to_ss(result_i(3 downto 0), overflow_i, '0');
						s_led(15) <= '1';
					else
						s_dig0 <= "01100001"; -- E
						s_dig1 <= "11110101"; -- r
						s_dig2 <= "11110101"; -- r
						s_dig3 <= "11111111"; --
					end if;
			end case;
		end if;
	end process;
	op1_o    <= s_op1;
	op2_o    <= s_op2;

	dig0_o   <= s_dig0;
	dig1_o   <= s_dig1;
	dig2_o   <= s_dig2;
	dig3_o   <= s_dig3;

	led_o    <= s_led;
	start_o  <= s_start;
	optype_o <= s_optype;

end rtl;