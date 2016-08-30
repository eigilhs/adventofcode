m = []
with open('day19.input') as file:
    for line in file:
        if line != '\n':
            m.append(line.strip().split(' => '))
        else:
            t = next(file).strip()

p = set()
for c, r in m:
    i = t.find(c)
    while i != -1:
        p.add(hash(t[:i] + t[i:].replace(c, r, 1)))
        i = t.find(c, i+1)
print(len(p))

a = -1
for i, c in enumerate(t):
    if c.isupper():
        a += 1
    if t[i:i+2] in ('Rn', 'Ar'):
        a -= 1
    if c == 'Y':
        a -= 2
print(a)
