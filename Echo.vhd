----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:36:02 03/13/2014 
-- Design Name: 
-- Module Name:    Echo - Behavioral 
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

entity Echo is
    Port ( d_in : in  STD_LOGIC_VECTOR (7 downto 0);
           r_done : in  STD_LOGIC;
           w_done : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           w_start : out  STD_LOGIC;
           d_out : out  STD_LOGIC_VECTOR (7 downto 0));
end Echo;

architecture Behavioral of Echo is
type state_type is (idle, send);
signal current_state, next_state : state_type;
signal w_start_reg, w_start_reg_next : std_logic;
signal d_out_reg, d_out_reg_next : std_logic_vector (7 downto 0);

begin

	process(clk, rst)
	begin
		if(rst = '1') then
			w_start_reg <= '0';
			d_out_reg <= "00000000";
			current_state <= idle;
		else
			if(rising_edge(clk)) then
				w_start_reg <= w_start_reg_next;
				d_out_reg <= d_out_reg_next;
				current_state <= next_state;
			end if;
		end if;
	end process;

	process (r_done, d_in, w_start_reg, d_out_reg)
	begin
		w_start_reg_next <= w_start_reg;
		d_out_reg_next <= d_out_reg;
		next_state <= current_state;
		
		case current_state is
			when idle =>
				if(r_done = '1')  then
					w_start_reg_next <= '1';
					d_out_reg_next <= d_in;
					next_state <= send;
				end if;
			when send =>
				if (w_done = '1') then
					next_state <= idle;
					w_start_reg_next <= '0';
				end if;
		end case;
	end process;
	
	d_out <= d_out_reg;
	w_start <= w_start_reg;
end Behavioral;

