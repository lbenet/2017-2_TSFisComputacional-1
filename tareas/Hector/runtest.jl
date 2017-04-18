
include("AutomDiff.jl")
using Base.Test
using AD

# A continuación vienen los tests que implementaron y que deben 
# ser suficientemente exhaustivos

a = Dual(1, 2.0)
constante=Dual(4)
constante2=xdual(9)
constante3=xdual(8)

@testset "pruebas de operaciones con duales y funciones" begin
    @test a.fun==1.0
    @test a.der==2.0
    @test constante.fun == 4 
    @test constante.der == 0
    @test constante2.fun == 9
    @test constante2.der == 1
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
    @test 100/Dual(2)==Dual(50.0,0.0)
    @test Dual(2)/Dual(2,2)==Dual(1,-1)
    @test Dual(4,2)^2==Dual(16,16)
    @test Dual(4)==Dual(4,0)
    @test Dual(4.0)==Dual(4.0,0.0)
    @test Dual(4,0)==Dual(4)
    @test Dual(5)==Dual(5,0)
    @test Dual(8,2)==Dual(8,2)
    @test Dual(2,2)-4==Dual(-2,2)
    @test Dual(2,2)+4==Dual(6,2)
    @test 4-Dual(1,1)==Dual(3,-1)
    @test 4+Dual(2,2)==Dual(6,2)
    @test Dual(2,2)*4==Dual(8,8)
    @test 4*Dual(2,2)==Dual(8,8)
    @test Dual(2,2)/4==Dual(0.5,0.5)
    @test Dual(2,1)-2==Dual(0,1)
    @test Dual(2,1)/2==Dual(1.0,0.5)
    @test xdual(2) == Dual(2,1)
    @test xdual(2.0) == Dual(2,1)
    
    
    
    @test sqrt(xdual(2)) == Dual(1.4142135623730951,0.35355339059327373)
    @test cbrt(xdual(27)) == Dual(3.0,0.03703703703703705)
    
    @test exp(xdual(1))==Dual(2.718281828459045,2.718281828459045)
    @test log(xdual(1))==Dual(0.0,1.0)
    
    @test sin(xdual(0))==Dual(0,1)
    @test cos(xdual(0))==Dual(1.0,0.0)
    @test tan(xdual(0))==Dual(0.0,1.0)
    
    @test cot(xdual(90))==Dual(-0.5012027833801532,-1.2512042300680128)
    @test sec(xdual(0))==Dual(1.0,0.0)
    @test csc(xdual(90))==Dual(1.1185724071637084,0.5606316038826887)
    
    @test sinh(xdual(0))==Dual(0.0,1.0)
    @test cosh(xdual(0))==Dual(1.0,0.0)
    @test tanh(xdual(0))==Dual(0.0,1.0)
    
    @test coth(xdual(90))==Dual(1.0,-2.685673715284637e-78)
    @test sech(xdual(0))==Dual(1.0,0.0)
    @test csch(xdual(90))==Dual(1.638802524798103e-39,-1.638802524798103e-39)
    
    @test asin(xdual(0))==Dual(0.0,1.0)
    @test acos(xdual(0))==Dual(1.5707963267948966,-1.0)
    @test atan(xdual(0))==Dual(0.0,1.0)
    
    @test acot(xdual(1))==Dual(0.7853981633974483,-2.0)
    @test asec(xdual(1))==Dual(0.0,0.0)
    @test acsc(xdual(90))==Dual(0.011111339747498774,-0.9999382696996233) 
    
    @test asinh(xdual(0))==Dual(0.0,1.0)
    @test acosh(xdual(90))==Dual(5.192925985263684,0.011111797045680466)
    @test atanh(xdual(0))==Dual(0.0,1.0)
    
    @test acoth(xdual(90))==Dual(0.0111115683923551,-0.00012347203358439315)
    @test asech(xdual(1))==Dual(0.0,-Inf)
    @test acsch(xdual(90))==Dual(0.01111088250012608,-0.00012344917003949906)  
  
end



