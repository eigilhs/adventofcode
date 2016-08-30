from hashlib import md5

for n in 5, 6:
    i = 0
    while '0'*n != md5(b'iwrupvqb%d' % i).hexdigest()[:n]:
        i += 1
    print(i)
