library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;

entity eq2_tb is
end eq2_tb;

architecture tb_arch of eq2_tb is
	signal test_in0, test_in1: std_logic_vector(1 downto 0);
	signal test_out: std_logic;
begin
	-- instantiate the circuit under test
	uut: entity work.eq2(struc_arch)
		port map(a=>test_in0, b=>test_in1, aeqb=>test_out);
	-- test vector generator
	process
		file infile : text open read_mode is "in.txt"; 
		file outfile : text open write_mode is "out.txt";
		variable inline, outline, printline : line; 
		variable test_in0v, test_in1v : std_logic_vector(1 downto 0);
		variable gooda, goodb : boolean;
		variable linenumber : integer := 1;
	begin
		if linenumber = 1 then
			write(printline, "#a b aeqb");
			writeline(outfile, printline);
		end if;
		if endfile(infile) then
			wait; 
		end if;
		readline(infile, inline);
		if inline(inline'low) /= '#' then
			read(inline, test_in0v, gooda);
			read(inline, test_in1v, goodb);
			if gooda and goodb then
				test_in0 <= test_in0v;
				test_in1 <= test_in1v;
				wait for 200 ns;
				write(outline, test_in0);
				write(outline, " ");
				write(outline, test_in1);
				write(outline, " ");
				write(outline, test_out);
				writeline(outfile, outline);
			else
				write(printline, "something wrong at line "&integer'image(linenumber));
				writeline(output, printline);
				wait; 
			end if;
		end if; 
		linenumber := linenumber + 1;
	end process;
end tb_arch;
