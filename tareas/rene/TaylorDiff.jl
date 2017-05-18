
#=
En este módulo estan definidos elementos tipo Taylor.

René Mora Maya

29-04-17
=#
# La siguiente instrucción sirve para *precompilar* el módulo
__precompile__(true)

module ATaylor
    import Base: +, -, *, /, ==,exp,log,^,sin,cos 
export Taylor,taylor,producto,division,taylorsum,taylorres,taylorprod,taylordiv,taylorigual,Cexp,coeflog,Cexpalpha,Csencos,Csen,Ccos
"""
Taylor

Definición de polinomios de Taylor, donde v representa los coeficientes 
\$f_{[k]} = \\frac{f^{(k)}(x_0)}{k!} = \\frac{1}{k!}\\frac{d^k f}{dx^k}(x_0)\$ evaluados en \$x_0\$ y n es 
el grado del polinomio.
"""
type Taylor{T<:Number}
    v::Array{T,1}
    n::Int
end
function Taylor{T<:Number}(v::T)#función Taylor aplicada sobre un número
    x=[zero(eltype(v))]
    x[1]=v
    return Taylor(x,0)#devuelve una estructura Taylor de orden 0
end
function Taylor{T<:Number}(v::Array{T,1})#función Taylor aplicada sobre un vector
    i=length(v)#número de elementos del vector v
    while(v[i]==0&& i>1)
        i=i-1
    end
    x=zeros(eltype(v), i)#vector con i elementos
    for j in 1:i
        x[j]=v[j]
    end
    return Taylor(x,i-1)#regresa un Taylor con el orden mayor del vector v
end
"""
taylor(v,n)
Función que representa una estructura Taylor con n+1 elementos de v. Si los elementos de v son menores 
a n llena los elementos faltantes con ceros. Siempre regresa el orden del vector v.
"""
function taylor(v,n)#función Taylor aplicada sobre un vector
    x=Taylor(v)
    a=zeros(eltype(v), n+1)
    if x.n==n
        return x
    elseif x.n<n
        for i in 1:x.n+1
            a[i]=x.v[i]
        end
        return Taylor(a,x.n)
    else
        for i in 1:n+1
            a[i]=x.v[i]
        end
        return Taylor(a,x.n)
    end
end
"""
taylorsum(a,b)
Función que suma dos estructuras Taylor a y b.
"""
function taylorsum(a,b)#función que suma los coeficientes tipo Taylor
    (x,y)=(Taylor(a.v),Taylor(b.v))
    if x.n==y.n#comparo los ordenes de la estructura Taylor de a y b
        return Taylor(x.v+y.v)#suma los vectores y regresa un Taylor
    elseif x.n<y.n
        z=taylor(x.v,y.n)
        return Taylor(z.v+y.v)
    else 
        z=taylor(y.v,x.n)
        return Taylor(x.v+z.v)
    end
end
"""
taylorres(a,b)
Función que resta dos estructuras Taylor a y b.
"""
function taylorres(a,b)#función que suma los coeficientes tipo Taylor
    (x,y)=(Taylor(a.v),Taylor(b.v))
    if x.n==y.n#comparo los ordenes de la estructura Taylor de a y b
        return Taylor(x.v-y.v)#resta los vectores y regresa un Taylor
    elseif x.n<y.n
        z=taylor(x.v,y.n)
        return Taylor(z.v-y.v)
    else 
        z=taylor(y.v,x.n)
        return Taylor(x.v-z.v)
    end
end
"""
producto(a,b)
Función que regresa el producto de dos vectores a,b de igual magnitud. Implementa las operaciones aritméticas de 
Taylor.
"""
function producto(a,b)#producto de los coeficientes tipo Taylor para dos vectores de igual número de elementos
    ab=zeros(eltype(a), length(a))#vector con los mismos elementos de a
    for k in 1:length(a)
        for i in 1:k
            ab[k]+=a[i]*b[k+1-i]
        end
    end
    return ab
end
"""
taylorprod(a,b)
Función que regresa el producto de dos estructuras tipo Taylor. 
"""
function taylorprod(a,b)#función que devuelve el producto de los coeficientes tipo Taylor
    (x,y)=(Taylor(a.v),Taylor(b.v))
    o=taylor(x.v,x.n+y.n)
    f=taylor(y.v,x.n+y.n)
    return Taylor(producto(o.v,f.v))
