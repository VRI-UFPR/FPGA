library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity im_e is
  port(addr_in                                 : in  std_logic_vector(3 downto 0);
       ins_out                                 : out std_logic_vector(7 downto 0)));
end im_e;

architecture Behavioral of im_e is
  type dataArray_t is array (0 to 15)          of std_logic_vector(7 downto 0);
  
  constant memData_c : memArray_t := (
  -- Add the desired instructions here
 
  -- Initial settings
  
  --Mem[0..3] = 1 0 7 7
  --Reg[0..3] = 0 1 5 5
 
  -- Initializate the program, ensures the instructions loop
  "10000100", --lw $1, 0(S0)    ($1 = 1)
  "10001001", --lw $2, 1($0)    ($2 = 0)
  "10001111", --lw $3, 3($0)    ($3 = 7)
  "11001111", --sw $3, 3($0)    (Mem[3] = 7)
  
  --Mem[0..3] = 1 0 7 7
  --Reg[0..3] = 0 1 0 7
  
  --$2 counts to 7
  "00100110", --add $2, $2, $1 ($2++)
  "01111000", --bne $3, $2, 0  ($3 != $2? If yes, go back 1 instruction)
  
  --Mem[0..3] = 1 0 7 7
  --Reg[0..3] = 0 1 7 7
  
  -- Change some values to the next loop
  "00011111", --add $3, $1, $3 ($3 = -8)
  "11001110", --sw $3, 2($0)   (Mem[2] = -8)
  "11001011", --sw $2, 3($0)   (Mem[3] = 7)
  "10001101", --lw $3, 1($0)   ($3 = 0)
   
  --Mem[0..3] = 1 0 -8 7
  --Reg[0..3] = 0 1 7 0
  
  --$3 counts to -8, $2 alternate between 0 e -8
  "10001010", --lw $2, 2($0)   ($2 = -8)
  "00110111", --add $3, $3, $1 ($3++)
  "00000010", --add $2, $0, $0 ($2 = 2)
  "10001010", --lw $2, 2($0)  ($2 = -8)
  "01111011", --bne $3, $2, 3  ($3 != $2? If yes, go back 4 instructions)
  
  --Mem[0..3] = 1 0 -8 7
  --Reg[0..3] = 0 1 -8 -8
  
  --$1 receive -8 to mark the end of one PC cicle
  "10000110"  --lw $1, 2($0)   $1 = -8)
  
  --Mem[0..3] = 1 0 -8 7
  --Reg[0..3] = 0 -8 -8 -8
  
  );

begin

  ins_out <= memData_c(to_integer(unsigned(addr_in)));
  
end Behavioral;
