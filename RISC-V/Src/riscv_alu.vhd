library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;

library work;
use     work.riscv_pkg.all;

entity riscv_alu is
  port (
    i_arith  : in  std_logic;
    i_sign   : in  std_logic;
    i_opcode : in  std_logic_vector(ALUOP_WIDTH-1 downto 0);
    i_shamt  : in  std_logic_vector(SHAMT_WIDTH-1 downto 0);
    i_src1   : in  std_logic_vector(XLEN-1 downto 0);
    i_src2   : in  std_logic_vector(XLEN-1 downto 0);
    o_res    : out std_logic_vector(XLEN-1 downto 0));
end entity riscv_alu;

architecture beh of riscv_alu is

  signal adder_res   : std_logic_vector(XLEN downto 0);
  --and more--

begin
  ------------------------------------------------------------------------------
  --  SHIFTER
  ------------------------------------------------------------------------------
  p_shift : process (ALL)
  begin
    --shifting logic here--
  end process p_shift;

  ------------------------------------------------------------------------------
  -- ADDER
  ------------------------------------------------------------------------------
  u_adder : riscv_adder
    generic map (
      N => XLEN)
    port map (
      i_a    => i_src1,
      i_b    => i_src2,
      i_sign => i_sign,
      i_sub  => i_arith,
      o_sum  => adder_res);

    --signal assigned here--

  ------------------------------------------------------------------------------
  --  RESULT SELECTION
  ------------------------------------------------------------------------------
  p_res : process (ALL)
  begin
    case i_opcode is
      when ALUOP_ADD  => o_res <= adder_res(XLEN-1 downto 0);
      --and more--
    end case;
  end process p_res;

end architecture beh;