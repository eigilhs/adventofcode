my @insns = lines».Int;

loop (my $pos = my $steps = 0; $pos < @insns; ++$steps) {
    $pos += @insns[$pos]++
}

say $steps
