include("AutomDiff.jl")
using Base.Test
using AD

# Aquí se incluyen las pruebas necesarias
x = 10
y = 14.3
z = 0.4
w = 3

# Utilizo estos 3 duales porque creo que cubren todos los casos de uso.

a = Dual(x, y) # (x, y)
b = Dual(z)    # (z, 0)
c = xdual(x)   # (x, 1)

s1 = a + b
s2 = a + c
s3 = b + c
s4 = a + w
s5 = + a

r1 = a - b
r2 = a - c
r3 = b - c
r4 = a - w
r5 = - a

p1 = a * b
p2 = a * c
p3 = b * c
p4 = a * w

d1 = a / b
d2 = a / c
d3 = b / c
d4 = a / w

pot1 = a^w


@test s1.fun == x + z
@test s1.der == y

@test s2.fun == 2 * x
@test s2.der == y + 1

@test s3.fun == z + x
@test s3.der == 1

@test s4.fun == x + w
@test s4.der == y

@test s5.fun == x
@test s5.der == y

# Test de resta

@test r1.fun == x - z
@test r1.der == y

@test r2.fun == 0
@test r2.der == y - 1

@test r3.fun == z - x
@test r3.der == -1

@test r4.fun == x - w
@test r4.der == y

@test r5.fun == -x
@test r5.der == -y

# Test de producto

@test p1.fun == x * z
@test p1.der == y * z

@test p2.fun == x * x
@test p2.der == x + x * y

@test p3.fun == z * x
@test p3.der == z

@test p4.fun == x * w
@test p4.der == y * w

# Test de division

@test d1.fun == x / z
@test d1.der == (y * z ) / z^2

@test d2.fun == 1
@test d2.der == (x * y - x) / x^2

@test d3.fun == z / x
@test d3.der == -z / x^2

@test d4.fun == x / w
@test d4.der == y / w

# Test de potencia

@test pot1.fun == x^w
@test pot1.der == w * y * x ^(w-1)
