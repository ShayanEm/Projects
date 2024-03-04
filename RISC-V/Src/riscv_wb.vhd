-------------------------------------------------------------------------------
-- Project  CPU Risc-V
-------------------------------------------------------------------------------
-- Autor Shayan Eram
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.riscv_pkg.all;

entity riscv_wb is
  port (
    i_load_data_wb      : in std_logic_vector(XLEN-1 downto 0);
    i_reg_me_wb         : in T_REG_ME_WB;
    --alu_result        : std_logic_vector(XLEN-1 downto 0);
    --wb                : std_logic;
    --rd_addr           : std_logic_vector(REG_WIDTH-1 downto 0);
    --rw                : std_logic;
  
    o_wb                : out T_WB
    --rd_addr           : std_logic_vector(REG_WIDTH-1 downto 0);
    --rd_data           : std_logic_vector(XLEN-1 downto 0);
    --wb                : std_logic;
  );
end entity riscv_wb;

architecture beh of riscv_wb is

signal rd_data : std_logic_vector(XLEN-1 downto 0);

begin

p_mux : process(i_reg_me_wb.rw,i_reg_me_wb.alu_result,i_load_data_wb)
begin
  case (i_reg_me_wb.rw) is
    when "10" => rd_data <= i_load_data_wb;             --write operation
    when "01" => rd_data <= i_reg_me_wb.alu_result;     --read operation
    when others => rd_data <= i_reg_me_wb.alu_result;
  end case;
end process;
  
  -- Output without clk
  o_wb.rd_data <= rd_data;
  o_wb.rd_addr <= i_reg_me_wb.rd_addr;
  o_wb.wb <= i_reg_me_wb.wb;

end architecture beh;