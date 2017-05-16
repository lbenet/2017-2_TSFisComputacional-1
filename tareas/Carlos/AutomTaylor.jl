__precompile__(true)
module BD
    import Base: +, -, *, /, ==  #importo las operaciones principales
    export Taylor
    
    #incluyendo, primero que nada, la definición de Taylor.

type Taylor{T<:Number}
    orden::Int #el orden de la serie de taylor.
    coff::Array{T,1}   #coeficientes en la serie de taylor.
    function Taylor(orden::Int,coff::Array{T,1})#ESTE AGREGADO ES NECESARIO PARA GARANTIZAR QUE TODOS LOS ELEMENTOS INGRESADOS EN EL VECTOR SEAN DEL MISMO ORDEN QUE LA N PROPUESTA
        if length(coff)==orden+1
            new(orden,coff) 
        else
        error("función no válida ya que el orden no coincide con el número de coeficientes")
        end
    end
end
#se especifican los posibles casos para los que se puede usar este taylor.
Taylor{T<:Number}(orden::Int,coff::Array{T,1})=Taylor{T}(orden,coff)    #el caso general
Taylor{T<:Number}(coff::Array{T,1})=Taylor{T}(length(coff-1),coff)
Taylor{T<:Number}(orden::Int,coff::T)=Taylor{T}(orden,[coff])    #este caso particular es para escalares 

#esta parte es para ver si los elementos son del mismo orden para hacer la suma y resta, de no ser así, obtener el orden deseado para hacer la suma
function igualavector!(a,b)
    if length(a.coff) < length(b.coff)
        for i in length(a.coff):length(b.coff)-1
            push!(a.coff,0)
        end
        return a.coff
    elseif length(a.coff) > length(b.coff)
        for i in length(b.coff):length(a.coff)-1
            push!(b.coff,0)
        end 
        return b.coff
    end
end

#suma de taylor
function +(f::Taylor,g::Taylor) 
    igualavector!(f,g)  #igualdor de taylor's
    return Taylor(f.orden,f.coff+g.coff)   #operación artimética directa, la resta es análoga
end

#resta de taylor
function -(f::Taylor,g::Taylor)
    igualavector!(f,g)  #se usa el igualador de taylor's
    return Taylor(f.orden,f.coff-g.coff)  
end

#producto entre taylors
#funcion auxiliar para hacer el producto
function prod!(f::Taylor,g::Taylor)
    m=Taylor(f.orden+g.orden,zeros(f.orden+g.orden+1))    #taylor auxiliar para poder hacer el producto
    f=igualavector!(f,m)
    g=igualavector!(g,m)     #con esto se tienen vectores de mismo orden y coeficientes
    return f,g
end
#fin de l funcion axiliar
#funcion principal de taylor
function *(f::Taylor,g::Taylor)     #con la funcion prod ya formulada, se puede hacer producto ya que son del mismo orden
    prod!(f,g)                    #se usa el promotor de coeficientes
    z=Taylor(f.orden,zeros(f.orden+1)) 
    for i in 1:length(f.coff)       #se usa doble ciclo for para poder hacer el producto por cada coeficiente y depositarl en el resultado
        for j in 1:i
            z.coff[i]+=f.coff[j]*g.coff[i+1-j]
        end
    end
    return z
end
*(A::Real,B::Taylor)=Taylor(B.orden,A*B.coff)
*(A::Taylor,B::Real)=Taylor(A.orden,B*A.coff)
#fin del producto

#comparación
==(A::Taylor,B::Taylor)=(A.orden==B.orden && A.coff==B.coff)

