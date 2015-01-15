----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:39:42 03/11/2014 
-- Design Name: 
-- Module Name:    UARTController - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UARTController is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           rx : in  STD_LOGIC;
           w_data : in  STD_LOGIC_VECTOR (7 downto 0);
           w_start : in  STD_LOGIC;
           tx : out  STD_LOGIC;
           w_done : out  STD_LOGIC;
           r_data : out  STD_LOGIC_VECTOR (7 downto 0);
           r_done : out  STD_LOGIC;
			  led_out : out std_logic_vector (6 downto 0));
end UARTController;

architecture Behavioral of UARTController is

	component BaudRateGenerator port (
			clk : in  STD_LOGIC;
         rst : in  STD_LOGIC;
         tick : out  STD_LOGIC
	);
	end component;
	
	component UARTReciever port (
		  clk : in  STD_LOGIC;
		  rst : in  STD_LOGIC;
		  tick : in  STD_LOGIC;
		  rx : in  STD_LOGIC;
		  d_out : out  STD_LOGIC_VECTOR (7 downto 0);
		  rx_done : out  STD_LOGIC;
		  led : out std_logic_vector (6 downto 0));
	end component;
	
	component UARTTransmitter port (
		  clk : in  STD_LOGIC;
		  rst : in  STD_LOGIC;
		  tick : in  STD_LOGIC;
		  d_in : in  STD_LOGIC_VECTOR (7 downto 0);
		  tx_start : in  STD_LOGIC;
		  tx_done : out  STD_LOGIC;
		  tx : out  STD_LOGIC);
	end component;	

signal tick : std_logic;	
begin
	BRG: entity work.BaudRateGenerator port map (clk => clk,rst => rst,tick => tick);
	URx: entity work.UARTReciever port map (clk => clk, rst => rst, tick => tick, rx => rx, d_out => r_data, rx_done => r_done, led => led_out);
	UTx: entity work.UARTTransmitter port map (clk => clk, rst => rst, tick => tick, d_in => w_data, tx_start => w_start, tx_done => w_done, tx => tx);


end Behavioral;

