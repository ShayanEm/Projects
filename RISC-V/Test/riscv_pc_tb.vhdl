library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;	  

library std;
use     std.textio.all;                                                      
use     std.env.all;

library work;
use     work.all;
use     work.riscv_pkg.all;
	  
entity riscv_pc_tb is
end entity riscv_pc_tb;

architecture tb of riscv_pc_tb is

  component riscv_pc is
    generic (RESET_VECTOR : natural := 16#00000000#);
    port (
      i_clk       : in  std_logic;
      i_rstn      : in  std_logic;
      i_stall     : in  std_logic;
      i_transfert : in  std_logic;
      i_target    : in  std_logic_vector(XLEN-1 downto 0);
      o_pc        : out std_logic_vector(XLEN-1 downto 0));
  end component riscv_pc;
  
  signal clk        : std_logic := '1';
  signal rstn       : std_logic := '0';
  signal stall      : std_logic := '0';
  signal transfert  : std_logic := '0';
  signal target     : std_logic_vector(XLEN-1 downto 0);
  signal pc_expected: std_logic_vector(XLEN-1 downto 0);
  signal pc_actual  : std_logic_vector(XLEN-1 downto 0);

  constant RST_VECTOR: natural := 16#00000000#;

  begin
    DUT: riscv_pc
      generic map (
        RESET_VECTOR => RST_VECTOR
      )
      port map (
        i_clk       => clk,
        i_rstn      => rstn,
        i_stall     => stall,
        i_transfert => transfert,
        i_target    => target,
        o_pc        => pc_actual
      );

    process
    begin
      while now < 100 ns loop 
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
      end loop;
      wait;
    end process;

    process
    begin

      rstn <= '1';
      stall <= '0';
      --and more--

      wait for 10 ns;
    
      --more tests here--
      assert pc_actual = pc_expected
        report "Test Case failed for o_pc"
        severity failure;

      wait;
    end process;

end architecture tb;
