my @a = '10001001100000001'.comb;
constant $len = 272;

@a = (|@a, 0, |@a.reverse.map(+!+*)) while @a < $len;
@a = @a[^$len];
@a .= map(+(* == *)) while @a %% 2;

say |@a
