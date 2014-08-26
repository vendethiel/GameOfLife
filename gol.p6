#!/usr/bin/env perl6
sub clear {
	$*OS eq 'MSWin32' ?? 'cls' !! 'clear'
	==> shell;
}

class Life {
	has @.grid;
	has Int $.dim;

	multi method new(@grid) {
		self.bless(dim => @grid.elems, grid => @grid);
	}

	multi method new(Int $dim) {
		self.new([[True, False].roll($dim)] xx $dim);
	}

	method tick {
		my $prev = self.clone;
		for ^$.dim X ^$.dim -> $y, $x {
			my $neigh = [+] map({ $prev.alive($^y, $^x); }, ($y - 1, $y, $y + 1 X $x - 1, $x, $x + 1)), -$prev.alive($y, $x);
			@.grid[$y][$x] = so do given $prev.alive($y, $x) {
				when 0 { $neigh == 2 | 3 } # currently dead
				when 1 { $neigh == 3	 } # currently alive
			}
		}
	}

	method alive(Int $y, Int $x --> Bool) {
		0 <= $y <= $.dim && 0 <= $x <= $.dim && @.grid[$y][$x] // False;
	}

	method Str { @.grid.map(*.map({$^v ?? "+" !! " "}).join).join("\n") }

	method clone {
		self.new(map({ [$^row.clone] }, @.grid));
	}
}

sub MAIN(Int $dim = 8) {
	my Life $life .= new($dim);

	loop {
		clear;
		say ~$life;
		$life.tick;
	}
}
