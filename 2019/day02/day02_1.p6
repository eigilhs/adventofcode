my @p = slurp.split(',');

@p[1, 2] = 12, 2;

my $ip = 0;
while $ip < @p.elems {
    given @p[$ip] {
        when 1 { @p[@p[$ip+3]] = [+] @p[@p[$ip+1, $ip+2]] }
        when 2 { @p[@p[$ip+3]] = [*] @p[@p[$ip+1, $ip+2]] }
        last when 99
    }
    $ip += 4;
}

say @p[0];
