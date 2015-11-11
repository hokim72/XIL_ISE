library ieee;
use ieee.std_logic_1164.all;
entity decoder_2_4 is
	port(
		a: in std_logic_vector(1 downto 0);
		en: in std_logic;
		y: out std_logic_vector(3 downto 0)
	);
end decoder_2_4;

architecture if_arch of decoder_2_4 is
begin
	process(en, a)
	begin
		if (en = '0') then
			y <= "0000";
		elsif (a = "00") then
			y <= "0001";
		elsif (a = "01") then
			y <= "0010";
		elsif (a = "10") then
			y <= "0100";
		else
			y <= "1000";
		end if;
	end process;
end if_arch;
