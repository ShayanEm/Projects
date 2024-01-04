-------------------------------------------------------------------------------
-- Project  ELE8304 : Circuits intégrés à très grande échelle
-------------------------------------------------------------------------------
-- File     riscv_pkg.vhd
-- Author   Mickael Fiorentino  <mickael.fiorentino@polymtl.ca>
-- Lab      GRM - Polytechnique Montreal
-- Date     2019-08-09
-------------------------------------------------------------------------------
-- Brief    Package for constants, components, and procedures
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package riscv_pkg is

  ------------------------------------------------------------------------------
  -- MAIN PARAMETERS
  ------------------------------------------------------------------------------
  constant XLEN      : positive := 32;
  constant BYTE      : positive := 8;
  constant ADDR_INCR : positive := integer(XLEN / BYTE);
  constant LSB       : natural  := integer(ceil(log2(real(XLEN / BYTE))));
  
  constant MEM_ADDR_WIDTH : positive := 9;
  constant RESET_VECTOR   : natural  := 16#00000000#;
  constant RESET : std_logic_vector(XLEN-1 downto 0) := std_logic_vector(to_unsigned(RESET_VECTOR, XLEN));
  
  constant REG_WIDTH : positive := 5;
  constant REG_NB    : positive := 2**REG_WIDTH;
  constant REG_X0    : std_logic_vector(REG_WIDTH-1 downto 0) := "00000";
  constant JUMP_MASK : std_logic_vector(XLEN-1 downto 0)      := X"FFFFFFFE";  

  ------------------------------------------------------------------------------
  --  INSTRUCTION FORMATS
  ------------------------------------------------------------------------------
  constant SHAMT_H     : natural := 24;
  constant SHAMT_L     : natural := 20;
  constant SHAMT_WIDTH : natural := SHAMT_H-SHAMT_L+1;
  
  ------------------------------------------------------------------------------
  -- ALU
  ------------------------------------------------------------------------------
  constant ALUOP_WIDTH : natural := 3;
  constant ALUOP_ADD   : std_logic_vector(ALUOP_WIDTH-1 downto 0) := "000";
  constant ALUOP_SL    : std_logic_vector(ALUOP_WIDTH-1 downto 0) := "001";
  constant ALUOP_SR    : std_logic_vector(ALUOP_WIDTH-1 downto 0) := "010";
  constant ALUOP_SLT   : std_logic_vector(ALUOP_WIDTH-1 downto 0) := "011";
  constant ALUOP_XOR   : std_logic_vector(ALUOP_WIDTH-1 downto 0) := "100";
  constant ALUOP_OR    : std_logic_vector(ALUOP_WIDTH-1 downto 0) := "101";
  constant ALUOP_AND   : std_logic_vector(ALUOP_WIDTH-1 downto 0) := "110";
  constant ALUOP_OTHER : std_logic_vector(ALUOP_WIDTH-1 downto 0) := "111";

  ------------------------------------------------------------------------------
  -- ADDED DEFINITIONS
  ------------------------------------------------------------------------------
  -- Les siguax sortie de Execute
  type T_EX is record
    flush     : std_logic;
    stall     : std_logic;
    transfert : std_logic;
    target    : std_logic_vector(XLEN-1 downto 0);
  end record;
  
  -- Les signaux sortie de FETCH
  type T_REG_IF_ID is record
    instr     : std_logic_vector(XLEN-1 downto 0);
    pc        : std_logic_vector(XLEN-1 downto 0);
  end record;

  -- Les signaux sorties Write-back
  type T_WB is record
    rd_addr   : std_logic_vector(REG_WIDTH-1 downto 0);
    rd_data   : std_logic_vector(XLEN-1 downto 0);
    wb        : std_logic;
  end record;  

  -- Les signaux sortie de registre ID
  type T_REG_ID_EX is record
    branch    : std_logic;                                  --Branch (BEQ)
    jump      : std_logic;                                  --JUMP (JAL, JAR)
    rw        : std_logic_vector(1 downto 0);               --Ecrire/Lire (LW/SW) (dmem-rw)
    wb        : std_logic;                                  --Write-back (Ecrire des registres a la sortie ALU) (wb_wb)
    alu_arith : std_logic;                                  --arith de ALU
    alu_sign  : std_logic;                                  --signe de ALU
    imm       : std_logic_vector(XLEN-1 downto 0);          --La valeur imm dans les instruction
    src_imm   : std_logic;                                  -- Imm ou registre, 1 pour imm
    alu_op    : std_logic_vector(ALUOP_WIDTH-1 downto 0);   -- Opcode alu, funct3 pour operations de base
    --Les signaux passants
    rd_addr   : std_logic_vector(REG_WIDTH-1 downto 0);     --signal (wb_addr)
    shamt     : std_logic_vector(SHAMT_WIDTH-1 downto 0);   --signal alu
    pc        : std_logic_vector(XLEN-1 downto 0);          --signal Fetch
  end record;

  -- Les signaux sortie de Registre-File ID
  type A_RS_DATA is array(0 to 1) of std_logic_vector(XLEN-1 downto 0);
  type A_RS_ADDR is array(0 to 1) of std_logic_vector(REG_WIDTH-1 downto 0); -- utlise pour forwarding ou stallling dans ex

  -- Les signaux sorties registre EX
  type T_REG_EX_ME is record
    alu_result: std_logic_vector(XLEN-1 downto 0);
    store_data: std_logic_vector(XLEN-1 downto 0);          --(dmem_write)
    rw        : std_logic_vector(1 downto 0);               --demem-rw
    rd_addr   : std_logic_vector(REG_WIDTH-1 downto 0);
    wb        : std_logic;
  end record;

  -- Les signaux sortie registre ME
  type T_REG_ME_WB is record
    alu_result: std_logic_vector(XLEN-1 downto 0);
    wb        : std_logic;
    rd_addr   : std_logic_vector(REG_WIDTH-1 downto 0);
    rw        : std_logic_vector(1 downto 0);
  end record;

  ------------------------------------------------------------------------------
  -- COMPONENTS
  ------------------------------------------------------------------------------
  component riscv_adder is
    generic (
      N : positive);
    port (
      i_a    : in  std_logic_vector(N-1 downto 0);
      i_b    : in  std_logic_vector(N-1 downto 0);
      i_sign : in  std_logic;
      i_sub  : in  std_logic;
      o_sum  : out std_logic_vector(N downto 0));
  end component riscv_adder;

  component riscv_alu is
    port (
      i_arith  : in  std_logic;
      i_sign   : in  std_logic;
      i_opcode : in  std_logic_vector(ALUOP_WIDTH-1 downto 0);
      i_shamt  : in  std_logic_vector(SHAMT_WIDTH-1 downto 0);
      i_src1   : in  std_logic_vector(XLEN-1 downto 0);
      i_src2   : in  std_logic_vector(XLEN-1 downto 0);
      o_res    : out std_logic_vector(XLEN-1 downto 0));
  end component riscv_alu;

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
      i_data_w  : in  std_logic_vector(XLEN-1 downto 0));
  end component riscv_rf;

  component riscv_pc is
    generic (
      RESET_VECTOR : natural);
    port (
      i_clk       : in  std_logic;
      i_rstn      : in  std_logic;
      i_stall     : in  std_logic;
      i_transfert : in  std_logic;
      i_target    : in  std_logic_vector(XLEN-1 downto 0);
      o_pc        : out std_logic_vector(XLEN-1 downto 0));
  end component riscv_pc;

  component riscv_perf is
    port (
      i_rstn   : in  std_logic;
      i_clk    : in  std_logic;
      i_en     : in  std_logic;
      o_cycles : out std_logic_vector(XLEN-1 downto 0);
      o_insts  : out std_logic_vector(XLEN-1 downto 0));
  end component riscv_perf;
  ------------------------------------------------------------------------------
  -- ADDED COMPONENTS
  ------------------------------------------------------------------------------
  component dpm
    generic (
      WIDTH : integer := 32;
      DEPTH : integer := 10;
      RESET : integer := 16#00000000#;
      INIT  : string  := "memory.mem"
    );
    port (
    -- Port A
    i_a_clk   : in  std_logic;                               -- Clock
    i_a_rstn  : in  std_logic;                               -- Reset Address
    i_a_en    : in  std_logic;                               -- Port enable
    i_a_we    : in  std_logic;                               -- Write enable
    i_a_addr  : in  std_logic_vector(DEPTH-1 downto 0);      -- Address port
    i_a_write : in  std_logic_vector(WIDTH-1 downto 0);      -- Data write port
    o_a_read  : out std_logic_vector(WIDTH-1 downto 0);      -- Data read port
    -- Port B
    i_b_clk   : in  std_logic;                               -- Clock
    i_b_rstn  : in  std_logic;                               -- Reset Address
    i_b_en    : in  std_logic;                               -- Port enable
    i_b_we    : in  std_logic;                               -- Write enable
    i_b_addr  : in  std_logic_vector(DEPTH-1 downto 0);      -- Address port
    i_b_write : in  std_logic_vector(WIDTH-1 downto 0);      -- Data write port
    o_b_read  : out std_logic_vector(WIDTH-1 downto 0)      -- Data read port
    );
  end component dpm;
  
  component riscv_half_adder is
    port (
      i_a     : in  std_logic;
      i_b     : in  std_logic;
      o_carry : out std_logic;
      o_sum   : out std_logic
    );
  end component riscv_half_adder;

