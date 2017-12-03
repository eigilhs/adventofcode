say [+] lines».words.map({[/] .combinations(2)».sort(-*).grep({[%%] .cache}).flat})
