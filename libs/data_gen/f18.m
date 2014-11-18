function [ f ] = f18( D, x_opt, f_opt, R, Q )
%F_18 Schaffers F7 Function moderately ill conditioned
%  instead of lambda(10, D) uses lambda(1.5, D)
%  instead of T_asy(..., 0.5) uses 0.1

    function [ res ] = f18_compute(x)
        
        z = lambda(1000, D) * Q * T_asy(R*(x - x_opt), 0.12);
        %z = x;
        s = sqrt(z.^2 + [z(2:D); 0].^2);
        res = ((1/(D-1)) * sum(sqrt(s(1:D-1)) + sqrt(s(1:D-1))*(sin(50 * s(1:D-1) .^ (1/5)))))^2 + 10 * f_pen(x) + f_opt;

    end

    f = @(x) f18_compute(x);

end
