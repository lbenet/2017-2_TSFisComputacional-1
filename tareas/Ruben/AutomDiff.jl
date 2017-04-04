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


    doc"""
        Dual{T<:Real}
            fun
            der
    Definición de los duales, donde lo campos son:
    fun, una función y der, su derivada.
    """

    type Dual{T<:Real}
        fun :: T
        der :: T
    end


    doc"""
        Dual(f, d)
            fun = f
            der = d

    Función que garantiza que las entradas de un dual tengan sean del mismo tipo.
    Utiliza la funcion promote().
    """

    function Dual(f, d)
        return Dual(promote(f, d)...)
    end


    doc"""
        Dual(a)

    Crea el Dual de un real, la segunda entrada es 0 ya que es la derivada de una constante
    """

    function Dual(a::Real)
        return Dual(a, 0)
    end

    doc"""
        xdual(x0) -> Dual(x0, 1)

    Representa a la variable independiente, asociada con su derivada (dx = 1)
    """

    function xdual(x0)
            return Dual(x0,1)
    end

    # Se definen las operaciones con duales.

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
