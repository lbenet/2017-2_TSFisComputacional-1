
__precompile__(true)

module AD
    import Base: +, -, *, /, ^, ==,
                sqrt,cbrt,
                exp,log,
                sin,cos,tan,
                cot,sec,csc,
                sinh,cosh,tanh,
                coth,sech,csch,
                asin,acos,atan,
                acot,asec,acsc,
                asinh,acosh,atanh,
                acoth,asech,acsch
    
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
/(a::Real, b::Dual) = Dual(a / b.fun, -a * b.der / b.fun^2)

^(a::Dual, b::Int64) = Dual(a.fun^b,b*a.fun^(b-1)*a.der)

==(a::Dual, b::Dual) = a.fun==b.fun && a.der==b.der
==(a::Dual, b::Real) = a==b.fun && 0.0==b.der
==(a::Real, b::Dual) = a.fun==b && a.der==0.0




sqrt(a::Dual) = Dual(sqrt(a.fun), a.der/(2*sqrt(a.fun)))
cbrt(a::Dual) = Dual(cbrt(a.fun), 1/(3*(a.fun^(2/3))))

exp(a::Dual) = Dual(exp(a.fun), exp(a.fun) * a.der)
log(a::Dual) = Dual(log(a.fun), (1/(a.fun)) *a.der)

sin(a::Dual) = Dual(sin(a.fun), cos(a.fun) * a.der)
cos(a::Dual) = Dual(cos(a.fun), - sin(a.fun) * a.der)
tan(a::Dual) = Dual(tan(a.fun), (1/(cos(a.fun))^2) * a.der)

cot(a::Dual) = Dual(cot(a.fun), - 1/(sin(a.fun))^2 * a.der)
sec(a::Dual) = Dual(sec(a.fun), sec(a.fun)*tan(a.fun) * a.der)
csc(a::Dual) = Dual(csc(a.fun), - csc(a.fun)*cot(a.fun) * a.der)

sinh(a::Dual) = Dual(sinh(a.fun), cosh(a.fun) * a.der)
cosh(a::Dual) = Dual(cosh(a.fun), sinh(a.fun) * a.der)
tanh(a::Dual) = Dual(tanh(a.fun), (1/(cosh(a.fun))^2) * a.der)

coth(a::Dual) = Dual(coth(a.fun), - (1/sinh(a.fun)^2) * a.der)
sech(a::Dual) = Dual(sech(a.fun), - sech(a.fun)*tanh(a.fun) * a.der)
csch(a::Dual) = Dual(csch(a.fun), - csch(a.fun)*coth(a.fun) * a.der)

asin(a::Dual) = Dual(asin(a.fun), (1/sqrt(1-a.fun^2)) * a.der)
acos(a::Dual) = Dual(acos(a.fun), - (1/sqrt(1-a.fun^2)) * a.der)
atan(a::Dual) = Dual(atan(a.fun), (1/1+(a.fun)^2) * a.der)

acot(a::Dual) = Dual(acot(a.fun), - (1/1+(a.fun)^2) * a.der)
asec(a::Dual) = Dual(asec(a.fun), (1/a.fun*sqrt(((a.fun)^2)-1)) * a.der)
acsc(a::Dual) = Dual(acsc(a.fun), - (1/a.fun*sqrt(((a.fun)^2)-1)) * a.der)
    
asinh(a::Dual) = Dual(asinh(a.fun), (1/sqrt(((a.fun)^2)+1)) * a.der)
acosh(a::Dual) = Dual(acosh(a.fun), (1/sqrt(((a.fun)^2)-1)) * a.der)
atanh(a::Dual) = Dual(atanh(a.fun), (1/(1-(a.fun)^2)) * a.der)

acoth(a::Dual) = Dual(acoth(a.fun), - (1/((a.fun^2)-1)) * a.der)
asech(a::Dual) = Dual(asech(a.fun), - (1/(abs(a.fun)*sqrt(1-(a.fun)^2))) * a.der)
acsch(a::Dual) = Dual(acsch(a.fun), - (1/(abs(a.fun)*sqrt(1+(a.fun)^2))) * a.der) 

end


