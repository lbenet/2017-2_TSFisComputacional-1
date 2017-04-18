include("AutomDiff.jl")
using Base.Test
using AD

# A continuación vienen los tests que implementaron y que deben 
# ser suficientemente exhaustivos

#test de problema1
@testset "pruebas realizadas"  begin
a=Dual(1,2.0)
@test a.fun==1
@test a.der==2

b=Dual(3)
@test b.fun==3
@test b.der==0


c=xdual(10)
@test c.fun==10
@test c.der==1
end


#test de problema2
@testset "pruebas realizadas"  begin
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

    #agregado para la tarea 4
end
@testset "pruebas realizadas" begin
    @test sqrt(xdual(1))==Dual(1.0,0.5)
    @test exp(xdual(1))==Dual(exp(1),exp(1))
    @test log(xdual(1))==Dual(log(1),1.0)
    @test sin(xdual(0))==Dual(0.0,1.0)
    @test cos(xdual(0))==Dual(1.0,0.0)
    @test tan(xdual(1))==Dual(tan(1),sec(1)^2)
    @test cot(xdual(1))==Dual(cot(1),-csc(1)^2)
    @test sec(xdual(1))==Dual(sec(1),sec(1)*tan(1))
    @test csc(xdual(1))==Dual(csc(1),-csc(1)*cot(1))
    @test sinh(xdual(1))==Dual(sinh(1),cosh(1))
    @test cosh(xdual(1))==Dual(cosh(1),sinh(1))
    @test tanh(xdual(1))==Dual(tanh(1),sech(1)^2)
    @test coth(xdual(1))==Dual(coth(1),-csch(1)^2)
    @test sech(xdual(1))==Dual(sech(1),-tanh(1)*sech(1))
    @test csch(xdual(1))==Dual(csch(1),-coth(1)*csch(1))
    @test asin(xdual(0.5))==Dual(asin(0.5),1/(sqrt(1-(1/2)^2)))
    @test acos(xdual(0.5))==Dual(acos(0.5),-1/(sqrt(1-(0.5)^2)))
    @test atan(xdual(0))==Dual(atan(0),1/(1+0^2))
    @test acot(xdual(0.5))==Dual(acot(0.5),-1/(1+(0.5)^2))
    @test asec(xdual(2))==Dual(asec(2),1/((2)*(sqrt(((2)^2)-1))))
    @test acsc(xdual(2))==Dual(acsc(2),-1/((2)*(sqrt(((2)^2)-1))))
end