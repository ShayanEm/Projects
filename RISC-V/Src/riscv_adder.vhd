library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
library work;

entity  riscv_adder is
  generic (
    N : positive := 32
  );
  port (			 
    i_a    : in  std_logic_vector(N-1 downto 0);
    i_b    : in  std_logic_vector(N-1 downto 0);
    i_sign : in  std_logic;
    i_sub  : in  std_logic;
    o_sum  : out std_logic_vector(N downto 0)
  );
end entity riscv_adder;

architecture beh of riscv_adder is
  component riscv_half_adder is
    port (
    i_a     : in  std_logic;
    i_b     : in  std_logic;
    o_carry : out std_logic;
    o_sum   : out std_logic);
  end component riscv_half_adder;
  --signal declared here--

begin

  --signals used here--
  gen_add: for i in 0  to N generate 
  --logic in here
	end generate gen_add;

end architecture beh;	