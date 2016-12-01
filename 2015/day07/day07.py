import re

class md(dict):
    def __getitem__(self, key):
        self[key] = value = eval(str(super().get(key)), self)
        return value

t = {'RSHIFT': '>>', 'LSHIFT': '<<', 'AND': '&', 'OR': '|', 'NOT': '~'}
d = {}

with open('day07.input') as f:
    for line in f:
        line = re.sub('|'.join(t.keys()), lambda m: t[m.group(0)], line)
        k, d[k] = line.upper().strip().split(' -> ')[::-1]

d1, d2 = md(d), md(d)
d2['B'] = d1['A']
print(d1['A'], d2['A'])
