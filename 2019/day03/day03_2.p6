sub step($line) {
    my %wire, my $s = 0, my ($x, $y) = (0, 0);
    for $line.split(',') {
        when /U(\d+)/ { %wire{$x X, $y..($y+$0)} «min=« ($s «+« ^$0); $y += $0, $s += $0 }
        when /D(\d+)/ { %wire{$x X, ($y-$0)..$y} «min=« ($s «+« ^$0); $y -= $0, $s += $0 }
        when /L(\d+)/ { %wire{($x-$0)..$x X, $y} «min=« ($s «+« ^$0); $x -= $0, $s += $0 }
        when /R(\d+)/ { %wire{$x..($x+$0) X, $y} «min=« ($s «+« ^$0); $x += $0, $s += $0 }
    }
    return %wire
}

say ([«+»] lines».&step).values.min
