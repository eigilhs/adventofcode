my @p = slurp.split(',');

my $ip = 0;
while @p[$ip++].flip -> $_ {
    my ($arg1, $arg2);
    when / ^ (<[124]>) / {
        $arg1 = .comb[2] eqv '1' ?? @p[$ip++] !! @p[@p[$ip++]];
        $arg2 = .comb[3] eqv '1' ?? @p[$ip++] !! @p[@p[$ip++]] unless $0 == 4;
        proceed
    }
    when / ^ 1 / { @p[@p[$ip++]] = $arg1 + $arg2 }
    when / ^ 2 / { @p[@p[$ip++]] = $arg1 * $arg2 }
    when / ^ 3 / { @p[@p[$ip++]] = 1 }
    when / ^ 4 / { say $arg1 }
    last when / ^ 99 /
}
