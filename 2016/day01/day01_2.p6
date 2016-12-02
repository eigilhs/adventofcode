my %visited, my $loc, my $dir = 0, my @dirs = i, 1, -i, -1;

a: for (slurp) ~~ m:g/(.)(\d+)/ {
    $dir = ($dir + (-1, 1)[.head ~~ 'R']) % 4;
    last a if %visited{~($loc += @dirs[$dir])}++ for 1..$_[1]
}

say [+] $loc.reals».abs
