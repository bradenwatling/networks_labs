[seqNo1, sendTime1, receiveTime1] = textread('packet_train_N_100_L_400_r_10.data', '%f %f %f');
[seqNo2, sendTime2, receiveTime2] = textread('packet_train_N_100_L_400_r_1000.data', '%f %f %f');
[seqNo3, sendTime3, receiveTime3] = textread('packet_train_N_100_L_400_r_10000.data', '%f %f %f');

figure(1);
plot(seqNo1, sendTime1, 'r', seqNo1, receiveTime1, 'b')
legend('Send Timestamps', 'Receive Timestamps')
title('Send an Receive Timestamps vs. Sequence Number for N=100, L=400, r=10')
xlabel('Sequence Number')
ylabel('Timestamp (microseconds)')

figure(2);
plot(seqNo2, sendTime2, 'r', seqNo2, receiveTime2, 'b')
legend('Send Timestamps', 'Receive Timestamps')
title('Send an Receive Timestamps vs. Sequence Number for N=100, L=400, r=1000')
xlabel('Sequence Number')
ylabel('Timestamp (microseconds)')

figure(3);
plot(seqNo3, sendTime3, 'r', seqNo3, receiveTime3, 'b')
legend('Send Timestamps', 'Receive Timestamps')
title('Send an Receive Timestamps vs. Sequence Number for N=100, L=400, r=10000')
xlabel('Sequence Number')
ylabel('Timestamp (microseconds)')