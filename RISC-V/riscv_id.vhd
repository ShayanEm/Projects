library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.riscv_pkg.all;

entity riscv_id is
  port (
    i_clk_id         : in std_logic;
    i_rstn_id        : in std_logic;

    i_wb_id          : in T_WB;
    --rd_addr        : std_logic_vector(REG_WIDTH-1 downto 0);
    --rd_data        : std_logic_vector(XLEN-1 downto 0);
    --wb             : std_logic;

    i_reg_if_id      : in T_REG_IF_ID;
    --instr          : std_logic_vector(XLEN-1 downto 0);
    --pc             : std_logic_vector(XLEN-1 downto 0);

    i_flush_id       : in std_logic;

    o_rs_data_id     : out A_RS_DATA; --std_logic_vector(XLEN-1 downto 0);

    o_reg_id_ex      : out T_REG_ID_EX
    --branch         : std_logic;
    --jump           : std_logic;
    --rw             : std_logic;
    --wb             : std_logic;
    --alu_arith      : std_logic;
    --alu_sign       : std_logic;
    --imm            : std_logic_vector(XLEN-1 downto 0);
    --src_imm        : std_logic;
    --alu_op         : std_logic_vector(ALUOP_WIDTH-1 downto 0);
    --rd_addr        : std_logic_vector(REG_WIDTH-1 downto 0);
    --shamt          : std_logic_vector(SHAMT_WIDTH-1 downto 0);
    --pc             : std_logic_vector(XLEN-1 downto 0);
  );
end entity riscv_id;

architecture beh of riscv_id is

  type S_INSTR is record
    opcode       : std_logic_vector(6 downto 0);
    rd           : std_logic_vector(REG_WIDTH-1 downto 0);
    funct3       : std_logic_vector(3-1 downto 0);
    rs           : A_RS_ADDR;
    funct7       : std_logic_vector(7-1 downto 0);
    imm          : std_logic_vector(XLEN-1 downto 0);
  end record;
  
  signal predecode   : S_INSTR;
  signal decode      : T_REG_ID_EX;

begin
u_rf : riscv_rf
port map(
    i_clk     => i_clk_id,
    i_rstn    => i_rstn_id,
    i_we      => i_wb_id.wb,
    i_addr_w  => i_wb_id.rd_addr,
    i_data_w  => i_wb_id.rd_data,
    i_addr_ra => predecode.rs(0),
    i_addr_rb => predecode.rs(1),
    o_data_ra => o_rs_data_id(0),
    o_data_rb => o_rs_data_id(1)
);

p_reg_id_ex : process(i_clk_id, i_rstn_id)
begin
  if (i_rstn_id = '0') then

    o_reg_id_ex.alu_arith <= '0';
    o_reg_id_ex.alu_op    <= (others => '0');
    o_reg_id_ex.alu_sign  <= '0';
    o_reg_id_ex.branch    <= '0';
    o_reg_id_ex.imm       <= (others => '0');
    o_reg_id_ex.jump      <= '0';
    o_reg_id_ex.pc        <= (others => '0');
    o_reg_id_ex.rd_addr   <= (others => '0');
    o_reg_id_ex.rw        <= (others => '0');
    o_reg_id_ex.src_imm   <= '0';
    o_reg_id_ex.wb        <= '0';
    o_reg_id_ex.shamt     <= (others => '0');

  elsif rising_edge(i_clk_id) then
      
    if(i_flush_id = '1') then
      
      o_reg_id_ex.alu_arith <= '0';
      o_reg_id_ex.alu_op    <= (others => '0');
      o_reg_id_ex.alu_sign  <= '0';
      o_reg_id_ex.branch    <= '0';
      o_reg_id_ex.imm       <= (others => '0');
      o_reg_id_ex.jump      <= '0';
      o_reg_id_ex.pc        <= (others => '0');
      o_reg_id_ex.rd_addr   <= (others => '0');
      o_reg_id_ex.rw        <= (others => '0');
      o_reg_id_ex.src_imm   <= '0';
      o_reg_id_ex.wb        <= '0';
      o_reg_id_ex.shamt     <= (others => '0');

    else

      o_reg_id_ex.alu_arith <= decode.alu_arith;
      o_reg_id_ex.alu_op    <= decode.alu_op;
      o_reg_id_ex.alu_sign  <= decode.alu_sign;
      o_reg_id_ex.branch    <= decode.branch;
      o_reg_id_ex.imm       <= decode.imm;
      o_reg_id_ex.jump      <= decode.jump;
      o_reg_id_ex.pc        <= decode.pc;
      o_reg_id_ex.rd_addr   <= decode.rd_addr;
      o_reg_id_ex.rw        <= decode.rw;
      o_reg_id_ex.src_imm   <= decode.src_imm;
      o_reg_id_ex.wb        <= decode.wb;
      o_reg_id_ex.shamt     <= decode.shamt;

    end if;

  end if;
