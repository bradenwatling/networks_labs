clc;clear all;
[eth_time, eth_size] = textread('BC-pAug89-small.TL', '%f %f');
[trafficsink_i, trafficsink_time, trafficsink_size] = textread('trafficsink_eth.data', '%f %f %f');
[bucket_time, bucket_packetsize, buff_size, num_tokens] = textread('bucket_eth.txt', '%f %f %f %f');

trafficsink_sum = 0;

eth_arrivals = zeros(length(eth_i), 1);
trafficsink_arrivals = zeros(length(trafficsink_i), 1);
bucket_arrivals= zeros(length(bucket_time), 1);

%Trace data
time_eth = time_eth*10^6;
eth_arrivals(1) = eth_size(1);
for i = 2:length(eth_arrivals)
    %eth_time(i) = eth_time(i) - eth_time(1);
    eth_arrivals(i) = eth_arrivals(i-1) + eth_arrivals(i);
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
plot(eth_time, eth_arrivals, 'b', trafficsink_time, trafficsink_arrivals, 'r', time_tbucket, bucket_arrivals, 'g')
legend('Ethernet data', 'Traffic Sink data', 'Token bucket');
title('Difference of Ethernet Traffic, Token Bucket, and Traffic Sink Output File');
xlabel('Arrival Time (us)'); % x-axis label
ylabel('Cumulative Number of Bytes'); % y-axis label