import math

def generate_arctan_table(num_points):
    table = []
    t = 1

    for i in range(num_points):
        x = math.atan(t)
        t = t/2
        table.append(x)
    return table

def cordiac_algorithm(N, angle):
    x = []
    y = []
    z = []
    x.append(1)
    y.append(0)
    z.append(angle)
    angles_table = generate_arctan_table(N)
    for i in range(N):
        if (z[i] < 0):
            znak = -1
        else:
            znak = 1

        x.append(x[i] - znak*(2**-i)*y[i])
        y.append(y[i] + znak*(2**-i)*x[i])
        z.append(z[i] - znak*angles_table[i])

    return z[len(z)-1], x[len(x)-1], y[len(y)-1]

# przykładowe użycie
N = 15
K = 0.6072 #scaling factor
arctan_table = generate_arctan_table(N)
z = cordiac_algorithm(N, 0.8727)
cosx = z[1] * K
sinx = z[2] * K
x = (sinx**2)+(cosx**2)
print(arctan_table)
print(z)
print(cosx)
print(sinx)
print(x)
#print(K)
