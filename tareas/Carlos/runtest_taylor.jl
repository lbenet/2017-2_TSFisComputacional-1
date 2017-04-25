include("AutomTaylor.jl")
using Base.Test
using AD
#las pruebas necesarias para taylor.
@testset "pruebas realizadas" begin
    @test Taylor(2,[1,2])+Taylor(2,[5,6])==Taylor(2,[6,8])
    @test Taylor(3,[3,2,1])-Taylor(3,[3,2,1])==Taylor(3,[0,0,0])
    @test Taylor(3,[10,20,30])*3==Taylor(3,[30,60,90])
    @test 3*Taylor(3,[10,20,30])==Taylor(3,[30,60,90])
    @test Taylor(4,[2,4,6,8])/2==Taylor(4,[1,2,3,4])
    @test Taylor(2,[1,2])==Taylor(2,[1,2])
end