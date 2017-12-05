my @insns = lines».Int;

loop (my $pos = my $steps = 0; $pos < @insns; ++$steps) {
    my $c := @insns[$pos];
    $pos += $c > 2 ?? $c-- !! $c++
}

say $steps
