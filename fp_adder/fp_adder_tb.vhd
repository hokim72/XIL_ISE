library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;

entity fp_adder_tb is
end fp_adder_tb;

architecture tb_arch of fp_adder_tb is
	signal test_sign1, test_sign2: std_logic;
	signal test_exp1, test_exp2: std_logic_vector(3 downto 0);
	signal test_frac1, test_frac2: std_logic_vector(7 downto 0);
	signal test_sign_out: std_logic;
	signal test_exp_out: std_logic_vector(3 downto 0);
	signal test_frac_out: std_logic_vector(7 downto 0);
begin
	uut: entity work.fp_adder(arch)
		port map(sign1=>test_sign1, sign2=>test_sign2,
				exp1=>test_exp1, exp2=>test_exp2,
				frac1=>test_frac1, frac2=>test_frac2,
				sign_out=>test_sign_out, exp_out=>test_exp_out,
				frac_out=>test_frac_out);
		process
			file infile: text open read_mode is "in.txt";
			file outfile: text open write_mode is "out.txt";
			variable inline, outline, printline: line;
			variable test_sign1v, test_sign2v: std_logic;
			variable test_exp1v, test_exp2v: std_logic_vector(3 downto 0);
			variable test_frac1v, test_frac2v: std_logic_vector(7 downto 0);
			variable goodsign1, goodsign2, goodexp1, goodexp2, goodfrac1, goodfrac2: boolean;
			variable linenumber: integer:=1;
		begin
			if endfile(infile) then
				wait;
			end if;
			if linenumber = 1 then
				write(outline, "# sign1 exp1 frac1 sign2 exp2 frac2 sign_out exp_out frac_out");
				writeline(outfile, outline);
			end if;
			readline(infile, inline);
			if inline(inline'low) /= '#' then
				read(inline, test_sign1v, goodsign1);
				read(inline, test_exp1v, goodexp1);
				read(inline, test_frac1v, goodfrac1);
				read(inline, test_sign2v, goodsign2);
				read(inline, test_exp2v, goodexp2);
				read(inline, test_frac2v, goodfrac2);
				if goodsign1 and goodexp1 and goodfrac1 and goodsign2 and goodexp2 and goodfrac2 then
					test_sign1 <= test_sign1v;
					test_exp1 <= test_exp1v;
					test_frac1 <= test_frac1v;
					test_sign2 <= test_sign2v;
					test_exp2 <= test_exp2v;
					test_frac2 <= test_frac2v;
					wait for 200 ns;
					write(outline, test_sign1v);
					write(outline, " ");
					write(outline, test_exp1v);
					write(outline, " ");
					write(outline, test_frac1v);
					write(outline, " ");
					write(outline, test_sign2v);
					write(outline, " ");
					write(outline, test_exp2v);
					write(outline, " ");
					write(outline, test_frac2v);
					write(outline, " ");
					write(outline, test_sign_out);
					write(outline, " ");
					write(outline, test_exp_out);
					write(outline, " ");
					write(outline, test_frac_out);
					writeline(outfile, outline);
				else
					write(printline, "something wrong at line "&integer'image(linenumber)&" at time "&time'image(now));
					writeline(output, printline);
				end if;
			end if;
			linenumber := linenumber + 1;
		end process;
end tb_arch;
