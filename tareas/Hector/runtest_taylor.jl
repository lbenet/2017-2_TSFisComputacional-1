

using Base.Test
include("taylor.jl")

using Ty

@testset "pruebas de operaciones para Taylor" begin
    
    @test Taylor([1,2,3],3)+Taylor([9,8,7,6],3)==Taylor([10,10,10,6],3)
    @test Taylor([10,10,10,6],3)+Taylor([1,2,3,4,5],6)==Taylor([11,12,13,10,5,0,0],6)
    @test Taylor([1,2,3,4,5],6)+Taylor([1.0,2.0,3.0,4.0,5.0],4)==Taylor([2.0,4.0,6.0,8.0,10.0,0.0,0.0],6)
    @test Taylor([1,2,3,4,5],6)+Taylor([-1,-2,-3,-4,5],6)==Taylor([0,0,0,0,10,0,0],6)
    @test Taylor([1,2,3],3)-Taylor([9,8,7,6],3)==Taylor([-8,-6,-4,-6],3)
    @test Taylor([10,10,10,6],3)-Taylor([1,2,3,4,5],6)==Taylor([9,8,7,2,-5,0,0],6)
    @test Taylor([1,2,3,4,5],6)-Taylor([1.0,2.0,3.0,4.0,5.0],4)==Taylor([0.0,0.0,0.0,0.0,0.0,0.0,0.0],6)
    @test Taylor([1,2,3,4,5],6)-Taylor([-1,-2,-3,-4,5],6)==Taylor([2,4,6,8,0,0,0],6)
    @test Taylor([1,1,1,1],1)*Taylor([8,8,8,8],3)==Taylor([8.0,16.0,24.0,32.0,0.0,0.0,0.0],6)
    @test Taylor([8,8,8,8],4)*Taylor([1,1,1,1],3)==Taylor([8.0,16.0,24.0,32.0,24.0,0.0,0.0,0.0],7)
    @test Taylor([8,7,6,5],4)*Taylor([1.0,2.0,3.0,1],3)==Taylor([8.0,23.0,44.0,46.0,35.0,0.0,0.0,0.0],7)
    @test Taylor([8,7,-6,-5],4)*Taylor([1.0,-2.0,3.0,-1],3)==Taylor([8.0,-9.0,4.0,20.0,-15.0,0.0,0.0,0.0],7)
    @test Taylor([1,1,3,4],3)/Taylor([1,3,2,1],3)==Taylor([1.0,-2.0,7.0,-14.0],3)
    @test Taylor([1,1,1,1],3)/Taylor([1,1,1,1],3)==Taylor([1.0,0.0,0.0,0.0],3)
    @test Taylor([1,0,3,0],3)/Taylor([1,0,0,6],3)==Taylor{Float64}([1.0,0.0,3.0,-6.0],3)
    @test Taylor([9,8,7,6],3)/Taylor{Int64}([1,0,0,-1],3)==Taylor([9.0,8.0,7.0,15.0],3)
    @test Taylor([1,1],2)^3==Taylor{Int64}([1,3,3,1,0,0,0],6)
    @test Taylor([1,2,3,4],3)^3==Taylor([1,6,21,56,111,0,0,0,0,0],9)
    @test Taylor([1,2],1)^8==Taylor{Int64}([1,16,112,0,0,0,0,0,0],8)
end

