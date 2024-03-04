library ieee; 
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;

library std;
use     std.textio.all;                                                      
use     std.env.all;

library work;
use     work.all;

entity riscv_core_tb is 
end riscv_core_tb;

architecture tb of riscv_core_tb is

signal	clk		: std_logic := '0';
signal	rstn		: std_logic := '0';

signal imem_en : std_logic;
signal imem_addr : std_logic_vector(9-1 downto 0);
signal imem_read : std_logic_vector(31 downto 0);

signal dmem_en : std_logic;
signal dmem_we : std_logic;
signal dmem_addr : std_logic_vector(9-1 downto 0);
signal dmem_read : std_logic_vector(31 downto 0);
signal dmem_write : std_logic_vector(31 downto 0);

signal imem_addr_div4 : std_logic_vector(9-1 downto 0);
signal dmem_addr_div4 : std_logic_vector(9-1 downto 0);

constant PERIOD   : time := 100 ns;

begin

MEM0 : entity work.dpm 
  generic map (
    WIDTH => 32,
    DEPTH => 9,
    RESET => 16#00000000#,
    INIT  => "riscv_basic.mem")
  port map (
    -- Port A
    i_a_clk   => clk,
    i_a_rstn  => rstn,
    i_a_en    => imem_en,
    i_a_we    => '0',
    i_a_addr  => imem_addr_div4(8 downto 0),		
    i_a_write => X"00000000",
    o_a_read  => imem_read,
    -- Port B
    i_b_clk   => clk,
    i_b_rstn  => rstn,
    i_b_en    => dmem_en,
    i_b_we    => dmem_we,
    i_b_addr  => dmem_addr_div4(8 downto 0),
    i_b_write => dmem_write,
    o_b_read  => dmem_read
);

imem_addr_div4 <= imem_addr srl 2;
dmem_addr_div4 <= dmem_addr srl 2;     

DUT : entity work.riscv_core 
port map(
	i_rstn => rstn,
	i_clk  => clk,
	o_imem_en => imem_en,
	o_imem_addr => imem_addr,
	i_imem_read => imem_read,
	o_dmem_en   => dmem_en,
	o_dmem_we   => dmem_we,
	o_dmem_addr => dmem_addr,
	i_dmem_read => dmem_read,
	o_dmem_write=> dmem_write
-- DFT
);
	
clk <= not clk after PERIOD/2 ;
rstn <= '1' after 2*PERIOD;
  
end architecture tb;
