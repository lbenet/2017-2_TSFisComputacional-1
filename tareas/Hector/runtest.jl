
include("AutomDiff.jl")
using Base.test
using AD

# A continuación vienen los tests que implementaron y que deben 
# ser suficientemente exhaustivos

a = Dual(1, 2.0)
@test a.fun==1.0

@test a.der==2.0

constante=Dual(4)
@test constante.fun == 4 

@test constante.der == 0

constante2=xdual(9)

@test constante2.fun == 9

@test constante2.der == 1

constante3=xdual(8)

@test constante3.fun == 8

@test constante3.der == 1



