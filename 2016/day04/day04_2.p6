for (slurp) ~~ m:g/ (\S+) \- (\d+) \[ (\w+) \] / {
    my $b = bag $_[0].comb(/\w/);
    if $b.keys.sort({ (-$b{$_}, $_) })[^5].join eq $_[2] {
        my $d = $_[0].trans('-a..z' => [' ', |['a'..'z'].rotate($_[1])]);
        say +$_[1] and last if $d ~~ /north/
    }
}
