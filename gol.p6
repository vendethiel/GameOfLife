#!/usr/bin/env perl6
sub clear {
	$*DISTRO.name eq 'MSWin32' ?? 'cls' !! 'clear'
	==> shell;
}

class Life {
	has @!grid;
	has Int $!dim;

	submethod BUILD(:@!grid) {
    $!dim = @!grid.elems;
	}

	our sub build(Int $dim) {
		Life.new(grid => [Bool.roll($dim)] xx $dim);
	}

	method tick {
		my $prev = self.clone;
		for ^$!dim X ^$!dim -> $y, $x {
      my $neigh = [+] map({ $prev.alive($y + $^i, $x + $^j); }, (-1, 0, +1 X -1, 0, +1)), -$prev.alive($y, $x);
			@!grid[$y][$x] = so do given $prev.alive($y, $x) {
				when 0 { $neigh == 2 | 3 } # currently dead
				when 1 { $neigh == 3	 }   # currently alive
			}
		}
	}

	method alive(Int $y, Int $x --> Bool) {
		0 <= $y <= $!dim && 0 <= $x <= $!dim && @!grid[$y][$x] // False;
	}

	method Str {
    @!grid.map(*.map({$_ ?? "+" !! " "}).join).join("\n")
  }

	method clone {
		self.new(grid => map({ [$^row.clone] }, @!grid));
	}
}

sub MAIN(Int $dim = 8) {
	my Life $life = Life::build($dim);

  loop {
		clear;
		say ~$life;
		$life.tick;
	}
}
