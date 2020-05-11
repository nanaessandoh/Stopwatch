-- Counter based on 50 MHz clock that outputs control signals 
-- at 6, with asynchronous reset

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Second1 is
  port( clk, rstb, en:in std_logic;
        cnt5: out std_logic;
        Count : out std_logic_vector(3 downto 0) := "0000"
);
end Second1;

architecture behav of Second1 is
  signal cnt: std_logic_vector(3 downto 0) := "0000";
begin

  -- Clock the counter
  process (clk, rstb)
  begin
   if (rstb = '0') then -- asynchronous active low reset
      cnt <= "0000";
  elsif (clk'event) and (clk = '1') then
      if (en = '1') then
        if (cnt = "0101") then
          cnt5 <= '1';
          cnt <= "0000";
        else
          cnt5 <= '0';
          cnt <= cnt + '1';
        end if;
      else
        cnt <= cnt;
        cnt5 <= '0';
        Count <= cnt;        
      end if;
    end if;
  end process;
  
end behav;
