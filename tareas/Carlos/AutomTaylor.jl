__precompile__(true)
module BD
    import Base: +, -, *, /, ^, ==  #importo las operaciones principales
    export Taylor,xTaylor
    
    #incluyendo, primero que nada, la definición de Taylor.

type Taylor{T<:Number}
    orden::Int64 #el orden de la serie de taylor.
    coff::Array{T,1}   #coeficientes en la serie de taylor.
end

function taylor(n,v)    #ESTE AGREGADO ES NECESARIO PARA GARANTIZAR QUE TODOS LOS ELEMENTOS INGRESADOS EN EL VECTOR SEAN DEL MISMO ORDEN QUE LA N PROPUESTA
    if length(v)==n
        return Taylor(n-1,v)   #el primer elemento del vector es de orden 0, por eso la sustraccción
    else
        error("función no válida")
    end
end
#definición de xTaylor

function xTaylor(n)
    w=zeros(n) #genera un vector de n ceros
    w=deleteat!(w,n)#el último elemento no es cero
    w=append!(w,1.0) #el último elemento del vector de orden cero es 1.0
    return Taylor(n,w)
end
#esta parte es para verisi los elementos son del mismo orden para hacer la suma y resta, de no ser así, obtener el orden deseado para hacer la suma
function igualavector(a,b)
    if length(a.coff) < length(b.coff)
        for i in length(a.coff):length(b.coff)-1
            push!(a.coff,0)
        end
        return a.coff
    elseif length(a.coff) >length(b.coff)
        for i in length(b.coff):length(a.coff)-1
            push!(b.coff,0)
        end 
        return b.coff
    end
end

#suma de vecotres
function sumavector(a,b)
    igualavector(a,b)
    v=a.coff+b.coff
    return taylor(a.orden,v)
end

#resta de vectores
function restavector(a,b)
    igualavector(a,b)
    v=a.coff-b.coff
    return taylor(a.orden,v)
end

#incluyendo las operaciones de Taylor

+(A::Taylor,B::Taylor)=Taylor(A.orden,A.coff+B.coff)
-(A::Taylor,B::Taylor)=Taylor(A.orden,A.coff-B.coff)

*(A::Real,B::Taylor)=Taylor(B.orden,A*B.coff)
*(A::Taylor,B::Real)=Taylor(A.orden,B*A.coff)

/(A::Taylor,B::Real)=Taylor(A.orden,(A.coff)/B)

==(A::Taylor,B::Taylor)=(A.orden==B.orden && A.coff==B.coff)

end
