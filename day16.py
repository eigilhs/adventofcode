from re import findall

with open('day16.input') as file:
    sues = [{k: int(v) for k, v in findall('(\w+): (\d+),?', l)} for l in file]

signature = {'children': 3, 'cats': 7, 'samoyeds': 2, 'pomeranians': 3,
             'akitas': 0, 'vizslas': 0, 'goldfish': 5, 'trees': 3,
             'cars': 2, 'perfumes': 1}

for sue in sues:
    for compound in sue.keys() & signature:
        if sue[compound] != signature[compound]:
            break
    else:
        print(sues.index(sue)+1)

for sue in sues:
    for compound in sue.keys() & signature:
        if compound in {'cats', 'trees'}:
            if sue[compound] <= signature[compound]:
                break
        elif compound in {'pomeranians', 'goldfish'}:
            if sue[compound] >= signature[compound]:
                break
        elif sue[compound] != signature[compound]:
            break
    else:
        print(sues.index(sue)+1)
