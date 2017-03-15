import java.io.*;
import java.net.*;
import java.util.*;

class ReferenceTrafficGenerator {
  private static long currentTimeNanos() {
    return System.nanoTime();
  }

  /*
   * Every T nsec transmit a group of N packets back-to-back, each of size L
   */
  private static void sendPackets(InetAddress addr, long T, int N, int L) {
    DatagramSocket socket = null;
    try {
      /*
       * Open file for output
       */
      FileOutputStream fout =  new FileOutputStream("../trafficgen_2.2.3.data");
      PrintStream pout = new PrintStream(fout);

      socket = new DatagramSocket();

      long startTime = currentTimeNanos();
      long groupEndTime = startTime + T;

      long previousPacketTime = startTime;

      byte[] buf = new byte[L];

      // We are going to be sending 10000 packets
      for (int i = 0; i < Math.ceil(10000.0 / N); i++) {
        if (i != 0) {
          groupEndTime = currentTimeNanos() + T;
          //System.out.println(groupEndTime);
        }
        // Send N packets back-to-back for this group
        for (int j = 0; j < N; j++) {
          // Record the time that we sent this packet
          long packetTime = currentTimeNanos();
          // Send a packet of size L
          DatagramPacket d = new DatagramPacket(buf, buf.length, addr, 4444);
          socket.send(d);
          if (i == 0 && j == 0) {
            packetTime = startTime; // Make the first packet have time 0
          }
          /*
           *  Write line to output file
           */
          pout.println((i * N +j + 1) + "\t" + ((packetTime - /*startTime*/previousPacketTime) / 1000) + "\t" + L);

          // Record the time of the previous packet
          previousPacketTime = packetTime;
        }
        int k = 0;
        long waitingTime = groupEndTime - currentTimeNanos();
        if (waitingTime > 0) {
          try {
            Thread.sleep(waitingTime / 1000000l, (int) (waitingTime % 1000000l));
          } catch (InterruptedException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
          }
        }
      }
    } catch (IOException e) {
      // Catch io errors from FileInputStream or readLine()
      System.out.println("IOException: " + e.getMessage());
    } finally {
      if (socket != null) {
        socket.close();
      }
    }
  }

  public static void main(String[] args) throws IOException {
    InetAddress addr = InetAddress.getByName(args[0]);

    // 2.2.1 - 800us, 1, 100
    // 2.2.2 - 8000us, 10, 100
    // 2.2.3 - 421.053us, 1, 100
    sendPackets(addr, 421053, 1, 100);
  }
}
