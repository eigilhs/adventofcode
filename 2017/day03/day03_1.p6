sub MAIN(Int $number=289326) {
    my $root = $number.sqrt.ceiling;
    ++$root if $root %% 2;
    my $r = $root div 2;
    say $r + abs($r - ($number - ($root²-2)²) % ($root-1));
}