#cociente entre taylors
function /(f::Taylor,g::Taylor)
    d=f.orden-g.orden   #el discriminante para ver si la división da como resultado un polinomio
    if d<0
        error("división no válida ya que el resultado no es un polinomio de grado mayor a cero")
    end
    #fin del if
    igualavector!(f,g)   #se igualan los coeficientes para poder operar en la división
    cociente=zeros(f.orden+1)
    h=1    #contador que indica donde se empieza a ser el resultado distinto de cero
    for i in 1:length(g.coff)
        if g.coff[i]!=0
            cociente[1]=(f.coff[i])/(g.coff[i])     #es es para hacer la división y evitar dividir coeficientes cero
            h=i
            break
            elseif (i==length(g.coff)) & (g.coff[i]==0)    #en caso de encontrar un coeficiente del denominador con cero, manda un error
            error("polinomio divisor posee un cero")
        end
    end
    #fin del for
    for i in 1:h-1   #usando el contador del ciclo pasado
        if f.coff[i]!=0
            error("no tiene una expansión de Taylor")  #esto es para asegurar que no sea de la forma a^n/b^m donde m>n
        end
    end
    #lo que falta ahora, es hacer el resto de la división si el polinomio cumple con lo estipulado previamente
    #como en el producto, en el cociente se hace doble ciclo for
    for i in h+1:length(cociente)-h
        suma=0 #suma de los resultados que se lleven a cabo en la division
        for j in 1:i-h
            suma=suma+(cociente[j])*g.coff[i-j+1]
        end
        cociente[1+i-h]=(1/g.coff[h])*(f.coff[i]-suma)
    end
    if cociente[d+2]==0
        deleteat!(cociente,d+2)
    end
    return Taylor(d,cociente)
end
/(A::Taylor,B::Real)=Taylor(A.orden,(A.coff)/B)
#fin de la división

import Base:exp,log,^,sin,cos   #importando mas funciones
#anexo para funciones del problema 2

#exponencial
function exp(f::Taylor) #se implementa la función de la exponencial
    v=zeros(Number,f.orden+1)
    v[1]=exp(f.coff[1])
    for i in 2:length(v)
        for j in 1:i-1
            v[i]+=(i-j)*(f.coff[i-j+1])*(v[j])
        end
        v[i]=(v[i])/(i-1)
    end
    return Taylor(length(v)-1,v)
end
#fin de la exponencial

#logaritmo
function log(f::Taylor)  #se implementa la función de logaritmo
    L=zeros(length(f.coff))
    m=0
    L[1]=log(f.coff[1])
    L[2]=(f.coff[2])/(f.coff[1])
    for i in 2:length(f.coff)-1
        for j in 1:i-1
            m+=j*L[j+1]*(f.coff[i+1-j])
        end
        L[i+1]=(1/f.coff[1])*(f.coff[i+1]-m/i)
    end
    return Taylor(length(L)-1,L)
end
#fin del logaritmo

#potencias
function ^(f::Taylor,a::Int)   #funcion que implementa la exponencial
    P=zeros(length(f.coff))
    m=0
    if a==0
        Taylor(length(f.coff),zeros(length(f.coff)))
    else
        P[1]=(f.coff[1])^(a)
        P[2]=a*((f.coff[2])/(f.coff[1]))*P[1]
        for i in 1:length(f.coff)-1
            for j in 1:i-1
                m+=((a*i)-(a+1)*(j))*(f.coff[i+1-j])*(P[j+1])
            end
            P[i+1]=(a)*(f.coff[i+1]/f.coff[1])*P[1]+(1/(i*f.coff[1]))*m
        end
        return Taylor(length(P)-1,P)
    end
end
#fin de potencias

#seno
function sin(f::Taylor)   #creando la función de seno
    S=zeros(length(f.coff))
    C=zeros(length(f.coff))
    C[1]=cos(f.coff[1])
    S[2]=C[1]    #se hará lo mismo para coseno
    m=0
    for i in 2:length(f.coff)-1
        for j in 0:i-1
            m+=(i-j)*(f.coff[i+1-j])*(S[j+1])
        end
        S[i+1]=m/i
    end
    return Taylor(length(S)-1,S)
end
#fin de seno

#coseno
function cos(f::Taylor)   #creando la funcion coseno, semejante a la del seno
    S=zeros(length(f.coff))
    C=zeros(length(f.coff))
    C[1]=cos(f.coff[1])
    S[2]=C[1]
    m=0
    for i in 2:length(f.coff)-1
        for j in 0:i-1
            m+=(i-j)*f(f.coff[i+1-j])*(C[j+1])
        end
        C[i+1]=-(m/i)
    end
    return Taylor(length(C)-1,C)
end
#fin de coseno
#fin del agregado


end
