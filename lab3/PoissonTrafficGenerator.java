import java.io.*;
import java.net.*;
import java.util.*;

class PoissonTrafficGenerator {
  private static long currentTimeMicros() {
    return System.nanoTime() / 1000;
  }

  private static class Packet {
    int seqNo;
    long time;
    int size;
  }

  /**
   * Send packets to addr according to the poisson data in filename. The
   * average rate is scaled by N.
   */
  private static void sendPackets(InetAddress addr, String filename, int N) {
    BufferedReader bis = null;
    String currentLine = null;
    DatagramSocket socket = null;
    try {
      socket = new DatagramSocket();

      /*
       * Open input file as a BufferedReader
       */
      File fin = new File(filename);
      FileReader fis = new FileReader(fin);
      bis = new BufferedReader(fis);

      List<Packet> packets = new ArrayList<Packet>();

      long prevTime = 0;
      /*
       *  Read file line-by-line until the end of the file
       */
      while ((currentLine = bis.readLine()) != null) {
        /*
         *  Parse line and break up into elements
         */
        StringTokenizer st = new StringTokenizer(currentLine);
        String col1 = st.nextToken();
        String col2 = st.nextToken();
        String col3 = st.nextToken();

        Packet p = new Packet();

        /*
         *  Convert each element to desired data type
         */
        p.seqNo = Integer.parseInt(col1);

        // Record the difference in time between the current packet and the previous one.
        // Scale this time difference by 1 / N
        long curTime = Long.parseLong(col2);
        p.time = (curTime - prevTime) / N;
        prevTime = curTime;

        p.size = Integer.parseInt(col3);

        packets.add(p);
      }

      long startTime = currentTimeMicros();
      long prevSendTime = currentTimeMicros();

      /*
       * Send the data once the entire file has been read
       */
      for (Packet p : packets) {
        long now;
        while ((now = currentTimeMicros()) - prevSendTime <= p.time) {
          // Wait until the correct time to send the packet
        }

        // Record the time we sent this last packet
        prevSendTime = now;

        /*System.out.println("Transmitting packet #" + p.seqNo +
                           ": packetTime=" + p.time +
                           ", sendTime=" + (now - startTime));*/

        byte[] buf = new byte[p.size];
        DatagramPacket d = new DatagramPacket(buf, buf.length, addr, 4444);
        socket.send(d);
      }
    } catch (IOException e) {
      // Catch io errors from FileInputStream or readLine()
      System.out.println("IOException: " + e.getMessage());
    } finally {
      // Close files
      if (bis != null) {
        try {
          bis.close();
        } catch (IOException e) {
          System.out.println("IOException: " +  e.getMessage());
        }
      }
      if (socket != null) {
        socket.close();
      }
    }
  }

  public static void main(String[] args) throws IOException {
    InetAddress addr = InetAddress.getByName(args[0]);

    sendPackets(addr, "poisson3.data", 1);
  }
}
