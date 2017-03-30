
__precompile__(true)

module AD
    import Base: +, -, *, /, ^, ==
    
    export Dual, xdual
    
    # Aquí viene TODO el código que implementaron.
    # Primero uno incluye la definición de Dual y
    # después las operaciones con Duales.
    """
    Dual{T<:Real}

Definición de los duales, donde lo campos son:

fun y der que corresponden a una función y su derivada respectivamente 
...
"""
type Dual{T<:Real}
    # código: 
    fun::T
    der::T
end

Dual(fun,der)= Dual(promote(fun,der)...)
Dual(f)=Dual(f,0)


"""
    xdual(x0) -> Dual(x0, 1)

...
"""
function xdual(x0)
    # código
    
    return Dual(x0,1)
    
end


+(a::Dual, b::Dual) = Dual(a.fun+b.fun, a.der+b.der)
-(a::Dual, b::Dual) = Dual(a.fun-b.fun, a.der-b.der)
*(a::Dual, b::Dual) = Dual(a.fun*b.fun, a.fun*b.der+b.fun*a.der)
/(a::Dual, b::Dual) = Dual(a.fun/b.fun, a.der-(a.fun/b.fun)*b.der/b.fun)
^(a::Dual, alfa::Real) = Dual(a.fun^alfa, alfa*a.fun^(alfa-1)*a.der)
==(a::Dual, b::Dual) = Bool(a.fun==b.fun && a.der==b.der)

end


