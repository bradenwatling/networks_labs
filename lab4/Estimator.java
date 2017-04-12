import java.io.*;
import java.net.*;
import java.util.*;
import java.nio.ByteBuffer;
import java.util.concurrent.CountDownLatch;

public class Estimator {

  private static final int MAX_PACKET_SIZE = 1480;

  static class PacketData {
    int seqNo;
    long sendTime;
    long receiveTime;
  }

  private PacketData[] packetData;
  private InetAddress targetAddr;
  private short targetPort;
  private short receivePort;
  private int numPackets;
  private int packetSize;
  private int packetRate;

  private CountDownLatch latch;

  private void packetTrain() {
    packetSize = Math.min(MAX_PACKET_SIZE, packetSize);

    // Sending packets of size packetSize bytes at packetRate kbps. The delay between them in nanoseconds is
    // given by packetSize / (1_000 * packetRate / 8) * 1_000_000_000
    long delay = (long) (((double) packetSize) / ((double) packetRate) * 8_000_000.0);

    try {
      DatagramSocket socket = new DatagramSocket();

      byte[] buf = new byte[packetSize];
      for (int i = 0; i < numPackets; i++) {
        // Put the receivePort as the first 2 bytes (big-endian)
        ByteBuffer bb = ByteBuffer.wrap(buf);
        bb.putShort(receivePort);
        bb.putInt(i);

        // Create the PacketData
        packetData[i] = new PacketData();
        packetData[i].seqNo = i;
        // Record the time that we sent this packet
        packetData[i].sendTime = System.nanoTime();

        // Send the packet to the target
        DatagramPacket d = new DatagramPacket(buf, buf.length, targetAddr, targetPort);
        socket.send(d);

        // Delay until the next packet should be sent
        long start = System.nanoTime();
        while (System.nanoTime() - start <= delay);
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  private void receivePackets() {
    new Thread() {
      @Override
      public void run() {
        try {
          DatagramSocket socket = new DatagramSocket(receivePort);
          byte[] buf = new byte[MAX_PACKET_SIZE];
          DatagramPacket p = new DatagramPacket(buf, buf.length);

          // Wait to receive all packets
          for (int i = 0; i < numPackets; i++) {
            socket.receive(p);

            // Retrieve the sequence number
            ByteBuffer bb = ByteBuffer.wrap(buf);
            bb.getShort();
            int seqNo = bb.getInt();
            // Record the time that we received this packet
            packetData[seqNo].receiveTime = System.nanoTime();

            // Count down the latch
            latch.countDown();
          }
        } catch (Exception e) {
          e.printStackTrace();
        }
      }
    }.start();
  }

  public Estimator(InetAddress targetAddr, short targetPort, short receivePort, int numPackets, int packetSize, int packetRate) {
    this.targetAddr = targetAddr;
    this.targetPort = targetPort;
    this.receivePort = receivePort;
    this.numPackets = numPackets;
    this.packetSize = packetSize;
    this.packetRate = packetRate;

    // Create the array to store all of the packet data
    packetData = new PacketData[numPackets];

    // Create a latch to wait for all of the packets to be replied to
    latch = new CountDownLatch(numPackets);
  }

  public void run() throws InterruptedException {
    receivePackets();
    packetTrain();

    // Wait for all packets to return
    latch.await();
  }

  public int getMaxBacklog() {
    long[] sendTimestamps = new long[packetData.length];
    long[] recvTimestamps = new long[packetData.length];
    for (int i = 0; i < packetData.length; i++) {
      sendTimestamps[i] = packetData[i].sendTime;
      recvTimestamps[i] = packetData[i].receiveTime;
    }

    // Sort the send and receive timestamps so that they occur in order
    Arrays.sort(sendTimestamps);
    Arrays.sort(recvTimestamps);

    // Iterate through the send and receive events
    int backlog = 0, maxBacklog = 0;
    int sendIndex = 0, recvIndex = 0;
    while (sendIndex < packetData.length && recvIndex < packetData.length) {
      // Calculate the relative timestamp. Not necessary but was useful for
      // debugging
      long sendTime = sendTimestamps[sendIndex] - sendTimestamps[0];
      long recvTime = recvTimestamps[recvIndex] - sendTimestamps[0];
      if (sendTime < recvTime) {
        // If the next event was sending, increment the backlog and move
        // to the next packet that was sent
        sendIndex++;
        backlog += packetSize;
      } else if (sendTime > recvTime) {
        // If the next event was receiving, decrement the backlog and move
        // to the next packet that was received
        recvIndex++;
        backlog -= packetSize;
      } else {
        // If a send and receive occurred at the same time, then the backlog
        // is unchanged but we should move to the next event for both sending
        // and receiving
        sendIndex++;
        recvIndex++;
      }

      maxBacklog = Math.max(backlog, maxBacklog);
    }

    // The backlog at the end of the transmission should be 0
    assert(backlog == 0);

    return maxBacklog;
  }

  public void writeData(String filename) throws FileNotFoundException {
    FileOutputStream fout =  new FileOutputStream(filename);
    PrintStream pout = new PrintStream (fout);

    // Analyze the data that was collected
    PacketData first = null;
    for (int i = 0; i < numPackets; i++) {
      PacketData current = packetData[i];
      if (first == null) first = current;

      // Determine the sequence number, send time, and receive time (in microseconds relative
      // to the send time of the first packet)
      int seqNo = current.seqNo;
      long sendTime = (current.sendTime - first.sendTime) / 1000;
      long receiveTime = (current.receiveTime - first.sendTime) / 1000;

      String line = seqNo + "\t" + sendTime + "\t" + receiveTime;
      //System.out.println(line);
      pout.println(line);
    }
  }

  public static void main(String[] args) {
    if (args.length != 6) {
      System.out.println("USAGE: Estimator <targetHost> <targetPort> <receivePort> <numPackets> <packetSize [bytes]> <packetRate [kbps]>");
    } else {
      try {
        InetAddress targetAddr = InetAddress.getByName(args[0]);
        short targetPort = Short.parseShort(args[1]);
        short receivePort = Short.parseShort(args[2]);
        int numPackets = Integer.parseInt(args[3]);
        int packetSize = Integer.parseInt(args[4]);
        int packetRate = Integer.parseInt(args[5]);

        Estimator estimator = new Estimator(targetAddr, targetPort, receivePort, numPackets, packetSize, packetRate);
        estimator.run();
        estimator.writeData("packet_train.data");
        System.out.println("Max backlog: " + estimator.getMaxBacklog());
      } catch (Exception e) {
        e.printStackTrace();
      }
    }
  }
}
