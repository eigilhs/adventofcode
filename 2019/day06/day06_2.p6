my %m = lines».split(')')».reverse.Map;
say +[⊖] <YOU SAN>.map: { %m{$_}, {%m{$_}} ... 'COM' }
