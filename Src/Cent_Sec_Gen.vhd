-- Counter based on 50 MHz clock that outputs control signal representing 1 decisecond
-- at 50M, with asynchronous reset and

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity Count_Gen is
  port( clk, rstb, en: in std_logic;
        cnt500K: out std_logic);
end Count_Gen;

architecture behav of Count_Gen is
  signal cnt: std_logic_vector(18 downto 0) := "0000000000000000000";
begin

  -- Clock the counter
  process (clk, rstb)
  begin

    if (rstb = '0') then -- asynchronous active low reset
        cnt <= "0000000000000000000";
    elsif (clk'event) and (clk = '1') then
      if (en = '1') then 
        if (cnt = "1111010000100100000") then -- Uncomment for FPGA board simulations
      --  if (cnt = "0000000000000000010") then -- Uncomment this line for testbench
          cnt500K <= '1';
          cnt <= "0000000000000000000";
        else
          cnt500K <= '0';
          cnt <= cnt + '1';
        end if;
      else
        cnt <= cnt;
        cnt500K <= '0';        
      end if;
    end if;
  end process;
  
end behav;
