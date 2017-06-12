function osciladorParametrico(t, x̄)
	ẋ = x̄[2]
	ẏ = (1 + β * cos(t)) * sin(x̄[1])

	return [ẋ; ẏ]
end

function osciladorDePruebas(t, x̄)
	ẋ = x̄[2]
	ẏ = -x̄[1]

	return [ẋ; ẏ]
end

function energiaParametrico(t, x, y)
	E = 0.5 * y^2 + ( 1 + β * cos(t)) * cos(x)

	return E
end

function energiaDePruebas(t, x, y)
	E = 0.5 * (y^2 + x^2)

	return E
end
