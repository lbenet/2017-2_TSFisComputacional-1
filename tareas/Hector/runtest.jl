
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

@test Dual(4,1)+Dual(9,2)==Dual(13,3)

@test Dual(4,1)+Dual(9)==Dual(13,1)

@test Dual(4)+Dual(9,2)==Dual(13,2)

@test Dual(4,1)-Dual(9,2)==Dual(-5,-1)

@test Dual(4,1)-Dual(9)==Dual(-5,1)

@test Dual(4)-Dual(9,2)==Dual(-5,-2)

@test Dual(4,1)*Dual(9,2)==Dual(36,17)

@test Dual(4,1)*Dual(9)==Dual(36,9)

@test Dual(4)*Dual(9,2)==Dual(36,8)

@test Dual(4,2)/Dual(2,2)==Dual(2,0)

@test Dual(4,2)/Dual(2)==Dual(2,2)

@test Dual(2)/Dual(2,2)==Dual(1,-1)

@test Dual(4,2)^2==Dual(16,16)

@test Dual(4)==Dual(4)

@test Dual(4,0)==Dual(4)

@test Dual(5)==Dual(5,0)

@test Dual(8,2)==Dual(8,2)

@test 4*Dual(2,1)==Dual(8,4)

@test Dual(2,1)^2==Dual(4,4)

@test Dual(2,1)+2==Dual(4,1)

@test Dual(2,1)-2==Dual(0,1)

@test Dual(2,1)/2==Dual(1.0,0.5)





