----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:44:11 03/13/2014 
-- Design Name: 
-- Module Name:    UARTEcho - Behavioral 
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

entity UARTEcho is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           rx : in  STD_LOGIC;
           tx : out  STD_LOGIC;
			  led : out std_logic_vector (6 downto 0));
end UARTEcho;

architecture Behavioral of UARTEcho is

component UARTController port 
	( clk : in  STD_LOGIC;
	  rst : in  STD_LOGIC;
	  rx : in  STD_LOGIC;
	  w_data : in  STD_LOGIC_VECTOR (7 downto 0);
	  w_start : in  STD_LOGIC;
	  tx : out  STD_LOGIC;
	  w_done : out  STD_LOGIC;
	  r_data : out  STD_LOGIC_VECTOR (7 downto 0);
	  r_done : out  STD_LOGIC;
	  led_out : out std_logic_vector (6 downto 0));
end component;

component Echo port 
	( d_in : in  STD_LOGIC_VECTOR (7 downto 0);
	  r_done : in  STD_LOGIC;
	  w_done : in  STD_LOGIC;
	  clk : in  STD_LOGIC;
	  rst : in  STD_LOGIC;
	  w_start : out  STD_LOGIC;
	  d_out : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

signal w_data: std_logic_vector (7 downto 0);
signal w_start: std_logic;
signal w_done: std_logic;
signal r_done_sig: std_logic;
signal r_data: std_logic_vector (7 downto 0);

begin
	UARTCon: entity work.UARTController port map (clk => clk, rst => rst, rx => rx, w_data => w_data, w_start => w_start,
																	tx => tx, w_done => w_done, r_data => r_data, r_done => r_done_sig, led_out => led);
	EchoModul: entity work.Echo port map (d_in => r_data, r_done => r_done_sig, w_done => w_done, clk => clk, rst => rst, w_start => w_start, d_out => w_data);


end Behavioral;

