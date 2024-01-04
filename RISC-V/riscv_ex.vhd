-------------------------------------------------------------------------------
-- Project  ELE8304 : Circuits intégrés à très grande échelle
-------------------------------------------------------------------------------
-- File     riscv_if.vhd
-- Lab      GRM - Polytechnique Montreal
-------------------------------------------------------------------------------
-- Brief    : Appliquer les opérations nécessaires sur les opérandes
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.riscv_pkg.all;

entity riscv_ex is
  port (
    i_clk_ex             : in std_logic;
    i_rstn_ex            : in std_logic;
    
    i_reg_id_ex          : in T_REG_ID_EX;
    --branch             : std_logic;
    --jump               : std_logic;
    --rw                 : std_logic;
    --wb                 : std_logic;
    --alu_arith          : std_logic;
    --alu_sign           : std_logic;
    --imm                : std_logic_vector(XLEN-1 downto 0);
    --src_imm            : std_logic;
    --alu_op             : std_logic_vector(ALUOP_WIDTH-1 downto 0);
    --rd_addr            : std_logic_vector(REG_WIDTH-1 downto 0);
    --shmat              : std_logic_vector(SHAMT_WIDTH-1 downto 0);
    --pc                 : std_logic_vector(XLEN-1 downto 0);

    i_rs_data_ex         : in A_RS_DATA; --std_logic_vector(XLEN-1 downto 0);

    o_pc_ex              : out T_EX;
    --flush              : std_logic;
    --stall              : std_logic;
    --transfert          : std_logic;
    --target             : std_logic_vector(XLEN-1 downto 0);

    o_reg_ex_me          : out T_REG_EX_ME
    --alu_result         : std_logic_vector(XLEN-1 downto 0);
    --store_data         : std_logic_vector(XLEN-1 downto 0);
    --rw                 : std_logic;
    --rd_addr            : std_logic_vector(REG_WIDTH-1 downto 0);
    --wb                 : std_logic;
  );
end entity riscv_ex;

architecture beh of riscv_ex is

signal alu_mux    : std_logic_vector(XLEN-1 downto 0)         := (others => '0');
signal alu_res    : std_logic_vector(XLEN-1 downto 0)         := (others => '0');
signal adder_sum  : std_logic_vector(XLEN downto 0)           := (others => '0');

begin

p_pc_transfert : process(i_reg_id_ex.jump, i_reg_id_ex.branch, alu_res)
begin
  if (i_reg_id_ex.branch&alu_res = "100000000000000000000000000000000") then
    o_pc_ex.transfert <= '1' or i_reg_id_ex.jump;
  else
    o_pc_ex.transfert <= '0' or i_reg_id_ex.jump;
  end if;

end process;

p_alu_mux : process(i_rs_data_ex(1),i_reg_id_ex.imm,i_reg_id_ex.src_imm)
begin
  case i_reg_id_ex.src_imm is
    when '0'    => alu_mux <= i_rs_data_ex(1);
    when '1'    => alu_mux <= i_reg_id_ex.imm;
    when others => alu_mux <= i_rs_data_ex(1);
  end case;
end process;

u_alu : riscv_alu
port map (
  i_arith  => i_reg_id_ex.alu_arith,
  i_sign   => i_reg_id_ex.alu_sign,
  i_opcode => i_reg_id_ex.alu_op,
  i_shamt  => i_reg_id_ex.shamt,
  i_src1   => i_rs_data_ex(0),
  i_src2   => alu_mux,
  o_res    => alu_res
);

u_add : riscv_adder
  generic map ( N => 32 )
  port map (
    i_a    => i_reg_id_ex.imm,
    i_b    => i_reg_id_ex.pc,
    i_sign => '0',
    i_sub  => '0',
    o_sum  => adder_sum
);

p_reg_ex_me : process(i_clk_ex,i_rstn_ex)
begin

  if(rising_edge(i_clk_ex)) then
    
    -- Les signaux sortie EX
    o_reg_ex_me.alu_result <= alu_res;
    o_reg_ex_me.store_data <= i_rs_data_ex(1);
    
    -- Les signaux passants clocked
    o_reg_ex_me.rd_addr    <= i_reg_id_ex.rd_addr;
    o_reg_ex_me.rw         <= i_reg_id_ex.rw;
    o_reg_ex_me.wb         <= i_reg_id_ex.wb;

   --Reset values
  elsif(i_rstn_ex = '0') then

    o_reg_ex_me.alu_result <= (others => '0');
    o_reg_ex_me.store_data <= (others => '0');
    o_reg_ex_me.rd_addr    <= (others => '0');
    o_reg_ex_me.rw         <= (others => '0');
    o_reg_ex_me.wb         <= '0';

  end if; 
end process;

  --Autres outputs
  o_pc_ex.target <= adder_sum(XLEN-1 downto 0);
  o_pc_ex.flush  <= '0';
  o_pc_ex.stall  <= '0';

end architecture beh;