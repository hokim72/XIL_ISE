library ieee;
use ieee.std_logic_1164.all;

entity prio_encoder is
	port(
		r: in std_logic_vector(4 downto 1);
		pcode: out std_logic_vector(2 downto 0)
	);
end prio_encoder;

architecture case_arch of prio_encoder is
begin
	process(r)
	begin
		case r is
			when "1000"|"1001"|"1010"|"1011"|
				 "1100"|"1101"|"1110"|"1111" =>
				pcode <= "100";
			when "0100"|"0101"|"0110"|"0111" =>
				pcode <= "011";
			when "0010"|"0011" =>
				pcode <= "010";
			when "0001" =>
				pcode <= "001";
			when others =>
				pcode <= "000";
		end case;
	end process;
end case_arch;
