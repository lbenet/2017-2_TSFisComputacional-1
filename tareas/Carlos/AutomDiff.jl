
__precompile__(true)

module AD
    import Base: +, -, *, /, ^, ==

    export Dual, xdual

    # Aquí viene TODO el código que implementaron.
    # Primero uno incluye la definición de Dual y
    # después las operaciones con Duales.
   
#=
    Dual{T<:Real}

Definición de los duales, donde lo campos son:
=#
type Dual{T<:Real}
    fun::T
    der::T
end

"""
promoviendo los duales del tipo distinto
"""
function Dual(fun,der)
 return Dual(promote(fun,der)...)
end

"""
garantizando de que la derivada de una funcion constante es igual a cero
"""
function Dual(a::Real)
    return Dual(a,0.0)
end

"""
Aquí se define la función `xdual`, que se usará para identificar 
la variable independiente. La función dependerá de x_0, y debe 
regresar el Dual apropiado a la variable independiente
"""

function xdual(x0)
    return Dual(x0,1)
end

+(A::Dual,B::Dual)=Dual(A.fun+B.fun,A.der+B.der)
+(gama::Real,B::Dual)=Dual(gama+B.fun,B.der)
+(A::Dual,gama::Real)=Dual(A.fun+gama,A.der)

-(A::Dual,B::Dual)=Dual(A.fun-B.fun,A.der-B.der)
-(delta::Real,B::Dual)=Dual(delta-B.fun,-B.der)
-(A::Dual,delta::Real)=Dual(A.fun-delta,A.der)

*(A::Dual,B::Dual)=Dual(A.fun*B.fun,(A.der*B.fun)+(A.fun*B.der))
*(alfa::Real,B::Dual)=Dual(alfa*B.fun,alfa*B.der)     #debe especificarse el orden de los factores, porque no debe alterar 
*(A::Dual,alfa::Real)=Dual(alfa*A.fun,alfa*A.der)     #el producto.

/(A::Dual,B::Dual)=Dual((A.fun)/(B.fun),((A.fun*B.der)-(A.der*B.fun))/(B.fun)^2)
/(A::Dual,epsilon::Real)=Dual(A.fun/epsilon,A.der/epsilon)
/(epsilon::Real,B::Dual)=Dual(epsilon/B.fun,(-epsilon*B.der)/((B.fun)^2))   #agregado necesario para la tarea4

^(A::Dual,beta::Int64)=Dual((A.fun)^(beta),beta*((A.fun)^(beta-1))*(A.der))

==(A::Dual,B::Dual)=(A.fun==B.fun && A.der==B.der)
==(A::Dual,zeta::Real)=(A==zeta.fun && 0.0==zeta.der)
==(zeta::Real,B::Dual)=(zeta.fun==B.fun && zeta.der==0.0)



#agregado para la tarea 4
import Base:sin,cos,tan,cot,sec,csc,sinh,cosh,tanh,coth,sech,csch,asin,acos,atan,acot,asec,acsc,exp,log,sqrt
#como en la tarea pasada, se harán tuplas, la primera entrada del dual es la función, mientras que la segunda entraa es su dervidad.
for (f,df)=((:sin,(:(cos(a.fun)))),
    (:cos,(:(-sin(a.fun)))),
    (:tan,(:(sec(a.fun)^2))),
    (:cot,(:(-csc(a.fun)^2))),
    (:sec,(:(sec(a.fun)*tan(a.fun)))),
    (:csc,(:(-csc(a.fun)*cot(a.fun)))),
    (:sinh,(:(cosh(a.fun)))),
    (:cosh,(:(sinh(a.fun)))),
    (:tanh,(:(sech(a.fun)^2))),
    (:coth,(:(-csch(a.fun)^2))),
    (:sech,(:(-sech(a.fun)*tanh(a.fun)))),
    (:csch,(:(-coth(a.fun)*csch(a.fun)))),
    (:asin,(:(1/sqrt(1-(a.fun)^2)))),
    (:acos,(:(-1/sqrt(1-(a.fun)^2)))),
    (:atan,(:(1/(1+(a.fun)^2)))),
    (:acot,(:(-1/(1+(a.fun)^2)))),
    (:asec,(:(1/((a.fun)*sqrt(((a.fun)^2)-1))))),
    (:acsc,(:(-1/((a.fun)*sqrt(((a.fun)^2)-1))))),
    (:exp,(:(exp(a.fun)))),
    (:log,(:(1/(a.fun)))),
    (:sqrt,(:(1/(2*sqrt(a.fun))))))
    ex=quote
        $f(a::Dual)=Dual($f(a.fun),$df*a.der)
    end
    println(ex)
    @eval $ex
end

end