library ieee;
use ieee.std_logic_1164.all;

entity micow_e is
  port(clk_in                                    : in  std_logic;
       an_out                                    : out std_logic_vector(3 downto 0);
       cat_out                                   : out std_logic_vector(7 downto 0));
end micow_e;

architecture Behavior of micow_e is

------------------------------- Declare the components --------------------------------
  
  -- Clock Divisor
  component clkDiv_e
    port(clk_in                                  : in  std_logic;
         clk_out                                 : out std_logic);
  end component;
  
  -- Unit Control
  component uc_e
    port (op_in                                  : in  std_logic_vector(1 downto 0);
          rbWr_out, imm_out, bne_out, aluOp_out  : out std_logic;    
          memWr_out, memRd_out                   : out std_logic);
  end component;

  -- Program Counter 
  component pc_e
    port(clk_in                                  : in  std_logic;
         pcCurr_in, pcPlus_in                    : in  std_logic_vector(3 downto 0);
         pcNext_out                              : out std_logic_vector(3 downto 0));
  end component;

  -- Instruction Memory
  component im_e
    port(addr_in                                 : in  std_logic_vector(3 downto 0);
         ins_out                                 : out std_logic_vector(7 downto 0));
  end component;

  -- Register Bank
  component rb_e
    port (clkDpy_in, clk_in, rbWr_in             : in  std_logic; 
          rbS_in, rbT_in, rbD_in                 : in  std_logic_vector(1 downto 0);
          rbWrData_in                            : in  std_logic_vector(3 downto 0);
          rbSOutData_out, rbTOutData_out         : out std_logic_vector(3 downto 0);
          an_out                                 : out std_logic_vector(3 downto 0); 
          cat_out                                : out std_logic_vector(7 downto 0)); 
  end component;

  -- Arithimetic Logic Unit
  component alu_e 
    port(aluOp_in                                : in  std_logic;
         aluFirst_in, aluSecond_in               : in  std_logic_vector(3 downto 0);
         zero_out                                : out std_logic;
         result_out                              : out std_logic_vector(3 downto 0));
  end component;

  -- Data Memory
  component dm_e
    port(clk_in, memRd_in, memWr_in              : in  std_logic;
         memData_in, memAddr_in                  : in  std_logic_vector(3 downto 0);
         memData_out                             : out std_logic_vector(3 downto 0));
  end component;

   
--------------------------------- Declare the signals ---------------------------------
 
  -- Clock divider signals
  signal clk_s                                   : std_logic;

  -- Unit control signals
  signal rbWr_s, aluOp_s, imm_s, bne_s           : std_logic; 
  signal memRd_s, memWr_s                        : std_logic;
  signal op_s									 : std_logic_vector(1 downto 0);
  signal ins_s                                   : std_logic_vector(7 downto 0); 

  -- PC signals
  signal branch_s                                : std_logic;
  signal pcPlus_s, pcCurr_s, pcNext_s            : std_logic_vector(3 downto 0); 
  
  -- Register bank signals
  signal rbS_s, rbT_s, rbD_s                     : std_logic_vector(1 downto 0);
  signal rbSOutData_s, rbTOutData_s, rbWrData_s  : std_logic_vector(3 downto 0);

  -- Alu signals
  signal zero_s                                  : std_logic;
  signal aluResult_s, rtOrimm_s                  : std_logic_vector(3 downto 0);

  -- Data memory signals
  signal memOutData_s                            : std_logic_vector(3 downto 0); 

begin

------------------------------------- Set signals -------------------------------------

  -- Divide the instruction
  rbT_s     <= ins_s(3 downto 2);
  rbS_s     <= ins_s(5 downto 4);
  op_s      <= ins_s(7 downto 6);

  -- Change the pc addr to the addr of the next instruction
  pcCurr_s  <= pcNext_s;
  
  -- Set the branch signal: 
  -- '1' if op is bne and the values are not equal
  -- '0' otherwhise
  branch_s  <= bne_s and not zero_s;


------------------------------------ Multiplexers -------------------------------------   

  -- Mux to set the value to be add to the current pc addr:
  -- when the branch is taken, select the imm,
  -- otherwise, select '1'
  mux_branch: pcPlus_s    <= "11" & not rbD_s    when branch_s = '1' else
                             "0001";

  -- Mux to set the register to be written:
  -- when op is lw, it's the rt, otherwhise, it's the rd 
  mux_rbD_s:  rbD_s       <= rbT_s               when memRd_s = '1' else
                             ins_s(1 downto 0);  
							
  -- Mux to set the value for the alu:
  -- when the imm signal is activate select the extended imm,
  -- otherwhise, select the value in the rt register
  mux_alu:    rtOrimm_s   <= rbTOutData_s        when imm_s = '0' else
                             bne_s&bne_s&rbD_s   when imm_s = '1';
  
  -- Mux to set the data to be written in the RB:
  -- when the memRead signal is activate select the data read from the memory,
  -- otherwise, select the result from the alu 
  mux_dm:     rbWrData_s  <= memOutData_s        when memRd_s = '1' else
                             aluResult_s;
 
  
-------------------------------- The important part -----------------------------------

  -- Divide the clk from the FPGA board to the desired value
  clock:  clkDiv_e  port map (clk_in, clk_s);

  -- Generate the necessary control signals 
  UC:     uc_e      port map (op_s, rbWr_s, imm_s, bne_s, 
                              aluOp_s, memWr_s, memRd_s);
  
  -- Set the addr to the next instruction
  PC:     pc_e      port map (clk_s, pcCurr_s, pcPlus_s, pcNext_s);
 
  -- Read the next instruction
  IM:     im_e      port map (pcCurr_s, ins_s);     
  
  -- Read and write the values in the register bank
  RB:     rb_e      port map (clk_in, clk_s, rbWr_s, 
                              rbS_s, rbT_s, rbD_s, rbWrData_s, 
                              rbSOutData_s, rbTOutData_s, 
                              an_out, cat_out); 
                          
  -- Make the operation set by the aluOp
  ALU:    alu_e     port map (aluOp_s, rbSOutData_s, rtOrimm_s, 
                              zero_s, aluResult_s);
  
  -- Write or read data in the data memory when apropriate
  DM:     dm_e      port map (clk_s, memRd_s, memWr_s, 
                              aluResult_s, rbTOutData_s, memOutData_s); 
end Behavior;


