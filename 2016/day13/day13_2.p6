sub clear($x, $y) {
    (1358 + $x² + 3*$x + 2*$x*$y + $y + $y²).base(2).comb.sum %% 2
}

my $start = 1+i;
my @q = [$start];
my %visited = $start => True;

sub neighbors($node) {
    $node «+« <1i -1i 1 -1>
        ==> grep({ 0 <= all .reals and clear(|.reals) })
        ==> grep(~* ∉ %visited)
}

my $moves = 0;
my ($i, $j) = 1, 0;

for do neighbors(@q.shift) while @q {
    $j += @_;
    for @_ {
        @q.push($_);
        %visited{$_} = True;
    }
    if --$i == 0 {
        last if ++$moves == 50;
        ($i, $j) = $j, 0;
    }
}

say +%visited
