----------------------------------------------------------------------------------
--
--
--
--PROGETTO DI 
--KEVIN MATO: MATRICOLA 845726 
--LUCA MASSINI: MATRICOLA 844049 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;



library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.NUMERIC_STD.ALL;
--da modificare i counter di colonna e riga
library ieee;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.NUMERIC_STD.ALL;

entity FSM is
port (
        o_done        : out std_logic; 
        o_en          : out std_logic;    
        o_we          : out std_logic; 
      
      clk : in std_logic;
      reset : in std_logic;
      flag : in std_logic;
      start : in std_logic;
      
      
      ram_address_0: out std_logic_vector(0 to 3);
      ram_address_1: out std_logic_vector(0 to 3);
      ram_wr_en: out std_logic;
      sup1c: out std_logic_vector(0 to 2);
      sup2c: out std_logic_vector(0 to 2);
      d1c: out std_logic;
      d2c: out std_logic;
      d3c: out std_logic; 
      d4c: out std_logic;
      is_msb : out std_logic;
 
      ALU_CONTROL:out std_logic_vector(0 to 2);
      enrc: out std_logic;
      encc:out std_logic;
      enpc: out std_logic;
      en_port_0 :out std_logic;
      en_port_1 :out std_logic;
      
     
      rstram :out std_logic;
      rstrega :out std_logic;
      rstregb :out std_logic;
      
      rstresult:out std_logic;
      rstc: out std_logic;
      rstr: out std_logic;
      rst2: out std_logic;
      first_timeo: out std_logic;
      first_timerit: in std_logic
  );
end FSM;

architecture behavioral of FSM is

type state_type is (idle,reset_state,start_s,ask_addr_1,ask_addr_2,ask_addr_3,ask_addr_4,
                    save_1,save_2,save_3,save_4,save_5,save_6,save_7,save_8,save_9,save_10,save_11,
                    --read_1,read_2,
                    read_3,read_4,read_5,read_6,read_7,read_8,read_9,read_10,read_11,read_12,read_13,
                    read_14,read_15,read_16,read_17,
                    add_1,add_2,sub_1,sub_2,mult_1,multing,less_1,less_2,less_3,less_4,less_5,less_6,
                    increment,check_1,check_2, addone_1,addone_2,
                    --equal_1,equal_2,
                    set_1,set_2,set_3,set_4,set_5,set_6,set_7,
                    quick_reset,
                    final_1,done,is_msb0,is_msb1,choice_1,choice_2,choice_3,choice_4,choice_5,choice_6,waiting_1,waiting_2,waiting_3
                    );  
signal current_s: state_type;--idle; 
signal next_s: state_type;--idle;
---------------------------
--signal first_time: std_logic :='1';
----------------------------
begin





state_process: process (clk,reset)
begin
 if (reset='1') then
  current_s <= reset_state; 
elsif (rising_edge(clk)) then
  current_s <= next_s;   
end if;
end process;

FIRST_DECLARATION: process(clk,reset,current_s,first_timerit)
begin

case current_s is
        when set_4 =>
                first_timeo<='0';
        when others => 
                if(first_timerit='0')then
                    first_timeo<='0';
                elsif(first_timerit='1')then
                    first_timeo<='1';
                end if;
        end case;
end process;


lambda: process (current_s,flag,start,reset,first_timerit)
begin
  case current_s is
     when idle =>        
                     if(reset ='1') then
                         next_s <= reset_state;
                     elsif(start='1') then   
                         next_s <= reset_state;
                     else  
                         next_s <= idle;
                     end if;   

    when reset_state =>
         next_s<=start_s;

    when start_s =>     
                next_s<=ask_addr_1;
                
    when ask_addr_1 =>
                next_s<=save_1;
                
    when save_1=>
                next_s<=ask_addr_2;
                     
    when ask_addr_2 =>
                next_s<=save_2;
    
    when save_2=>
             next_s<=ask_addr_3;     
    
    when ask_addr_3 =>
               next_s<= save_3;   
     
     when save_3=>
                 next_s<=read_3; 
                 
      when read_3=>
                next_s<=mult_1;    
      when mult_1=>     
                next_s<=save_4;
                
      when save_4=>
                next_s<=read_4;  
                         
       when read_4=>
                next_s<=add_1;
                
        when add_1=>
                next_s<=save_5;
                
        when save_5=>
                next_s<=read_5;
                
         when read_5=>
                next_s<=less_1;
        when less_1=>
                next_s<=choice_1;
                
        when choice_1=>
                             if (flag='0') then 
                                next_s<=ask_addr_4;
                             else 
                                 next_s<=check_2;
                             end if;  
         
    when ask_addr_4 =>
            next_s<=save_6;
             
    when save_6=>
                next_s<=read_6;
                
    when read_6=>
                next_s<=less_2;
    when less_2=>
         next_s<=choice_2;
         
    when choice_2=>
         if(flag='1') then 
            next_s<=check_1;
         else 
            next_s<=increment;
         end if;
                
          when check_1=>   
                    if(first_timerit='1') then
                       next_s<=set_1;
                    else
                       next_s<=read_7;
                    end if;
