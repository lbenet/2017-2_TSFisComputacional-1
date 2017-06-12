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
    export Taylor, gradomax, prom, evaluacion, integradorT2

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
    

    ## Integracion

    function adaptive_step(a::Taylor, epsi::Real = 1e-40)
        p = gradomax(a)

        while a.coef[p] == 0 ## Se encarga de terminos nulos.
            p -= 1
        end

        h1 = 0.5 * (epsi / abs(a.coef[p - 0]))^(1 / (p - 0)) ## Multiplicar por 0.5 nos garantiza que es menor que la cota
        h2 = 0.5 * (epsi / abs(a.coef[p - 1]))^(1 / (p - 1)) ## Multiplicar por 0.5 nos garantiza que es menor que la cota
        h3 = 0.5 * (epsi / abs(a.coef[p - 2]))^(1 / (p - 2)) ## Multiplicar por 0.5 nos garantiza que es menor que la cota
        
        h = min(h1, h2, h3)

        return h
    end

    function horner_evaluation(a::Taylor, x0::Number)
        n = gradomax(a)
        y = a.coef[n]

        for i = 1:(n - 1)
            y = a.coef[n - i] + y * x0
        end

        return y
    end

    function coeficient2(t::Real, x̄0::Array, f::Function, n = 30)
        ## n fue escogido de manera arbitraria, 30 parece un buen numero

        X̄ = [prom(Taylor([x̄0[1]]), n), prom(Taylor([x̄0[2]]), n)]
        ##T = prom(Taylor(t), n)

        for k = 1:(n - 1) ## usar n - 1 nos deja con un polinomio de grado n ya que se utiliza el valor de x0
            g = f(t, X̄) ## f entrega un vector de 2 entradas

            X̄[1].coef[k + 1] = g[1].coef[k] / k
            X̄[2].coef[k + 1] = g[2].coef[k] / k

        end

        return X̄
    end

    function integradorT2(f::Function, t0::Real, tf::Real, x̄0::Array, max = 100000, epsi::Real = 1e-40)

        tiempos = [t0]
        X̄ = [x̄0]
        
        n = 1 ## Contador

        while t0 <= tf && n <= max

            sol = coeficient2(t0, X̄[end], f)

            hx = adaptive_step(sol[1], epsi)
            hy = adaptive_step(sol[2], epsi)

            h = min(hx, hy)

            t0 += h

            x0 = horner_evaluation(sol[1], h)
            y0 = horner_evaluation(sol[2], h)
        
            
            push!(tiempos, t0)
            push!(X̄, [x0, y0])
            n += 1


        end
        l = length(tiempos)
        k = length(X̄)
    
        println("Integracion terminada")
        println("#T = $l, #X̄ = $k, n = $n / $max")

        return tiempos, X̄
    end
end
