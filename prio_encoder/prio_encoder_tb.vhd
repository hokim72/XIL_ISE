library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;

entity prio_encoder_tb is
end prio_encoder_tb;

architecture tb_arch of prio_encoder_tb is
	signal test_in: std_logic_vector(4 downto 1);
	signal test_out: std_logic_vector(2 downto 0);
begin
	uut: entity work.prio_encoder(cond_arch)
		port map(r=>test_in, pcode=>test_out);
	process
		file infile: text open read_mode is "in.txt";
		file outfile: text open write_mode is "out.txt";
		variable inline, outline, printline : line;
		variable test_inv : std_logic_vector(4 downto 1);
		variable goodr : boolean;
		variable linenumber : integer := 1;
	begin
		if endfile(infile) then
			wait;
		end if;
		if linenumber = 1 then
			write(outline, "# r pcode");
			writeline(outfile, outline);
		end if;
		readline(infile, inline);
		if inline(inline'low) /= '#' then
			--hread(inline, test_inv, goodr);
			read(inline, test_inv, goodr);
			if goodr then
				test_in <= test_inv;
				wait for 200 ns;
				--write(outline, string'("0x"));
				--hwrite(outline, test_inv);
				write(outline, test_inv);
				write(outline, " ");
				write(outline, test_out);
				writeline(outfile, outline);
			else
				write(printline, "something wrong at line "&integer'image(linenumber)&" at time "&time'image(now));
				writeline(output, printline);
				wait;
			end if;
		end if;
		linenumber := linenumber + 1;
	end process;
end tb_arch;

