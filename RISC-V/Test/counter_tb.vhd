library ieee; 
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;

library std;
use     std.textio.all;                                                      
use     std.env.all;

library work;
use     work.all;

entity compteur_tb is 
end compteur_tb;

architecture tb of compteur_tb is

  component counter is
    port (
      i_clk  : in  std_logic;
      i_rstn : in  std_logic;
      i_en   : in  std_logic;
      o_cnt  : out std_logic_vector(3 downto 0));
  end component counter;
  
  signal clk   : std_logic := '1';
  signal rst_n : std_logic := '0';
  signal en    : std_logic := '0';
  signal cnt   : std_logic_vector(3 downto 0);

  constant PERIOD   : time := 10 ns; 
  constant TB_LOOP  : positive := 2;
  --and few more constanst--

begin
  
  -- Clock
  clk <= not clk after PERIOD / 2;

  -- DUT
  dut: counter
    port map (
      i_clk  => clk,
      i_rstn => rst_n,
      i_en   => en,
      o_cnt  => cnt);

  -- Main TB process
  P_tb : process
  
  variable EXPECTED : unsigned(3 downto 0) := (others => '0');
  
  begin
    report "*** Simulation Starts ***";
    for i in 0 to TB_LOOP-1 loop
      en    <= '0';
      rst_n <= '0';
      wait for 2.3 * PERIOD;
      --more tests here--
    end loop;
    report "*** Simulation Ends ***";
    stop;      
  end process P_tb;
  
end architecture tb;
