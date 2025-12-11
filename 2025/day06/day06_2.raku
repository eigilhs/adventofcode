my ($op, $x);

say (0, |([Z] lines».comb)».join, '').reduce: -> $a, $b {
    if $b ~~ m/ (\d+) \s* ( \* {$op = &[*]} || \+ {$op = &[+]} )? / {
	$x = $/[1] ?? $/[0] !! $op($x, $b);
	$a
    } else {
	$a + $x
    }
}
