library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;

entity decoder_2_4_tb is
end decoder_2_4_tb;

architecture tb_arch of decoder_2_4_tb is
	signal test_in_a : std_logic_vector(1 downto 0);
	signal test_in_en : std_logic;
	signal test_out : std_logic_vector(3 downto 0);
begin
	uut: entity work.decoder_2_4(if_arch)
		port map(a=>test_in_a, en=>test_in_en, y=>test_out);
	process
		file infile: text open read_mode is "in.txt";
		file outfile: text open write_mode is "out.txt";
		variable inline, outline, printline : line;
		variable test_in_av : std_logic_vector(1 downto 0);
		variable test_in_env : std_logic;
		variable gooda, gooden : boolean;
		variable linenumber : integer := 1;
	begin
		if endfile(infile) then
			wait;
		end if;
		if linenumber = 1 then
			write(outline, "# a en y");
			writeline(outfile, outline);
		end if;
		readline(infile, inline);
		if inline(inline'low) /= '#' then
			read(inline, test_in_av, gooda);
			read(inline, test_in_env, gooden);
			if gooda and gooden then
				test_in_a <= test_in_av;
				test_in_en <= test_in_env;
				wait for 200 ns;
				write(outline, test_in_av);
				write(outline, " ");
				write(outline, test_in_env);
				write(outline, " ");
				write(outline, test_out);
				writeline(outfile, outline);
			else
				write(printline, "something wrong at line "&integer'image(linenumber)&" at time "&time'image(now));
				writeline(output, printline);
			end if;
		end if;
		linenumber := linenumber + 1;
	end process;
end tb_arch;