--                else 
--                    next_s<=increment;
--                end if;
                
           when set_1=>
                next_s<=set_2; 
                
           when set_2=>
                 next_s<=set_3;
                 
           when set_3=>
               next_s<=set_4;
               
           when set_4=>
                next_s<=increment;
                
           when read_7=>
                next_s<=less_3;
                
          when less_3=>
              next_s<=choice_3;
           
          when choice_3=>
               if(flag='0') then 
                 next_s<=set_5;
               else
                 next_s<=read_8;
               end if;
                  
              
           when set_5=>
               next_s<=read_9; 
                 
                   
           when read_8=>
                next_s<=less_4;
                
          when less_4=>
              next_s<= choice_4;
              
          when choice_4=>
               if(flag='1') then
                  next_s<=set_6;
               else
                   next_s<=read_9;
               end if;    
              
          when set_6 =>
               next_s<=read_9;
                  
          when read_9=>
               next_s<=less_5;
               
          when less_5=>
               next_s<=choice_5;
          
          when choice_5=>
               if (flag='1') then 
                   next_s<=set_7;
               else 
                   next_s<=increment;
               end if;
             
            when set_7=>
                     next_s<=increment;
                   
          
            when increment=>
                    next_s<=waiting_1;
                    
            when waiting_1=>
                 next_s<=read_10;

           when read_10=>
                next_s<=less_6;
                
          when less_6=>
              next_s<=choice_6;
          
          when choice_6=>
               if(flag='1') then 
                  next_s<=quick_reset;
               else
                   next_s<=read_5;
               end if;
              
          when quick_reset=>
                  next_s <=waiting_2;
          
          when waiting_2=>
               next_s<=read_5;
                  
          when check_2 =>
                if(first_timerit='0') then
                    next_s<= read_11;
                else    
                    next_s<=read_17;
                end if;
            
          when read_11=>
                next_s<=sub_1;
                
           when sub_1=>
               next_s<=save_7;
               
           when save_7=>
             next_s<=read_12;
             
           when read_12=>
                   next_s<=addone_1;
                   
           when addone_1=>
                  next_s<=save_8;
                  
           when save_8=>
                next_s<=read_13;

          when read_13=>
                next_s<=sub_2;
                
           when sub_2=>
               next_s<=save_9;
               
           when save_9=>
                 next_s<=read_14;
             
           when read_14=>
                   next_s<=addone_2;
                   
           when addone_2=>
                  next_s<=save_10;
                  
           when save_10=>
                next_s<=read_15;

           when read_15=>
                   next_s<=multing;
                   
            when multing=>
                  next_s<=save_11;
                  
            when save_11=>
                next_s<=final_1;
                
            when final_1=> 
                      next_s<=is_msb0;
                      
            when is_msb0=>
                    next_s<=is_msb1;
                    
             when is_msb1=>
                    next_s<=waiting_3;
             
             when waiting_3=>
                 next_s<=done;
                    
            when done=>
                    next_s<=idle;
                    
            when read_17=>
                    next_s<=is_msb0; 
                          
            when others => next_s<=idle;

        end case;
        end process;
        
 delta: process(current_s,flag)
 
 begin
