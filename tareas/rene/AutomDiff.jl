
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

/(a::Dual, b::Dual) = Dual( a.fun/b.fun, (a.der*b.fun-a.fun*b.der)/(b.fun*b.fun) )
/(a::Dual, b::Real) = Dual( a.fun/b, a.der/b )
/(a::Real, b::Dual) = Dual( a/b.fun, (-a*b.der)/(b.fun*b.fun) )

^(a::Dual, b::Int64) = Dual( a.fun^b, b*a.fun^(b-1)*a.der )

==(a::Dual, b::Dual) =a.fun==b.fun && a.der==b.der
==(a::Real, b::Dual) =a==b.fun && 0.0==b.der
==(a::Dual, b::Real) =a.fun==b && a.der==0.0

import Base:sqrt,cbrt,exp,log,sin,cos,tan,cot,sec,csc,sinh,cosh,tanh,coth,sech,csch,asin,acos,atan,acot,asec,acsc

for (f,fp) = ((:sin,(:(cos(a.fun)))),
              (:cos,(:(-sin(a.fun)))),
              (:sqrt,(:(1/(2*sqrt(a.fun))))),
              (:cbrt,(:(1/(3*cbrt((a.fun)^2))))),
              (:exp,(:(exp(a.fun)))),
              (:log,(:((1/(a.fun))))),
              (:tan,(:(sec(a.fun)^2))),
              (:cot,(:(-csc(a.fun)^2))),
              (:sec,(:(sec(a.fun)*tan(a.fun)))),
              (:csc,(:(-csc(a.fun)*cot(a.fun)))),
              (:cosh,(:(sinh(a.fun)))),
              (:sinh,(:(cosh(a.fun)))),
              (:tanh,(:(sech(a.fun)^2))),
              (:coth,(:(-csch(a.fun)^2))),
              (:sech,(:(-sech(a.fun)*tanh(a.fun)))),
              (:csch,(:(-csch(a.fun)*coth(a.fun)))),
              (:asin,(:(1/sqrt(1-(a.fun)^2)))),
              (:acos,(:(-1/sqrt(1-(a.fun)^2)))),
              (:atan,(:(1/(1+(a.fun)^2)))),
              (:acot,(:(-1/(1+(a.fun)^2)))),
              (:asec,(:(1/(a.fun*sqrt((a.fun)^2-1))))),
              (:acsc,(:(-1/(a.fun*sqrt((a.fun)^2-1))))))
    ex = quote
        $f(a::Dual)=Dual($f(a.fun),$fp*a.der)
    end
    println(ex)
    @eval $ex
end

end


