use MONKEY-SEE-NO-EVAL;

my $t = <RSHIFT LSHIFT AND OR NOT> => qw{+> +< +& +| +^};

say class md is Hash {
    method AT-KEY($) { callsame.=&{EVAL S:g/(<:L>+)/{self{$0}}/} }
}.new(lines».trans($t)».split(" -> ")».reverse)<a>