--"case" statement for delta function:
o_done<='0';
rst2<='0';
o_en<='0';
o_we<='0';
ram_address_1<=(others=>'0');
ram_address_0<=(others=>'0');
ram_wr_en<='0';
sup1c<="001";
sup2c<="001";
d1c<='0';
d2c<='0';
d3c<='0';
d4c<='0';
is_msb<='0';
alu_control<=(others=>'0');
enrc<='0';
encc<='0';
enpc<='0';
en_port_0<='0';
en_port_1<='0';
rstram <='0';
rstrega <='0';
rstregb <='0';
rstresult <='0';
rstc <='0';
rstr <='0'; 
 case current_s is
 
            when idle =>  
                null;
                
            when reset_state =>
                    rstram <='1';
                    rstrega <='1';
                    rstregb <='1';
                    rstresult <='1';
                    rstc <='1';
                    rstr <='1';
        
            when start_s =>   
                    null;
                
            when ask_addr_1 =>
                    o_en<='1';
                    
                        
            when save_1=>
                    en_port_0<='1';
                    ram_wr_en<='1';
                    ram_address_0<=conv_std_logic_vector(2,4);
                    sup2c<="100";
                    enpc<='1';
                             
            when ask_addr_2 =>
                    o_en<='1'; 
                     
            when save_2=>
                    en_port_0<='1';
                    ram_wr_en<='1';
                    ram_address_0<=conv_std_logic_vector(3,4);
                    sup2c<="100";
                    enpc<='1';
                    
            when ask_addr_3 =>
                    o_en<='1';
                       
             
           when save_3=>
                   en_port_0<='1';
                   ram_wr_en<='1';
                   ram_address_0<=conv_std_logic_vector(4,4);
                   sup2c<="100";             
                        
                        
            when read_3=>
                           en_port_1<='1';
                           en_port_0<='1';
                           ram_address_0<= conv_std_logic_vector(2,4);
                           ram_address_1<= conv_std_logic_vector(3,4);
                           sup1c<="100";   
                   
              when mult_1=>  
                    alu_control<="100";
                        
              when save_4=>
                     en_port_0<='1';
                     ram_wr_en<='1';
                     ram_address_0<=conv_std_logic_vector(10,4);
                     sup2c<="011";
                     
              when read_4=>
                    en_port_1<='1';
                    ram_address_1<= conv_std_logic_vector(10,4);
                    sup1c<="011";
                    d3c<='1';
                    
              when add_1=>
                    alu_control<="000";
                        
                when save_5=>
                    en_port_0<='1';
                    ram_wr_en<='1';
                    ram_address_0<=conv_std_logic_vector(10,4);
                    sup2c<="011";
                    enpc<='1';
                    
                when read_5=>
                    en_port_1<='1';
                    ram_address_1<=conv_std_logic_vector(10,4);
                    sup1c<="011";
                    d3c<='1';
                          
               when less_1=>
                    alu_control<="110";
        
            when ask_addr_4=>
                    
                     d3c<='0';
                     o_en<='1';
                     
                     
            when save_6=>
                   ram_wr_en<='1';
                   en_port_0<='1';
                   ram_address_0<= conv_std_logic_vector(9,4);
                   sup2c<="100";
                   
            when read_6=>
                  en_port_1<='1';
                  en_port_0<='1';
                  ram_address_0<= conv_std_logic_vector(9,4);
                  ram_address_1<= conv_std_logic_vector(4,4);
                  sup1c<="100";
                              
            when less_2=>
                  alu_control<="011";
                
                        
            when check_1=>  
                  null;
                        
            when set_1=>
                    en_port_0<='1';
                    ram_wr_en<='1';
                    ram_address_0<=conv_std_logic_vector(7,4);
                    sup2c<="001";
                    
            when set_2=>
                    en_port_0<='1';
                    ram_wr_en<='1';
                    ram_address_0<=conv_std_logic_vector(8,4);
                    sup2c<="001"; 
                         
            when set_3=>
                    sup2c<="010";
                    en_port_0<='1';
                    ram_wr_en<='1';
                    ram_address_0<=conv_std_logic_vector(5,4);
                       
            when set_4=>
                    sup2c<="010";
                    en_port_0<='1';
                    ram_wr_en<='1';
                    ram_address_0<=conv_std_logic_vector(6,4);
                               
            when read_7=>
                    en_port_1<='1';
                    ram_address_1<=conv_std_logic_vector(7,4);
                    sup1c<="001";                
                    d1c<='1';    
                        
            when less_3=>
                    alu_control<="011";      
                      
            when set_5=>
                    
                       sup2c<="001";
                       en_port_0<='1';
                       ram_wr_en<='1';
                       ram_address_0<=conv_std_logic_vector(7,4);
                    
                           
            when read_8=>
                  d1c<='1';
                  en_port_1<='1';
                  ram_address_1<=conv_std_logic_vector(8,4);
                  sup1c<="001";
                           
            when less_4=>
                        --d4c<='0';
                  alu_control<="110";
                        
                     
             when set_6 =>
                      
                         ---d1c<='0'; 
                         sup2c<="001";
                         ram_wr_en<='1';
                         en_port_0<='1';
                         ram_address_0<=conv_std_logic_vector(8,4);
                       
                         
              when read_9=>
                  sup1c<="010";
                  d2c<='1';
                  en_port_1<='1';
                  ram_address_1<=conv_std_logic_vector(6,4);
                  --d4c<='0';
                  
               when less_5=>
                   --d4c<='0';
                   alu_control<="110";
                
               when set_7=>
                     
                                 --d2c<='0';
                                 sup2c<="010";
                                 ram_wr_en<='1';
                                 en_port_0<='1';
                                 ram_address_0<=conv_std_logic_vector(6,4);
                      
             
             when increment=>
                  encc<='1';
                  enpc<='1';
                             
           
             when read_10=>
                d1c<='1';
                sup1c<="001";
                en_port_1<='1';
                ram_address_1<=conv_std_logic_vector(2,4);
                           
             when less_6=>
                 alu_control<="110";
                 --d4c<='0';
                         
             when quick_reset=>
                      
                         rstc<='1';
                         enrc<='1';
                       
                       
              when check_2 =>
                     null;
                       
              when read_11=>
                         en_port_1<='1';
                         en_port_0<='1';
                         ram_address_1<= conv_std_logic_vector(7,4);
                         ram_address_0<= conv_std_logic_vector(8,4);
                         sup1c<="100";
                           
              when sub_1=>
                        alu_control<="010";
                        --d4c<='0';
                        
              when save_7=>
                       sup2c<="011";
                       en_port_0<='1';
                       ram_wr_en<='1';
                       ram_address_0<=conv_std_logic_vector(8,4);
            
             when read_12=>
                            en_port_0<='1';
                            en_port_1<='1';
                            ram_address_0<=conv_std_logic_vector(8,4);
                            ram_address_1<=conv_std_logic_vector(1,4);
                            sup1c<="100";
                              
             when addone_1=>     
                        --d4c<='0';
                        alu_control<="000";
                            
   
             when save_8=>  
                      sup2c<="011";
                      en_port_0<='1';
                      ram_wr_en<='1';
                      ram_address_0<=conv_std_logic_vector(8,4);
                              
   
           
                     when read_13=>
                          ram_address_0<=conv_std_logic_vector(6,4);
                          ram_address_1<=conv_std_logic_vector(5,4);
                          en_port_0<='1';
                          en_port_1<='1';
                          --d4c<='0';
                          sup1c<="100";
                           
                      when sub_2=>
                          --d4c<='0';
                          alu_control<="010";
                          
                          
                      when save_9=>
                         
                         sup2c<="011";
                         en_port_0<='1';
                         ram_wr_en<='1';   
                         ram_address_0<=conv_std_logic_vector(7,4);
                         
                      when read_14=>
                      
                        en_port_0<='1';
                        en_port_1<='1';
                        ram_address_0<=conv_std_logic_vector(7,4);
                        ram_address_1<=conv_std_logic_vector(1,4);
                        sup1c<="100";   
                        --d4c<='0';      
                              
                       when addone_2=>
                       
                         --d4c<='0';
                         alu_control<="000";
                             
                     when save_10=>                        
                           sup2c<="011";
                           en_port_0<='1';
                           ram_wr_en<='1';
                           ram_address_0<=conv_std_logic_vector(7,4);  
           
                      when read_15=>
                          
                          en_port_0<='1';
                          en_port_1<='1';
                          ram_address_0<=conv_std_logic_vector(7,4);
                           ram_address_1<=conv_std_logic_vector(8,4);
                          sup1c<="100";
                          --d4c<='0';
                              
                     when multing=>
                     
                         --d4c<='0';
                         alu_control<="100";   
                             
                     when save_11=>
                           sup2c<="011";
                           en_port_0<='1';
                           ram_wr_en<='1';
                           ram_address_0<=conv_std_logic_vector(5,4);
                           
                     when final_1=>                        
                             rst2<='1';
                             en_port_1<='1';
                             ram_address_1<=conv_std_logic_vector(5,4);
                                            
                     when is_msb0=>--rileggo il dato se no lo cancella
                           en_port_1<='1';
                           ram_address_1<=conv_std_logic_vector(5,4);
                           o_we<='1';
                           o_en<='1';
                           d4c<='1';
                           --d3c<='0';    
                           --is_msb<='0';
                               
                      when is_msb1=>
                             ram_address_1<=conv_std_logic_vector(5,4);
                             en_port_1<='1';
                             enpc<='1';
                             --d3c<='0';
                             d4c<='1';
                             is_msb<='1';
                      
                      when waiting_3=> 
                           en_port_1  <= '1';
                           ram_address_1<=conv_std_logic_vector(5,4);
                           o_en<='1';
                           o_we<='1';
                           --d3c<='0';
                           d4c<='1';
                           is_msb<='1';          
                               
                       when done=>
                       
                           --o_en<='0';
                           --o_we<='0';
                          --enpc<='0';
                           o_done<='1';
                               
                       when read_17=>
                       
                           --ram_wr_en<='0';
                           rst2<='1';
                           en_port_1<='1';
                           ram_address_1<= conv_std_logic_vector(0,4);
                           --sup1c<="100";
                           --d4c<='1';
                          
                                     
                       when others =>  
                             null;
   --                        first_time<='1';
   --                        o_done<='0';
   --                        rst2<='Z';
   --                        o_en<='Z';
   --                        o_we<='Z';
   --                        ram_address_1<=(others=>'Z');
   --                        ram_address_0<=(others=>'Z');
   --                        ram_wr_en<='Z';
   --                        sup1c<=(others=>'Z');
   --                        sup2c<=(others=>'Z');
   --                        d1c<='Z';
   --                        d2c<='Z';
   --                        d3c<='Z';
   --                        d4c<='Z';
   --                        is_msb<='Z';
   --                        alu_control<=(others=>'Z');
   --                        enrc<='Z';
   --                        encc<='Z';
   --                        enpc<='Z';
   --                        en_port_0<='Z';
   --                        en_port_1<='Z';
   --                        rstram <='Z';
   --                        rstrega <='Z';
   --                        rstregb <='Z';
   --                        rstresult <='Z';
   --                        rstc <='Z';
   --                        rstr <='Z';
                               
           
                   end case;
                   
         end process;
         end behavioral;
       
    --======================================================
    --========================================================
