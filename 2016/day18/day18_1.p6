my @s = +«(slurp.chomp.comb.map(* eq '^'));

say [+] gather for ^40 {
    take [+] !«@s;
    @s = (?@s[$_-1 ^ $_+1] for ^@s)
}
