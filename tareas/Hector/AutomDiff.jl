
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
+(a::Dual, b::Real) = Dual(a.fun+b,a.der)
+(a::Real, b::Dual) = Dual(a+b.fun,b.der)

-(a::Dual, b::Dual) = Dual(a.fun-b.fun, a.der-b.der)
-(a::Dual, b::Real) = Dual(a.fun-b,a.der)
-(a::Real, b::Dual) = Dual(a-b.fun,-b.der)

*(a::Dual, b::Dual) = Dual(a.fun*b.fun, a.fun*b.der+b.fun*a.der)
*(a::Dual, b::Real) = Dual(b*a.fun,b*a.der)
*(a::Real, b::Dual) = Dual(a*b.fun,a*b.der)

/(a::Dual, b::Dual) = Dual(a.fun/b.fun, a.der-(a.fun/b.fun)*b.der/b.fun)
/(a::Dual, b::Real) = Dual( a.fun/b, a.der/b)

^(a::Dual, b::Int64) = Dual(a.fun^b,b*a.fun^(b-1)*a.der)

==(a::Dual, b::Dual) = a.fun==b.fun && a.der==b.der
==(a::Dual, b::Real) = a==b.fun && 0.0==b.der
==(a::Real, b::Dual) = a.fun==b && a.der==0.0

end


