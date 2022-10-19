
library ieee;
use ieee.std_logic_1164.all;

entity ula_tb is
end ula_tb;

architecture tb of ula_tb is

  -- Componente a ser testado
  component ula is
  port( c_in : in std_logic;
        a, b : in std_logic_vector (3 downto 0); 
        op : in std_logic; 
        s : out std_logic_vector (3 downto 0); 
        z, overflow : out std_logic );
  end component;

  type test_record is record
    a, b, s : std_logic_vector (3 downto 0);
	 op : std_logic;
	 overflow, z : std_logic;
  end record;

  type test_array is array(positive range <>) of test_record;

  constant test_vectors : test_array := (
  
  -- Subtracao
  -- a,       b,     s,    op,  overflow  z
  ("1111", "0000", "1111", '1', '0',   '0'),
  ("0000", "1111", "0001", '1', '0',   '0'),
  ("1111", "1111", "0000", '1', '0',   '1'),
  ("0111", "1000", "1111", '1', '1',   '0'),
  ("1000", "0110", "0010", '1', '1',   '0'),
  
  --Adicao
  -- a,       b,     s,    op,  overflow  z
  ("1111", "1111", "1110", '0', '0',   '0'),
  ("0000", "0000", "0000", '0', '0',   '1'),
  ("1111", "0000", "1111", '0', '0',   '0'),
  ("0111", "0111", "1110", '0', '1',   '0'),
  ("1000", "1001", "0001", '0', '1',   '0') );

  -- Sinais do testbench
  signal a, b, s_e, s_r : std_logic_vector (3 downto 0);
  signal op : std_logic;  
  signal overflow_e, overflow_r, z_r, z_e : std_logic;

begin
  
  -- Componente a ser testado
  U_ula: ula port map(a, b, op, s_r, z_r, overflow_r);

  -- Efetua os testes
  U_testValues: process
    variable v : test_record;
  begin
    
    for i in test_vectors'range loop
      v          := test_vectors(i); -- Valores de teste
      a          <= v.a;
      b          <= v.b;
      op         <= v.op;
      s_e        <= v.s;
		z_e        <= v.z;
      overflow_e  <= v.overflow;

      wait for 200 ps; -- Duracao do passo de simulacao

      assert ( (s_e = s_r) and (overflow_e = overflow_r) and (z_e = z_r) )
        report LF & " algo deu errado "
        severity error;

    end loop;
      
    wait; -- Encerra a simulacao

  end process U_testValues;

end architecture tb;
