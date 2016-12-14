import re
from collections import defaultdict
from hashlib import md5


hashes = defaultdict(list)
indices, pad, i = {}, [], 0

while len(pad) < 64:
    h = md5(b'ihaygndm%d' % i).hexdigest()
    for _ in range(2016):
        h = md5(h.encode()).hexdigest()
    for a in set(re.findall(r'(.)\1{4,}', h)):
        pad += hashes[a]
    if i >= 1000 and i-1000 in indices:
        hashes[indices[i-1000]].pop(0)
    m = re.search(r'(.)\1{2}', h)
    if m:
        hashes[m.group(1)].append(i)
        indices[i] = m.group(1)
    i += 1

print(sorted(pad)[63])
