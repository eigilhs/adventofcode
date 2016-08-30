from itertools import permutations as ps
from collections import defaultdict

d = defaultdict(lambda: defaultdict(int))
with open('day13.input') as file:
    for line in file:
        a, _, g, n, *_, b = line.rstrip('.\n').split()
        d[b][a] = d[a][b] = int((g == 'lose')*'-' + n) + d[b][a]

for g in d.keys(), d.keys()|{0}:
    print(max(sum(map(lambda a, b: d[a][b], p, p[1:]+p[:1])) for p in ps(g)))
