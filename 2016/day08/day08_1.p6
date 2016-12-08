my @screen = [0 xx 50] xx 6;

for (lines) {
    when / rect \h (\d+) x (\d+) / {
        @screen[^$1; ^$0] = 1 xx $0*$1
    }

    when / row \h y \= (\d+) \h by \h (\d+) / {
        @screen[$0] .= rotate(-$1)
    }

    when / column \h x \= (\d+) \h by \h (\d+) / {
        @screen[*; $0] .= rotate(-$1)
    }
}

say @screen».sum.sum
