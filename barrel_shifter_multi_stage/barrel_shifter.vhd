library ieee;
use ieee.std_logic_1164.all;
entity barrel_shifter is
	port(
		a: in std_logic_vector(7 downto 0);
		amt: in std_logic_vector(2 downto 0);
		y: out std_logic_vector(7 downto 0)
	);
end barrel_shifter;

architecture multi_stage_arch of barrel_shifter is
	signal s0, s1 : std_logic_vector(7 downto 0);
begin
	-- state 0, shift 0 or 1 bit
	s0 <= a(0) & a(7 downto 1) when amt(0) = '1' else
		  a;
	-- state 1, shift 0 or 2 bits
	s1 <= s0(1 downto 0) & s0(7 downto 2) when amt(1) = '1' else
		  s0;
	-- state 2, shift 0 or 4 bits
	y <= s1(3 downto 0) & s1(7 downto 4) when amt(2) = '1' else
	     s1;
end multi_stage_arch;