--FSMFSMFSMFSMFSMFSMFSM=======================================
--FSMFSMFSMFSMFSMFSMFSM=======================================
--FSMFSMFSMFSMFSMFSMFSM=======================================
--==========================================================
--======================================================
--========================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FIRSTT is
port(
    input: in std_logic;
     output: out std_logic;
     clock: in std_logic;
     reset: in std_logic
    );
end FIRSTT;

architecture behave of FIRSTT is
begin 
process(clock,reset)
    begin
        if(reset='1') then
            output<='1';
        elsif(rising_edge(clock)) then
            output<=input;
        end if;
end process;
end behave;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FATTY is
port(
    input: in std_logic_vector(0 to 17);
     output: out std_logic_vector(0 to 17);
     clock: in std_logic;
     reset: in std_logic
    );
end FATTY;

architecture behave of FATTY is
begin 
process(clock,reset)
    begin
        if(reset='1') then
            output<=(others=>'0');
        elsif(rising_edge(clock)) then
            output<=input;
        end if;
end process;
end behave;

------------------------------------------------
------------------------------------------------
-----------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RAM is
port(   
        clk: in std_logic;       
        rst: in std_logic;     
                
        wr_en : in std_logic;        
        data_in : in std_logic_vector(0 to 17);  
        addr_in_0 : in std_logic_vector(0 to 3);    
        addr_in_1 : in std_logic_vector(0 to 3);    
        port_en_0 : in std_logic;   
        port_en_1 : in std_logic;  
        data_out_0 : out std_logic_vector(0 to 17); 
        data_out_1 : out std_logic_vector(0 to 17)   
    );
end RAM;

architecture Behavioral of RAM is
type ram_type is array(0 to 10) of std_logic_vector(0 to 17);
signal ram : ram_type := (others => (others => '0'));

begin
process(clk)
begin
    if(rising_edge(clk)) then
        if(rst = '1') then    
                ram <= (others => (others => '0'));
                ram(1)<=std_logic_vector(to_unsigned(1,18));
        elsif(port_en_0 = '1') then    
            if(wr_en = '1') then    
                ram(conv_integer(addr_in_0)) <= data_in;
            end if;
        end if;
    end if;
end process;
data_out_0 <= ram(conv_integer(addr_in_0)) when (port_en_0 = '1') else
            (others => '0');
data_out_1 <= ram(conv_integer(addr_in_1)) when (port_en_1 = '1') else
            (others => '0');
            
end Behavioral;
--))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))
--)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))
--ADDER
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity adder is                 
port(
a:in std_logic_vector(0 to 17);       
b:in std_logic_vector(0 to 17);
output:out std_logic_vector(0 to 17)
);
end adder;

architecture add of adder is
begin 
output<=signed(a)+signed(b);
end add;

library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.std_logic_signed.all;
  use IEEE.std_logic_arith.all;

entity multiplier is
port(
a: in std_logic_vector(0 to 17);
b: in std_logic_vector(0 to 17);
output: out std_logic_vector( 0 to 17)
);
end multiplier;

architecture mult of multiplier is
signal tmp:std_logic_vector(0 to 35);
begin
     tmp<=signed(a)*signed(b);
     output<=tmp(18 to 35);
     end mult;
 
 library IEEE;
 use IEEE.STD_LOGIC_1164.ALL;
 use IEEE.std_logic_signed.all;
 use IEEE.std_logic_arith.all;
       
      entity two_complement is
      port(
          b:in std_logic_vector(0 to 17);
          output: out std_logic_vector(0 to 17)
          );
      end two_complement;
      
      architecture two_comp of two_complement is
      begin
          output<=signed(not b)+1;
      end two_comp;
      
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;
      
