include("funciones.jl")
include("Taylor.jl")
using ADT, ODE, PyPlot

## Comparacion de los integradores
## osciladorDePruebas

x̄0 = [1.0, 0.0]
t0, tf = 0.0, 100.0
t = linspace(t0, tf, 100)

E0 = energiaDePruebas(0, x̄0[1], x̄0[2])

t_ode, sol_ode = ode78(osciladorDePruebas, x̄0, t)
x_ode = map(x -> x[1], sol_ode)
y_ode = map(x -> x[2], sol_ode)
E_ode = energiaDePruebas.(t_ode, x_ode, y_ode)


t_tay, sol_tay = integradorT2(osciladorDePruebas, x̄0, t0, tf)
x_tay = map(x -> x[1], sol_tay)
y_tay = map(x -> x[2], sol_tay)
E_tay = energiaDePruebas.(t_tay, x_tay, y_tay)

p = figure()

ax = subplot(221); bx = subplot(222); cx = subplot(223); dx = subplot(224)
ax[:plot](x_ode, y_ode)
bx[:plot](x_tay, y_tay)
cx[:plot](t_ode, abs(E_ode - E0))
dx[:plot](t_tay, abs(E_tay - E0))

## Comparacion de los integradores
## osciladorParametrico

x̄0 = [1.0, 0.0]
t0, tf = 0.0, 100.0
β  = 1.0
t = linspace(t0, tf, 100)

E0 = energiaParametrico(0, x̄0[1], x̄0[2])

t_ode, sol_ode = ode78(osciladorParametrico, x̄0, t)
x_ode = map(x -> x[1], sol_ode)
y_ode = map(x -> x[2], sol_ode)
E_ode = energiaDePruebas.(t_ode, x_ode, y_ode)


t_tay, sol_tay = integradorT2(osciladorParametrico, x̄0, t0, tf)
x_tay = map(x -> x[1], sol_tay)
y_tay = map(x -> x[2], sol_tay)
E_tay = energiaDePruebas.(t_tay, x_tay, y_tay)

q = figure()

ax = subplot(221); bx = subplot(222); cx = subplot(223); dx = subplot(224)
ax[:plot](x_ode, y_ode)
bx[:plot](x_tay, y_tay)
cx[:plot](t_ode, abs(E_ode - E0))
dx[:plot](t_tay, abs(E_tay - E0))
#
# savefig(p,)
