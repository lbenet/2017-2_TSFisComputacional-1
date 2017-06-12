#=
En este módulo estan definidos elementos tipo Taylor.

René Mora Maya

06-06-17
=#
# La siguiente instrucción sirve para *precompilar* el módulo
__precompile__(true)

module AT
export Taylor,taylor,producto,division,taylorsum,taylorres,taylorprod,taylordiv,taylorigual,simplificaT,
igualvec,integrador,Horner,pasointh,CTaylor,kasRK42,metRungeKutta2
"""
Taylor

Definición de polinomios de Taylor, donde v representa los coeficientes 
\$f_{[k]} = \\frac{f^{(k)}(x_0)}{k!} = \\frac{1}{k!}\\frac{d^k f}{dx^k}(x_0)\$ evaluados en \$x_0\$ y n es 
el grado del polinomio.
"""
type Taylor{T<:Number}
    v::Array{T}
    n::Int
end
"""
taylor(v,n)

Función que crea un tipo Taylor con un vector de n+1 elementos. Los primeros elementos son iguales a v.
"""
function taylor{T<:Number}(v::Array{T},n::Int)
    i=length(v)#número de elementos del vector v
    while(v[i]==0&& i>1)
        i=i-1
    end
    if i<n
        x=zeros(eltype(v),n+1)
        for j in 1:i
            x[j]=v[j]
        end
        return Taylor(x,length(x)-1)
    elseif i>n
        x=zeros(eltype(v),n+1)
        for j in 1:n+1
            x[j]=v[j]
        end
        return Taylor(x,length(x)-1)
    else
        x=zeros(eltype(v),n+1)
        for j in 1:i
            x[j]=v[j]
        end
        return Taylor(x,length(x)-1)
    end
end
function taylor{T<:Number}(v::T,N::Int)#función Taylor aplicada sobre un número
    x=zeros(eltype(v),N+1)
    x[1]=v
    return taylor(x,N)#devuelve una estructura Taylor de orden 0
end
function taylor{T<:Number}(v::T)#función Taylor aplicada sobre un número
    x=zeros(eltype(v),1)
    x[1]=v
    return Taylor(x,0)#devuelve una estructura Taylor de orden 0
end
function taylor{T<:Number}(v::Array{T})#función Taylor aplicada sobre un vector
    n=length(v)#número de elementos del vector v
    X=[i=taylor(zero(eltype(v))) for i in 1:n]
    for i in 1:n
        X[i]=taylor(v[i],0)
    end
    return X#regresa un Taylor con el orden mayor del vector v
end
"""
simplificaT(x)

Función que expresa un tipo Taylor de la forma más compacta.
"""
function simplificaT(x)
    n=length(x.v)#número de elementos del vector x.v
    while(x.v[n]==0&& n>1)
        n=n-1
    end
    a=zeros(eltype(x.v),n)
    for i in 1:n
        a[i]=x.v[i]
    end
    return taylor(a,length(a)-1)
end
"""
igualvec(a,b)

Función que iguala la longitud de los vectores a y b. Llena con ceros los elementos faltantes.
"""
function igualvec(a,b)
    (n,m)=(length(a),length(b))
    if n==m
        return a,b
    elseif n<m
        x=append!(a,zeros(eltype(a),m-n))
        return x,b
    else
        x=append!(b,zeros(eltype(b),n-m))
        return a,x
    end
end
"""
taylorsum(a,b)

Función que regresa la suma de dos tipos Taylor.
"""
function taylorsum(a,b)#función que suma los coeficientes tipo Taylor
    (x,y)=igualvec(a.v,b.v)
    return taylor(x+y,length(x)-1)#suma los vectores y regresa un Taylor
end
"""
taylorres(a,b)

Función que regresa la diferencia de dos tipos Taylor.
"""
function taylorres(a,b)#función que suma los coeficientes tipo Taylor
    (x,y)=igualvec(a.v,b.v)
    return taylor(x-y,length(x)-1)#suma los vectores y regresa un Taylor
end
"""
producto(a,b)

Función que regresa el producto de dos vectores de la misma longitud.
"""
function producto(a,b)#producto de los coeficientes tipo Taylor para dos vectores de igual número de elementos
    x,y=igualvec(a,b)
    ab=zeros(eltype(x), length(x))#vector con los mismos elementos de a
    for k in 1:length(x)
        for i in 1:k
            ab[k]+=x[i]*y[k+1-i]
        end
    end
    return ab
end
"""
taylorprod(a,b)

Función que regresa el producto de dos tipos Taylor.
"""
function taylorprod(a,b)#función que devuelve el producto de los coeficientes tipo Taylor
    x,y=igualvec(a.v,b.v)
    o=producto(x,y)
    return taylor(o,length(x)-1)
