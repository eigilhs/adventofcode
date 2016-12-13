say sub ($_ is copy) {
    (/'('/ ?? gather while / '(' (\d+) x (\d+) ')' / {
        .=substr($/.to);
        take $/.from + &?ROUTINE(.substr(0, $0)) * $1;
        .=substr($0)
    }.sum !! 0) + .chars
}(slurp.chomp)
