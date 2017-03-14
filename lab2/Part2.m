[poisson_i, poisson_time, poisson_size] = textread('poisson3.data', '%f %f %f');
[trafficsink_i, trafficsink_time, trafficsink_size] = textread('trafficsink.data', '%f %f %f');
[trafficsink_2_i, trafficsink_2_time, trafficsink_2_size] = textread('trafficsink_ug61_to_ug248.data', '%f %f %f');

diff = 0;
diff_2 = 0;

for i = 1 : length(poisson_arrivals)
    diff = diff - trafficsink_time(i) + poisson_time(i) - poisson_time(1);
    diff_2 = diff_2 - trafficsink_2_time(i) + poisson_time(i) - poisson_time(1);
end

avg_diff = diff / length(poisson_arrivals)
avg_diff_2 = diff_2 / length(poisson_arrivals)
return
poisson_sum = 0;
trafficsink_sum = 0;

poisson_arrivals = zeros(length(poisson_i), 1);
trafficsink_arrivals = zeros(length(trafficsink_i), 1);
for i = 1:length(poisson_arrivals)
    poisson_time(i) = poisson_time(i) - poisson_time(1);
    poisson_sum = poisson_sum + poisson_size(i);
    poisson_arrivals(i) = poisson_sum;

end

for i = 1:length(trafficsink_arrivals)
    trafficsink_sum = trafficsink_sum + trafficsink_size(i);
    trafficsink_arrivals(i) = trafficsink_sum;
end

figure(1)
plot(poisson_time, poisson_arrivals, 'r', trafficsink_time, trafficsink_arrivals, 'b')
legend('Poisson data', 'Traffic Sink data')
title('Arrivals for Poisson vs. Traffic Sink Data')
xlabel('Time (microseconds)')
ylabel('Arrivals (bytes)')
xlim([0, trafficsink_time(10000)])