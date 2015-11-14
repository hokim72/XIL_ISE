library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;

entity d_ff_en_tb is
end d_ff_en_tb;

architecture tb_arch of d_ff_en_tb is
	constant T: time := 20 ns;
	signal clk: std_logic;
	signal reset: std_logic;
	signal en: std_logic := '0';
	signal d: std_logic := '0';
	signal q: std_logic;
begin
	d_ff_en_unit: entity work.d_ff_en(two_seg_arch)
		port map(clk=>clk, reset=>reset, en=>en, d=>d, q=>q);

	-- clock
	process
	begin
		clk <= '0';
		wait for T/2;
		clk <= '1';
		wait for T/2;
	end process;
	-- reset
	reset <= '1', '0' after T/2;

	process
		file infile: text open read_mode is "in.txt";
		variable inline, printline: line;
		variable tpv: real:= 0.0;
		variable tv: real;
		variable env: std_logic;
		variable dv: std_logic;
		variable goodt, gooden, goodd: boolean;
		variable linenumber: integer := 1;
	begin
		if endfile(infile) then
			wait for T;
			assert false
				report "Simulation Completed"
			severity failure;
		end if;
		readline(infile, inline);
		if inline(inline'low) /= '#' then
			read(inline, tv, goodt);
			read(inline, env, gooden);
			read(inline, dv, goodd);
			if goodt and gooden and goodd then 
				wait for (tv-tpv) * 1 ns;
				en <= env;
				d <= dv;
				tpv := tv;
			else
				write(printline, "something wrong at line "&integer'image(linenumber)&" at time "&time'image(now));
				writeline(output, printline);
			end if;
		end if;
		linenumber := linenumber + 1;
	end process;
	process
		file outfile: text open write_mode is "out.txt";
		variable outline: line;
		variable linenumber: integer := 1;
	begin
		if linenumber = 1 then 
			write(outline, "# time timeunit q");
			writeline(outfile, outline);
		end if;
		wait until q'event;
		write(outline, now);
		write(outline, " ");
		write(outline, q);
		writeline(outfile, outline);
		linenumber := linenumber + 1;
	end process;
end tb_arch;
