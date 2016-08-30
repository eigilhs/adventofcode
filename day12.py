with open('day12.input') as file:
    import json, re

    print(sum(map(int, re.findall(r'-?\d+', file.read()))))

    file.seek(0)

    j = json.load(file, object_hook=lambda o: 'red' in o.values() or o)
    print(sum(map(int, re.findall(r'(-?\d+)', str(j)))))
