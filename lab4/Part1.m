[seqNo1, sendTime1, receiveTime1] = textread('packet_train_N_100_L_400_r_10.data', '%f %f %f');
[seqNo2, sendTime2, receiveTime2] = textread('packet_train_N_100_L_400_r_1000.data', '%f %f %f');
[seqNo3, sendTime3, receiveTime3] = textread('packet_train_N_100_L_400_r_10000.data', '%f %f %f');

figure(1)
stairs(seqNo1, sendTime1, 'r')
hold
stairs(seqNo1, receiveTime1, 'b')
legend('Send Timestamps', 'Receive Timestamps')
title('Send an Receive Timestamps vs. Sequence Number for N=100, L=400, r=10')
xlabel('Sequence Number')
ylabel('Timestamp (microseconds)')

figure(2)
stairs(seqNo2, sendTime2, 'r')
hold
stairs(seqNo2, receiveTime2, 'b')
legend('Send Timestamps', 'Receive Timestamps')
title('Send an Receive Timestamps vs. Sequence Number for N=100, L=400, r=1000')
xlabel('Sequence Number')
ylabel('Timestamp (microseconds)')

figure(3)
stairs(seqNo3, sendTime3, 'r')
hold
stairs(seqNo3, receiveTime3, 'b')
legend('Send Timestamps', 'Receive Timestamps')
title('Send an Receive Timestamps vs. Sequence Number for N=100, L=400, r=10000')
xlabel('Sequence Number')
ylabel('Timestamp (microseconds)')

sendTime3 = sort(sendTime3);
receiveTime3 = sort(receiveTime3);
L=400;
arrivals3 = zeros(length(sendTime3), 1);
departures3 = zeros(length(receiveTime3), 1);
arrivals3(1) = L;
for i = 2:length(seqNo3)
    arrivals3(i) = arrivals3(i-1) + L;
    departures3(i) = departures3(i-1) + L;
end

figure(4)
stairs(sendTime3, arrivals3, 'r')
hold
stairs(receiveTime3, departures3, 'b')
legend('Cumulative Send Function', 'Cumulative Receive Function')
title('Cumulative Send and Receive Functions vs. Time')
xlabel('Timestamp (microseconds)')
ylabel('Bytes')