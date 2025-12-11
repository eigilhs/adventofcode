say [+] ([Z] lines».words).map: {
    reduce (&[*], &[+])[.tail ~~ '+'], $_[0..*-2]
}
