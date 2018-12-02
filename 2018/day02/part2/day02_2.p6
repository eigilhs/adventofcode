my \boxes = lines.combinations(2).first: { ([»-«] $_».ords) ∖ 0 == 1 };
say |boxes».comb.&zip.grep({ [eq] $_ }).&zip[0]
