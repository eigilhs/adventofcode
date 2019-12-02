my @original = slurp.split(',');

hyper for 0..99 X 0..99 {
    my @p = @original;
    @p[1, 2] = $_;
    my $ip = 0;
    while $ip < @p.elems {
        given @p[$ip] {
            when 1 { @p[@p[$ip+3]] = [+] @p[@p[$ip+1, $ip+2]] }
            when 2 { @p[@p[$ip+3]] = [*] @p[@p[$ip+1, $ip+2]] }
            last when 99
        }
        $ip += 4
    }

    say [+] @p[1, 2] »*« (100, 1) and exit if @p[0] == 19_690_720
}
