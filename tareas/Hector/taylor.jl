
__precompile__(true)

module Ty
    import Base: +, -, *, /, ==,^


    export Taylor

"""
Definición de polinomios de Taylor, donde

cofun::Array{T,1} es el arreglo de los coeficientes de la función f.
grado::Int64 es el grado de la función
...
"""
type Taylor{T<:Number}
    # código: 
    cofun::Array{T,1} #Arreglo de los coeficientes de la función f.
    grado::Int64 #Grado de la función
    
    function Taylor(v::Vector{T},n::Int) 
        len = length(v) #Longitud del vector
        
        if len-1==n 
            return new{T}(v,n) #Si el grado ingresado es igual a los coeficientes del vector, 
                               #el grado y el vector se quedan igual.
            
        elseif len-1<n #Si el grado ingresado es mayor a los coeficientes del vector, 
                           #se completa con ceros.
            
            cv=copy(v) #Hacemos una copia del vector de entrada v, con el fin
                       #de no modificar su logitud original.  
            
            return new{T}(append!(cv,zeros(T,n-len+1)),n)
        else               #Si el grado ingresado es menor a los coeficientes del vector, 
                           #se resta un grado.
            return new{T}(v,len-1)
        end
    end
       
end
#-************************************************************************************
Taylor{T<:Number}(v::Array{T,1},n::Int)=Taylor{T}(v,n)
#*************************************************************************************

function tsuma(a,b)
    #Comparamos la longitud de los vectores
    
    la=length(a.cofun)
    lb=length(b.cofun)
 
    if a.grado==b.grado #Si los grados son iguales
        
            grado_principal=a.grado

            suma=a.cofun+b.cofun
        
    elseif a.grado>b.grado
        
            grado_principal=a.grado #El grado pricipal es el mayor de los grados
        
            ceros=zeros(la-lb)
            b=copy(b.cofun)  
            for i=1:length(ceros)
                b=push!(b,ceros[i])
            end
            
            suma=a.cofun+b
        
    else 
       
            grado_principal=b.grado #El grado pricipal es el mayor de los grados
        
            ceros=zeros(lb-la) #Creamos un vector con ceros para igualar en tamaño
            a=copy(a.cofun)                   #al vector más chico.
           
            for i=1:length(ceros) #Agragamos los ceros al vector chico
                a=push!(a,ceros[i])
            end
            
            suma=a+b.cofun 
               
    end   
                                              
    return Taylor(suma,grado_principal)
    
end

#*******************************************************************************************

function tresta(a,b)
    #Comparamos la longitud de los vectores
    
    la=length(a.cofun)
    lb=length(b.cofun)
 
    if a.grado==b.grado #Si los grados son iguales
        
            grado_principal=a.grado

            resta=a.cofun-b.cofun
        
    elseif a.grado>b.grado
        
            grado_principal=a.grado #El grado pricipal es el mayor de los grados
        
            ceros=zeros(la-lb)
            b=copy(b.cofun)  
            for i=1:length(ceros)
                b=push!(b,ceros[i])
            end
            
            resta=a.cofun-b
        
    else 
       
            grado_principal=b.grado #El grado pricipal es el mayor de los grados
        
            ceros=zeros(lb-la) #Creamos un vector con ceros para igualar en tamaño
            a=copy(a.cofun)                   #al vector más chico.
           
            for i=1:length(ceros) #Agragamos los ceros al vector chico
                a=push!(a,ceros[i])
            end
            
            resta=a-b.cofun 
               
    end   
                                              
    return Taylor(resta,grado_principal)
    
end

#******************************************************************************************

function tmulti(a,b)
    
#=---------------------Multiplicación de los vectores-------------------------=#
        
        grado_principal=a.grado+b.grado #obtenemos el grado  principal
    
        #Copiamos los vectores para no modificar los originales
        a=copy(a.cofun)
        b=copy(b.cofun)
        
        #Para los polinomios p = [1,1] y q = [1-1]
        #Si creamos las entradas extra a[3]=b[3]=0 , de la siguiente forma:
                     #a=push!(a,0)
                     #b=push!(b,0)
        #De este modo, el método nos da todas las entradas del polinomio resultante.
        #Sin embargo, esto no funciona para otros polinomios.
       
        
        #Obtenemos la longitud de los vectores
        la=length(a)
        lb=length(b)
    
        suma=zeros(la) #Aquí estamos truncando la multiplicación, 
                       #pues el arreglo del resultado
                       #puede ser mayor que el de los vectores de entrada. 
