
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
sin(A::Dual)=Dual(sin(A.fun),cos(A.fun)*A.der)
cos(A::Dual)=Dual(cos(A.fun),-sin(A.fun)*A.der)
tan(A::Dual)=Dual(tan(A.fun),(sec(A.fun)^2)*A.der)
cot(A::Dual)=Dual(cot(A.fun),(-csc(A.fun)^2)*A.der)
sec(A::Dual)=Dual(sec(A.fun),(sec(A.fun)*tan(A.fun))*A.der)
csc(A::Dual)=Dual(csc(A.fun),(-csc(A.fun)*cot(A.fun))*A.der)
sinh(A::Dual)=Dual(sinh(A.fun),cosh(A.fun)*A.der)
cosh(A::Dual)=Dual(cosh(A.fun),sinh(A.fun)*A.der)
tanh(A::Dual)=Dual(tanh(A.fun),(sech(A.fun)^2)*A.der)
coth(A::Dual)=Dual(coth(A.fun),(-csch(A.fun)^2)*A.der)
sech(A::Dual)=Dual(sech(A.fun),(-sech(A.fun)*tanh(A.fun))*A.der)
csch(A::Dual)=Dual(csch(A.fun),(-coth(A.fun)*csch(A.fun))*A.der)
asin(A::Dual)=Dual(asin(A.fun),(1/sqrt(1-(A.fun)^2))*A.der)
acos(A::Dual)=Dual(acos(A.fun),(-1/sqrt(1-(A.fun)^2))*A.der)
atan(A::Dual)=Dual(atan(A.fun),(1/(1+(A.fun)^2))*A.der)
acot(A::Dual)=Dual(acot(A.fun),(-1/(1+(A.fun)^2))*A.der)
asec(A::Dual)=Dual(asec(A.fun),(1/((A.fun)*sqrt(((A.fun)^2)-1)))*A.der)
acsc(A::Dual)=Dual(acsc(A.fun),(-1/((A.fun)*sqrt(((A.fun)^2)-1)))*A.der)
exp(A::Dual)=Dual(exp(A.fun),(exp(A.fun))*A.der)
log(A::Dual)=Dual(log(A.fun),(1/(A.fun))*A.der)
sqrt(A::Dual)=Dual(sqrt(A.fun),(A.der/(2*sqrt(A.fun))))
# basado en la sintaxis empleada en la tarea4 del alumno Héctor Alonso a.k.a. H-Cote
end