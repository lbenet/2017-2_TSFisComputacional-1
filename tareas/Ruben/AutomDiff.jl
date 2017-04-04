#=
Modulo para definir la estructura "Dual"
Autor: Rubén Darío Araiza Acosta
email: ruben1995@gmail.com
github: ravioaraiza

4/04/17
=#


__precompile__(true)

module AD
    import Base: +, -, *, /, ^, ==

    export Dual, xdual


    type Dual{T<:Real}
        fun :: T
        der :: T
    end


    function Dual(f, d)
        return Dual(promote(f, d)...)
    end


    function Dual(a::Real)
        return Dual(a, 0)
    end


    function xdual(x0)
            return Dual(x0,1)
    end


    +(a::Dual, b::Dual) = Dual(a.fun + b.fun, a.der + b.der)
    +(a::Dual, b::Real) = Dual(a.fun + b, a.der)
    +(b::Real, a::Dual) = Dual(a.fun + b, a.der)

    -(a::Dual, b::Dual) = Dual(a.fun - b.fun, a.der - b.der)
    -(a::Dual, b::Real) = Dual(a.fun - b, a.der)
    -(b::Real, a::Dual) = Dual(a.fun - b, a.der)

    *(a::Dual, b::Dual) = Dual(a.fun * b.fun, a.fun * b.der + b.fun * a.der)
    *(a::Dual, b::Real) = Dual(a.fun * b, a.der * b)
    *(a::Real, b::Dual) = Dual(a * b.fun, a * b.der)

    /(a::Dual, b::Dual) = Dual(a.fun / b.fun, (a.der - (a.fun / b.fun) * b.der) / b.fun)
    /(a::Dual, b::Real) = Dual(a.fun / b, a.der / b)
    /(a::Real, b::Dual) = Dual(a / b.fun, -a * b.der / b.fun^2)

    ^(a::Dual, b::Int) = Dual(a.fun^b, b * a.der * a.fun^(b - 1))

    +(a::Dual) = Dual(+a.fun, +a.der)
    -(a::Dual) = Dual(-a.fun, -a.der)

    ==(a::Dual, b::Dual) = (a.fun == b.fun) && (a.der == b.der)
end
