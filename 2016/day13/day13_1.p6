sub clear($x, $y) {
    (1358 + $x² + 3*$x + 2*$x*$y + $y + $y²).base(2).comb.sum %% 2
}

sub neighbors($node) {
    grep { 0 <= all .reals and clear(|.reals) }, $node «+« <1i -1i 1 -1>
}

my @q = 1+i;
my $goal = 31+39i;
my %distance is default(∞);
%distance{@q.head} = 0;

for do @q.shift while @q {
    last when $goal;
    for .&neighbors -> $n {
        if %distance{$_} + 1 < %distance{$n} {
            @q.push($n);
            %distance{$n} = %distance{$_} + 1
        }
    }
}

say %distance{$goal}
