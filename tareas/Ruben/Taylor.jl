#=
Modulo para definir la estructura Taylor
Autor: Rubén Darío Araiza Acosta
email: ruben1995@gmail.com
github: ravioaraiza
25/04/17
=#


__precompile__(true)

module ADT

    import Base: +, -, *, /, ^, ==
    export Taylor, gradomax, prom, evaluacion

    """
    Definición de polinomios de Taylor, donde coef es el arreglo que contiene al polinomio de taylor
    """
    type Taylor{T<:Number}
        coef::Array{T}
    end

    doc"""
    función constructora, inicia una variable de tipo Taylor de grado 1.
    """

    function Taylor(a::Number)
        return Taylor([a])
    end

    doc"""
    Función que regresa la longitud maxima entre dos polinomios de Taylor.
    Al ingresar solo un polinomio, regresa el grado de este.
    El grado de los polinomios esta dado por gradomax(x) - 1.
    """
    function gradomax(a::Taylor, b::Taylor)
        return max(length(a.coef), length(b.coef))
    end

    function gradomax(a::Taylor)
        return length(a.coef)
    end

    doc"""
    Función que promueve el grado del polinomio a a al del polinomio b.
    Si en lugar de un segundo polinomio se le da un entero, esta promueve el primer polinomio al grado que se le dio.
    """

    function prom(a::Taylor, b::Taylor)
        return Taylor([a.coef; fill(0, gradomax(a,b) - gradomax(a))])
    end

    function prom(a::Taylor, N::Integer)
        return Taylor([a.coef; fill(0, N - gradomax(a))])
    end


    doc"""
    Función que utiliza metaprogramación para evaluar un polinomio de Taylor
    """

    function evaluacion(a::Taylor, x0::Number)
        polinomio = :(0)  ## Ok, usemos algo de meta programacion
        for k in 1:gradomax(a)
            polinomio = :($polinomio + $a.coef[$k] * $x0 ^ $(k - 1))
            end      # Esta conformado por las iteraciones anteriores + el coeficiente por x0 ^ k-1
        return eval(polinomio)
    end

    # Aqui se implementan los métodos necesarios para cada función
    +(a::Taylor, b::Taylor) = Taylor(prom(a, gradomax(a, b)).coef + prom(b, gradomax(a, b)).coef)
    +(a::Taylor, b::Number) = a + Taylor(b)
    +(a::Number, b::Taylor) = b + Taylor(a)
    +(a::Taylor) = Taylor(a.coef)
    ## Tanto la suma como la resta de polinomios promueven el resultado a el grado mayor entre los sumandos.
    -(a::Taylor, b::Taylor) = Taylor(prom(a, gradomax(a, b)).coef - prom(b, gradomax(a, b)).coef)
    -(a::Taylor, b::Number) = a - Taylor(b)
    -(a::Number, b::Taylor) = Taylor(a) - b
    -(a::Taylor) = Taylor(-a.coef)

    function *(a::Taylor, b::Taylor)
        n = gradomax(a) + gradomax(b) - 1 ## Este sera el grado del producto de dos polinomios a y b.
        A = prom(a,n)
        B = prom(b,n)
        producto = Taylor(zeros(n)) ## Inicializamos un polinomio de Taylor de grado n.

        for k = 0:(n - 1)
            suma = 0
            for j = 0:k
                suma += A.coef[j + 1] * B.coef[k - j + 1]
            end
            producto.coef[k + 1] = suma

        end

        return producto
    end
    *(a::Taylor, b::Number) = Taylor(b * a.coef)
    *(a::Number, b::Taylor) = Taylor(a * b.coef)

    function /(a::Taylor, b::Taylor)
        n = gradomax(a, b)
        A = prom(a, n)
        B = prom(b, n)

        div = Taylor(zeros(n))
        ## Checamos por coeficientes nulos
        p = 1
        while b.coef[p] == 0
            p += 1;
        end

        div.coef[1] = A.coef[p] / B.coef[p] ## Agregamos el primer elemento

        for k = (p + 1):n
            suma = 0

            for j = 0:(k - 1)
                suma += div.coef[j + 1] * B.coef[k - j]
            end

            div.coef[k - p + 1] = (A.coef[k] - suma) / B.coef[p]
        end

        return div
    end

    /(a::Taylor, k::Number) = Taylor(a.coef / k)
    /(k::Number, a::Taylor) = Taylor(k) / a

    ## La función == promueve los polinomios y despues los compara, asi podemos ver si los coeficientes son iguales
    ## sin considerar la diferencia en el grado, asi Taylor([1,1]) == Taylor([1,1,0])
    ==(a::Taylor, b::Taylor) = prom(a, b).coef == prom(b, a).coef


    ## Funciones

    import Base: exp, log, sin, cos

    # Exponencial

    function exp(a::Taylor)
        n = gradomax(a)

        expo = Taylor(exp(a.coef[1]))
        expo = prom(expo, n)

        for k = 2:n
            suma = 0
            for j = 1:k
                suma += (k - j) * a.coef[k - j + 1] * expo.coef[j]
            end
            expo.coef[k] = suma * (1 / (k - 1))
        end

        return expo
    end

    exp(a::Taylor, n::Integer) = exp(prom(a, n))


    # Logaritmo

    import Base: log

    function log(a::Taylor)
        n = gradomax(a); # grado máximo

        Loga = Taylor(zeros(n));
        Loga.coef[1] = log(a.coef[1]);

        for k = 2:n
            suma = 0;

            for j = 2: k
                suma += (j - 1) * Loga.coef[j] * a.coef[k - j + 1];
            end
            Loga.coef[k] = (1 / a.coef[1]) * (a.coef[k] - suma / (k - 1))
        end

        return Loga
    end

    log(a::Taylor, n::Integer) = log(prom(a, n))

    # Exponenciales
    
    ^(a::Taylor, N::Number) = exp(N * log(a))

    function ^(a::Taylor, n::Integer)
        if n != 0
            pot = a
            for i = 2:n
                pot *= a
            end
            return pot
        else
            return Taylor([1])
        end
    end
    
    # Seno y coseno
    
    function sin(a::Taylor)
        A = exp(a * 1im)
        return Taylor(imag(A.coef))
    end

    sin(a::Taylor, n::Integer) = sin(prom(a, n))

    function cos(a::Taylor)
        A = exp(a * 1im)
        return Taylor(real(A.coef))
    end

    cos(a::Taylor, n::Integer) = cos(prom(a, n))

end
