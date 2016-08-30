with open('silje.input') as file:
    file.readline()
    children = [tuple(map(int, line.split()[1:])) for line in file]
presents = [80, 100, 150, 200, 120, 240, 70, 160, 130, 210]

presents = sorted(presents)
children = sorted(children, key=lambda x: x[1]-x[2])

h = 0
for x, y, z in children:
    for i, present in enumerate(presents):
        if present >= x:
            h += z
            break
    else:
        h += y
    del presents[i]
print(h)
