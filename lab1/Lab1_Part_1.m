clc;clear all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Reading data from a file
%Note that time is in micro seconds and packetsize is in Bytes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[packet_no_p, time_p, packetsize_p] = textread('poisson1.data', '%f %f %f');

%%%%%%%%%%%%%%%%%%%%%%%%%Exercise 1.2%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The following code will generate Plot 1; You generate Plot2 , Plot3.
%Hint1: For Plot2 and Plot3, you only need to change 'initial_p', the
%       initial time in microseconds, and 'ag_frame', the time period of
%       aggregation
%Hint2: After adding Plot2 and Plot3 to this part, you can use 'subplot(3,1,2);'
%       and 'subplot(3,1,3);' respectively to show 3 plots in the same figure.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1);
jj=1;
i=1;
initial_p=0;
ag_time=1000000;
bytes_p=zeros(1,100);
while time_p(jj)<=initial_p
    jj=jj+1;
end
while i<=100
while ((time_p(jj)-initial_p)<=ag_time*i && jj<length(packetsize_p))
bytes_p(i)=bytes_p(i)+packetsize_p(jj);
jj=jj+1;
end
i=i+1;
end

%%%%%%%%
subplot(3,1,1);bar(bytes_p);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Note: Run the same MATLAB code for Exercise 1.3 and 1.4 but change the
%second line of the code in order to read the files 'poisson2.data' and
%'poisson3.data' respectively.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(4);

x=time_p(1:100);%length(index);
ac=zeros(1, length(x));
for i=1:length(x)
    ac(i) = autocorrelation(packetsize_p, i);
end
plot(x, ac);
xlabel('k [microseconds]');
ylabel('Packet size [bytes]');
title('Plot of Autocorrelation for Poisson Traffic');

figure(5);

x=time_p(1:100);%length(index);
bn=zeros(1, length(x));
for i=1:length(x)
    bn(i) = burstiness(packetsize_p, i);
end
plot(x, bn);
xlabel('t [microseconds]');
ylabel('Worst case average bitrate in time interval [bytes]');
title('Plot of Burstiness Function for Poisson Traffic');

figure(6);

x=time_p;
iod=zeros(1, length(x));
for i=1:length(x)
    iod(i) = dispersion(packetsize_p, i);
end
plot(x, iod);
xlabel('t [microseconds]');
ylabel('Index of dispersion [bytes]');
title('Plot of Index of Dispersion for Poisson Traffic');
