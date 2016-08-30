from itertools import combinations, accumulate, takewhile

with open('day17.input') as file:
    s = sorted(map(int, file.read().split()))

def r(s):
    def take(s):
        return len(list(takewhile(lambda x: x < 150, accumulate(s))))
    return range(take(s[::-1]), take(s)+1)

v = [len(c) for i in r(s) for c in combinations(s, i) if sum(c) == 150]

print(len(v), v.count(min(v)))
