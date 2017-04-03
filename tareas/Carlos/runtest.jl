include("AutomDiff.jl")
using Base.Test
using AD

# A continuación vienen los tests que implementaron y que deben 
# ser suficientemente exhaustivos

#test de problema1
a=Dual(1,2.0)
@test a.fun==1
@test a.der==2

b=Dual(3)
@test b.fun==3
@test b.der==0


c=xdual(10)
@test c.fun==10
@test c.der==1


#test de problema2
 alfa=Dual(5,2)+Dual(5,2)
@test alfa.fun==10
@test alfa.der==4
alfa1=5+Dual(5,2)
@test alfa1.fun==10
@test alfa1.der==2
alfa2=Dual(5,2)+5
@test alfa2.fun==10
@test alfa2.der==2

betha=Dual(5,4)-Dual(5,2)
@test betha.fun==0
@test betha.der==2
betha1=5-Dual(5,4)
@test betha1.fun==0
@test betha1.der==-4
betha2=Dual(5,4)-5
@test betha2.fun==0
@test betha2.der==4

gamma=Dual(5,2)*Dual(6,1)
@test gamma.fun==30
@test gamma.der==17
gamma1=3*Dual(5,2)
@test gamma1.fun==15
@test gamma1.der==6
gamma2=Dual(5,2)*3
@test gamma2.fun==15
@test gamma2.der==6

delta=Dual(6,2)/Dual(2,1)
@test delta.fun==3
@test delta.der==0.5
delta1=Dual(6,2)/2
@test delta1.fun==3
@test delta1.der==1

epsilon=Dual(2)^4
@test epsilon.fun==16
@test epsilon.der==0

@test Dual(12,2)==Dual(12,2)
@test Dual(12)==Dual(12,0)
@test Dual(12,0)==Dual(12)