end
"""
division(x,y)

Función que regresa el cociente de dos vectores de la misma longitud.
"""
function division(a,b)#división de los coeficientes tipo Taylor para dos vectores de igual número de elementos 
    x,y=igualvec(a,b)
    h=1
    for m in 1:length(x)
        if(y[m]==0 && x[m]==0)
            h=m+1
        else
            break
        end
    end
    a=[x[i] for i=h:length(x)]
    b=[y[i] for i=h:length(y)]
    divab=[zero(eltype(x)) for i=h:length(x)]
    if b[1]!=zero(eltype(y))
        divab[1]=a[1]/b[1]
        for k in 2:length(a)
            l=zero(eltype(a))
            for i in 1:k
                l+=divab[i]*b[k-i+1]
            end
            divab[k]=(1/b[1])*(a[k]-l)
        end
        return divab
    else
        return error("b[h] debe ser distinto de cero")
    end
end
"""
taylordiv(a,b)

Función que regresa el cociente de dos tipos Taylor.
"""
function taylordiv(a,b)#función que devuelve la división de los coeficientes tipo Taylor
    x,y=igualvec(a.v,b.v)
    return taylor(division(x,y),length(x)-1)
end
"""
taylorigual(a,b)

Función que determina si dos tipos Taylor son iguales.
"""
function taylorigual(a,b)
    (x,y)=igualvec(a.v,b.v)
    if x==y && a.n==b.n
        return true
    else
        return false
    end
end 
#Funciones que realizan operaciones entre estructuras tipo Taylor
import Base: +, -, *, /, ==,exp,^,log,sin,cos
for (f,f1,f2,f3) = ((:+,Taylor,Taylor,(:(taylorsum(a,b)))),
                    (:+,Taylor,Number,(:(a+taylor(b,length(a.v)-1)))),
                    (:+,Number,Taylor,(:(taylor(a,length(b.v)-1)+b))),                  
                    (:-,Taylor,Taylor,(:(taylorres(a,b)))),
                    (:-,Taylor,Number,(:(a-taylor(b,length(a.v)-1)))),
                    (:-,Number,Taylor,(:(taylor(a,length(b.v)-1)-b))),
                    (:*,Taylor,Taylor,(:(taylorprod(a,b)))),
                    (:*,Taylor,Number,(:(a*taylor(b,length(a.v)-1)))),
                    (:*,Number,Taylor,(:(taylor(a,length(b.v)-1)*b))),
                    (:/,Taylor,Taylor,(:(taylordiv(a,b)))),
                    (:/,Taylor,Number,(:(a/taylor(b,length(a.v)-1)))),
                    (:/,Number,Taylor,(:(taylor(a,length(b.v)-1)/b))),
                    (:(==),Taylor,Taylor,(:(taylorigual(a,b)))),
                    (:(==),Taylor,Number,(:(a==taylor(b,length(a.v)-1)))),
                    (:(==),Number,Taylor,(:(taylor(a,length(b.v)-1)==b))) ) 
              
    ex = quote
        $f(a::$f1,b::$f2)=$f3
    end
    @eval $ex
end                     
-(a::Taylor)=-1*a
"""
exp(g)
Función que regresa los coeficientes Taylor para la exp(g), donde g es un polinomio. 
"""
function exp(g::Taylor)#algoritmo que cálcula los coeficientes de Taylor para la función exp(g(x))
    a=taylor(zeros(eltype(g.v),length(g.v)),length(g.v)-1)
    for i in 1:length(g.v)-1
        a+=(1.0)(g)^(i)/factorial(big(i))
    end
    return a
end
"""
log(g)
Función que regresa los coeficientes Taylor para el log(g), donde g es un polinomio. 
"""
function log(g::Taylor)#algoritmo que cálcula los coeficientes de Taylor para la función log(g(x))
    L=zeros(eltype(g.v), length(g.v))
    L[1]=log(g.v[1])
    L[2]=g.v[2]/g.v[1]
    for k in 2:length(g.v)-1
    l=zero(eltype(g.v))
        for j in 1:k-1
            l+=j*L[j+1]*g.v[k+1-j]
        end
    L[k+1]=(1/g.v[1])*(g.v[k+1]-l/k)
    end
    return taylor(L,length(g.v)-1)
end
"""
^(g,alpha)
Función que regresa los coeficientes Taylor para (g)^α, donde g es un polinomio. 
"""
function ^(g::Taylor,alpha::Int64)#algoritmo que cálcula los coeficientes de Taylor para la función (g(x))^α
    a=g
    for i in 2:alpha
        a=taylorprod(a,g)
    end
    return a
end
"""
sen(g)
Función que regresa los coeficientes Taylor para sin(g), donde g es un polinomio. 
"""
function sin(g::Taylor)
    a=taylor(zeros(eltype(g.v),length(g.v)),length(g.v)-1)
    for i in 1:2:length(g.v)-1
        a+=(-1.0)^((i-1)/2)*(g)^(i)/factorial(big(i))
    end
    return a
end
"""
cos(g)
Función que regresa los coeficientes Taylor para cos(g), donde g es un polinomio. 
"""
function cos(g::Taylor)
    a=taylor(zeros(eltype(g.v),length(g.v)),length(g.v)-1)
    a=taylor(one(eltype(g.v)),length(g.v)-1)
    for i in 2:2:length(g.v)-1
        a+=(-1.0)^(i/2)*(g)^(i)/factorial(big(i))
    end
    return a
