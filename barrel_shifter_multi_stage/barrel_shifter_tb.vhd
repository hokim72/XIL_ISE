library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;

entity barrel_shifter_tb is
end barrel_shifter_tb;

architecture tb_arch of barrel_shifter_tb is
	signal test_in_a : std_logic_vector(7 downto 0);
	signal test_in_amt : std_logic_vector(2 downto 0);
	signal test_out_y : std_logic_vector(7 downto 0);
begin
	uut: entity work.barrel_shifter(multi_stage_arch)
		port map(a=>test_in_a, amt=>test_in_amt, y=>test_out_y);
	process
		file infile: text open read_mode is "in.txt";
		file outfile: text open write_mode is "out.txt";
		variable inline, outline, printline: line;
		variable test_in_av : std_logic_vector(7 downto 0);
		variable test_in_amtv : std_logic_vector(2 downto 0);
		variable gooda, goodamt : boolean;
		variable linenumber : integer := 1;
	begin
		if endfile(infile) then
			wait;
		end if;
		if linenumber = 1 then
			write(outline, "# a amt");
			writeline(outfile, outline);
		end if;
		readline(infile, inline);
		if inline(inline'low) /= '#' then
			read(inline, test_in_av, gooda);
			read(inline, test_in_amtv, goodamt);
			if gooda and goodamt then
				test_in_a <= test_in_av;
				test_in_amt <= test_in_amtv;
				wait for 200 ns;
				write(outline, test_in_av);
				write(outline, " ");
				write(outline, test_in_amtv);
				write(outline, " ");
				write(outline, test_out_y);
				writeline(outfile, outline);
			else
				write(printline, "something wrong at line "&integer'image(linenumber)&" at time "&time'image(now));
				writeline(output, printline);
			end if;
		end if;
		linenumber := linenumber + 1;
	end process;
end tb_arch;
