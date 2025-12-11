say [+] lines».comb.map: -> @a {
    my $i = 0;
    [~] do for 12...1 {
        $i += @a[$i..*-$_].max(:k).head;
        @a[$i++];
    }
}