end process;

p_predecode : process(i_reg_if_id)
begin
  -- Par default
  predecode.opcode  <= i_reg_if_id.instr(6 downto 0);
  predecode.rd      <= i_reg_if_id.instr(11 downto 7);
  predecode.funct3  <= i_reg_if_id.instr(14 downto 12);
  predecode.rs(0)   <= i_reg_if_id.instr(19 downto 15);
  predecode.rs(1)   <= i_reg_if_id.instr(24 downto 20);
  predecode.funct7  <= i_reg_if_id.instr(31 downto 25);
  predecode.imm     <= (others => '0');

  case i_reg_if_id.instr(6 downto 0) is
    
    when "0110011" => -- R-TYPE
      null;

    when "0010011" | "0000011" | "1100111" => -- I-TYPE
      
      predecode.rs(1)                 <= (others => '0');
      predecode.funct7                <= (others => '0');
      
      predecode.imm(10 downto 0)      <= i_reg_if_id.instr(30 downto 20);
      predecode.imm(31 downto 11)     <= (others => i_reg_if_id.instr(XLEN-1));

    when "0100011" => -- S-TYPE
      
      predecode.rd                    <= (others => '0');
      predecode.funct7                <= (others => '0');

      predecode.imm(4 downto 0)       <= i_reg_if_id.instr(11 downto 7);
      predecode.imm(10 downto 5)      <= i_reg_if_id.instr(30 downto 25);
      predecode.imm(31 downto 11)     <= (others => i_reg_if_id.instr(XLEN-1));
      
    when "1100011" => -- B-TYPE
      
      predecode.rd                    <= (others => '0');
      predecode.funct7                <= (others => '0');

      predecode.imm(0)                <= '0';
      predecode.imm(4 downto 1)       <= i_reg_if_id.instr(11 downto 8);
      predecode.imm(10 downto 5)      <= i_reg_if_id.instr(30 downto 25);
      predecode.imm(11)               <= i_reg_if_id.instr(7);
      predecode.imm(12)               <= i_reg_if_id.instr(31);
      predecode.imm(31 downto 13)     <= (others => i_reg_if_id.instr(XLEN-1));

    when "0110111" => -- U-TYPE
      
      predecode.funct3                <= (others => '0');
      predecode.rs(0)                 <= (others => '0');
      predecode.rs(1)                 <= (others => '0');
      predecode.funct7                <= (others => '0');
      
      predecode.imm(11 downto 0)      <= (others => '0');
      predecode.imm(31 downto 12)     <= i_reg_if_id.instr(31 downto 12);

    when "1101111" => -- J-TYPE
      
      predecode.funct3                <= (others => '0');
      predecode.rs(0)                 <= (others => '0');
      predecode.rs(1)                 <= (others => '0');
      predecode.funct7                <= (others => '0');
      
      predecode.imm(0)                <= '0';
      predecode.imm(10 downto 1)      <= i_reg_if_id.instr(30 downto 21);
      predecode.imm(11)               <= i_reg_if_id.instr(20);
      predecode.imm(19 downto 12)     <= i_reg_if_id.instr(19 downto 12);
      predecode.imm(20)               <= i_reg_if_id.instr(31);
      predecode.imm(31 downto 21)     <= (others => i_reg_if_id.instr(XLEN-1));

    when others => --None
      
      predecode.opcode                <= (others => '0');
      predecode.rd                    <= (others => '0');
      predecode.funct3                <= (others => '0');
      predecode.rs(0)                 <= (others => '0');
      predecode.rs(1)                 <= (others => '0');
      predecode.funct7                <= (others => '0');
        
    end case;
end process;

