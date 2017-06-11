function ψ(t, x̄)
	ẋ = x̄[2]
	ẏ = (α + β * cos(t)) * sin(x̄[1])

	return [ẋ; ẏ]
end
