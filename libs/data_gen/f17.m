function [ f ] = f17( D, x_opt, f_opt, R, Q )
%F_17 Schaffers F7 Function
%  instead of lambda(10, D) uses lambda(1.5, D)
%  instead of T_asy(..., 0.5) uses 0.1

    function [res] = f17_compute(x)
        z = lambda(10, D) * Q * T_asy(R*(x - x_opt), 0.12);
        %z = x;
        s = sqrt(z.^2 + [z(2:D); 0].^2);
        res = ((1/(D-1)) * sum(sqrt(s(1:D-1)) + sqrt(s(1:D-1))*(sin(50 * s(1:D-1) .^ (1/5)))))^2 + 10 * f_pen(x) + f_opt;
    end

    f = @(x) f17_compute(x);
end

