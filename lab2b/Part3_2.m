clc;clear all;
[poisson_i, poisson_time, poisson_size] = textread('poisson3.data', '%f %f %f');
[trafficsink_i, trafficsink_time, trafficsink_size] = textread('trafficsink.data', '%f %f %f');
[bucket_time, bucket_packetsize, buff_size, num_tokens] = textread('bucket_poisson.txt', '%f %f %f %f');
%[bucket_time, bucket_size] = textread('bucket_poisson.txt', '%f %f');

poisson_sum = 0;
trafficsink_sum = 0;

poisson_arrivals = zeros(length(poisson_i), 1);
trafficsink_arrivals = zeros(length(trafficsink_i), 1);
bucket_arrivals= zeros(length(bucket_time), 1);

%Trace data
for i = 1:length(poisson_arrivals)
    poisson_time(i) = poisson_time(i) - poisson_time(1);
    poisson_sum = poisson_sum + poisson_size(i);
    poisson_arrivals(i) = poisson_sum;

end

%Sink
for i = 1:length(trafficsink_arrivals)
    trafficsink_sum = trafficsink_sum + trafficsink_size(i);
    trafficsink_arrivals(i) = trafficsink_sum;
end

%Token bucket
bucket_arrivals(1) = bucket_packetsize(1);
for i = 2:length(bucket_bytes)
    bucket_arrivals(i) = bucket_arrivals(i-1) + bucket_arrivals(i);
end

time_tbucket=zeros(1,length(bucket_time));
time_tbucket(1)=0;
for i = 2:length(time_tbucket)
    time_tbucket(i) = time_tbucket(i-1) + bucket_time(i);
end



figure(1)
axis([0,inf,0,inf]);
plot(poisson_time, poisson_arrivals, 'b', trafficsink_time, trafficsink_arrivals, 'r', time_tbucket, bucket_arrivals, 'g')
legend('Poisson data', 'Traffic Sink data', 'Token bucket');
title('Difference of Trace File, Token Bucket, and Traffic Sink');
xlabel('Arrival Time (us)'); % x-axis label
ylabel('Number of Bytes'); % y-axis label
xlim([0, trafficsink_time(10000)])


% Content of tbucket and buffer backlog
figure(2);
plot(time_tbucket, num_tokens, 'b', time_tbucket, buffer_size, 'r');
axis([0,inf,-100,11000]);
legend('Token bucket', 'Backlog');
title('Content of Token Bucket and Backlog in Buffer');
xlabel('Arrival Time (us)'); % x-axis label
ylabel('Content'); % y-axis label