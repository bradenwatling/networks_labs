for x = 0:2
    % N = 1, 5, 9
    N = x * 4 + 1;
    receiverFilename = ['data/part2_3/PrioritySchedulerReceiver_N_', num2str(N), '.data'];
    senderFilename = ['data/part2_3/PrioritySchedulerSender_N_', num2str(N), '.data'];
    sinkFilename = ['data/part2_3/trafficsink_N_', num2str(N), '.data'];
    [receiver_id, receiver_timediff, receiver_size, receiver_backlog, receiver_dropped, receiver_priority] = textread(receiverFilename, '%f %f %f %f %f %f');
    [sender_id, sender_waittime, sender_size] = textread(senderFilename, '%f %f %f');
    [sink_id, sink_timediff, sink_size] = textread(sinkFilename, '%f %f %f');

    receiver_time_sum = 0;
    sink_time_sum = 0;
    dropped_sum = 0;
    
    receiver_agg_time = zeros(length(receiver_id), 1);
    receiver_agg_dropped = zeros(length(receiver_id), 1);
    sender_agg_time = zeros(length(sender_id), 1);
    sink_agg_time = zeros(length(sink_id), 1);

    % the id of the next sender packet
    next_sender_packet = 0;
    
    for i = 1:length(receiver_id)
        dropped_sum = dropped_sum + receiver_dropped(i);
        receiver_time_sum = receiver_time_sum + receiver_timediff(i);
        receiver_agg_dropped(i) = dropped_sum;
        receiver_agg_time(i) = receiver_time_sum;
        
        if next_sender_packet == receiver_id(i)
            sender_agg_time(sender_index) = receiver_time_sum;
        end
    end

    for i = 1:length(sink_id)
        sink_time_sum = sink_time_sum + sink_timediff(i);
        sink_agg_time(i) = sink_time_sum;
    end
    
    figure(N)
    plot(receiver_agg_time, receiver_backlog, 'r')
    title(['Backlog for N=', num2str(N)])
    xlabel('Time (microseconds)')
    ylabel('Backlog (bytes)')
    
    figure(N + 1)
    plot(receiver_agg_time, sender_waittime, 'b')
    title(['Waiting Time for N=', num2str(N)])
    xlabel('Time (microseconds)')
    ylabel('Waiting Time (microseconds)')
    
    figure(N + 2)
    plot(receiver_agg_time, receiver_agg_dropped, 'g')
    title(['Number of Discarded Packets for N=', num2str(N)])
    xlabel('Time (microseconds)')
    ylabel('Number of discarded packets')
end