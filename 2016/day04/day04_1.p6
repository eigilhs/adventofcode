say [+] do for (slurp) ~~ m:g/ (\S+) \- (\d+) \[ (\w+) \] / {
    my $b = bag $_[0].comb(/\w/);
    $_[1] if $b.keys.sort({ (-$b{$_}, $_) })[^5].join eq $_[2]
}