end
"""
division(a,b)
Función que regresa la división de dos vectores a,b de igual magnitud. Implementa las operaciones aritméticas de 
Taylor.
"""
function division(x,y)#división de los coeficientes tipo Taylor para dos vectores de igual número de elementos 
    h=1
    for m in 1:length(x)
        if(y[m]==0 && x[m]==0)
            h=m+1
        else
            break
        end
    end
    a=[x[i] for i=h:length(x)]
    b=[y[i] for i=h:length(x)]
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
Función que regresa el división de dos estructuras tipo Taylor. 
"""
function taylordiv(a,b)#función que devuelve la división de los coeficientes tipo Taylor
    (x,y)=(Taylor(a.v),Taylor(b.v))
    o=taylor(x.v,x.n+y.n)
    f=taylor(y.v,x.n+y.n)
    return Taylor(division(o.v,f.v))
end
"""
taylorigual(a,b)
Función que compara dos estructuras tipo Taylor. 
"""
function taylorigual(a,b)
    (x,y)=(Taylor(a.v),Taylor(b.v))
    if x.v==y.v
        return true
    else
        return false
    end
end

"""
Cexp(g)
Función que regresa los coeficientes Taylor para la exp(g), donde g es un polinomio. 
"""
function Cexp(g)#algoritmo que cálcula los coeficientes de Taylor para la función exp(g(x))
    E=zeros(eltype(g.v), length(g.v))
    E[1]=exp(g.v[1])
    E[2]=g.v[2]*E[1]
    for k in 2:length(g.v)-1
        p=zero(eltype(g.v))
        for j in 0:k-1
            p+=(k-j)*g.v[k+1-j]*E[j+1]
        end
    E[k+1]=p/k
    end
    return Taylor(E)
end
"""
coeflog(g)
Función que regresa los coeficientes Taylor para el ln(g), donde g es un polinomio. 
"""
function coeflog(g)#algoritmo que cálcula los coeficientes de Taylor para la función log(g(x))
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
    return Taylor(L)
end
"""
Cexpalpha(g,alpha)
Función que regresa los coeficientes Taylor para (g)^α, donde g es un polinomio. 
"""
function Cexpalpha(g,alpha)#algoritmo que cálcula los coeficientes de Taylor para la función (g(x))^α
    if(g.v[1]!=0)
    P=zeros(eltype(g.v), length(g.v))
    P[1]=(g.v[1])^alpha
    P[2]=alpha*(g.v[2]/g.v[1])*P[1]
    for k in 2:length(g.v)-1
    p=zero(eltype(g.v))
        for j in 1:k-1
            p+=(alpha*k-(alpha+1)*j)*g.v[k+1-j]*P[j+1]
        end
    P[k+1]=alpha*(g.v[k+1]/g.v[1])*P[1]+(1/(k*g.v[1]))*p
    end
    return Taylor(P)
    else 
    return error("el orden cero de g debe ser distinto de cero")
    end
end
"""
Csencos(g)
Función que regresa a la vez,los coeficientes Taylor para sin(g) y cos(g), donde g es un polinomio. 
"""
function Csencos(g)#algoritmo que cálcula los coeficientes de Taylor para las funciones cos(g(x)) y sin(g(x))
    S=zeros(eltype(g.v), length(g.v))
    C=zeros(eltype(g.v), length(g.v))
    C[1]=cos(g.v[1])
    S[2]=C[1]
    for k in 2:length(g.v)-1
        p=zero(eltype(g.v))
        q=zero(eltype(g.v))
        for j in 0:k-1
            p+=(k-j)*g.v[k+1-j]*C[j+1]
            q+=(k-j)*g.v[k+1-j]*S[j+1]
        end
    S[k+1]=p/k
    C[k+1]=-q/k
    end
    return Taylor(C),Taylor(S)
end
"""
Csen(g)
Función que regresa los coeficientes Taylor para sin(g), donde g es un polinomio. 
"""
function Csen(g)
    (a,b)=Csencos(g)
    return b
end
"""
Ccos(g)
Función que regresa los coeficientes Taylor para cos(g), donde g es un polinomio. 
"""
function Ccos(g)
    (a,b)=Csencos(g)
    return a
end

for (f,f1,f2,f3) = ((:+,Taylor,Taylor,(:(taylorsum(a,b)))),
                    (:+,Taylor,Number,(:(Taylor(a)+Taylor(b)))),
                    (:+,Number,Taylor,(:(Taylor(a)+Taylor(b)))),
                    (:-,Taylor,Taylor,(:(taylorres(a,b)))),
                    (:-,Taylor,Number,(:(Taylor(a)-Taylor(b)))),
                    (:-,Number,Taylor,(:(Taylor(a)-Taylor(b)))),
                    (:*,Taylor,Taylor,(:(taylorprod(a,b)))),
                    (:*,Taylor,Number,(:(Taylor(a)*Taylor(b)))),
                    (:*,Number,Taylor,(:(Taylor(a)*Taylor(b)))),
                    (:/,Taylor,Taylor,(:(taylordiv(a,b)))),
                    (:/,Taylor,Number,(:(Taylor(a)/Taylor(b)))),
                    (:/,Number,Taylor,(:(Taylor(a)/Taylor(b)))),
                    (:(==),Taylor,Taylor,(:(taylorigual(a,b)))),
                    (:(==),Taylor,Number,(:(a==Taylor(b)))),
                    (:(==),Number,Taylor,(:(Taylor(a)==b))) )
              
    ex = quote
        $f(a::$f1,b::$f2)=$f3
    end
    @eval $ex
end
-(a::Taylor)=-1*a

exp(a::Taylor)=Cexp(a)
log(a::Taylor)=coeflog(a)
^(a::Taylor,b::Int)=Cexpalpha(a,b)
sin(a::Taylor)=Csen(a)
cos(a::Taylor)=Ccos(a)

end

#=
Funciones opcionales
function taylorprod(a,b)#función que devuelve el producto de los coeficientes tipo Taylor
    (x,y)=(Taylor(a.v),Taylor(b.v))
    if x.n==y.n
        o=taylor(x.v,length(x.v)+length(y.v))
        f=taylor(y.v,length(x.v)+length(y.v))
        return Taylor(producto(o.v,f.v))
    elseif x.n<y.n
        z=taylor(x.v,y.n)
        return Taylor(producto(z.v,y.v))
    else
        z=taylor(y.v,x.n)
        return Taylor(producto(z.v,x.v))
    end
end
function taylordiv(a,b)#función que devuelve la división de los coeficientes tipo Taylor
    (x,y)=(Taylor(a.v),Taylor(b.v))
    if x.n==y.n
        return Taylor(division(x.v,y.v))
    elseif x.n<y.n
        z=taylor(x.v,y.n)
        return Taylor(division(z.v,y.v))
    else
        z=taylor(y.v,x.n)
        return Taylor(division(x.v,z.v))
    end
end
=#
