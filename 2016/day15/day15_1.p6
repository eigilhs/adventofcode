constant @discs = flat (++$+$_[1], +$_[0] for lines.map({m/(\d+)\sp.+\s(\d+)/}));
for (^∞).race(:batch(1E5)) { .say and exit if none(@discs.map((* + $_) % *))};
