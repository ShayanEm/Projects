library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;

entity riscv_adder_tb is
end entity riscv_adder_tb;

architecture tb of riscv_adder_tb is

    component riscv_adder is
    generic (
    	N : positive := 32
    );
    port (
    	if_a    : in  std_logic_vector(N-1 downto 0);
        if_b    : in  std_logic_vector(N-1 downto 0);
		if_sign : in  std_logic;
        if_sub  : in  std_logic;
        of_sum  : out std_logic_vector(N downto 0)
    );	  
	end component riscv_adder;
	
	constant N : integer :=32;
	signal dut_o_sum : std_logic_vector(N downto 0);
	signal dut_i_sub : std_logic;
	signal dut_i_sign : std_logic;
	signal dut_i_b :	 std_logic_vector(N-1 downto 0);
	signal dut_i_a : std_logic_vector(N-1 downto 0);    
	constant T : time := 10 ns;
	constant n_bits : integer :=32; 

begin
	dut: riscv_adder
    generic map (
    	N => n_bits
    )
    port map (
    	if_a    => dut_i_a,
        if_b    => dut_i_b,
        if_sign => dut_i_sign,
        if_sub  => dut_i_sub,
        of_sum  => dut_o_sum 
    );	 
	
	test : process
	begin
		wait for T;
	  	-- subs tests
		wait for T; 
		-- addition tests
		wait for T;
		 -- subs test signed
		wait for T; 
		-- addition test signed
		wait for T;
	end process test;

end architecture tb;