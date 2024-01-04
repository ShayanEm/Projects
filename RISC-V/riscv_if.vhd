-------------------------------------------------------------------------------
-- Project  ELE8304 : Circuits intégrés à très grande échelle
-------------------------------------------------------------------------------
-- File     riscv_if.vhd
-- Lab      GRM - Polytechnique Montreal
-------------------------------------------------------------------------------
-- Brief    : Lire la prochaine instruction à traiter dans la mémoire d’instruction
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.riscv_pkg.all;

entity riscv_if is
  port (
    i_clk_if        : in std_logic;
    i_rstn_if       : in std_logic;

    i_ex_if         : in T_EX;
    --flush         : std_logic;
    --stall         : std_logic;
    --transfert     : std_logic;
    --target        : std_logic_vector(XLEN-1 downto 0);

    i_imem_read_if  : in std_logic_vector(XLEN-1 downto 0);
    o_imem_addr_if  : out std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);
    o_imem_en_if    : out std_logic;
    
    o_reg_if_id      : out T_REG_IF_ID
    --instr         : std_logic_vector(XLEN-1 downto 0);
    --pc            : std_logic_vector(XLEN-1 downto 0);
  );
end entity riscv_if;

architecture beh of riscv_if is

signal PC_O  : std_logic_vector(XLEN-1 downto 0) := (others => '0');

begin
u_pc : riscv_pc 
    generic map(
      RESET_VECTOR => 16#00000000#)
    port map (
      i_clk       => i_clk_if,
      i_rstn      => i_rstn_if,
      i_stall     => i_ex_if.stall,
      i_transfert => i_ex_if.transfert,
      i_target    => i_ex_if.target,
      o_pc        => PC_O
    );

p_reg_if_id : process(i_clk_if, i_rstn_if)
begin
  
  --Update IF/ID register with the fetched instruction
  if(rising_edge(i_clk_if)) then
    
    --Flush values
    if(i_ex_if.flush = '1') then
      o_reg_if_id.instr <= (others => '0');

    --Stall values
    elsif (i_ex_if.stall = '1') then
      
    else
      o_reg_if_id.instr <= i_imem_read_if;
      o_reg_if_id.pc <= PC_O;

    end if;

   --Reset values
  elsif(i_rstn_if = '0') then

    o_reg_if_id.instr <= (others => '0');
    o_reg_if_id.pc <= (others => '0');

  end if; 

end process;

  -- D'autres outputs
  o_imem_addr_if <= PC_O(MEM_ADDR_WIDTH-1 downto 0);
  o_imem_en_if <= '1';

end architecture beh;