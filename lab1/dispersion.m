function [ret] = dispersion(A, t)
    A_t = A(1:t);

    ret = var(A_t) / mean(A_t);
end

