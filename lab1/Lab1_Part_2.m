clc;
clear all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Reading data from the file
%Note: - time is in miliseconds and framesize is in Bytes
%      - file is sorted in transmit sequence
%  Column 1:   index of frame (in display sequence)
%  Column 2:   time of frame in ms (in display sequence)
%  Column 3:   type of frame (I, P, B)
%  Column 4:   size of frame (in Bytes)
%  Column 5-7: not used
%
% Since we are interested in the transmit sequence we ignore Columns 1 and
% 2. So, we are only interested in the following columns: 
%       Column 3:  assigned to type_f
%       Column 4:   assigned to framesize_f
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[index, time, type_f, framesize_f, dummy1, dummy2, dummy3 ] = textread('movietrace.data', '%f %f %c %f %f %f %f');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   CODE FOR EXERCISE 2.2   (version: Spring 2007)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Extracting the I,P,B frmes characteristics from the source file
%frame size of I frames  : framesize_I
%frame size of P frames  : framesize_p 
%frame size of B frames  : framesize_B
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

a=0;
b=0;
c=0;
for i=1:length(index)
    if type_f(i)=='I'
        a=a+1;
        framesize_I(a)=framesize_f(i);
    end
    if type_f(i)=='B'
        b=b+1;
        framesize_B(b)=framesize_f(i);
    end
    if type_f(i)=='P'
        c=c+1;
        framesize_P(c)=framesize_f(i);
    end

end

numFrames = length(index);
numBytes = sum(framesize_f);

minFrameSize = min(framesize_f);
maxFrameSize = max(framesize_f);
meanFrameSize = mean(framesize_f);

minFrameSize_I = min(framesize_I);
maxFrameSize_I = max(framesize_I);
meanFrameSize_I = mean(framesize_I);

minFrameSize_B = min(framesize_B);
maxFrameSize_B = max(framesize_B);
meanFrameSize_B = mean(framesize_B);

minFrameSize_P = min(framesize_P);
maxFrameSize_P = max(framesize_P);
meanFrameSize_P = mean(framesize_P);

% meanBitRate = meanFrameSize / frameDuration
% frameDuration = 1 / FPS = 1 / 30
meanBitRate = meanFrameSize * 30;
peakBitRate = maxFrameSize * 30;

peakToMeanBitRate = peakBitRate / meanBitRate;

disp(strcat('numFrames: ', num2str(numFrames)));
disp(strcat('numBytes: ', num2str(numBytes)));
disp(strcat('minFrameSize: ', num2str(minFrameSize)));
disp(strcat('maxFrameSize: ', num2str(maxFrameSize)));
disp(strcat('meanFrameSize: ', num2str(meanFrameSize)));
disp(strcat('minFrameSize_I: ', num2str(minFrameSize_I)));
disp(strcat('maxFrameSize_I: ', num2str(maxFrameSize_I)));
disp(strcat('meanFrameSize_I: ', num2str(meanFrameSize_I)));
disp(strcat('minFrameSize_B: ', num2str(minFrameSize_B)));
disp(strcat('maxFrameSize_B: ', num2str(maxFrameSize_B)));
disp(strcat('meanFrameSize_B: ', num2str(meanFrameSize_B)));
disp(strcat('minFrameSize_P: ', num2str(minFrameSize_P)));
disp(strcat('maxFrameSize_P: ', num2str(maxFrameSize_P)));
disp(strcat('meanFrameSize_P: ', num2str(meanFrameSize_P)));
disp(strcat('meanBitRate: ', num2str(meanBitRate)));
disp(strcat('peakBitRate: ', num2str(peakBitRate)));
disp(strcat('peakToMeanBitRate: ', num2str(peakToMeanBitRate)));

% x is the frame's transmit sequence number
x = 1:1:numFrames;
% y is the frame's size
y = framesize_f;
plot(x, y);
xlabel('Frame sequence number');
ylabel('Frame size [bytes]');
title('Frame Size in Transmission Order');

figure(2);

subplot(3,1,1);
[n, xout] = hist(framesize_I, 50);
bar(xout, n / length(framesize_I));
xlabel('Frame size [bytes]');
ylabel('Relative frequency');
title('Relative Frequency of Frame Sizes for I frames');

