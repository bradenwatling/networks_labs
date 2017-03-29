clc;clear all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Reading data from a file
%Note that time is in micro seconds and packetsize is in Bytes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_samples = 11000;

 [seqno1, time_poisson, packetsize_poisson] = textread('poisson3.data', '%f %f %f');
 [seqno2, time_movie, type_f, framesize_movie, dummy1, dymmy2, dymmy3] = textread('movietrace.data', '%f %f %c %f %f %f %f');
 [time_gen2, framesize_eth] = textread('BC-pAug89-small.TL', '%f %f');

 [timearr_tbucket1, packetsize_tbucket1, buffer_size1, num_tokens1] = textread('bucket_poisson3_2.txt', '%f %f %f %f');
 [timearr_tbucket2, packetsize_tbucket2, buffer_size2, num_tokens2] = textread('bucket_movie3_1.txt', '%f %f %f %f');
 [timearr_tbucket3, packetsize_tbucket3, buffer_size3, num_tokens3] = textread('bucket_ethernet3_2.txt', '%f %f %f %f');

 [trafficsink1_i, time_sink1, packetsize_sink1] = textread('trafficsink_poisson3.data', '%f %f %f');
 [trafficsink2_i, time_sink2, packetsize_sink2] = textread('trafficsink_movie3_1.data', '%f %f %f');
 [trafficsink3_i, time_sink3, packetsize_sink3] = textread('trafficsink_ethernet3_2.data', '%f %f %f');
%%
%%%%%%%%%%%%%%%%%%%%%
% EXPERIMENT 1
%%%%%%%%%%%%%%%%%%%%%

%Trace file
i=2;
bytes_gen1=zeros(1,num_samples);
bytes_gen1(1) = packetsize_poisson(1);
while i <= num_samples
    bytes_gen1(i) = bytes_gen1(i-1)+packetsize_poisson(i);
    i=i+1;
end

%Token bucket output
i=2;
bytes_tbucket1=zeros(1,num_samples);
bytes_tbucket1(1) = packetsize_tbucket1(1);
while i<= num_samples
    bytes_tbucket1(i) = bytes_tbucket1(i-1)+packetsize_tbucket1(i);
    i=i+1;
end

i=2;
time_tbucket1=zeros(1,num_samples);
time_tbucket1(1)=0;
while i<= num_samples
    time_tbucket1(i) = time_tbucket1(i-1)+timearr_tbucket1(i);
    i=i+1;
end

%Server output #2
i=2;
bytes_sink1=zeros(1, num_samples);
bytes_sink1(1) = packetsize_sink1(1);
while i <= num_samples
    bytes_sink1(i) = bytes_sink1(i-1)+packetsize_sink1(i);
    i=i+1;
end

%Plot traffic generator, token bucket, and traffic sink
figure(1);
axis([0,inf,0,inf]);
plot(time_tbucket1, bytes_tbucket1, 'b', time_sink1(1:num_samples), bytes_sink1, 'g');
legend('Token bucket', 'Traffic sink');
title('Poisson Traffic: Difference of Token Bucket and Traffic Sink Output File');
xlabel('Arrival Time (us)'); % x-axis label
ylabel('Cumulative Number of Bytes'); % y-axis label

%Content of token bucket and backlog in buffer
figure(2);
plot(time_tbucket1(1:num_samples), num_tokens1(1:num_samples), 'b', time_tbucket1, buffer_size1(1:num_samples), 'r');
axis([0,inf,-10,inf]);
legend('Token bucket', 'Backlog');
title('Poisson Traffic: Content of Token Bucket and Backlog in Buffer');
xlabel('Arrival Time (us)'); % x-axis label
ylabel('Content'); % y-axis label

%%
%%%%%%%%%%%%%%%%%%%%%
% EXPERIMENT 2
%%%%%%%%%%%%%%%%%%%%%

%Trace file
i=2;
bytes_gen2=zeros(1,num_samples);
bytes_gen2(1) = framesize_movie(1);
while i <= num_samples
    bytes_gen2(i) = bytes_gen2(i-1)+framesize_movie(i);
    i=i+1;
