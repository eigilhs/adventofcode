my @elves = 1 .. 3014387;
@elves.shift until @elves.push(@elves.shift) == 1;
say |@elves
