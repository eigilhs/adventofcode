my $a = 0;

say [+] gather for lines».split('-').sort(+*[0]) {
    take .[0] - $a max 0;
    $a max= 1 + .[1]
}
