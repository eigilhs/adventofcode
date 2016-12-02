my @keypad = <0 0 1 0 0>,
             <0 2 3 4 0>,
             <5 6 7 8 9>,
             <0 A B C 0>,
             <0 0 D 0 0>;

my ($x, $y) = 2, 0;

for slurp.comb {
    when 'U' { --$x if @keypad[$x-1; $y] }
    when 'R' { ++$y if @keypad[$x; $y+1] }
    when 'D' { ++$x if @keypad[$x+1; $y] }
    when 'L' { --$y if @keypad[$x; $y-1] }
    default { print @keypad[$x; $y] }
}

say ''
