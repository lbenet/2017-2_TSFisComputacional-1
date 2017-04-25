__precompile__(true)
module AD
    import Base: +, -, *, /, ^, ==  #importo las operaciones principales
    export Taylor,xTaylor
    
    #incluyendo, primero que nada, la definición de Taylor.

type Taylor{T<:Number}
    orden::Int64 #el orden de la serie de taylor.
    coff::Array{T,1}   #coeficientes en la serie de taylor.
end

function Taylor(orden,coff)
    return Taylor(promote(orden,coff)...)#al igual que la tarea3, se bhace la especificación de cómo estará compuesto la función taylor
end    
function taylor(n,v)    #ESTE AGREGADO ES NECESARIO PARA GARANTIZAR QUE TODOS LOS ELEMENTOS INGRESADOS EN EL VECTOR SEAN DEL MISMO ORDEN QUE LA N PROPUESTA
    if length(v)==n
        return Taylor(n,v)
    else
        println("función no válida")
    end
end
#definición de xTaylor

function xTaylor(n)
    w=zeros(n) #genera un vector de n ceros
    w=deleteat!(w,n)#el último elemento no es cero
    w=append!(w,1.0) #el último elemento del vector de orden cero es 1.0
    return Taylor(n,w)
end

#incluyendo las operaciones de Taylor

+(A::Taylor,B::Taylor)=Taylor(A.orden,A.coff+B.coff)
-(A::Taylor,B::Taylor)=Taylor(A.orden,A.coff-B.coff)

*(A::Real,B::Taylor)=Taylor(B.orden,A*B.coff)
*(A::Taylor,B::Real)=Taylor(A.orden,B*A.coff)

/(A::Taylor,B::Real)=Taylor(A.orden,(A.coff)/B)

==(A::Taylor,B::Taylor)=(A.orden==B.orden && A.coff==B.coff)

end
