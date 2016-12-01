with open('day03.input') as f:
    s = f.read()

d = {'>': 1, '<': -1, '^': 1j, 'v': -1j}

for part in 1, 2:
    p, loc = {0}, [0, 0]
    for i, m in enumerate(s):
        loc[i % part] += d[m]
        p.add(loc[i % part])
    print(len(p))
