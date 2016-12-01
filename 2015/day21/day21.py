from itertools import combinations
from collections import namedtuple
import re

with open('day21.input') as file:
    hp, d, a = map(int, re.findall('\d+', file.read()))

boss = namedtuple('Boss', 'hp damage armor')(hp, d, a)

armors = ((0, 0), (13, 1), (31, 2), (53, 3), (75, 4), (102, 5))
weapons = ((8, 4), (10, 5), (25, 6), (40, 7), (74, 8))
rings = ((0, 0, 0), (25, 1, 0), (50, 2, 0), (100, 3, 0),
         (20, 0, 1), (40, 0, 2), (80, 0, 3))

best, worst = 1E9, 0
for weapon in weapons:
    for armor in armors:
        for ring1, ring2 in combinations(rings, 2):
            gold = weapon[0] + armor[0] + ring1[0] + ring2[0]
            if boss.hp // max(1, weapon[1] + ring1[1] + ring2[1] - boss.armor) \
               <= 100 // max(1, boss.damage - armor[1] - ring1[2] - ring2[2]):
                best = gold if gold < best else best
            else:
                worst = gold if gold > worst else worst

print(best, worst)
