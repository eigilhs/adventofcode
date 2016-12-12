my %bots;
my $lines = slurp;

for $lines ~~ m:g/ (\d+) ' gives' .+? (\w+) \s (\d+) .+? (\w+) \s (\d+) / {
    %bots{$_[0]} = {
        state @chips.push($^a) .= sort;
        if @chips == 2 {
            say +$_[0] if @chips[0] == 17 and @chips[1] == 61;
            {%bots{$^a}(@chips.pop) if $^b eq 'bot'} for $_[4 ... 1];
        }
    }
}

for $lines ~~ m:g/ 'value ' (\d+) \D+ (\d+) / {
    %bots{$_[1]}(+$_[0])
}
