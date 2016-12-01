import re
import random
import numpy as np
from itertools import permutations, repeat

with open('day15.input') as file:
    a = np.array(re.findall(r'-?\d+', file.read()), dtype=int).reshape((-1, 5))

def mut(s, i, j, m=100):
    if not 0 < s[i] < m > s[j] > 0:
        return s
    s = s.copy()
    s[i] += 1
    s[j] -= 1
    return s

def score(s):
    r, r[r < 0] = s @ a[:,:-1], 0
    return r.prod()

def randrec(n):
    r = [n//a.shape[0]]*a.shape[0]
    r[0] += n%a.shape[0]
    return r

def solve(n=100):
    recipe = randrec(n)
    random.shuffle(recipe)
    previous, current = -1E9, score(recipe)
    while previous < current:
        ideas = (mut(recipe, *ij, m=n) for ij in permutations(range(a.shape[0]), 2))
        recipe = max(ideas, key=score)
        previous, current = current, score(recipe)
    return previous

def find():
    r = a[:, -1] - 1
    for i in range(100):
        for j in range(100-i):
            for k in range(100-i-j):
                l = 100-(i+j+k)
                if i*r[0] + j*r[1] + k*r[2] + l*r[3] == 400:
                    yield score((i, j, k, l))

s = 0
while not s:
    s = solve()
print(s)
print(max(find()))