#************************************************************************************* 
    if la==lb
        
            for k=1:la
                for i=1:k
                    suma[k]+=a[i]*b[k+1-i]
                end
            end 
        
    elseif la<lb  
                #-------------Ajuste de logitud--------------

            lc=lb-la #Calculamos la diferencia de las longitudes
            ceros=zeros(lc) #Creamos un vector con ceros para igualar en tamaño
                            #al vector más chico.

            for i=1:length(ceros) #Agregamos los ceros al vector chico
                a=push!(a,ceros[i])
            end
                #---------------------------------------------
            for k=1:la
                for i=1:k
                    suma[k]+=a[i]*b[k+1-i]
                end
            end 
        
     else
             #-------------Ajuste de logitud---------------
            lc=la-lb
            ceros=zeros(lc)       

            for i=1:length(ceros)
                b=push!(b,ceros[i])
            end
             #---------------------------------------------  
            for k=1:la
                for i=1:k
                    suma[k]+=a[i]*b[k+1-i]
                end
            end 
        
    end  
        
    return Taylor(suma,grado_principal)
    
end   

#*****************************************************************************************
function tdiv(a,b)
  #=---------------------División de los vectores-------------------------=#  
       
        grado_principal=a.grado-b.grado #obtenemos el grado  principal
    
if grado_principal<0
        return println("grado negativo")
end


        #Copiamos los vectores para no modificar los originales
        f=copy(a.cofun)
        g=copy(b.cofun)
        
        #Obtenemos la longitud de los vectores
        lenf=length(f)
        leng=length(g)
   #=------------------Ajuste de la longitud------------------------------=#     
    if lenf<leng

            lenc=leng-lenf #Calculamos la diferencia de las longitudes
            ceros=zeros(lenc) #Creamos un vector con ceros para igualar en tamaño
                            #al vector más chico.

            for i=1:length(ceros) #Agregamos los ceros al vector chico
                f=push!(f,ceros[i])
            end
    
    elseif lenf<leng

            lenc=lenf-leng
            ceros=zeros(lenc)       

            for i=1:length(ceros)
                g=push!(g,ceros[i])
            end
            
    end
 #************************************************************************************* 
divi = zeros(lenf)  

    for k=1:length(divi) #(era -1)
        suma=0 #Valor inicial de la suma
        for i=1:k-1
            suma+=(divi[i])*g[k+1-i]
        end
        divi[k]=(1/g[1])*(f[k]-suma)
    end
    for i=1:grado_principal+2:length(lenf)
        if divi[i]==0
            deleteat!(cociente,i)
    end
        end    
    return Taylor(divi,grado_principal)
end
#****************************************************************************************

function tcomp(a,b)
    if a.cofun==b.cofun
        return true
    else
        return false
    end    
end    

#*****************************************************************************************
function elevar(pol,expo)
    grado_principal = expo*pol.grado #El grado principal es el producto del grado y el exponente.
    poly=copy(pol.cofun) #Hacemos una copia del vector del polinomio
    
    lp=length(grado_principal+1)
   # ceros=zeros(lp+(grado_principal-4))       
    ceros=zeros(lp) #Creamos un arreglo de ceros cuya longitud es determinada por el grado_principal 
    for i=1:length(ceros)
        poly=push!(poly,ceros[i]) #Agregamos ceros al arreglo para que tenga la longitud 
                                  #ideal para el resultado
    end
        
    p=zeros(poly) #Creamos un arreglo de ceros de la longitud del vector anterior

    p[1]=(poly[1])^expo #Primer valor del vector resultado.
    
    for k=1:length(poly)-1
        suma=0 #Valor inicial de la suma
        for i in 1:k-1
            suma+=(expo*k-(expo+1)*i)*poly[k+1-i]*p[i+1]
        end
        
        p[k+1]=p[1]*expo*(poly[k+1]/poly[1])+(1/(k*poly[1]))*suma
    end
    
    return Taylor(p,grado_principal)
end
#*****************************************************************************************

+(f::Taylor, g::Taylor) = tsuma(f,g)
-(f::Taylor, g::Taylor) = tresta(f,g)
*(f::Taylor, g::Taylor) = tmulti(f,g)
/(f::Taylor, g::Taylor) = tdiv(f,g)
==(f::Taylor, g::Taylor) = tcomp(f,g)
^(f::Taylor, exp::Int) = elevar(f,exp)


end

