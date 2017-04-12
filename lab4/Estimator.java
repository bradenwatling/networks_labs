import java.io.*;
import java.net.*;
import java.nio.ByteBuffer;
import java.util.concurrent.CountDownLatch;

public class Estimator {

  private static final int MAX_PACKET_SIZE = 1480;

  static class PacketData {
    int seqNo;
    long sendTime;
    long receiveTime;
  }

  private static void packetTrain(PacketData[] data, InetAddress targetAddr, int numPackets, int packetSize, int packetRate, short targetPort, short receivePort) {
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
        data[i] = new PacketData();
        data[i].seqNo = i;
        // Record the time that we sent this packet
        data[i].sendTime = System.nanoTime();

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

  private static void receivePackets(final PacketData[] data, final CountDownLatch latch, final int numPackets, final short receivePort) {
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
            data[seqNo].receiveTime = System.nanoTime();

            // Count down the latch
            latch.countDown();
          }
        } catch (Exception e) {
          e.printStackTrace();
        }
      }
    }.start();
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

        // Create the array to store all of the packet data
        PacketData[] packetData = new PacketData[numPackets];

        // Create a latch to wait for all of the packets to be replied to
        CountDownLatch latch = new CountDownLatch(numPackets);

        receivePackets(packetData, latch, numPackets, receivePort);
        packetTrain(packetData, targetAddr, numPackets, packetSize, packetRate, targetPort, receivePort);

        // Wait for all packets to return
        latch.await();

        FileOutputStream fout =  new FileOutputStream("packet_train.data");
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
          System.out.println(line);
          pout.println(line);
        }
      } catch (Exception e) {
        e.printStackTrace();
      }
    }
  }
}
