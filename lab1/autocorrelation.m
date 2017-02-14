function [ret] = autocorrelation(x_n, k)
    %x_n_plus_k = circshift(x_n, [k, 0]);
    %for i=1:k
    %    x_n_plus_k(i) = 0;
    %end
    
    v = (x_n - mean(x_n));
    
    product = zeros(size(v));
    for i=k:length(v)
        product(i)=v(i)*v(i -k + 1);
    end
    
    ret = mean(product) / var(x_n);
end

