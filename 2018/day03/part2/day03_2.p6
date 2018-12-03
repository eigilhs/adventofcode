my $lines = lines.cache;
my $seen = $lines».&{ m:g/\d+/; $1..^$1+$3 X+ ($2..^$2+$4)»i }.Bag;

$lines».&{
    m:g/\d+/;
    say +$0 and last if all($seen{$1..^$1+$3 X+ ($2..^$2+$4)»i} »==» 1)
}
