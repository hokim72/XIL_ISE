library ieee;
use ieee.std_logic_1164.all;
entity decoder_2_4 is
	port(
		a: in std_logic_vector(1 downto 0);
		en: in std_logic;
		y: out std_logic_vector(3 downto 0)
	);
end decoder_2_4;

architecture sel_arch of decoder_2_4 is
	signal s: std_logic_vector(2 downto 0);
begin
	s <= en & a;
	with s select
		y <= "0000" when "000"|"001"|"010"|"011",
		     "0001" when "100",
			 "0010" when "101",
			 "0100" when "110",
			 "1000" when others; -- s="111"
end sel_arch;
