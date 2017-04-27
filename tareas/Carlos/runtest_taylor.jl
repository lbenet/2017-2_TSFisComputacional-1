include("AutomTaylor.jl")
using Base.Test
using BD
#las pruebas necesarias para taylor.
@testset "pruebas realizadas" begin
    @test taylor(1,[1])+taylor(2,[1,2])==Taylor(1,[2,2])
    @test taylor(1,[1])-taylor(2,[1,2])==Taylor(1,[0,-2])
    @test 3*taylor(3,[10,20,30])==Taylor(2,[30,60,90])
    @test taylor(4,[2,4,6,8])/2==Taylor(3,[1,2,3,4])# divisiones
    @test taylor(2,[1,2])==Taylor(1,[1,2]) #igualdad
end