p_decode : process(i_reg_if_id.instr,predecode)
begin
  -- Par default
  decode.alu_arith      <= '0';
  decode.alu_op         <= predecode.funct3;
  decode.alu_sign       <= '0';
  decode.branch         <= '0';
  decode.imm            <= predecode.imm;
  decode.jump           <= '0';
  decode.pc             <= i_reg_if_id.pc;
  decode.rd_addr        <= predecode.rd;
  decode.rw             <= (others => '0');
  decode.src_imm        <= '0';
  decode.wb             <= '1';
  decode.shamt          <= (others => '0');

  case predecode.opcode is
    
    when "0110111" =>   -- LUI
        decode.alu_op     <= ALUOP_ADD;
        decode.src_imm    <= '1';
    
    -- Branchements
    when "1101111" => --JAL
      decode.jump       <= '1';
      decode.alu_op     <= ALUOP_ADD;

    when "1100111" => --JALR
      decode.jump       <= '1';
      decode.alu_op     <= ALUOP_ADD;

    when "1100011" => --BEQ
      decode.branch     <= '1';
      decode.alu_op     <= ALUOP_ADD;
      decode.src_imm    <= '0';
      decode.wb         <= '0';
      decode.alu_arith  <= '1';

    -- Acces a la memoire
    when "0000011" => --LW
      decode.rw         <= "10";
      decode.alu_op     <= ALUOP_ADD;
      decode.src_imm    <= '1';

    when "0100011" => --SW
      decode.rw         <= "01";
      --decode.we         <= '1';
      decode.wb         <= '0';
      decode.alu_op     <= ALUOP_ADD;
      decode.src_imm    <= '1';

    -- Operations arithmetiques et logiques
    when "0010011" => --i
      
      decode.src_imm  <= '1';

      if (predecode.funct3 = "000") then --ADDI
        decode.alu_op     <= ALUOP_ADD;
        decode.alu_arith  <= '0';

      elsif (predecode.funct3 = "010") then --SLTI
        decode.alu_op <= ALUOP_ADD;
        decode.alu_arith <= '1';
        decode.alu_sign <= '1';

      elsif (predecode.funct3 = "011") then --SLTIU
        decode.alu_op <= ALUOP_ADD;
        decode.alu_arith <= '1';

      elsif (predecode.funct3 = "100") then --XORI
        decode.alu_op     <= ALUOP_XOR;

      elsif (predecode.funct3 = "110") then --ORI
        decode.alu_op     <= ALUOP_OR;

      elsif (predecode.funct3 = "111") then --ANDI
        decode.alu_op     <= ALUOP_AND;

      elsif (predecode.funct3 = "001") then --SLLI
        decode.alu_arith <= predecode.funct7(5);
        decode.shamt <= predecode.imm(4 downto 0);

      elsif (predecode.funct3 = "101") then --SRLI
        decode.alu_arith <= predecode.funct7(5);
        decode.shamt <= predecode.imm(4 downto 0);

      elsif (predecode.funct3 = "101") then --SRAI
        decode.alu_arith <= predecode.funct7(5);
        decode.shamt <= predecode.imm(4 downto 0);

      end if;

    when "0110011" => --sans i

      decode.alu_arith <= predecode.funct7(5);

      if(predecode.funct3 = "000") then --add/sub
        decode.alu_op <= ALUOP_ADD;
        decode.alu_arith <= predecode.funct7(5);

      elsif (predecode.funct3 = "001") then --SLL
        null;

      elsif (predecode.funct3 = "010") then --SLT
        decode.alu_op <= ALUOP_ADD;
        decode.alu_arith <= '1';
        decode.alu_sign <= '1';

      elsif (predecode.funct3 = "011") then --SLTU
        decode.alu_op <= ALUOP_ADD;
        decode.alu_arith <= '1';

      elsif (predecode.funct3 = "100") then --XOR
        decode.alu_op <= ALUOP_XOR;
      
      elsif (predecode.funct3 = "101") then --SRL
        null;

      elsif (predecode.funct3 = "101") then --SRA
        decode.alu_arith <= predecode.funct7(5);

      elsif (predecode.funct3 = "110") then --OR
        decode.alu_op <= ALUOP_OR;
      
      elsif (predecode.funct3 = "111") then --AND
        decode.alu_op <= ALUOP_AND;
      
      end if;

    --Autres  
    when others =>
      -- Par default
      decode.alu_arith      <= '0';
      decode.alu_op         <= predecode.funct3;
      decode.alu_sign       <= '0';
      decode.branch         <= '0';
      decode.imm            <= predecode.imm;
      decode.jump           <= '0';
      decode.pc             <= i_reg_if_id.pc;
      decode.rd_addr        <= predecode.rd;
      decode.rw             <= (others => '0');
      decode.src_imm        <= '0';
      decode.wb             <= '1';
      decode.shamt          <= (others => '0');
  
  end case;
end process;

end architecture beh;