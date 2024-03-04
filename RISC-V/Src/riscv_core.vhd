-------------------------------------------------------------------------------
-- Project  CPU Risc-V
-------------------------------------------------------------------------------
-- Autor Shayan Eram
-------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;

library work;
use work.riscv_pkg.all;

entity riscv_core is
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
      o_dmem_write  : out std_logic_vector(31 downto 0)
      --DFT
    );
end entity riscv_core;

architecture beh of riscv_core is

  signal s_reg_if_id  : T_REG_IF_ID;
  signal s_reg_id_ex  : T_REG_ID_EX;
  signal s_reg_ex_me  : T_REG_EX_ME;
  signal s_reg_me_wb  : T_REG_ME_WB;

  signal s_ex         : T_EX;
  signal s_wb         : T_WB;

  --signal s_rs_addr    : A_RS_ADDR;  
  signal s_rs_data    : A_RS_DATA;

begin

  u_if : riscv_if
  port map(
    i_clk_if        => i_clk,
    i_rstn_if       => i_rstn,
    i_ex_if         => s_ex,
    i_imem_read_if  => i_imem_read,
    o_imem_addr_if  => o_imem_addr,
    o_imem_en_if    => o_imem_en,
    o_reg_if_id      => s_reg_if_id
  );

  u_id : riscv_id
  port map (
    i_clk_id             => i_clk,
    i_rstn_id            => i_rstn,
    i_wb_id              => s_wb,
    i_reg_if_id          => s_reg_if_id,
    i_flush_id           => s_ex.flush,
    o_rs_data_id         => s_rs_data,
    o_reg_id_ex          => s_reg_id_ex
  );

  u_ex : riscv_ex
  port map (
    i_clk_ex             => i_clk,
    i_rstn_ex            => i_rstn,
    i_reg_id_ex          => s_reg_id_ex,
    i_rs_data_ex         => s_rs_data,
    o_pc_ex              => s_ex,
    o_reg_ex_me          => s_reg_ex_me
  );

  u_me : riscv_me
  port map (
    i_clk_me            => i_clk,
    i_rstn_me           => i_rstn,
    i_dmem_we           => s_reg_id_ex.rw(0),
    i_reg_ex_me         => s_reg_ex_me,
    o_load_data_me      => o_dmem_write,
    o_dmem_addr         => o_dmem_addr,
    o_dmem_en           => o_dmem_en,
    o_dmem_we           => o_dmem_we,
    o_reg_me_wb         => s_reg_me_wb
  );

  u_wb : riscv_wb
  port map (
    i_load_data_wb      => i_dmem_read,
    i_reg_me_wb         => s_reg_me_wb,
    o_wb                => s_wb
  );

end architecture beh;