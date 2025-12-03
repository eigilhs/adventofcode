say [+] lines».comb.map: {
        my (\x, \y) = @_[0..*-2].max(:p).head.kv;
        y~@_[x^..*].max
}
