import re
import numpy as np

with open('day14.input') as file:
    a = np.array(re.findall(r'\d+', file.read()), dtype=int).reshape((-1, 3))

deer = np.zeros((2, a.shape[0]))

for t in range(1, 2503+1):
    for i, (v, d, r) in enumerate(a):
        q, r = divmod(t, d + r)
        deer[0, i] = v * (q*d + min(r, d))
    deer[1, deer[0] == deer[0].max()] += 1

print(deer.max(1))
