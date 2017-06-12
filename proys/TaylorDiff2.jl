
#=
En este módulo estan definidos elementos tipo Taylor.

René Mora Maya

29-04-17
=#
# La siguiente instrucción sirve para *precompilar* el módulo
__precompile__(true)

module AT
    import Base: +, -, *, /, ==,exp,log,^,sin,cos 
export Taylor,taylor,producto,division,taylorsum,taylorres,taylorprod,taylordiv,taylorigual,integrador,Horner,pasointh,simplificaT,coefTaylor
type Taylor{T<:Number}
    v::Array{T,1}
    n::Int
end
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
        return Taylor(x,i-1)
    elseif i>n
        x=zeros(eltype(v),n+1)
        for j in 1:n+1
            x[j]=v[j]
        end
        return Taylor(x,i-1)
    else
        x=zeros(eltype(v),n+1)
        for j in 1:i
            x[j]=v[j]
        end
        return Taylor(x,n)
    end
end
function Taylor{T<:Number}(v::T,n::Int)#función Taylor aplicada sobre un número
    x=zeros(eltype(v),n+1)
    x[1]=v
    return Taylor(x,0)#devuelve una estructura Taylor de orden 0
end
function Taylor{T<:Number}(v::T)#función Taylor aplicada sobre un número
    x=zeros(eltype(v),1)
    x[1]=v
    return Taylor(x,0)#devuelve una estructura Taylor de orden 0
end
function Taylor{T<:Number}(v::Array{T,1})#función Taylor aplicada sobre un vector
    i=length(v)#número de elementos del vector v
    while(v[i]==0&& i>1)
        i=i-1
    end
    return Taylor(v,i-1)#regresa un Taylor con el orden mayor del vector v
end
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
function taylorsum(a,b)#función que suma los coeficientes tipo Taylor
    (x,y)=igualvec(a.v,b.v)
    return Taylor(x+y)#suma los vectores y regresa un Taylor
end
function taylorres(a,b)#función que suma los coeficientes tipo Taylor
    (x,y)=igualvec(a.v,b.v)
    return Taylor(x-y)#suma los vectores y regresa un Taylor
end
function producto(a,b)#producto de los coeficientes tipo Taylor para dos vectores de igual número de elementos
    ab=zeros(eltype(a), length(a))#vector con los mismos elementos de a
    for k in 1:length(a)
        for i in 1:k
            ab[k]+=a[i]*b[k+1-i]
        end
    end
    return ab
end
function taylorprod(a,b)#función que devuelve el producto de los coeficientes tipo Taylor
    o=taylor(a.v,a.n+b.n)
    f=taylor(b.v,a.n+b.n)
    return Taylor(producto(o.v,f.v))
end
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
function taylordiv(a,b)#función que devuelve la división de los coeficientes tipo Taylor
    o=taylor(a.v,a.n+b.n)
    f=taylor(b.v,a.n+b.n)
    return Taylor(division(o.v,f.v))
end
function taylorigual(a,b)
    (x,y)=igualvec(a.v,b.v)
    if x==y && a.n==b.n
        return true
    else
        return false
    end
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
^(a::Taylor, N::Number) = exp(N * log(a))
function ^(a::Float64, N::Int64)
    for i in 2:N
        a=a*a
    end
    return a
end
function exp(g::Taylor)#algoritmo que cálcula los coeficientes de Taylor para la función exp(g(x))
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
    return Taylor(L)
end
function ^(g::Taylor,alpha::Int64)#algoritmo que cálcula los coeficientes de Taylor para la función (g(x))^α
    a=g
    for i in 2:alpha
        a=taylorprod(a,g)
    end
    return a
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
function sin(g::Taylor)
    (a,b)=Csencos(g)
    return b
end
function cos(g::Taylor)
    (a,b)=Csencos(g)
    return a
end
######################################################################
#Funciones usadas para resolver ecuaciones diferenciales
function coefTaylor(eq1,eq2,x0,y0,t0,N)
    t=Taylor([0.0,t0])
    x=Taylor([x0,0])
    y=Taylor([y0,0])
    for n in 1:N
        q=eq1(t,x,y);                       w=eq2(t,x,y)
        a=taylor(q.v,n+1);                  b=taylor(w.v,n+1)
        x.v[n+1]=a.v[n]/n;                  y.v[n+1]=b.v[n]/n
        x.v=append!(x.v,zero(eltype(x.v))); x=Taylor(x.v)
        y.v=append!(y.v,zero(eltype(y.v))); y=Taylor(y.v)
        t.v=append!(t.v,zero(eltype(t.v))); t=Taylor(t.v)
    end
    return x,y
end
function simplificaT(x)
    n=length(x.v)#número de elementos del vector x.v
    while(x.v[n]==0&& n>1)
        n=n-1
    end
    a=zeros(eltype(x.v),n)
    for i in 1:n
        a[i]=x.v[i]
    end
    return Taylor(a)
end
function pasointh(x,y,ϵ)
    (x,y)=(simplificaT(x),simplificaT(y))
    fh=(ϵ/abs(x.v[end]))^(1/(length(x.v)-1))
    fl=(ϵ/abs(x.v[end-2]))^(1/(length(x.v)-3))
    gh=(ϵ/abs(y.v[end]))^(1/(length(y.v)-1))
    gl=(ϵ/abs(y.v[end-2]))^(1/(length(y.v)-3))
    return min(fh,fl,gh,gl)
end
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
        x,y=coefTaylor(eq1,eq2,x0,y0,t[i],N)
        (x,y)=(simplificaT(x),simplificaT(y))
        h=pasointh(x,y,ϵ)
        x0=Horner(h,x,x.n+1)
        y0=Horner(h,y,y.n+1)
        s1[i]=x0
        s2[i]=y0
        t[i]=t[i-1]+h
        i+=1
    end
    t=Taylor(t);s1=Taylor(s1);s2=Taylor(s2)
    (t,s1,s2)=(simplificaT(t),simplificaT(s1),simplificaT(s2))
    return t.v,s1.v,s2.v
end

end
