[poisson_i, poisson_time, poisson_size] = textread('poisson3.data', '%f %f %f');
[trafficsink_i, trafficsink_time, trafficsink_size] = textread('trafficsink.data', '%f %f %f');

poisson_sum = 0;
trafficsink_sum = 0;

poisson_arrivals = zeros(length(poisson_i), 1);
trafficsink_arrivals = zeros(length(trafficsink_i), 1);
for i = 1:length(poisson_arrivals)
    poisson_time(i) = poisson_time(i) - poisson_time(1);
    poisson_sum = poisson_sum + poisson_size(i);
    poisson_arrivals(i) = poisson_sum;
    
    trafficsink_sum = trafficsink_sum + trafficsink_size(i);
    trafficsink_arrivals(i) = trafficsink_sum;
end

figure(1)
plot(poisson_time, poisson_arrivals, 'r', trafficsink_time, trafficsink_arrivals, 'b')
%xlim([0, trafficsink_time(10000)])