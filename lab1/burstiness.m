function [ret] = burstiness(A, t)

    difference = zeros(length(A) * 3, 1);
    for i=1:length(difference)
        x = i - length(A);
        % a1 = A(x + t) unless x + t isnt within bounds
        a1 = 0;
        if (x + t >= 1 && x + t <= length(A))
            a1 = A(x + t);
        end
        % a2 = A(x) unless x isnt within bounds
        a2 = 0;
        if (x >= 1 && x <= length(A))
            a2 = A(x);
        end
        difference(i)= a1 - a2;
    end

    ret = 1 / t * max(difference);
end

