use NativeCall;
use experimental :pack;

sub MD5(Buf, size_t, Buf is rw) is native('ssl') { * }
sub md5($str) {
    my $b = buf8.new(0 xx 16);
    MD5($str.encode, $str.codes, $b);
    $b.unpack('H*')
}

my @dirs = (-i, i, -1, 1) Zbut <U D L R>;

sub neighbors($cur) {
    ((@dirs Z md5("edjrjqaa$cur").comb).grep(*[1] gt 'a')[*; 0]
     .map({$cur + $_ but $cur ~ $_}).grep({0 <= all(.reals) < 4}))
}

my @q = 0 but '',;

until ($_ = @q.shift) == 3+3i {
    @q.push($_) for .&neighbors
}

.say