end


function CTaylor(eq1,eq2,x0,y0,t0,N)
    t=taylor(t0)
    x=taylor(x0)
    y=taylor(y0)
    for n in 1:N
        t=taylor(t0,n)
        x=taylor(x0,n)
        y=taylor(y0,n)
        a=eq1(t,x,y);a=taylor(a.v,n)
        b=eq2(t,x,y);b=taylor(b.v,n)
        x.v[n+1]=a.v[n]/n
        y.v[n+1]=b.v[n]/n
        x0=x.v
        y0=y.v
    end 
    return x,y
end
function pasointh(x,y,ϵ)
    (x,y)=(simplificaT(x),simplificaT(y))
    fh=(ϵ/abs(x.v[end]))^(1/(length(x.v)-1))
    fl=(ϵ/abs(x.v[end-2]))^(1/(length(x.v)-3))
    gh=(ϵ/abs(y.v[end]))^(1/(length(y.v)-1))
    gl=(ϵ/abs(y.v[end-2]))^(1/(length(y.v)-3))
    return min(fh,fl,gh,gl)
end
"""
Horner(h,x,P)

Función que regresa \$x_1\$ después de evaluar \$h\$ en el polinomio de Taylor. Implementa el método de Horner. 
\$h\$(paso de integración), \$x\$(arreglo de Taylor), \$P\$(grado máximo del polinomio) 
"""
function Horner(h,x,P)
    r = x.v[P]
    for i in P:-1:2
        r = x.v[i-1] + h*r
    end
    return r
end
function integrador(eq1,eq2,x0,y0,t0,tf,ϵ,N)
    M=300000 #número máximo de elementos para los vectores
    s1=zeros(eltype(x0), M)
    s2=zeros(eltype(y0), M)
    t=zeros(eltype(t0), M)
    s1[1]=x0
    s2[1]=y0
    i=2
    while i<=M && t[i-1]<=tf
        x,y=CTaylor(eq1,eq2,x0,y0,t[i],N)
        (x,y)=(simplificaT(x),simplificaT(y))
        h=pasointh(x,y,ϵ)
        x0=Horner(h,x,x.n+1)
        y0=Horner(h,y,y.n+1)
        s1[i]=x0
        s2[i]=y0
        t[i]=t[i-1]+h
        i+=1
    end
    t=taylor(t,length(t)-1);s1=taylor(s1,length(s1)-1);s2=taylor(s2,length(s2)-1)
    (t,s1,s2)=(simplificaT(t),simplificaT(s1),simplificaT(s2))
    return t.v,s1.v,s2.v
end

"""
    metRungeKutta2(f1,f2,x0,y0,z0,N,h)

Esta función resuelve la ecuación diferencial \$y=f(x,y,z)=\dot{x}\$ con condición inicial \$x(t_0)=x_0\$,
\$-2x=g(x,y,z)=\ddot{x}\$ con condición inicial \$\dot{x}(t_0)=y_0\$. Los valores de 
entrada son \$f=f(t,x,y)\;,g=g(t,x,y)\$, \$t0,tf,x0,y0\$(condiciones iniciales), 
\$h\$(tamaño del intervalo \$[t_n,t_{n+1}]\$).
"""
function metRungeKutta2(f,g,t0,tf,x0,y0,h)
    N=Int((tf-t0)/h)
    t=zeros(eltype(h),N)
    x=zeros(eltype(h),N)
    y=zeros(eltype(h),N)
    t[1]=t0 
    x[1]=x0
    y[1]=y0
    return kasRK42(f,g,t,x,y,h)
end
function kasRK42(f,g,t,x,y,h)#función de apoyo para el método de Runge Kutta
    for i in 1:length(x)-1
        kn11=f(t[i],x[i],y[i])#kn1 para f
        kn12=g(t[i],x[i],y[i])#kn1 para g
        
        kn21=f(t[i]+(1/2)*h,x[i]+(1/2)*h*kn11,y[i]+(1/2)*h*kn12)#kn1 para f
        kn22=g(t[i]+(1/2)*h,x[i]+(1/2)*h*kn11,y[i]+(1/2)*h*kn12)#kn1 para g
        
        kn31=f(t[i]+(1/2)*h,x[i]+(1/2)*h*kn21,y[i]+(1/2)*h*kn22)#kn1 para f
        kn32=g(t[i]+(1/2)*h,x[i]+(1/2)*h*kn21,y[i]+(1/2)*h*kn22)#kn1 para g
        
        kn41=f(t[i]+h,x[i]+h*kn31,y[i]+h*kn32)#kn1 para f
        kn42=g(t[i]+h,x[i]+h*kn31,y[i]+h*kn32)#kn1 para g
        
        x[i+1]=x[i]+(h/6)*(kn11 +2kn21+2kn31+kn41)
        y[i+1]=y[i]+(h/6)*(kn12 +2kn22+2kn32+kn42)
        t[i+1]=i*h
    end
    return t,x,y
end

end
