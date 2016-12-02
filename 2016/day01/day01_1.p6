my @loc = 0, 0;
my @d = 1, 0;

for (slurp) ~~ m:g/(.)(\d+)/ {
    @loc »+=« (@d = @d[1,0] Z* (1, -1; -1, 1)[.head ~~ 'R']) »*» .tail
}

dd [+] @loc».abs
