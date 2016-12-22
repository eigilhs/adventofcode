my \N = 3014387;
my @part1 = 1 .. N +> 1;
my @part2 = N +> 1 ^.. N;

while @part1 {
    @part2.shift;
    @part2.push(@part1.shift);
    @part1.push(@part2.shift) if (@part2 + @part1) %% 2
}

say |@part2
