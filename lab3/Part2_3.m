[gen_i, gen_time, gen_size] = textread('trafficgen_2.2.2.data', '%f %f %f');
[bucket_time, bucket_size, bucket_buffer_size, bucket_no_tokens] = textread('bucket_2.2.2.txt', '%f %f %f %f');
[sink_i, sink_time, sink_size] = textread('trafficsink_2.2.2.data', '%f %f %f');

gen_time_sum = -gen_time(1);
gen_sum = 0;
bucket_time_sum = -bucket_time(1);
bucket_sum = 0;
sink_time_sum = -sink_time(1);
sink_sum = 0;

gen_arrivals = zeros(length(gen_i), 1);
gen_acc_time = zeros(length(gen_i), 1);
bucket_arrivals = zeros(length(bucket_time), 1);
bucket_acc_time = zeros(length(bucket_time), 1);
sink_arrivals = zeros(length(sink_i), 1);
sink_acc_time = zeros(length(sink_i), 1);
for i = 1:length(gen_arrivals)
    gen_time_sum = gen_time_sum + gen_time(i);
    gen_acc_time(i) = gen_time_sum;
    gen_sum = gen_sum + gen_size(i);
    gen_arrivals(i) = gen_sum;
end
for i = 1:length(bucket_arrivals)
    bucket_time_sum = bucket_time_sum + bucket_time(i);
    bucket_acc_time(i) = bucket_time_sum;
    bucket_sum = bucket_sum + bucket_size(i);
    bucket_arrivals(i) = bucket_sum;
end
for i = 1:length(sink_arrivals)
    sink_time_sum = sink_time_sum + sink_time(i);
    sink_acc_time(i) = sink_time_sum;
    sink_sum = sink_sum + sink_size(i);
    sink_arrivals(i) = sink_sum;
end

figure(1)
plot(gen_acc_time, gen_arrivals, 'r', sink_acc_time, sink_arrivals, 'b', bucket_acc_time, bucket_arrivals, 'g')
legend('Generated Reference', 'Traffic Sink', 'TokenBucket')
title('Arrivals for Generated Reference vs. Traffic Sink Traffic Using TokenBucket')
xlabel('Time (microseconds)')
ylabel('Arrivals (bytes)')
%xlim([0, trafficsink_time(10000)])