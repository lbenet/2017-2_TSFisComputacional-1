include("funciones.jl")
include("Taylor.jl")
using ADT, PyPlot



x̄0 = [1.0; 0.0]
t0, tf = 0.0, 1_000.0
α, β = -1.0, 0.0

puntos = [x̄]
for i = 0:10

	t, sol = integradorT2(ψ, x̄0, i * 2 * pi, (1 + 1) * 2 * pi)

	x = map(x -> x[1], sol)
	y = map(x -> x[2], sol)
	push!(puntos, [x[end]; y[end]])
end


x_ = map(x -> x[1], puntos)
y_ = map(x -> x[2], puntos)

plot(x_, y_, ".")

#
# plot(x, y)
