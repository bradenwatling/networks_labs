clc;clear all;
[movie_i, movie_time, type_f, movie_size, foo1, foo2, foo3 ] = textread('movietrace.data', '%f %f %c %f %f %f %f');
[trafficsink_i, trafficsink_time, trafficsink_size] = textread('trafficsink_movie.data', '%f %f %f');
[bucket_time, bucket_packetsize, buff_size, num_tokens] = textread('bucket_movie.txt', '%f %f %f %f');

trafficsink_sum = 0;

movie_arrivals = zeros(length(movie_i), 1);
trafficsink_arrivals = zeros(length(trafficsink_i), 1);
bucket_arrivals= zeros(length(bucket_time), 1);

%Trace data
time_movie = time_movie*10^3;
movie_arrivals(1) = movie_size(1);
for i = 2:length(movie_arrivals)
    %movie_time(i) = movie_time(i) - movie_time(1);
    movie_arrivals(i) = movie_arrivals(i-1) + movie_arrivals(i);
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
plot(movie_time, movie_arrivals, 'b', trafficsink_time, trafficsink_arrivals, 'r', time_tbucket, bucket_arrivals, 'g')
legend('Movie data', 'Traffic Sink data', 'Token bucket');
title('Cumulative Arrivals of Video Trace File, Token Bucket, and Traffic Sink');
xlabel('Arrival Time (us)'); % x-axis label
ylabel('Cumulative Number of Bytes'); % y-axis label