my $loc, my $dir = 0, my @dirs = i, 1, -i, -1;

a: for (slurp) ~~ m:g/(.)(\d+)/ {
    $dir = ($dir + (-1, 1)[.head ~~ 'R']) % 4;
    last a if (%){~($loc += @dirs[$dir])}++ for ^$_[1]
}

say [+] $loc.reals».abs
