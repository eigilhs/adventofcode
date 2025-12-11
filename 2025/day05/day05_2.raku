my @ranges = slurp.&{m:g/(\d+)\-(\d+)/}».&{$_[0]..$_[1]};

my $n = 0;
say @ranges.sort.reduce(-> $a, $b {
    when $b ~~ $a { $a }
    when $a.max >= $b.min { $a.min..$b.max }
    default {
        $n += $a.elems;
        $b
    }
}).elems + $n;
