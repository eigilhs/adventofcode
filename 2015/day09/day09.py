from collections import defaultdict
from itertools import permutations

d = defaultdict(dict)
with open('day09.input') as file:
    for key1, _, key2, _, value in map(str.split, file):
        d[key1][key2] = d[key2][key1] = int(value)

s = [sum(map(lambda a, b: d[a][b], p, p[1:])) for p in permutations(d.keys())]
print(min(s), max(s))
