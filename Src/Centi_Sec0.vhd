-- Counter based on 50 MHz clock that outputs control signals 
-- at 10, with asynchronous reset and

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Cent_Sec0 is
  port( clk, rstb, en: in std_logic; 
        cnt9: out std_logic;
        Count : out std_logic_vector(3 downto 0) := "0000"
);
end Cent_Sec0;

architecture behav of Cent_Sec0 is
  signal cnt: std_logic_vector(3 downto 0) := "0000";
begin

  -- Clock the counter
  process (clk, rstb)
  begin
    if (rstb = '0') then -- synchronous active low reset
      cnt <= "0000";
   elsif (clk'event) and (clk = '1') then
      if (en = '1') then
        if (cnt = "1001") then
          cnt9 <= '1';
          cnt <= "0000";
        else
          cnt9 <= '0';
          cnt <= cnt + '1';
        end if;
      else
        cnt <= cnt;
        cnt9 <= '0';
	Count <= cnt;        
      end if;
    end if;
  end process;
  
end behav;