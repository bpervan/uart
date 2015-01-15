----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:27:32 03/11/2014 
-- Design Name: 
-- Module Name:    UARTTransmitter - Behavioral 
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

entity UARTTransmitter is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           tick : in  STD_LOGIC;
           d_in : in  STD_LOGIC_VECTOR (7 downto 0);
           tx_start : in  STD_LOGIC;
           tx_done : out  STD_LOGIC;
           tx : out  STD_LOGIC);
end UARTTransmitter;

architecture Behavioral of UARTTransmitter is
type state_type is (idle, start, data, stop);
signal next_state, current_state : state_type;
signal tick_counter, tick_counter_next : unsigned (3 downto 0);
signal bit_counter, bit_counter_next : unsigned (2 downto 0);
signal reg, reg_next : std_logic_vector (7 downto 0);
signal tx_reg, tx_reg_next : std_logic;

begin
	
	process (clk, rst)
	begin
		if (rst = '1') then
			current_state <= idle;
			tick_counter <= (others => '0');
			bit_counter <= (others => '0');
			reg <= (others => '0');
			tx_reg <= '1';
		else
			if (rising_edge(clk)) then
				current_state <= next_state;
				tick_counter <= tick_counter_next;
				bit_counter <= bit_counter_next;
				reg <= reg_next;
				tx_reg <= tx_reg_next;
			end if;
		end if;
	end process;
	
	process(current_state, tick_counter, bit_counter, reg, tick, tx_reg, tx_start, d_in)
	begin
		next_state <= current_state;
		tick_counter_next <= tick_counter;
		bit_counter_next <= bit_counter;
		reg_next <= reg;
		tx_reg_next <= tx_reg;
		tx_done <= '0';
		
		case current_state is
			when idle =>
				tx_reg_next <= '1';
				if(tx_start = '1') then
					next_state <= start;
					tick_counter_next <= "0000";
					reg_next <= d_in;
				end if;
			when start =>
				tx_reg_next <= '0';
				if(tick = '1') then
					if(tick_counter < 15) then
						tick_counter_next <= tick_counter + 1;
					else
						tick_counter_next <= "0000";
						bit_counter_next <= "000";
						next_state <= data;
					end if;
				end if;
			when data =>
				tx_reg_next <= reg(0);
				if(tick = '1') then
					if(tick_counter < 15) then
						tick_counter_next <= tick_counter + 1;
					else
						tick_counter_next <= "0000";
						reg_next <= '0' & reg(7 downto 1);
						if (bit_counter = 7) then
							next_state <= stop;
						else
							bit_counter_next <= bit_counter + 1;
						end if;
					end if;
				end if;
			when stop =>
				tx_reg_next <= '1';
				if(tick = '1') then
					if(tick_counter < 15) then
						tick_counter_next <= tick_counter + 1;
					else
						next_state <= idle;
						tx_done <= '1';
					end if;
				end if;
		end case;
	end process;
	
	tx <= tx_reg;

end Behavioral;

