library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;

library work;
use work.riscv_pkg.all;

entity riscv_pc is
  generic (RESET_VECTOR : natural := 16#00000000#);
  port (
    i_clk       : in  std_logic;
    i_rstn      : in  std_logic;
    i_stall     : in  std_logic;
    i_transfert : in  std_logic;
    i_target    : in  std_logic_vector(XLEN-1 downto 0);
    o_pc        : out std_logic_vector(XLEN-1 downto 0));
end entity riscv_pc;

architecture beh of riscv_pc is

  signal pc : unsigned(XLEN-1 downto 0);

begin
  -- Output
  o_pc <= std_logic_vector(pc);
  -- Flop
  p_pc : process(i_clk, i_rstn)
  begin
    if i_rstn = '0' then
    --more here-
    end if;
  end process p_pc;

end architecture beh;
