def dims(line):
    return sorted(map(int, line.split('x')))

with open('day02.input') as file:
    print(sum(3*l*w + 2*h*w + 2*h*l for l, w, h in map(dims, file)))

    file.seek(0)

    print(sum(2*l + 2*w + l*w*h for l, w, h in map(dims, file)))
