def look(s):
    si = iter(s+'x')
    p = next(si)
    n, r = 1, ''
    for c in si:
        if p != c:
            r += str(n)+p
            n = 1
        else:
            n += 1
        p = c
    return r

s = '1321131112'
for i in range(40):
    s = look(s)
print(len(s))
for i in range(10):
    s = look(s)
print(len(s))
