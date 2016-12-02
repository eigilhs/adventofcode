my @keypad = <1 2 3>,
             <4 5 6>,
             <7 8 9>;

my ($x, $y) = 1, 1;

for slurp.comb {
    when 'U' { --$x if $x > 0}
    when 'R' { ++$y if $y < 2}
    when 'D' { ++$x if $x < 2}
    when 'L' { --$y if $y > 0}
    default { print @keypad[$x; $y] }
}

say ''
