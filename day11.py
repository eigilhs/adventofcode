from string import ascii_lowercase as alphabet

def to26(n):
    if n < 26:
        return alphabet[n]
    else:
        q, r = divmod(n, 26)
        return to26(q) + alphabet[r]

def from26(n):
    return sum(alphabet.index(c)*26**i for i, c in enumerate(n[::-1]))

def password(pw):
    import re
    n = from26(pw) + 1
    while 1:
        p = to26(n)
        if 'i' in p:
            i = p.index('i')
            p = p[:i] + 'j' + 'a'*(7-i)
            n = from26(p)
        elif 'o' in p:
            i = p.index('o')
            p = p[:i] + 'p' + 'a'*(7-i)
            n = from26(p)
        elif 'l' in p:
            i = p.index('l')
            p = p[:i] + 'm' + 'a'*(7-i)
            n = from26(p)
        if len(re.findall(r'(.)\1', p)) < 2:
            n += 1
            continue
        bp = p.encode('ascii')
        for i in range(0, len(p)-3, 2):
            if bp[i+2]-bp[i+1] == 1 == bp[i+1]-bp[i]:
                break
        else:
            n += 1
            continue
        break
    return to26(n)

pw = password('cqjxjnds')
print(pw, password(pw))
