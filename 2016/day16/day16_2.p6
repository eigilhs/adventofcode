my @a = '10001001100000001'.comb;
constant $len = 35651584;

@a = (|@a, 0, |@a.reverse.map(+!+*)) while @a < $len;
@a = @a[^$len];
@a .= map(+(* == *)) while @a %% 2;

say |@a
