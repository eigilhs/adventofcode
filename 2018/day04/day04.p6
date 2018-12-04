my %guards, my $cg, my $m;

for lines.sort {
    when / '#' (\d+) / { $cg = $0 }
    when / ':' (\d+) .+ 'falls' / { $m = $0 }
    default { / ':' (\d+) /; %guards{$cg} ⊎= $m ..^ $0 }
}

# Part 1
say %guards.max(+*.value).&{ .value.max(*.value).key * .key };
# Part 2
say %guards.max(*.value.values.max).&{ .value.max(*.value).key * .key }
