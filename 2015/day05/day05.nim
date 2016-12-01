import re

var
  i = 0
  j = 0

for line in lines "day05.input":
  if findAll(line, re"[aeiou]").len > 2 and
     contains(line, re"(\w)\1") and
     not contains(line, re"ab|cd|pq|xy"):
    inc i
  if contains(line, re"(..).*\1") and
     contains(line, re"(.).\1"):
    inc j

echo i
echo j
