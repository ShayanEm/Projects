library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;

library work;
use     work.riscv_pkg.all;
use     work.all;

entity riscv_rf_tb is
end entity riscv_rf_tb;

architecture tb of riscv_rf_tb is
  
  component riscv_rf is
    port (
      i_clk     : in  std_logic;
      i_rstn    : in  std_logic;
      i_we      : in  std_logic;
      i_addr_ra : in  std_logic_vector(REG_WIDTH-1 downto 0);
      o_data_ra : out std_logic_vector(XLEN-1 downto 0);
      i_addr_rb : in  std_logic_vector(REG_WIDTH-1 downto 0);
      o_data_rb : out std_logic_vector(XLEN-1 downto 0);
      i_addr_w  : in  std_logic_vector(REG_WIDTH-1 downto 0);
      i_data_w  : in  std_logic_vector(XLEN-1 downto 0)
    );
  end component riscv_rf;

  signal clk       : std_logic := '0';
  signal rstn      : std_logic := '1';
  signal we        : std_logic := '0';
  signal addr_ra   : std_logic_vector(REG_WIDTH-1 downto 0) := (others => '0');
  signal data_ra   : std_logic_vector(XLEN-1 downto 0);
  signal addr_rb   : std_logic_vector(REG_WIDTH-1 downto 0) := (others => '0');
  signal data_rb   : std_logic_vector(XLEN-1 downto 0);
  signal addr_w    : std_logic_vector(REG_WIDTH-1 downto 0) := (others => '0');
  signal data_w    : std_logic_vector(XLEN-1 downto 0);

  signal all_zeros : std_logic_vector(XLEN-1 downto 0) := (others => '0');

begin
  DUT: riscv_rf
    port map (
      i_clk     => clk,
      i_rstn    => rstn,
      i_we      => we,
      i_addr_ra => addr_ra,
      o_data_ra => data_ra,
      i_addr_rb => addr_rb,
      o_data_rb => data_rb,
      i_addr_w  => addr_w,
      i_data_w  => data_w
    );

  -- Clock process
  process
  begin
    while now < 100 ns loop
      clk <= not clk;
      wait for 5 ns;
    end loop;
    wait;
  end process;

  -- Test process
  process
  begin
    -- Reset the design
    rstn <= '0';
    wait for 10 ns;
    rstn <= '1';

    -- Perform read and write operations
    we <= '1';
    --and more--
    wait for 10 ns;

    -- Perform read operations
    addr_ra <= "00000";
    --and more--
    wait for 10 ns;

    -- Verify the results
    assert data_ra = data_w
      report "A fail"
      severity failure;

    assert data_rb = all_zeros
      report "B fail"
      severity failure;

    wait;
  end process;

end architecture tb;

