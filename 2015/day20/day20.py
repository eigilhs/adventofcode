from itertools import count

N = 36000000

def presents(n):
    f = {1, n}
    for i in range(2, int(n**.5)+1):
        if not n % i:
            f.add(i)
            f.add(n // i)
    return sum(f)*10

def presents2(n):
    f = set()
    for i in range(1, 50):
        if not n % i:
            f.add(n//i)
    return sum(f)*11

for n in count(1):
    if presents(n) >= N:
        break
print(n)

for n in count(1):
    if presents2(n) >= N:
        break
print(n)
