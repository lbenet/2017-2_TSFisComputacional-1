include("funciones.jl")
include("Taylor.jl")
using ADT, PyPlot


x̄0 = [pi; 0.0]
β = 2.0

puntos = [x̄0]

for i = 0:500

	t, sol = integradorT2(osciladorParametrico, x̄0, i * 2 * pi, (i + 1) * 2 * pi)

	push!(puntos, sol[end])
	x̄0 = puntos[end]
end

x_ = map(x -> x[1], puntos)
y_ = map(x -> x[2], puntos)

plot(x_, y_, ".")
