my @p = slurp.split(',');

my $ip = 0;
while @p[$ip++].flip -> $_ {
    my ($arg1, $arg2);
    when / ^ (<-[39]>) / {
        $arg1 = .comb[2] eqv '1' ?? @p[$ip++] !! @p[@p[$ip++]];
        $arg2 = .comb[3] eqv '1' ?? @p[$ip++] !! @p[@p[$ip++]] unless $0 == 4;
        proceed
    }
    when / ^ 1 / { @p[@p[$ip++]] = $arg1 + $arg2 }
    when / ^ 2 / { @p[@p[$ip++]] = $arg1 * $arg2 }
    when / ^ 3 / { @p[@p[$ip++]] = 5 }
    when / ^ 4 / { say $arg1 }
    when / ^ 5 / { $ip = $arg2 if $arg1 != 0 }
    when / ^ 6 / { $ip = $arg2 if $arg1 == 0 }
    when / ^ 7 / { @p[@p[$ip++]] = +($arg1 < $arg2) }
    when / ^ 8 / { @p[@p[$ip++]] = +($arg1 == $arg2) }
    last when / ^ 99 /
}
