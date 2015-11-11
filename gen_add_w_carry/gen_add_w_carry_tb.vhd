library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;

entity gen_add_w_carry_tb is
end gen_add_w_carry_tb;

architecture tb_arch of gen_add_w_carry_tb is
	signal test_in_a, test_in_b: std_logic_vector(3 downto 0);
	signal test_out_cout: std_logic;
	signal test_out_sum: std_logic_vector(3 downto 0);
begin
	uut: entity work.gen_add_w_carry(arch)
		generic map(N=>4)
		port map(a=>test_in_a, b=>test_in_b, cout=>test_out_cout,
				 sum=>test_out_sum);
	process
		file infile: text open read_mode is "in.txt";
		file outfile: text open write_mode is "out.txt";
		variable inline, outline, printline : line;
		variable test_in_av, test_in_bv: std_logic_vector(3 downto 0);
		variable gooda, goodb: boolean;
		variable linenumber: integer := 1;
	begin
		if endfile(infile) then
			wait;
		end if;
		if linenumber = 1 then
			write(outline, "# a b cout sum");
			writeline(outfile, outline);
		end if;
		readline(infile, inline);
		if inline(inline'low) /= '#' then
			read(inline, test_in_av, gooda);
			read(inline, test_in_bv, goodb);
			if gooda and goodb then
				test_in_a <= test_in_av;
				test_in_b <= test_in_bv;
				wait for 200 ns;
				write(outline, test_in_av);
				write(outline, " ");
				write(outline, test_in_bv);
				write(outline, " ");
				write(outline, test_out_cout);
				write(outline, " ");
				write(outline, test_out_sum);
				writeline(outfile, outline);
			else
				write(printline, "something wrong at line "&integer'image(linenumber)&" at time "&time'image(now));
				writeline(output, printline);
			end if;
		end if;
		linenumber := linenumber + 1;
	end process;
end tb_arch;
