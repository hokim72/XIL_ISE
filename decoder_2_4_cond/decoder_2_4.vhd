library ieee;
use ieee.std_logic_1164.all;
entity decoder_2_4 is
	port(
		a: in std_logic_vector(1 downto 0);
		en: in std_logic;
		y: out std_logic_vector(3 downto 0)
	);
end decoder_2_4;

architecture cond_arch of decoder_2_4 is
begin
	y <= "0000" when (en = '0') else
		 "0001" when (a = "00") else
		 "0010" when (a = "01") else
		 "0100" when (a = "10") else
		 "1000"; -- a = "11"
end cond_arch;
