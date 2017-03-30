import PacketScheduler.PacketScheduler;

public class FIFOScheduler {
  public static void main(String[] args) {
    /*
     * Create a new packet scheduler.
     * Scheduler listens on UDP port 4444 for incoming packets
     * and sends outgoing packets to localhost:4445.
     * Transmission rate of scheduler is 10Mbps. The scheduler
     * has 1 queue (FIFO), and accepts packets of maximum size 1024
     * bytes.
     * Capacity of the queue is 100*1024
     * Arrivals of packets are recorded to file ps.txt.
     */
    PacketScheduler ps = new PacketScheduler(4444,
        "localhost", 4445, 10000000, 1, 1024,
        new long [] {100*1024}, "FIFOSchedulerReceiver.data", "FIFOSchedulerSender.data");
    // start packet scheduler
    new Thread(ps).start();
  }
}
