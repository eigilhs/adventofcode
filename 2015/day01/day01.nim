import strutils

const s = slurp "day01.input"

echo s.count('(') - s.count(')')

var floor: int
for i, c in s:
  floor += (if c == '(': 1 else: -1)
  if floor == -1:
    echo i+1
    break
