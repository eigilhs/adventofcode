from re import search, findall

with open('day05.input') as file:
    print(sum(bool(2 < len(findall('[aeiou]', line))
                   and search(r'(\w)\1', line)
                   and not search('ab|cd|pq|xy', line)) for line in file))
    file.seek(0)
    print(sum(bool(search(r'(..).*\1', line) and
                   search(r'(.).\1', line)) for line in file))
