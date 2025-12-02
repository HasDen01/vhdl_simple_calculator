-----------------------------------------------------------
--               FHTW CHIP DESIGN PROJECT                --
-----------------------------------------------------------
--  Author   : Hasan Denisultanov                        --
--  Date     : 30.05.2022                                --
--  Class    : BEL4                                      --
--  Filename : io_ctrl_rtl.vhd                           --
--  Variant  : B                                         --
--  Optypes  : Add, Square, logical not, logical xor     --
-----------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture rtl of io_ctrl is
	constant C_ENCOUNTVAL : unsigned(16 downto 0) := "11000011010100000"; -- 100k (100MHz / 1kHz)
	signal s_enctr        : unsigned(16 downto 0); --counter
	signal s_1khzen       : std_logic; -- 1kHz enable / prescaler
	signal swsync         : std_logic_vector(15 downto 0); -- debounced switches
	signal pbsync         : std_logic_vector(3 downto 0); -- debounced buttons
	signal s_ss_sel       : std_logic_vector(3 downto 0); -- seven segment select signal
	signal s_ss           : std_logic_vector(7 downto 0); -- seven segment leds binary signal
	-------------------------------------------------------------
	signal count : integer;
	type state_type_debounce is (idle, wait_time_pb, wait_time_sw);
	signal state_db : state_type_debounce := idle;
	type state_type_ss is (first_dig, second_dig, third_dig, fourth_dig);
	signal state_ss : state_type_ss;
	signal pb_val   : std_logic_vector(3 downto 0); 
	signal sw_val   : std_logic_vector(15 downto 0);
begin
	-- rtl
	-----------------------------------
	-- Generate 1 kHz enable signal. --
	-----------------------------------
	p_slowen : process (clk_i, reset_i)
	begin
		if reset_i = '1' then -- asynchronous reset (active high)
			s_1khzen <= '0';
			s_enctr  <= "0" & x"0000";
		elsif clk_i'EVENT and clk_i = '1' then -- rising clock edge
			-- Enable signal is inactive per default.
			if (s_enctr = C_ENCOUNTVAL) then -- When the terminal count is reached, set enable signal and reset the counter.
				s_enctr  <= "0" & x"0000";
				s_1khzen <= '1';
			else
				s_1khzen <= '0';
				s_enctr  <= unsigned (s_enctr) + unsigned'(x"0001");
				-- As long as the terminal count is not reached: increment the counter.
			end if;
		end if;
	end process p_slowen;
	-----------------------------------
	-- Debounce buttons and switches --
	-----------------------------------
	p_debounce : process (clk_i, reset_i)
	begin
		if reset_i = '1' then -- asynchronous reset (active high)
			state_db <= idle;
			pbsync   <= (others => '0');
			swsync   <= (others => '0');
			sw_val   <= (others => '0');
			pb_val   <= (others => '0');
			count    <= 0;
			-- set every sginal after reset
		elsif clk_i'EVENT and clk_i = '1' then -- rising clock edge
			if s_1khzen = '1' then
				case (state_db) is
					when idle => 
						if (pb_i /= pb_val) then
							pb_val   <= pb_i;
							state_db <= wait_time_pb;
						elsif (sw_i /= sw_val) then
							sw_val   <= sw_i;
							state_db <= wait_time_sw;
						else
							state_db <= idle; --wait until button is pressed.
							count    <= 0;
						end if;
					when wait_time_pb => --debouncing push buttons
						if (count = 20) then
							count <= 0;
							if (pb_i = pb_val) then -- after 20ms check if the value is the same
								pbsync <= pb_val;
							end if;
							state_db <= idle;
						else
							count <= count + 1;
						end if;
					when wait_time_sw => --debouncing switches
						if (count = 20) then
							count <= 0;
							if (sw_i = sw_val) then -- after 20ms check if the value is the same
								swsync <= sw_val;
							end if;
							state_db <= idle;
						else
							count <= count + 1;
						end if;
				end case;
			end if;
		end if;
	end process p_debounce;
	swsync_o <= swsync;
	pbsync_o <= pbsync;
	--------------------------------------------------
	-- Display controller for the 7-segment display --
	--------------------------------------------------
	p_display_ctrl : process (clk_i, reset_i)
	begin
		if reset_i = '1' then -- asynchronous reset (active high)
			s_ss     <= "11111111";
			s_ss_sel <= "1111";
			state_ss <= first_dig;
		elsif clk_i'EVENT and clk_i = '1' then -- rising clock edge
			if (s_1khzen = '1') then
				case(state_ss) is  -- display the four digits one after another every ms
					when(first_dig) => 
						s_ss     <= dig0_i;
						s_ss_sel <= "1110";
						state_ss <= second_dig;
					when(second_dig) => 
						s_ss     <= dig1_i;
						s_ss_sel <= "1101";
						state_ss <= third_dig;
					when(third_dig) => 
						s_ss     <= dig2_i;
						s_ss_sel <= "1011";
						state_ss <= fourth_dig;
					when(fourth_dig) => 
						s_ss     <= dig3_i;
						s_ss_sel <= "0111";
						state_ss <= first_dig;
				end case;
			end if;
		end if;
	end process p_display_ctrl;
	ss_o     <= s_ss;
	ss_sel_o <= s_ss_sel;
	------------------------
	-- Handle the 16 LEDs --
	------------------------
	led_o <= led_i; -- simply connect the internal to the external signals
end rtl;