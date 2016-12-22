my @s = +«(slurp.chomp.comb.map(* eq '^'));

say [+] gather for ^4E5 {
    take [+] !«@s;
    @s = (?@s[$_-1 ^ $_+1] for ^@s)
}
