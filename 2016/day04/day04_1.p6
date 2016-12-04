say [+] do for (slurp) ~~ m:g/ (\D+) \- (\d+) \[ (\w+) \] \v / {
    my $b = bag $_[0].comb(/\w/);
    $_[1] if $b.keys.sort({ (-$b{$_}, $_) })[0..4].join eq $_[2]
}
