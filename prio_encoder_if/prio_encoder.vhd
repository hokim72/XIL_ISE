library ieee;
use ieee.std_logic_1164.all;

entity prio_encoder is
	port(
		r: in std_logic_vector(4 downto 1);
		pcode: out std_logic_vector(2 downto 0)
	);
end prio_encoder;

architecture if_arch of prio_encoder is
begin
	process(r)
	begin
		if (r(4) = '1') then
			pcode <= "100";
		elsif (r(3) = '1') then
			pcode <= "011";
		elsif (r(2) = '1') then
			pcode <= "010";
		elsif (r(1) = '1') then
			pcode <= "001";
		else
			pcode <= "000";
		end if;
	end process;
end if_arch;
