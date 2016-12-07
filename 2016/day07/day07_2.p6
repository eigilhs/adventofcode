say [+] gather for (lines) {
    for m:ex/ [\]|^] \w* (\w)(\w)$0 <?{$1 ne $0}> / -> $m {
        take 1 and last if / \[ \w* "$m[1]$m[0]$m[1]" /
    }
}
