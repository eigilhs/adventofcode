my %m = lines».split(')')».reverse.Map;
say [+] %m.keys.map: { $_ eq 'COM' ?? 0 !! &?BLOCK(%m{$_}) + 1 }
