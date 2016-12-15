my @discs = (++$+$_[1], +$_[0] for lines.map({m/(\d+)\sp.+\s(\d+)/}));
@discs.push((@discs + 1, 11));

A: for ^∞ -> $t {
    next A if (.[0] + $t) % .[1] for @discs;
    say $t and last;
}