subplot(3,1,2);
[n, xout] = hist(framesize_P, 50);
bar(xout, n / length(framesize_P));
xlabel('Frame size [bytes]');
ylabel('Relative frequency');
title('Relative Frequency of Frame Sizes for P frames');

subplot(3,1,3);
[n, xout] = hist(framesize_B, 50);
bar(xout, n / length(framesize_B));
xlabel('Frame size [bytes]');
ylabel('Relative frequency');
title('Relative Frequency of Frame Sizes for B frames');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Hint1: You may use the MATLAB functions 'length()','mean()','max()','min()'.
%       which calculate the length,mean,max,min of a
%       vector (for example max(framesize_P) will give you the size of
%       largest P frame
%Hint2: Use the 'plot' function to graph the framesize as a function of the frame
%       sequence number. 
%Hint3: Use the function 'hist' to show the distribution of the frames. Before 
%       that function type 'figure(2);' to indicate your figure number.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   CODE FOR EXERCISE 2.3   (version: Spring 2007)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The following code will generates Plot 1. You generate Plot2 , Plot3 on
%your own. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The next line assigns a label (figure number) to the figure 
figure(3);

initial_point=1;
ag_frame=500;
jj=initial_point;
x=initial_point:ag_frame:(initial_point+ag_frame*99);
bytes_f=zeros(1,100);
for i=1:length(bytes_f)
    while ((jj-initial_point)<=ag_frame*i && jj<length(framesize_f))
        bytes_f(i)=bytes_f(i)+framesize_f(jj);
        jj=jj+1;
    end
end
subplot(3,1,1);
bar(x, bytes_f);
xlim([min(x), max(x)]);
xlabel('Bucket sequence number');
ylabel('Bucket size [bytes]');
title('Aggregate Frame Sizes with Bucket Size 500');

initial_point=3000;
ag_frame=50;
jj=initial_point;
x=initial_point:ag_frame:(initial_point+ag_frame*99);
bytes_f=zeros(1,100);
for i=1:length(bytes_f)
    while ((jj-initial_point)<=ag_frame*i && jj<length(framesize_f))
        bytes_f(i)=bytes_f(i)+framesize_f(jj);
        jj=jj+1;
    end
end
subplot(3,1,2);
bar(x, bytes_f);
xlim([min(x), max(x)]);
xlabel('Bucket sequence number');
ylabel('Bucket size [bytes]');
title('Aggregate Frame Sizes with Bucket Size 50');

initial_point=5000;
ag_frame=5;
jj=initial_point;
x=initial_point:ag_frame:(initial_point+ag_frame*99);
bytes_f=zeros(1,100);
for i=1:length(bytes_f)
    while ((jj-initial_point)<=ag_frame*i && jj<length(framesize_f))
        bytes_f(i)=bytes_f(i)+framesize_f(jj);
        jj=jj+1;
    end
end
subplot(3,1,3);
bar(x, bytes_f);
xlim([min(x), max(x)]);
xlabel('Bucket sequence number');
ylabel('Bucket size [bytes]');
title('Aggregate Frame Sizes with Bucket Size 5');

figure(4);

x=1:200;%length(index);
ac=zeros(1, length(x));
for i=1:length(x)
    ac(i) = autocorrelation(framesize_f, i);
end
plot(x, ac);
xlabel('k [index]');
ylabel('Frame size [bytes]');
title('Plot of Autocorrelation for Video Trace');

figure(5);

x=1:100;%length(index);
bn=zeros(1, length(x));
for i=1:length(x)
    bn(i) = burstiness(framesize_f, i);
end
plot(x, bn);
xlabel('t [index]');
ylabel('Worst case average bitrate in time interval [bytes]');
title('Plot of Burstiness Function for Video Trace');

figure(6);

x=1:length(index);
iod=zeros(1, length(x));
for i=1:length(x)
    iod(i) = dispersion(framesize_f, i);
end
plot(x, iod);
xlabel('t [index]');
ylabel('Index of dispersion [bytes]');
title('Plot of Index of Dispersion for Video Trace');
