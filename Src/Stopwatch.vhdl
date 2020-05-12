library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Stopwatch is
	port(
		CLOCK_50: in std_logic; -- Clock 
		KEY : in std_logic_vector(1 downto 0);
		D1,D2 : out std_logic := '0'; -- Dots on the seven segment
		HEX5, HEX4, HEX3, HEX2, HEX1, HEX0 : out std_logic_vector(6 downto 0)
	);
end Stopwatch;

architecture behav of Stopwatch is

-- Declare state type
type state_type is (SEC_ON,SEC_OFF);
signal current_state, next_state: state_type;

-- 1 Deci-Second Counter
component Count_Gen 
  port( clk, rstb, en: in std_logic;
        cnt500K: out std_logic);
end component;

-- Counter for DSec0 HEX0
component Cent_Sec0 
  port( clk, rstb, en: in std_logic; 
        cnt9: out std_logic;
        Count : out std_logic_vector(3 downto 0) := "0000"
);
end component;

-- Counter for DSec1 HEX1
component Cent_Sec1 
  port( clk, rstb, en: in std_logic; 
        cnt9: out std_logic;
        Count : out std_logic_vector(3 downto 0) := "0000"
);
end component;

-- Counter for Sec0 HEX2
component Second0 
  port( clk, rstb, en: in std_logic; 
        cnt9: out std_logic;
        Count : out std_logic_vector(3 downto 0) := "0000"
);
end component;


-- Counter for Sec1 HEX3
component Second1 
  port( clk, rstb, en:in std_logic;
        cnt5: out std_logic;
        Count : out std_logic_vector(3 downto 0) := "0000"
);
end component;

	
-- Counter for Min0 HEX4
component Minute0
  port( clk, rstb, en: in std_logic; 
        cnt9: out std_logic;
        Count : out std_logic_vector(3 downto 0) := "0000"
);
end component;
	
-- Counter for Min1 HEX5
component Minute1
  port( clk, rstb, en:in std_logic;
        cnt5: out std_logic;
        Count : out std_logic_vector(3 downto 0) := "0000"
);
end component;

-- Seven Segment Decoder
component Seven_Segment
    port(
        SW : in std_logic_vector(3 downto 0);
        HEX0 : out std_logic_vector(6 downto 0)
    );
end component;


-- Signal Declaration 
signal Main_EN, Min_Reset, G_Reset, EN1, EN2, EN3, EN4,EN5 : std_logic := '0';
signal DSec_0, DSec_1, Sec_0, Sec_1, Min_0, Min_1: std_logic_vector(3 downto 0) := "0000";
signal Start_Clock : std_logic := '1';

begin

G_Reset <= KEY(0) and not Min_Reset;
D1 <= '0';
D2 <= '0';

  Sequential:
  process (CLOCK_50, KEY(1))
  begin
      case current_state is

        when SEC_ON =>
          if KEY(1) = '0' then
            next_state <= SEC_OFF;
          else
            next_state <= SEC_ON;
          end if;

        when SEC_OFF =>
          if KEY(1) = '0' then
            next_state <= SEC_ON;
          else
            next_state <= SEC_OFF;
          end if;

        when others =>
          -- Error case
          next_state <= SEC_ON;  

      end case;
    end process;


    	clock_state_machine:
	process(CLOCK_50)
	begin
	if (CLOCK_50'event and CLOCK_50 = '1') then
	current_state <= next_state;
	end if;
	end process clock_state_machine;
  

	combinational:
	process(CLOCK_50, current_state)
	begin

	if ( CLOCK_50'event and CLOCK_50 = '1') then

	if (current_state = SEC_ON) then
	Start_Clock  <= '1';
	end if;

	if (current_state = SEC_OFF) then
	Start_Clock  <= '0';
	end if;

	end if;
	end process combinational;


-- Port Map Declarations
DSec_Gen  : Count_Gen port map (CLOCK_50, G_Reset, Start_Clock, Main_EN);
DSec_HEX0 : Cent_Sec0 port map (CLOCK_50, G_Reset, Main_EN, EN1, DSec_0);
DSec_HEX1 : Cent_Sec1 port map (CLOCK_50, G_Reset, EN1, EN2, DSec_1);
Sec_HEX2 :  Second0 port map (CLOCK_50, G_Reset, EN2, EN3, Sec_0);
Sec_HEX3 :  Second1 port map (CLOCK_50, G_Reset, EN3, EN4, Sec_1);
Min_HEX4 :  Minute0 port map (CLOCK_50, G_Reset, EN4, EN5, Min_0);
Min_HEX5 :  Minute1 port map (CLOCK_50, G_Reset, EN5, Min_Reset, Min_1);


DSecH_0 : Seven_Segment port map (DSec_0, HEX0);
DSecH_1 : Seven_Segment port map (DSec_1, HEX1);
SecH_0 : Seven_Segment port map (Sec_0, HEX2);
SecH_1 : Seven_Segment port map (Sec_1, HEX3);
MinH_0 : Seven_Segment port map (Min_0, HEX4);
MinH_1 : Seven_Segment port map (Min_1, HEX5);

end behav;