--entity central_control_bit is
--      port(
--          control:in std_logic_vector(0 to 2);
--          output:out std_logic
--          );
--          end central_control_bit;
          
--      architecture central_bit of central_control_bit is
--      begin 
--           output<=control(1);
--           end central_bit;
     
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity output_one_filter is 
port(
     control:in std_logic_vector(0 to 2);
     almost_final:in std_logic_vector(0 to 17);
     output:out std_logic_vector(0 to 17)
     );
end output_one_filter;   

architecture output_one of output_one_filter is 
begin 
     with control select
      output<= almost_final when "000",
                almost_final when "010",
                almost_final when "100",
                (others=>'Z') when others;
       end output_one;

library IEEE;
 use IEEE.STD_LOGIC_1164.ALL;
 use IEEE.std_logic_signed.all;
 use IEEE.std_logic_arith.all;

entity output2_filter is 
port(
     input:in std_logic_vector(0 to 17);
     control:in std_logic_vector(0 to 2);
     output:out std_logic
     );
     end output2_filter;
  
architecture output2 of output2_filter is
          signal is_equal,less_than,major_or_equal,major_than:std_logic;
          begin
          is_equal<='1' when input="000000000000000000"else
                    '0';
          less_than<='1' when input(0)='1' else
                      '0';
          major_than<=not(is_equal) and not(less_than);
          major_or_equal<=(not(is_equal) and not (less_than)) or is_equal;
          output<=major_or_equal when control="011" else
                  major_than when control="110" else
                  'Z';
          end output2;    
     
library IEEE;
      use IEEE.STD_LOGIC_1164.ALL;
      use IEEE.std_logic_signed.all;
      use IEEE.std_logic_arith.all;
     
entity control_MUX is 
     port( 
          a:in std_logic_vector(0 to 17);
          b:in std_logic_vector(0 to 17);
          control:in std_logic_vector(0 to 2);
          output:out std_logic_vector(0 to 17)
          );
          end control_MUX;
      
     architecture contr_MUX of control_MUX is 
     begin 
          with control select
               output<=b when "100",
                       a when others;
         end contr_MUX;
  
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;
         
entity normalMux is
   port(
          a: in std_logic_vector(0 to 17);
          b: in std_logic_vector(0 to 17);
          control: in std_logic;
          c: out std_logic_vector(0 to 17)
          );
          end normalMux;
              
         architecture rtl of normalMUX is
         begin
              with control select
                   c<= a when '0',
                       b when others;
               end rtl;
 ----------------------------------------------------
 library IEEE;
 use IEEE.STD_LOGIC_1164.ALL;
 use IEEE.STD_LOGIC_ARITH.ALL;
 use IEEE.STD_LOGIC_UNSIGNED.ALL;
 use IEEE.NUMERIC_STD.ALL;
 
 entity mycounter is
     Port ( 
            enable: in std_logic;
            clk: in std_logic; 
            reset: in std_logic;  
            count: out std_logic_vector(0 to 17) 
      );
 end mycounter;
 
 architecture Behavioral of mycounter is
 attribute keep : string;
 signal to_out: std_logic_vector(0 to 17);
 attribute keep of to_out : signal is "true";
 
 begin
         process(clk,reset)
             begin
             if(rising_edge(clk)) then
                 if(reset='1')then
                      to_out <= conv_std_logic_vector(1, 18);
                 elsif(enable='1') then
                     to_out <= to_out + 1;
                 end if;
              end if;
         end process;
  count <= to_out;
 
 
 end Behavioral;
 -------------------------------------------------------
 -------------------------------------------------------
 -------------------------------------------------------
 -------------------------------------------------------
 -------------------------------------------------------
 -------------------------------------------------------
 library IEEE;
 use IEEE.STD_LOGIC_1164.ALL;
 use IEEE.STD_LOGIC_ARITH.ALL;
 use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
 entity mycounterPOS is
     Port ( 
            enable: in std_logic;
            clk: in std_logic; 
            reset: in std_logic;  
            reset2: in std_logic;
            count: out std_logic_vector(0 to 17) 
      );
 end mycounterPOS;
 
 architecture Behavioral of mycounterPOS is
 attribute keep : string;
 signal to_out1: std_logic_vector(0 to 17);
 attribute keep of to_out1 : signal is "true";
 begin
         process(clk,reset)
             begin
             if(rising_edge(clk)) then
                 if(reset2='1')then
                      to_out1 <= conv_std_logic_vector(0, 18);
                 elsif(reset='1') then
                      to_out1 <= conv_std_logic_vector(2, 18);
                 elsif(enable='1') then
                     to_out1 <= to_out1 + 1;
                 end if;
              end if;
         end process;
  count <= to_out1;
 
 end Behavioral;
 ---------------------------------------
 ---------------------------------------
 library IEEE;
 use IEEE.STD_LOGIC_1164.ALL;
 
 entity demux is
 port(
     in1: in std_logic_vector(0 to 17);
     o0: out std_logic_vector(0 to 17);
     o1: out std_logic_vector(0 to 17);
     ctrl: in std_logic
     );
 end demux;
 
 architecture rtl of demux is
 begin
     o0<=in1 when ctrl='0' else (others=>'Z');
     o1<=in1 when ctrl='1' else (others=>'Z');
 end rtl;
 ----------------------------------
 --DEMUX FIGO CHE HA UNA USCITA DA 16
 ----------------------------------
 library IEEE;
 use IEEE.STD_LOGIC_1164.ALL;
 
 entity demuxFIGO is
 port(
     in1: in std_logic_vector(0 to 17);
     o0: out std_logic_vector(0 to 15);
     o1: out std_logic_vector(0 to 17);
     ctrl: in std_logic
     );
 end demuxfigo;
 
 architecture rtl of demuxfigo is
 begin
     o0<=in1(2 to 17) when ctrl='0' else (others=>'Z');
     o1<=in1 when ctrl='1' else (others=>'Z');
 end rtl;
 
 library IEEE;
 use IEEE.STD_LOGIC_1164.ALL;
 
 entity badass_mux is
 port(
     col: in STD_LOGIC_VECTOR(0 to 17);
     riga: in STD_LOGIC_VECTOR(0 to 17);
     pos: in STD_LOGIC_VECTOR(0 to 17);
     ram: in STD_LOGIC_VECTOR(0 to 17);
     control: in STD_LOGIC_VECTOR(0 to 2);
     outy: out STD_LOGIC_VECTOR(0 to 17)
     );
 end badass_mux;
 
 architecture rtl of badass_mux is
 begin
 with control select
     outy<= col when "001",
            riga when "010",
            pos when "011",
            ram when "100",
            (others=>'Z') when others;
 end rtl;
 --------------------------------------------------
 -------------------------------------------------

 ---------------------------------------------
 --------------------------------------------
 library IEEE;
 use IEEE.STD_LOGIC_1164.ALL;
 use ieee.numeric_std.all;
 entity custombank is
     port(
         d:in std_logic_vector(7 downto 0);
         o: out std_logic_vector(17 downto 0)
     );
 end custombank;
 
