my $a = 0;

for lines».split('-').sort(+*[0]) {
    say $a and last if $a < .[0];
    $a max= 1 + .[1]
}