end

%Token bucket output
i=2;
bytes_tbucket2=zeros(1,length(packetsize_tbucket2));
bytes_tbucket2(1) = packetsize_tbucket2(1);
while i<= length(packetsize_tbucket2)
    bytes_tbucket2(i) = bytes_tbucket2(i-1)+packetsize_tbucket2(i);
    i=i+1;
end

i=2;
time_tbucket2=zeros(1,length(timearr_tbucket2));
time_tbucket2(1)=0;
while i <= length(timearr_tbucket2)
    time_tbucket2(i) = time_tbucket2(i-1)+timearr_tbucket2(i);
    i=i+1;
end

%Server output #2
i=2;
bytes_sink2=zeros(1, length(time_sink2));
bytes_sink2(1) = packetsize_sink2(1);
while i <= length(time_sink2)
    bytes_sink2(i) = bytes_sink2(i-1) + packetsize_sink2(i);
    i=i+1;
end

%Plot traffic generator, token bucket, and traffic sink
figure(3);
axis([0,inf,0,inf]);
plot(time_tbucket2*10^3, bytes_tbucket2, 'b', time_sink2, bytes_sink2, 'g');
legend('Token bucket', 'Traffic sink');
title('Video Trace: Difference of Token Bucket and Traffic Sink Output File');
xlabel('Arrival Time (us)'); % x-axis label
ylabel('Cumulative Number of Bytes'); % y-axis label

%Content of token bucket and backlog in buffer
figure(4);
plot(time_tbucket2, num_tokens2, 'b', time_tbucket2, buffer_size2, 'r');
axis([0,inf,-10^4,inf]);
legend('Token bucket', 'Backlog');
title('Video Trace: Content of Token Bucket and Backlog in Buffer');
xlabel('Arrival Time (us)'); % x-axis label
ylabel('Content'); % y-axis label


%%
%%%%%%%%%%%%%%%%%%%%%
% EXPERIMENT 3
%%%%%%%%%%%%%%%%%%%%%

%Trace file
i=2;
bytes_gen3=zeros(1,num_samples);
bytes_gen3(1) = framesize_eth(1);
while i <= num_samples
    bytes_gen3(i) = bytes_gen3(i-1)+framesize_eth(i);
    i=i+1;
end

%Token bucket output
i=2;
bytes_tbucket3=zeros(1,num_samples);
bytes_tbucket3(1) = packetsize_tbucket3(1);
while i<= num_samples
    bytes_tbucket3(i) = bytes_tbucket3(i-1)+packetsize_tbucket3(i);
    i=i+1;
end

i=2;
time_tbucket3=zeros(1,num_samples);
time_tbucket3(1)=0;
while i<= num_samples
    time_tbucket3(i) = time_tbucket3(i-1)+timearr_tbucket3(i);
    i=i+1;
end

%Server output #2
i=2;
bytes_sink3=zeros(1, num_samples);
bytes_sink3(1) = packetsize_sink3(1);
while i <= num_samples
    bytes_sink3(i) = bytes_sink3(i-1)+packetsize_sink3(i);
    i=i+1;
end

%Plot traffic generator, token bucket, and traffic sink
figure(5);
axis([0,inf,0,inf]);
plot(time_tbucket3(1:num_samples), bytes_tbucket3, 'b', time_sink3(1:num_samples), bytes_sink3, 'g');
legend('Token bucket', 'Traffic sink');
title('Ethernet Traffic: Difference of Token Bucket and Traffic Sink Output File');
xlabel('Arrival Time (us)'); % x-axis label
ylabel('Cumulative Number of Bytes'); % y-axis label

%Content of token bucket and backlog in buffer
figure(6);
plot(time_tbucket3(1:num_samples), num_tokens3(1:num_samples), 'b', time_tbucket3(1:num_samples), buffer_size3(1:num_samples), 'r');
axis([0,inf,-10^4,inf]);
legend('Token bucket', 'Backlog');
title('Ethernet Traffic: Content of Token Bucket and Backlog in Buffer');
xlabel('Arrival Time (us)'); % x-axis label
ylabel('Content'); % y-axis label