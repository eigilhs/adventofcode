say [+] gather for (lines) {
    next if / \[ \w* (\w)(\w)$1$0 <?{$0 ne $1}> /;
    take 1 if / [\]|^] \w* (\w)(\w)$1$0 <?{$0 ne $1}> /
}
