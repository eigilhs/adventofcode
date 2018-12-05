say +slurp.trim.ords.reduce: {
    +$^a && abs($^a.tail - $^b) == 32 ?? $^a[^(*-1)] !! (|$^a, $^b)
}
