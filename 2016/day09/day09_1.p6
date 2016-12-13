$_ = slurp.chomp;
say do while / '(' (\d+) x (\d+) ')' / {
    .=substr($/.to + $0);
    $/.from + $0 * $1
}.sum + .chars
