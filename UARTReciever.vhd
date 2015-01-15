----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:05:12 03/11/2014 
-- Design Name: 
-- Module Name:    UARTReciever - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UARTReciever is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           tick : in  STD_LOGIC;
           rx : in  STD_LOGIC;
           d_out : out  STD_LOGIC_VECTOR (7 downto 0);
           rx_done : out  STD_LOGIC;
			  led : out std_logic_vector (6 downto 0));
end UARTReciever;

architecture Behavioral of UARTReciever is

type state_type is (idle, start, data, stop);
signal next_state, current_state : state_type;
signal tick_counter, tick_counter_next : unsigned (3 downto 0);
signal bit_counter, bit_counter_next : unsigned (2 downto 0);
signal reg, reg_next : std_logic_vector (7 downto 0);
signal ledReg, ledRegNext : std_logic_vector (6 downto 0);

begin
	
	process (clk, rst)
	begin
		if (rst = '1') then
			current_state <= idle;
			tick_counter <= "0000";
			bit_counter <= "000";
			ledReg <= "0000000";
			reg <= (others => '0');

		else
			if (clk'event and clk = '1') then
				current_state <= next_state;
				tick_counter <= tick_counter_next;
				bit_counter <= bit_counter_next;
				ledReg <= ledRegNext;
				reg <= reg_next;
			end if;
		end if;
	end process;
	
	process(current_state, tick_counter, bit_counter, reg, tick, rx)
	begin
		next_state <= current_state;
		tick_counter_next <= tick_counter;
		bit_counter_next <= bit_counter;
		reg_next <= reg;
		rx_done <= '0';
		ledRegNext <= ledReg;
		
		case current_state is
			when idle =>
				if(rx = '0') then
					next_state <= start;
					ledRegNext <= "0000001";
					tick_counter_next <= "0000";
				end if;
			when start =>
				if(tick = '1') then
					if(tick_counter < 7) then
						tick_counter_next <= tick_counter + 1;
					else
						tick_counter_next <= "0000";
						bit_counter_next <= "000";
						ledRegNext <= "0000010";
						next_state <= data;
					end if;
					
				end if;
			when data =>
				if(tick = '1') then
					if(tick_counter < 15) then
						tick_counter_next <= tick_counter + 1;
					else
						tick_counter_next <= "0000";
						reg_next <= rx & reg (7 downto 1);
						if (bit_counter = 7) then
							ledRegNext <= "0000011";
							next_state <= stop;
						else
							bit_counter_next <= bit_counter + 1;
						end if;
					end if;
				end if;
			when stop =>
				if(tick = '1') then
					if(tick_counter < 15) then
						tick_counter_next <= tick_counter + 1;
					else
						next_state <= idle;
						ledRegNext <= "0000100";
						rx_done <= '1';
					end if;
				end if;
		end case;
	end process;
	led <= ledReg;
	d_out <= reg;
end Behavioral;

