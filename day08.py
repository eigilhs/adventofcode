with open('day08.input') as file:
    print(sum(len(line.strip()) - len(eval(line)) for line in file))

    file.seek(0)

    from re import escape
    print(sum(len(escape(line.strip()))+2 - len(line.strip()) for line in file))
