
#=
En este módulo estan definidos los duales(estructura que da el valor de la función como primera 
componente y su derivada como segunda componente Dual(f,f').

René Mora Maya

29-03-17
=#

# La siguiente instrucción sirve para *precompilar* el módulo
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
...
"""
type Dual{T<:Real}
    fun::T
    der::T
end
"""
De ésta manera se promueven los duales para que sean del mismo tipo
"""
Dual(a,b) = Dual(promote(a,b)...)
"""
xdual(x0) -> Dual(x0, 1)

Función que regresa el Dual(el vector que tiene como primera entrada f(x0) y segunda entrada f'(x0)) del número x0. 
"""
xdual(x0)=Dual(x0,1)
"""
Dual(x0)

Función que regresa el Dual de una constante Dual(x0,0). 
"""
Dual(x0)=Dual(x0,0)

+(a::Dual, b::Dual) = Dual( a.fun+b.fun, a.der+b.der )
+(a::Dual, b::Real) = Dual( a.fun+b, a.der )
+(a::Real, b::Dual) = Dual( a+b.fun, b.der )

-(a::Dual, b::Dual) = Dual( a.fun-b.fun, a.der-b.der )
-(a::Dual, b::Real) = Dual( a.fun-b, a.der )
-(a::Real, b::Dual) = Dual( a-b.fun, -b.der )

*(a::Dual, b::Dual) = Dual( a.fun*b.fun, a.der*b.fun+a.fun*b.der )
*(a::Real, b::Dual) = Dual( a*b.fun, a*b.der )
*(a::Dual, b::Real) = Dual( b*a.fun, b*a.der )

/(a::Dual, b::Dual) = Dual( a.fun/b.fun, (a.der*b.fun-a.fun*b.der)/(a.fun*a.fun) )
/(a::Dual, b::Real) = Dual( a.fun/b, a.der/b )

^(a::Dual, b::Int64) = Dual( a.fun^b, b*a.fun^(b-1)*a.der )

==(a::Dual, b::Dual) =a.fun==b.fun && a.der==b.der
==(a::Real, b::Dual) =a==b.fun && 0.0==b.der
==(a::Dual, b::Real) =a.fun==b && a.der==0.0

end


