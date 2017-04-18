
#= Este archivo incluye los tests del módulo AD
René Mora Maya

29-03-17=#

include("AutomDiff.jl")
using Base.Test
using AD

# A continuación vienen los tests que implementaron y que deben 
# ser suficientemente exhaustivos
a = Dual(1, 2.0)
@testset "pruebas de las componentes de un Dual"begin
    @test a.fun == 1.0
    @test a.der == 2
end

funcion(x)=2x^3-2
@testset "pruebas con operaciones entre Duales"begin
    @test Dual(2) == Dual(2,0)
    @test Dual(5.0) == Dual(5.0,0.0)
    @test xdual(1)==Dual(1,1)
    @test xdual(3.0)==Dual(3,1)
    @test Dual(5)==Dual(5,0)
    @test Dual(1)==Dual(1,0)
    @test Dual(1,2)-3==Dual(-2,2)
    @test 3-Dual(1,2)==Dual(2,-2)
    @test Dual(1,2)+3==Dual(4,2)
    @test 3+Dual(1,2)==Dual(4,2)
    @test 3*Dual(1,2)==Dual(3,6)
    @test Dual(1,2)*3==Dual(3,6)
    @test Dual(1,2)/3==Dual(1/3,2/3)
    @test (Dual(2,1))^3==Dual(8,12)
    @test funcion(xdual(1))==Dual(0,6)
    @test funcion(xdual(3))==Dual(52,54)
end
#05-04-17
@testset "pruebas con operaciones en funciones trigonometricas entre Duales"begin
    @test sqrt(xdual(1))==Dual(1,1/2)
    @test cbrt(xdual(1)) == Dual(1,1/3)
    @test exp(xdual(0)) == Dual(1,1)
    a=exp(xdual(1))
    b=Dual(e,e)
    @test isapprox(a.der,b.der,atol=eps())
    @test isapprox(a.fun,b.fun,atol=eps())
    @test log(xdual(1)) == Dual(0,1)
    @test sin(xdual(1)) == Dual(sin(1),cos(1))
    a=sin(xdual(π))
    b=Dual(0,-1)
    @test isapprox(a.der,b.der,atol=eps())
    @test isapprox(a.fun,b.fun,atol=eps())
    @test cos(xdual(1)) == Dual(cos(1),-sin(1))
    @test cos(xdual(2π)) == Dual(cos(2π),-sin(2π))
    a=cos(xdual(2π))
    b=Dual(1,0)
    #@test isapprox(a.der,b.der,atol=eps())
    @test isapprox(a.fun,b.fun,atol=eps())
    @test tan(xdual(1)) == Dual(tan(1),sec(1)^2)
    @test tan(xdual(π/4)) == Dual(tan(π/4),sec(π/4)^2)
    a=tan(xdual(π/4))
    b=Dual(1,1/(cos(π/4)^2))
    @test isapprox(a.der,b.der,atol=eps())
    @test isapprox(a.fun,b.fun,atol=eps())
    @test cot(xdual(1)) == Dual(cot(1),-csc(1)^2)
    @test sec(xdual(1)) == Dual(sec(1),sec(1)*tan(1))
    @test csc(xdual(1)) == Dual(csc(1),-csc(1)*cot(1))
    @test sinh(xdual(1)) == Dual(sinh(1),cosh(1))
    @test cosh(xdual(1)) == Dual(cosh(1),sinh(1))
    @test tanh(xdual(1)) == Dual(tanh(1),sech(1)^2)
    @test coth(xdual(1)) == Dual(coth(1),-csch(1)^2)
    @test sech(xdual(1)) == Dual(sech(1),-sech(1)*tanh(1))
    @test csch(xdual(1)) == Dual(csch(1),-csch(1)*coth(1))
    @test asin(xdual(0.5)) == Dual(asin(0.5),1/sqrt(1-(1/2)^2))
    @test acos(xdual(0.5)) == Dual(acos(0.5),-1/sqrt(1-(1/2)^2))
    @test atan(xdual(0.5)) == Dual(atan(0.5),1/(1+(0.5)^2))
    @test acot(xdual(0.5)) == Dual(acot(0.5),-1/(1+(0.5)^2))
    @test asec(xdual(2)) == Dual(asec(2),1/(2*sqrt((2)^2-1)))
    @test acsc(xdual(2)) == Dual(acsc(2),-1/(2*sqrt((2)^2-1)))
end


