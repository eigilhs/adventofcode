sub step($line) {
    my %wire, my ($x, $y) = (0, 0);
    for $line.split(',') {
        when /U(\d+)/ { %wire{$x X, $y..($y+$0)} = True xx $0; $y += $0 }
        when /D(\d+)/ { %wire{$x X, ($y-$0)..$y} = True xx $0; $y -= $0 }
        when /L(\d+)/ { %wire{($x-$0)..$x X, $y} = True xx $0; $x -= $0 }
        when /R(\d+)/ { %wire{$x..($x+$0) X, $y} = True xx $0; $x += $0 }
    }
    return %wire
}

say ([∩] lines».&step).keys.map({ [+] .words».abs }).sort[1]
