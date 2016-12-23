use MONKEY-SEE-NO-EVAL;

class md is Hash {
    method AT-KEY($) { callsame.=&{(S:g/(<:L>+)/{self{$0}}/).EVAL} }
}

my $t = <RSHIFT LSHIFT AND OR NOT> => qw{+> +< +& +| +^};
my %a = lines».trans($t)».split(" -> ")».reverse.flat;
my $h1 = md.new(%a);
my $h2 = md.new(%a);
$h2<b> = $h1<a>;
say $h2<a>
