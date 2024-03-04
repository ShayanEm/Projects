library ieee; 
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;

library std;
use     std.textio.all;                                                      
use     std.env.all;

library work;
use work.riscv_pkg.all;
use work.all;

entity riscv_alu_tb is
end riscv_alu_tb;

architecture tb of riscv_alu_tb is

  constant XLEN : integer := 32;
  constant SHAMT_WIDTH : integer := 5;
  constant ALUOP_WIDTH: integer := 4;
  
  -- Signals for the test bench
  component riscv_alu is
    port (
      i_arith  : in  std_logic;                                -- Arith/Logic
      i_sign   : in  std_logic;                                -- Signed/Unsigned
      i_opcode : in  std_logic_vector(ALUOP_WIDTH-1 downto 0); -- ALU opcodes
      i_shamt  : in  std_logic_vector(SHAMT_WIDTH-1 downto 0); -- Shift Amount
      i_src1   : in  std_logic_vector(XLEN-1 downto 0);        -- Operand A
      i_src2   : in  std_logic_vector(XLEN-1 downto 0);        -- Operand B
      o_res    : out std_logic_vector(XLEN-1 downto 0));       -- Result
  end component riscv_alu;
  
  signal arith  : std_logic := '0';
  signal signn  : std_logic := '0';
  signal opcode : std_logic_vector(ALUOP_WIDTH-1 downto 0);
  signal shamt  : std_logic_vector(SHAMT_WIDTH-1 downto 0);
  signal src1   : std_logic_vector(XLEN-1 downto 0);
  signal src2   : std_logic_vector(XLEN-1 downto 0);
  signal res    : std_logic_vector(XLEN-1 downto 0);

  -- Constants
  constant ALUOP_SR_TEST : std_logic_vector(ALUOP_WIDTH-1 downto 0) := "0000";

begin  
  -- Connect the DUT
  dut: riscv_alu
    port map (
      i_arith  => arith,
      i_sign   => signn,
      i_opcode => opcode,
      i_shamt  => shamt,
      i_src1   => src1,
      i_src2   => src2,
      o_res    => res
    );

  -- Stimulus process
  process
  begin
    report "*** Simulation Starts ***";

    arith  <= '0';
    signn   <= '0';
    opcode <= ALUOP_SR_TEST;
    shamt  <= "00000"; 
    src1   <= (others => '0');
    src2   <= (others => '0');

    wait for 10 ns;

    --more tests here--

    wait;
  end process;

end architecture tb;
