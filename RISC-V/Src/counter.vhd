library ieee; 
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;

entity counter is
  port(
    i_clk  : in  std_logic;
    i_rstn : in  std_logic;
    i_en   : in  std_logic;
    o_cnt  : out std_logic_vector(3 downto 0));
end entity counter;

architecture beh of counter is

  signal cnt       : unsigned(3 downto 0);
  --more constants here--

begin
  -- Output 
  o_cnt <= std_logic_vector(cnt);

  -- Reset synchronizer
  P_rstn: process (i_clk)
  begin    
    --process here--
  end process P_rstn;

  -- Main process with asynchronous reset 
  P_bcd: process (i_clk)
  begin
    --process here--
  end process P_bcd;
    
end architecture beh;