architecture beh of custombank is
 begin
           o <= std_logic_vector(resize(unsigned(d), o'length)); 
end beh;

  -------------------------------------
  library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  
  entity B_mux is
  port(
    a: in STD_LOGIC_VECTOR(0 to 7);
    b: in STD_LOGIC_VECTOR(0 to 7);
    control: in STD_LOGIC;
    c: out STD_LOGIC_VECTOR(0 to 7)
    );
  end B_mux;
  
  architecture rtl of B_mux is
  begin
  with control select
      c<= a when '0',
          b when others;
  end rtl;
  -----------------------------------------
  ------------------------------------------
  
  --(((((((((((((((((((((((((((((((((((((((((((
  --)))))))))))))))))))))))))))))))))))))))))))
  --((((((((((((((((((((((((((((((((((((((((((
  --))))))))))))))))))))))))))))))))))))))))))))
  library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;
  
  
  entity project_reti_logiche is
  port(
    i_clk         : in  std_logic;
    i_start       : in  std_logic; 
    i_rst         : in  std_logic; 
    i_data        : in  std_logic_vector(7 downto 0);  
    o_address     : out std_logic_vector(15 downto 0); 
    o_done        : out std_logic; 
    o_en          : out std_logic;    
    o_we          : out std_logic; 
    o_data        : out std_logic_vector (7 downto 0)     
    );
  end project_reti_logiche;
  
  architecture box of project_reti_logiche is
  --====================================================
  --===================================================
  --=================================================
  --COMPONENTS======================================
  --COMPONENTS======================================
  --COMPONENTS======================================
  --COMPONENTS======================================
  --==============================================
  --====================================================
  --===================================================
  component FSM is
  port (
          o_done        : out std_logic; 
          o_en          : out std_logic;    
          o_we          : out std_logic; 
        ------------------
        --INPUT
        ------------------
        clk : in std_logic;
        reset : in std_logic;
        flag : in std_logic;
        start : in std_logic;
        ---------------------
        --OUTS
        ---------------------
        ram_address_0: out std_logic_vector(0 to 3);
        ram_address_1: out std_logic_vector(0 to 3);
        ram_wr_en: out std_logic;
        sup1c: out std_logic_vector(0 to 2);
        sup2c: out std_logic_vector(0 to 2);
        d1c: out std_logic;
        d2c: out std_logic;
        d3c: out std_logic; 
        d4c: out std_logic;
        is_msb: out std_logic;
        ---------------------
        ALU_CONTROL:out std_logic_vector(0 to 2);
        enrc: out std_logic;
        encc:out std_logic;
        enpc: out std_logic;
        en_port_0 :out std_logic;
        en_port_1 :out std_logic;
        -----------------------
        --rstcustom :out std_logic;
        rstram :out std_logic;
        rstrega :out std_logic;
        rstregb :out std_logic;
        --rstflag :out std_logic;
        rstresult:out std_logic;
        rstc: out std_logic;
        first_timeo: out std_logic;
        first_timerit: in std_logic;
        rstr: out std_logic;
        rst2: out std_logic
      
    );
  end component;

component FIRSTT is
  port(
      input: in std_logic;
       output: out std_logic;
       clock: in std_logic;
       reset: in std_logic
      );
  end component;

component FATTY is
  port(
      input: in std_logic_vector(0 to 17);
       output: out std_logic_vector(0 to 17);
       clock: in std_logic;
       reset: in std_logic
      );
end component;

component RAM is
port(   
        clk: in std_logic;       
        rst: in std_logic;     
                
        wr_en : in std_logic;        
        data_in : in std_logic_vector(0 to 17);  
        addr_in_0 : in std_logic_vector(0 to 3);    
        addr_in_1 : in std_logic_vector(0 to 3);    
        port_en_0 : in std_logic;   
        port_en_1 : in std_logic;  
        data_out_0 : out std_logic_vector(0 to 17); 
        data_out_1 : out std_logic_vector(0 to 17)   
    );
end component;

component adder is                 
port(
a:in std_logic_vector(0 to 17);       
b:in std_logic_vector(0 to 17);
output:out std_logic_vector(0 to 17)
);
end component;

component multiplier is
port(
a: in std_logic_vector(0 to 17);
b: in std_logic_vector(0 to 17);
output: out std_logic_vector( 0 to 17)
);
end component;

component two_complement is
      port(
          b:in std_logic_vector(0 to 17);
          output: out std_logic_vector(0 to 17)
          );
      end component;
  
