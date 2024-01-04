-------------------------------------------------------------------------------
-- Project  ELE8304 : Circuits intégrés à très grande échelle
-------------------------------------------------------------------------------
-- File     riscv_core.vhd
-- Lab      GRM - Polytechnique Montreal
-------------------------------------------------------------------------------
-- Brief    Le cas échéant, accéder à la mémoire de donnée pour lire ou écrire une valeur
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.riscv_pkg.all;

entity riscv_me is
  port (
    i_clk_me            : in std_logic;
    i_rstn_me           : in std_logic;

    i_dmem_we           : in std_logic;
    i_reg_ex_me         : in T_REG_EX_ME;
    --alu_result         : std_logic_vector(XLEN-1 downto 0);
    --store_data         : std_logic_vector(XLEN-1 downto 0);
    --rw                 : std_logic;
    --rd_addr            : std_logic_vector(REG_WIDTH-1 downto 0);
    --wb                 : std_logic;
 
    o_load_data_me      : out std_logic_vector(XLEN-1 downto 0);
    o_dmem_addr         : out std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);
    o_dmem_en           : out std_logic;
    o_dmem_we           : out std_logic;

    o_reg_me_wb         : out T_REG_ME_WB
    --alu_result        : std_logic_vector(XLEN-1 downto 0);
    --wb                : std_logic;
    --rd_addr           : std_logic_vector(REG_WIDTH-1 downto 0);
    --rw                : std_logic;
  );
end entity riscv_me;

architecture beh of riscv_me is

begin

p_reg_me_wb : process (i_clk_me,i_rstn_me)
begin
  if(rising_edge(i_clk_me)) then
    
    o_reg_me_wb.alu_result  <= i_reg_ex_me.alu_result;
    o_reg_me_wb.rd_addr     <= i_reg_ex_me.rd_addr;
    o_reg_me_wb.wb          <= i_reg_ex_me.wb;
    o_reg_me_wb.rw          <= i_reg_ex_me.rw;
    o_dmem_we               <= i_dmem_we;
  
  elsif(i_rstn_me = '0') then
    
    o_reg_me_wb.alu_result  <= (others => '0');
    o_reg_me_wb.rd_addr     <= (others => '0');
    o_reg_me_wb.wb          <= '0';
    o_reg_me_wb.rw          <= (others => '0');
    o_dmem_we               <= '0';

  end if;
end process;

  -- D_mem outputs
  o_load_data_me<= i_reg_ex_me.store_data;
  o_dmem_addr   <= i_reg_ex_me.alu_result(MEM_ADDR_WIDTH-1 downto 0);
  o_dmem_en     <= '1';

end architecture beh;