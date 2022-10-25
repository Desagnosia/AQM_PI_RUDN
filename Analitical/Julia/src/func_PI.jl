using ModelingToolkit, DifferentialEquations, Plots

function AQM_PI_Sol(setp::Int64, t2::Float64, init_kp::Float64, init_ki::Float64)
    @variables t y(t) e(t) de(t) x(t) dx(t) ddx(t) 
    D = Differential(t)
    @parameters kp ki
    sp(t) = setp
    @named sys = ODESystem([
        D(y) ~ kp*de + ki*e
        D(e) ~ de
        D(x) ~ dx
        D(dx) ~ ddx
        0.0 ~ (y)  - (ddx + dx  + x)
        0.0 ~ (e) - (sp(t) - x)
            ])
    time = (0.0,t2)
    u0 = zeros(6)
    solution = solve(ODEProblem(sys, u0, time, [init_ki, init_kp]),ImplicitEuler(),adaptive=false, dt=4e-4)
	u = hcat(solution.u...)
	savefig(plot(solution.t, u[3,:]), "Plot.png")
end