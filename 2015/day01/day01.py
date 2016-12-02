with open('day01.input') as f:
    s = f.read()
print(s.count('(')-s.count(')'))

floor = 0
for i, c in enumerate(s, 1):
    floor += {'(': 1, ')': -1}[c]
    if floor == -1:
        break
print(i)
