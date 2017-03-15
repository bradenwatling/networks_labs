[gen_i, gen_time, gen_size] = textread('TokenBucket/trafficgen_reference.data', '%f %f %f');
[sink_i, sink_time, sink_size] = textread('TokenBucket/trafficsink_reference.data', '%f %f %f');

gen_sum = 0;
sink_sum = 0;

gen_arrivals = zeros(length(gen_i), 1);
sink_arrivals = zeros(length(sink_i), 1);
for i = 1:length(gen_arrivals)
    gen_sum = gen_sum + gen_size(i);
    gen_arrivals(i) = gen_sum;
end

for i = 1:length(sink_arrivals)
    sink_sum = sink_sum + sink_size(i);
    sink_arrivals(i) = sink_sum;
end

figure(1)
plot(gen_time, gen_arrivals, 'r', sink_time, sink_arrivals, 'b')
legend('Generated Reference', 'Traffic Sink')
title('Arrivals for Generated Reference vs. Traffic Sink Traffic')
xlabel('Time (microseconds)')
ylabel('Arrivals (bytes)')
%xlim([0, trafficsink_time(10000)])