my $polymer = slurp.trim;
my $pairs = ('a'..'z' Z~ 'A'..'Z').&{ |@_, |@_».tclc };

say min gather for 'a' .. 'z' {
    my $prev = 0, my $cur = $polymer.trans([$_, .uc] => '');

    until $cur.chars == $prev {
        $prev = $cur.chars;
        $cur.=trans($pairs => '')
    }

    take $cur.chars
}
