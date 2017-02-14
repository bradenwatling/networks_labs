clc;clear all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Reading the data and putting the first 100000 entries in variables 
%Note that time is in seconds and framesize is in Bytes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
no_entries=100000;
[time1, framesize1] = textread('Bel.data', '%f %f');
time=time1(1:no_entries);
framesize=framesize1(1:no_entries);
%%%%%%%%%%%%%%%%%%%%%%%%%Exercise %%%3.2%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The following code will generate Plot 1; You generate Plot2 , Plot3.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1);
jj=1;
i=1;
initial_p=0;
ag_time=1;
bytes_p=zeros(1,100);
while time(jj)<=initial_p
    jj=jj+1;
end
while i<=100
while ((time(jj)-initial_p)<=ag_time*i && jj<no_entries)
bytes_p(i)=bytes_p(i)+framesize(jj);
jj=jj+1;
end
i=i+1;
end
%%%%%%%%
subplot(3,1,1);bar(bytes_p);


figure(4);

x=time1(1:200);%length(index);
ac=zeros(1, length(x));
for i=1:length(x)
    ac(i) = autocorrelation(framesize1, i);
end
plot(x, ac);
xlabel('k [seconds]');
ylabel('Packet size [bytes]');
title('Plot of Autocorrelation for Ethernet Traffic');

figure(5);

x=time1(1:100);%length(index);
bn=zeros(1, length(x));
for i=1:length(x)
    bn(i) = burstiness(framesize1, i);
end
plot(x, bn);
xlabel('t [seconds]');
ylabel('Worst case average bitrate in time interval [bytes]');
title('Plot of Burstiness Function for Ethernet Traffic');

figure(6);

x=time1(1:40000);
iod=zeros(1, length(x));
for i=1:length(x)
    iod(i) = dispersion(framesize1, i);
end
plot(x, iod);
xlabel('t [seconds]');
ylabel('Index of dispersion [bytes]');
title('Plot of Index of Dispersion for Ethernet Traffic');

