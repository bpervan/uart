----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:52:25 03/11/2014 
-- Design Name: 
-- Module Name:    BaudRateGenerator - Behavioral 
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

entity BaudRateGenerator is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           tick : out  STD_LOGIC);
end BaudRateGenerator;

architecture Behavioral of BaudRateGenerator is
signal brojac, brojacNext : unsigned (7 downto 0);

begin
	
	process (clk, rst)
	begin
		if(rst = '1') then
			brojac <= "00000000";
		else
			if (clk'event and clk = '1') then
				brojac <= brojacNext;
			end if;
		end if;
	end process;
	
	brojacNext <= "00000000" when brojac = 176 else
						brojac + 1;
	tick <= '1' when brojac = 176 else '0';
	
end Behavioral;

