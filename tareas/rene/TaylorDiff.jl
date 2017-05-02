
#=
En este módulo estan definidos elementos tipo Taylor.

René Mora Maya

29-04-17
=#
# La siguiente instrucción sirve para *precompilar* el módulo
__precompile__(true)

module AD
    import Base: +, -, *, /, ==
    export Taylor,producto,division,igualvec,veclleno,Cexp
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
    return Taylor(x,0)
end
function Taylor{T<:Number}(v::Array{T,1})#función Taylor aplicada sobre un vector
    n=length(v)
    return Taylor(v,n-1)
end
function veclleno(A,n)#vector A con n elementos
    a=[i=zero(eltype(A)) for i=1:n]
    if n<length(A)
        for i in 1:n
            a[i]=A[i]
        end
        return a
    elseif n==length(A)
        return A
    else
        for i in 1:length(A)
            a[i]=A[i]
        end
        return a
    end
end
function igualvec(a,b) #función que iguala la longitud de los vectores. Se llenan con ceros
    if length(a)<length(b)
        x=[i=zero(eltype(a)) for i=1:length(b)]
        for i in 1:length(a)
            x[i]=a[i]
        end
        return x,b
    elseif length(a)==length(b)
        return a,b
    else 
        x=[i=zero(eltype(b)) for i=1:length(a)]
        for i in 1:length(b)
            x[i]=b[i]
        end
        return a,x
    end
end
function taylorsum(a,b)#función que suma los coeficientes tipo Taylor
    (x,y)=igualvec(a,b)
    if length(a)<length(b)
        return Taylor(x+y,length(b)-1)
    elseif length(a)==length(b)
        return Taylor(a+b,length(b)-1)
    else
        return Taylor(x+y,length(a)-1)
    end
end
function taylorres(a,b)#función que resta los coeficientes tipo Taylor
    (x,y)=igualvec(a,b)
    if length(a)<length(b)
        return Taylor(x-y,length(b)-1)
    elseif length(a)==length(b)
        return Taylor(a-b,length(b)-1)
    else
        return Taylor(x-y,length(a)-1)
    end
end
function producto(a,b)#producto de los coeficientes tipo Taylor para dos vectores de igual número de elementos
    ab=[i=zero(eltype(a)) for i=1:length(a)]
    for k in 1:length(a)
        for i in 1:k
            ab[k]+=a[i]*b[k+1-i]
        end
    end
    return ab
end
function taylorprod(a,b)#función que devuelve el producto de los coeficientes tipo Taylor
    (x,y)=igualvec(a,b)
    if length(a)<length(b)
        return Taylor(producto(x,y),length(b)-1)
    elseif length(a)==length(b)
        return Taylor(producto(a,b),length(b)-1)
    else
        return Taylor(producto(x,y),length(a)-1)
    end
end
function division(a,b)#división de los coeficientes tipo Taylor para dos vectores de igual número de elementos 
    if b[1]!=zero(eltype(b))
        divab=[i=zero(eltype(a)) for i=1:length(a)]
        divab[1]=a[1]/b[1]
        for k in 2:length(a)
            l=zero(eltype(a))
            for i in 1:k-1
                l+=divab[i]*b[k-i+1]
            end
            divab[k]=(1/b[1])*(a[k]-l)
        end
        return divab
    else
        return error("b[1] debe ser distinto de cero")
    end
end
function taylordiv(a,b)#función que devuelve la división de los coeficientes tipo Taylor
    (x,y)=igualvec(a,b)
    if length(a)<length(b)
        return Taylor(division(x,y),length(b)-1)
    elseif length(a)==length(b)
        return Taylor(division(a,b),length(b)-1)
    else
        return Taylor(division(x,y),length(a)-1)
    end
end
function Cexp(G,n)#algoritmo que cálcula los coeficientes de Taylor para la función exp(g(x))
    E=[i=zero(eltype(G)) for i=1:n+1]
    g=veclleno(G,length(E))
    E[1]=exp(g[1])
    E[2]=g[2]*E[1]
    for k in 2:n
        p=zero(eltype(G))
        for j in 0:k-1
            p+=(k-j)*g[k+1-j]*E[j+1]
        end
    E[k+1]=p/k
    end
    return Taylor(E)
end
for (f,f1,f2,f3) = ((:+,Taylor,Taylor,(:(taylorsum(a.v,b.v)))),
                    (:+,Taylor,Number,(:(Taylor(a.v)+Taylor(b)))),
                    (:+,Number,Taylor,(:(Taylor(a)+Taylor(b.v)))),
                    (:-,Taylor,Taylor,(:(taylorres(a.v,b.v)))),
                    (:-,Taylor,Number,(:(Taylor(a.v)-Taylor(b)))),
                    (:-,Number,Taylor,(:(Taylor(a)-Taylor(b.v)))),
                    (:*,Taylor,Taylor,(:(taylorprod(a.v,b.v)))),
                    (:*,Taylor,Number,(:(Taylor(a.v)*Taylor(b)))),
                    (:*,Number,Taylor,(:(Taylor(a)*Taylor(b.v)))),
                    (:/,Taylor,Taylor,(:(taylordiv(a.v,b.v)))),
                    (:/,Taylor,Number,(:(Taylor(a.v)/Taylor(b)))),
                    (:/,Number,Taylor,(:(Taylor(a)/Taylor(b.v)))),
                    (:(==),Taylor,Taylor,(:(a.v==b.v && a.n==b.n))),
                    (:(==),Taylor,Number,(:(Taylor(a)==Taylor(b)))),
                    (:(==),Number,Taylor,(:(Taylor(a)==Taylor(b)))),
                    (:exp,Taylor,Int,(:(Cexp(a.v,b)))) )
              
    ex = quote
        $f(a::$f1,b::$f2)=$f3
    end
    @eval $ex
end


end
