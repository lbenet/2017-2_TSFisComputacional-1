include("AutomTaylor.jl")
using Base.Test
using BD
#las pruebas necesarias para taylor.
@testset "pruebas realizadas" begin
    @test Taylor(0,[1])+Taylor(1,[1,2])==Taylor(1,[2,2]) #sumas
    @test Taylor(1,[1,1])+Taylor(1,[1,1])==Taylor(1,[2,2])
    @test Taylor(0,[1])-Taylor(1,[1,2])==Taylor(1,[0,-2])#restas
    @test Taylor(1,[1,1])-Taylor(1,[1,1])==Taylor(1,[0,0])
    @test 3*Taylor(2,[10,20,30])==Taylor(2,[30,60,90])#producto
    @test Taylor(1,[1,1])*Taylor(1,[1,1])==Taylor(2,[1,2,1])
    @test Taylor(3,[2,4,6,8])/2==Taylor(3,[1,2,3,4])# divisiones
    @test Taylor(2,[1,2,1])/Taylor(1,[1,1])==Taylor(1,[1,1])
    @test Taylor(1,[1,2])==Taylor(1,[1,2]) #igualdad
end