component output_one_filter is 
port(
     control:in std_logic_vector(0 to 2);
     almost_final:in std_logic_vector(0 to 17);
     output:out std_logic_vector(0 to 17)
     );
end component;   

component output2_filter is 
port(
     input:in std_logic_vector(0 to 17);
     control:in std_logic_vector(0 to 2);
     output:out std_logic
     );
     end component;
 
 component normalMux is
        port(
               a: in std_logic_vector(0 to 17);
               b: in std_logic_vector(0 to 17);
               control: in std_logic;
               c: out std_logic_vector(0 to 17)
               );
               end component;
 
 component control_MUX is 
          port( 
               a:in std_logic_vector(0 to 17);
               b:in std_logic_vector(0 to 17);
               control:in std_logic_vector(0 to 2);
               output:out std_logic_vector(0 to 17)
               );
               end component;
      

component  mycounter is
     Port ( 
            enable: in std_logic;
            clk: in std_logic; 
            reset: in std_logic;  
            count: out std_logic_vector(0 to 17) 
      );
 end component;
 
  
 component mycounterPOS is
     Port ( 
            enable: in std_logic;
            clk: in std_logic; 
            reset: in std_logic;  
            reset2: in std_logic;
            count: out std_logic_vector(0 to 17) 
      );
 end component;
 
 component demux is
 port(
     in1: in std_logic_vector(0 to 17);
     o0: out std_logic_vector(0 to 17);
     o1: out std_logic_vector(0 to 17);
     ctrl: in std_logic
     );
 end component;
 
 component demuxFIGO is
  port(
      in1: in std_logic_vector(0 to 17);
      o0: out std_logic_vector(0 to 15);
      o1: out std_logic_vector(0 to 17);
      ctrl: in std_logic
      );
  end component;
  
  component badass_mux is
  port(
      col: in STD_LOGIC_VECTOR(0 to 17);
      riga: in STD_LOGIC_VECTOR(0 to 17);
      pos: in STD_LOGIC_VECTOR(0 to 17);
      ram: in STD_LOGIC_VECTOR(0 to 17);
      control: in STD_LOGIC_VECTOR(0 to 2);
      outy: out STD_LOGIC_VECTOR(0 to 17)
      );
  end component;
  
--  component flag is
--  port(
--  clk: in std_logic;
--  rst: in std_logic;
--  d:in std_logic;
--  o: out std_logic
--  );
--  end component;
component custombank is
    port(
        d:in std_logic_vector(7 downto 0);
        o: out std_logic_vector(17 downto 0)
    );
end component; 
     
   component B_mux is
   port(
     a: in STD_LOGIC_VECTOR(0 to 7);
     b: in STD_LOGIC_VECTOR(0 to 7);
     control: in STD_LOGIC;
     c: out STD_LOGIC_VECTOR(0 to 7)
     );
   end component;
      

    --====================================================
    --===================================================
    --=================================================
    --SIGNALS======================================
    --SIGNALS======================================
    --SIGNALS======================================
    --SIGNALS======================================
    --==============================================
    --====================================================
    --===================================================
    signal s1: std_logic_vector ( 0 to 17):=(others=>'0');
    signal s2: std_logic_vector ( 0 to 17):=(others=>'0');
    signal s3: std_logic_vector ( 0 to 17):=(others=>'0');
    signal s4: std_logic_vector ( 0 to 17):=(others=>'0');
    signal s5: std_logic_vector ( 0 to 17):=(others=>'0');
    signal s6: std_logic_vector ( 0 to 17):=(others=>'0');
    signal s7: std_logic_vector ( 0 to 17):=(others=>'0');
    signal s8: std_logic_vector ( 0 to 17):=(others=>'0');
    signal s9: std_logic_vector ( 0 to 17):=(others=>'0');
    signal s10: std_logic_vector ( 0 to 17):=(others=>'0');
    signal s11: std_logic_vector ( 0 to 17):=(others=>'0');
    signal s12: std_logic_vector ( 0 to 17):=(others=>'0');
    signal s13: std_logic_vector ( 0 to 17):=(others=>'0');
    signal s14: std_logic_vector ( 0 to 17):=(others=>'0');
    signal s15: std_logic_vector ( 0 to 17):=(others=>'0');
    signal s16: std_logic_vector ( 0 to 17):=(others=>'0');
    signal s17: std_logic_vector ( 0 to 17):=(others=>'0');
    signal s18: std_logic_vector ( 0 to 17):=(others=>'0');
    signal s18_LSB: std_logic_vector ( 0 to 7):=(others=>'0');
    signal s18_MSB: std_logic_vector ( 0 to 7):=(others=>'0');
    signal s19: std_logic_vector ( 0 to 17):=(others=>'0');
    signal s20: std_logic:='0';
    signal s21: std_logic_vector ( 0 to 17):=(others=>'0');
    signal s22: std_logic_vector ( 0 to 17):=(others=>'0');
    signal s23: std_logic_vector ( 0 to 17):=(others=>'0');
    signal s24: std_logic_vector ( 0 to 17):=(others=>'0');
    signal s25: std_logic_vector ( 0 to 17):=(others=>'0');
    signal s26: std_logic:='0';
    signal s27: std_logic_vector ( 0 to 17):=(others=>'0');
    signal s28: std_logic_vector ( 0 to 17):=(others=>'0'); 
    signal s29: std_logic_vector ( 0 to 17):=(others=>'0');
    signal s30: std_logic_vector ( 0 to 17):=(others=>'0'); 
    signal s31: std_logic_vector ( 0 to 17):=(others=>'0'); 
    signal s32: std_logic;
    
    signal ram_address_0: std_logic_vector(0 to 3):=(others=>'0');
    signal ram_address_1 :std_logic_vector(0 to 3):=(others=>'0');
    signal en_port_0: std_logic:='0';
    signal en_port_1 :std_logic:='0';
    signal ram_wr_en: std_logic:='0';
    
    signal CONTROL: std_logic_vector(0 to 2):=(others=>'0');--per la ALU
    signal sup1c: std_logic_vector(0 to 2):=(others=>'0');
    signal sup2c :std_logic_vector(0 to 2):=(others=>'0');
    signal d1c: std_logic:='0';
    signal d2c: std_logic:='0';
    signal d3c: std_logic:='0';
    signal d4c: std_logic:='0';
    attribute keep : string;
    signal is_msb: std_logic:='0';
    attribute keep of is_msb: signal is "true";
    signal rstc: std_logic:='0';
    signal rstr: std_logic:='0';
    signal rst2: std_logic:='0';
    signal enrc: std_logic:='0';
    signal encc: std_logic:='0';
    signal enpc: std_logic:='0';
    signal first_timeo: std_logic;
    --attribute keep of first_timeo: signal is "true";
    signal first_timerit:  std_logic;
  
    signal rstcustom: std_logic:='0';
    signal rstram: std_logic:='0';
    signal rstrega: std_logic:='0';
    signal rstregb: std_logic:='0';
   -- signal rstflag: std_logic:='0';
    --attribute keep : string;
    signal rstresult: std_logic:='0';
    attribute keep of rstresult: signal is "true";
    
