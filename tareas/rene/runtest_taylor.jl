
#= Este archivo incluye los tests del módulo AD
René Mora Maya

29-04-17=#

include("TaylorDiff.jl")
using Base.Test
using AD
a=[2.,3,4,5,6]
b=[1.,1,3]
c=[1.,1,3,0,0]
x=Taylor(a)
y=Taylor(b)
z=Taylor(1.0)
h=[2.,0,0]
@testset "pruebas con operaciones entre tipos Taylor"begin
    @test z==Taylor([1],0)
    @test x==Taylor([2,3,4,5,6],4)
    @test y==Taylor([1,1,3],2)
    @test z==Taylor([1],0)
    @test x+y==Taylor([3,4,7,5,6],4)
    @test 1+y==Taylor([2,1,3],2)
    @test y+1==Taylor([2,1,3],2)
    @test x-y==Taylor([1,2,1,5,6],4)
    @test y-x==Taylor([-1,-2,-1,-5,-6],4)
    @test 1-y==Taylor([0,-1,-3],2)
    @test y-1==Taylor([0,1,3],2)
    @test y*x==Taylor(producto(c,a),4)
    @test 2*y==Taylor([2,2,6],2)
    @test y*3==Taylor([3,3,9],2)
    @test y/x==Taylor(division(c,a),4)
    @test 2/y==Taylor(division(h,b),2)
    @test y/3==Taylor([1/3,1/3,1],2)
end


