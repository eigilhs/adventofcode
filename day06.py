import numpy, re

g = numpy.zeros((2, 1000, 1000), dtype=int)

with open('day06.input') as file:
    for line in file:
        i, *c = re.search(r'(\w+) (\d+),(\d+).+?(\d+),(\d+)', line).groups()
        x1, y1, x2, y2 = map(int, c)
        r1, r2 = g[:, x1:x2+1, y1:y2+1]
        if i == 'toggle':
            r1.__ixor__(1)
            r2 += 2
        else:
            r1.fill(i == 'on')
            r2 += i == 'on' or -1
            r2[r2 < 0] = 0

print(g.sum((1, 2)))
