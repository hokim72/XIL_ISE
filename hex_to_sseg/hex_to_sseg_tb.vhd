library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;

entity hex_to_sseg_tb is
end hex_to_sseg_tb;

architecture tb_arch of hex_to_sseg_tb is
	signal test_in_hex: std_logic_vector(3 downto 0);
	signal test_in_dp: std_logic;
	signal test_out_sseg: std_logic_vector(7 downto 0);
begin
	uut: entity work.hex_to_sseg(arch)
		port map(hex=>test_in_hex, dp=>test_in_dp, sseg=>test_out_sseg);
	process
		file infile: text open read_mode is "in.txt";
		file outfile: text open write_mode is "out.txt";
		variable inline, outline, printline: line;
		variable test_in_hexv: std_logic_vector(3 downto 0);
		variable test_in_dpv: std_logic;
		variable goodhex, gooddp: boolean;
		variable linenumber: integer:= 1;
	begin
		if endfile(infile) then
			wait;
		end if;
		if linenumber = 1 then
			write(outline, "# hex dp sseg");
			writeline(outfile, outline);
		end if;
		readline(infile, inline);
		if inline(inline'low) /= '#' then
			read(inline, test_in_hexv, goodhex);
			read(inline, test_in_dpv, gooddp);
			if goodhex and gooddp then
				test_in_hex <= test_in_hexv;
				test_in_dp <= test_in_dpv;
				wait for 200 ns;
				write(outline, test_in_hexv);
				write(outline, " ");
				write(outline, test_in_dpv);
				write(outline, " ");
				write(outline, test_out_sseg);
				writeline(outfile, outline);
			else
				write(printline, "something wrong at line "&integer'image(linenumber)&" at time "&time'image(now));
				writeline(output, printline);
			end if;
		end if;
		linenumber := linenumber + 1;
	end process;
end tb_arch;
