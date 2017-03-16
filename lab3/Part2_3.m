[gen_i, gen_time, dummy, gen_size, dumm2, dumm3, dumm4] = textread('TokenBucket/movietrace.data', '%f %f %s %f %f %f %f');
[bucket_time, bucket_size, bucket_buffer_size, bucket_no_tokens1, bucket_no_tokens2] = textread('bucket_4.txt', '%f %f %f %f %f');
[sink_i, sink_time, sink_size] = textread('trafficsink_4.data', '%f %f %f');

gen_time = gen_time * 1000;

gen_time_sum = -gen_time(1);
gen_sum = 0;
bucket_time_sum = -bucket_time(1);
bucket_sum = 0;
sink_time_sum = -sink_time(1);
sink_sum = 0;

max_size = length(bucket_size)

gen_arrivals = ones(max_size, 1) * gen_size(length(gen_size));
gen_acc_time = ones(max_size, 1) * gen_time(length(gen_time));
bucket_arrivals = zeros(max_size, 1);
bucket_acc_time = zeros(max_size, 1);
sink_arrivals = ones(max_size, 1) * sink_size(length(sink_size));
sink_acc_time = ones(max_size, 1) * sum(sink_time);
for i = 1:length(gen_size)
    %gen_time_sum = gen_time_sum + gen_time(i);
    %gen_acc_time(i) = gen_time_sum;
    gen_acc_time(i) = gen_time(i);
    gen_sum = gen_sum + gen_size(i);
    gen_arrivals(i) = gen_sum;
end
for i = 1:length(bucket_time)
    bucket_time_sum = bucket_time_sum + bucket_time(i);
    bucket_acc_time(i) = bucket_time_sum;
    bucket_sum = bucket_sum + bucket_size(i);
    bucket_arrivals(i) = bucket_sum;
end
for i = 1:length(sink_time)
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

figure(2)
plot(bucket_acc_time, bucket_buffer_size, 'r')
title('Backlog Size vs. Time')
xlabel('Time (microseconds)')
ylabel('Size (bytes)')

figure(3)
plot(bucket_acc_time, bucket_no_tokens1, 'b', bucket_acc_time, bucket_no_tokens2, 'r')
title('Token Bucket Size 1 and 2 vs. Time')
xlabel('Time (microseconds)')
ylabel('Size (bytes)')