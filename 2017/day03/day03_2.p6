sub is-corner($n is copy) {
    my $root = (--$n).sqrt.ceiling;
    ($n - $root²) %% $root
}

sub MAIN(Int $input-number=289326) {
    my $pos = 0i;
    my $direction = 1;
    my %grid is default(0);
    %grid{$pos} = 1;

    for 2..∞ {
        $pos += $direction;
        $direction *= -i if .&is-corner;
        %grid{$pos} = [+] %grid{$pos «+« <-1-1i 1-1i 1+1i -1+1i -1i 1i -1 1>};
        say %grid{$pos} and last if %grid{$pos} > $input-number
    }
}
