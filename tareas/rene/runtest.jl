
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

f(x)=2x^3-2
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
    @test f(xdual(1))==Dual(0,6)
    @test f(xdual(3))==Dual(52,54)
end



