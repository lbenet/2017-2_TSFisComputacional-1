include("funciones.jl")
include("Taylor.jl")
using ADT, PyPlot
x̄0 = [1.0, 0.0]
t0, tf = 0.0, 1_000_000.0
α, β = 10.0, 10.0

t, sol = integradorT2(ψ, x̄0, t0, tf)

x = map(x -> x[1], sol)
y = map(x -> x[2], sol)

plot(t, x)