--====================================================
--===================================================
--=================================================
--PORT MAPS=================================================
--PORT MAPS=================================================
--PORT MAPS=================================================
--PORT MAPS=================================================
--==============================================
--====================================================
--===================================================
begin
s18_LSB<=s18(10 to 17);
s18_MSB<=s18(2 to 9);

--componenti della ALU
 u1:multiplier
 port map(a=>s14,b=>s17,output=>s21);
 --u2: central_control_bit 
 --port map(control=>control,output=>s26);
 u3:two_complement
 port map (b=>s17,output=>s25);
 u4:normalMUX
 port map(a=>s17,b=>s25,control=>control(1),c=>s27);
 u5:adder
 port map(a=>s14,b=>s27,output=>s22);
 u6:control_mux
 port map(a=>s22,b=>s21,output=>s28,control=>control);
 u7:output2_filter
 port map(input=>s28,output=>s32,control=>control);
 u8:output_one_filter
 port map(almost_final=>s28,output=>s19,control=>control);

Finite_state: FSM
    port map(
           o_done=>o_done,
           o_en=>o_en, 
           o_we=>o_we, 
         ------------------
         --INPUT
         ------------------
         clk=>i_clk,
         reset=>i_rst,
         flag=>s20,
         start=>i_start,
         ---------------------
         --OUTS
         ---------------------
         ram_address_0=>ram_address_0,
         ram_address_1=>ram_address_1,
         ram_wr_en=>ram_wr_en,
         sup1c=>sup1c,
         sup2c=>sup2c,
         d1c=>d1c,
         d2c=>d2c,
         d3c=> d3c, 
         d4c=>d4c,
         is_msb=> is_msb, --d4c
         ---------------------
         ALU_control=>CONTROL,
         enrc=> enrc,
         encc=> encc,
         enpc=> enpc,
         en_port_0 => en_port_0,
         en_port_1 => en_port_1,
         -----------------------
         --rstcustom => rstcustom,
         rstram  => rstram,
         rstrega  => rstram,
         rstregb  => rstregb,
         --rstflag :out std_logic;
         
         rstresult  => rstresult,
         ----------------------
         first_timeo=>first_timeo,
         first_timerit=>first_timerit,
         rstc => rstc,
         rstr  => rstr,
         rst2  => rst2
        );

SAVE_FLAG: firstt
    port map(input=>s32,output=>s20,reset=>rstr,clock=>i_clk);
    
D1: demux
    port map(in1=>s3,o0=>s7,o1=>s6,ctrl=>d1c);
D2: demux
    port map(in1=>s2,o0=>s8,o1=>s5,ctrl=>d2c);
D3: demuxfigo
    port map(in1=>s1,o0=>o_address,o1=>s4,ctrl=>d3c);
D4: demux
    port map(in1=>s16,o0=>s17,o1=>s18,ctrl=>d4c);
super1: badass_mux
    port map(col=>s6,riga=>s5,pos=>s4,ram=>s9,control=>sup1c,outy=>s13);
super2:badass_mux
    port map(col=>s7,riga=>s8,pos=>s12,ram=>s11,control=>sup2c,outy=>s10);--pos qui è result back e data in è ram
REGA:FATTY
    port map(input=>s13, output=>s14, clock=>i_clk , reset=>rstrega);
REGB:FATTY
    port map(input=>s15, output=>s16, clock=>i_clk , reset=>rstregb);
MUX8B:b_mux
    port map(a=>s18_LSB,b=>s18_MSB,control=>is_msb,c=>o_data);
C_bank:custombank
    port map(o=>s11,d=>i_data);
COL:mycounter
    port map(enable=>encc,clk=>i_clk,reset=>rstc,count=>s3);
RIGA:mycounter
    port map(enable=>enrc,clk=>i_clk,reset=>rstr,count=>s2);
POS:mycounterpos
    port map(enable=>enpc,clk=>i_clk,reset=>rstr,reset2=>rst2,count=>s1);
Ramm: RAM
    port map(
            clk=>i_clk,      
            rst=>rstram,        
            wr_en=>ram_wr_en,        
            data_in=>s10,
            addr_in_0=> ram_address_0,
            addr_in_1=> ram_address_1,  
            port_en_0=>en_port_0,   
            port_en_1=>en_port_1,  
            data_out_0=>s9,
            data_out_1=>s15
            );
--FLAG:

RES: FATTY
    port map(input=>s19, output=>s12, clock=>i_clk , reset=>rstresult);
REGFLAGFIRSTTIME:firstt
    port map(input=>first_timeo,output=>first_timerit,reset=>rstr,clock=>i_clk);

end box;
