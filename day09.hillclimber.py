import sys
from collections import defaultdict

sys.path.append('../inf4490/oblig1/')
from tsp_solvers import Route, HillClimber

d = defaultdict(dict)
with open('day9.input') as file:
    for key1, _, key2, _, value in map(str.split, file):
        d[key1][key2] = d[key2][key1] = int(value)

solver = HillClimber(Route(d))
print(solver.solve(50)[1])

class LongRoute(Route):
    def length(self):
        return 1 / super().length()

solver = HillClimber(LongRoute(d))
print(int(1/solver.solve(50)[1]))