component riscv_if is
  port (
    --basic signals 
    i_clk_if        : in std_logic;
    i_rstn_if       : in std_logic;
    --inputs
    ----Execute_i
    i_ex_if         : in T_EX;
    ----I-meme_i
    i_imem_read_if  : in std_logic_vector(XLEN-1 downto 0);
    --outputs
    ----PC_o
    o_imem_addr_if  : out std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);
    o_imem_en_if    : out std_logic;
    ----Reg_if
    o_reg_if_id      : out T_REG_IF_ID
  );
  end component riscv_if;

  component riscv_id is
    port (
    --basic signals 
    i_clk_id         : in std_logic;
    i_rstn_id        : in std_logic;
    --inputs
    ----Write_back
    i_wb_id          : in T_WB;
    ----Fetch
    i_reg_if_id      : in T_REG_IF_ID;
    ----Execute
    i_flush_id       : in std_logic;
    --outputs
    ----Register_file
    o_rs_data_id     : out A_RS_DATA;
    ----Reg_id_ex
    o_reg_id_ex      : out T_REG_ID_EX
  );
  end component riscv_id;

  component riscv_ex is
    port (
      --basic signals
      i_clk_ex             : in std_logic;
      i_rstn_ex            : in std_logic;
      --inputs
      i_reg_id_ex          : in T_REG_ID_EX;
      i_rs_data_ex         : in A_RS_DATA;
      --outputs
      ----PC_signals and controls
      o_pc_ex              : out T_EX;
      ----Reg-ex_me
      o_reg_ex_me          : out T_REG_EX_ME
  );
  end component riscv_ex;

  component riscv_me is
    port (
      --basic signals
      i_clk_me            : in std_logic;
      i_rstn_me           : in std_logic;
      --inputs
      i_dmem_we           : in std_logic;
      i_reg_ex_me         : in T_REG_EX_ME;
      --outputs
      ----D-meme-o
      o_load_data_me      : out std_logic_vector(XLEN-1 downto 0);
      o_dmem_addr         : out std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);
      o_dmem_en           : out std_logic;
      o_dmem_we           : out std_logic;
      ----Reg-o
      o_reg_me_wb         : out T_REG_ME_WB
    );
  end component riscv_me;

  component riscv_wb is
    port (
    --inputs
    i_load_data_wb      : in std_logic_vector(XLEN-1 downto 0);
    i_reg_me_wb         : in T_REG_ME_WB;
    --outputs
    o_wb                : out T_WB
  );
  end component riscv_wb;

  component riscv_core
    port (
    i_rstn        : in std_logic;
    i_clk         : in std_logic;
    o_imem_en     : out std_logic;
    o_imem_addr   : out std_logic_vector(8 downto 0);
    i_imem_read   : in std_logic_vector(31 downto 0);
    o_dmem_en     : out std_logic;
    o_dmem_we     : out std_logic;
    o_dmem_addr   : out std_logic_vector(8 downto 0);
    i_dmem_read   : in std_logic_vector(31 downto 0);
    o_dmem_write  : out std_logic_vector(31 downto 0);
    --DFT
    i_scan_en     : in std_logic;
    i_test_mode   : in std_logic;
    i_tdi       	: in std_logic;
    o_tdo       	: out std_logic);
  end component riscv_core;

end package riscv_pkg;
