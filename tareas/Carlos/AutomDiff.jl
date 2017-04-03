
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

#=
promoviendo los duales del tipo distinto
=#
function Dual(fun,der)
 return Dual(promote(fun,der)...)
end

#= 
Aquí se define un método que garantiza que el dual de una constante 
(número) cumple lo requerido
=#
function Dual(a::Real)
    return Dual(a,0.0)
end

#= 
Aquí se define la función `xdual`, que se usará para identificar 
la variable independiente. La función dependerá de x_0, y debe 
regresar el Dual apropiado a la variable independiente
=#

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

^(A::Dual,beta::Int64)=Dual((A.fun)^(beta),beta*((A.fun)^(beta-1))*(A.der))

==(A::Dual,B::Dual)=(A.fun==B.fun && A.der==B.der)
==(A::Dual,zeta::Real)=(A==zeta.fun && 0.0==zeta.der)
==(zeta::Real,B::Dual)=(zeta.fun==B.fun && zeta.der==0.0)

end