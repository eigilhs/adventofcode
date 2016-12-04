for (slurp) ~~ m:g/ (\D+) \- (\d+) \[ (\w+) \] \v / {
    my $b = bag $_[0].comb(/\w/);
    if $b.keys.sort({ (-$b{$_}, $_) })[0..4].join eq $_[2] {
        my $d = $_[0].trans('-a..z' => [' ', |['a'..'z'].rotate($_[1])]);
        say +$_[1] and last if $d ~~ /north/
    }
}
