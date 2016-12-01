with open('day18.input') as file:
    g = [list(map(lambda x: (0, 1)[x=='#'], line.strip())) for line in file]

def neighbors(g, i, j):
    s = 0
    for k in i-1, i, i+1:
        for l in j-1, j, j+1:
            if (k != i or l != j) and k > -1 < l:
                try:
                    s += g[k][l]
                except:
                    pass
    return s

def n(g):
    h = [r[:] for r in g]
    for i in range(len(g)):
        for j in range(len(g[i])):
            n = neighbors(g, i, j)
            if g[i][j] and n != 2 and n != 3:
                h[i][j] = 0
            elif n == 3:
                h[i][j] = 1
    return h
            
m = [r[:] for r in g]

for _ in range(100):
    g[0][0] = g[len(g)-1][0] = g[0][len(g[0])-1] = g[len(g[0])-1][len(g[0])-1] = 1
    m = n(m)
    g = n(g)
g[0][0] = g[len(g)-1][0] = g[0][len(g[0])-1] = g[len(g[0])-1][len(g[0])-1] = 1
print(sum(map(sum, m)))
print(sum(map(sum, g)))
