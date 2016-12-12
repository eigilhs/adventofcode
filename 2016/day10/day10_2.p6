my %bots;
my %outs;
my $lines = slurp;

for $lines ~~ m:g/ (\d+) ' gives' .+? (\w+) \s (\d+) .+? (\w+) \s (\d+) / {
    %bots{$_[0]} = {
        state @chips.push($^a) .= sort;
        if @chips == 2 {
            for $_[4 ... 1] -> $a, $b {
                if $b eq 'bot' {
                    %bots{$a}(@chips.pop)
                } else {
                    %outs{$a} = @chips.pop
                }
            }
        }
    }
}

for $lines ~~ m:g/ 'value ' (\d+) \D+ (\d+) / {
    %bots{$_[1]}(+$_[0])
}

say [*] %outs{0, 1, 2}
