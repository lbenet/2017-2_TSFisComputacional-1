
#= Este archivo incluye los tests del módulo ATaylor
René Mora Maya

29-04-17=#

include("TaylorDiff.jl")
using Base.Test
using ATaylor

x=Taylor([1.0,1,1,1],7)
y=Taylor([1,1.0,1,1,0,0,0],7)
z=Taylor(7.0)
a=Taylor([1,1.,1,1,0,0,1],9)
b=Taylor([1,1.,0,0,0,0,1],2)
α=Taylor([0,0,1])
β=Taylor([0,1])
@testset "pruebas con operaciones entre tipos Taylor"begin
    @test z==Taylor([7],0)
    @test x==Taylor([1,1,1,1],3)
    @test y==Taylor([1,1,1,1],3)
    @test z==7
    @test x+y==Taylor([2,2,2,2],3)
    @test 1+y==Taylor([2,1,1,1],3)
    @test y+1==Taylor([2,1,1,1],3)
    @test x-y==Taylor([0],0)
    @test -y==Taylor([-1,-1,-1,-1],3)
    @test -x==Taylor([-1,-1,-1,-1],3)
    @test y-x==Taylor([0],0)
    @test 1-y==Taylor([0,-1,-1,-1],3)
    @test y-1==Taylor([0,1,1,1],3)
    @test y*x==Taylor(producto([1.0,1,1,1,0,0,0],[1.0,1,1,1,0,0,0]))
    @test 2*y==Taylor([2,2,2,2],3)
    @test y*3==Taylor([3,3,3,3],3)
    @test 2/y==Taylor(division([2.0,0,0,0],[1.0,1,1,1]))
    @test y*(1/3)==Taylor([1/3,1/3,1/3,1/3],3)
    @test y/3==Taylor([1/3,1/3,1/3,1/3],3)
    @test α/β==Taylor([0,1])
    @test z/z==Taylor([1])
    @test x/x==Taylor([1])
end

a=[0,1.]
b=[1,1.]
x=taylor(a,4)
y=taylor(b,4)
@testset "pruebas con operaciones entre funciones de tipos Taylor"begin
    @test exp(x)==Taylor([1,1,1/2,1/6,1/24],4)
    @test exp(x)==Cexp(x)
    @test exp(taylor(a,3))==Taylor([1,1,1/2,1/6],3)
    @test log(y)==Taylor([0,1,-1/2,1/3,-1/4],4)
    @test log(y)==coeflog(taylor(b,4))
    @test y^5.0==Cexpalpha(y,5)
    @test y^3.0==Taylor([1.,3,3,1],3)
    @test sin(x)==Csen(x)
    @test sin(x)==Csen(taylor(a,4))
    @test cos(x)==Ccos(x)
    @test cos(x)==Ccos(taylor(a,4))
    @test y^2.0==Taylor(producto([1.0,1.0,0.0,0.0,0.0],[1.0,1.0,0.0,0.0,0.0]))
    @test y^2.0==y*y    
end
