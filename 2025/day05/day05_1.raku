my ($a, $b) = slurp.trim.split: /\n\n/;
my @fresh = $a.&{m:g/(\d+)\-(\d+)/}».&{$_[0]..$_[1]};

say [+] $b.lines».&{ ?[|] @fresh.map($_ ~~ *) }
