include("Taylor.jl")
using Base.Test
using ADT

x  = Taylor([0,1])
x² = Taylor([0,0,1])
x³ = Taylor([0,0,0,1])
x⁴ = Taylor([0,0,0,0,1])

@testset "Inicial" begin
  @test Taylor(1) == Taylor([1])
  @test gradomax(x)  == 2
  @test gradomax(x²) == 3
  @test gradomax(x³) == 4
  @test gradomax(x⁴) == 5
end
@testset "Suma" begin
  @test x + x² == Taylor([0, 1, 1])
  @test x + x³ == Taylor([0, 1, 0, 1])
  @test x + x⁴ == Taylor([0, 1, 0, 0, 1])
end
@testset "Resta" begin
  @test x - x² == Taylor([0, 1, -1])
  @test x - x³ == Taylor([0, 1, 0, -1])
  @test x - x⁴ == Taylor([0, 1, 0, 0, -1])
end
@testset "Mult" begin
  @test x * x == x²
  @test x * x² == x³
  @test x * x³ == x⁴
  @test Taylor([1,1]) * Taylor([1,1]) == Taylor([1,2,1])
end
@testset "div" begin
  @test x² / x == x
  @test x³ / x == x²
  @test x⁴ / x == x³
end
