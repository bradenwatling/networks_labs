import java.io.*;
import java.net.*;
import java.util.*;

class PoissonTrafficGenerator {
  private static long currentTimeMicros() {
    return System.nanoTime() / 1000;
  }

  private static void sendPackets(InetAddress addr, String filename) {
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

      long startTime = currentTimeMicros();

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

        /*
         *  Convert each element to desired data type
         */
        int seqNo = Integer.parseInt(col1);
        long time = Long.parseLong(col2);
        int size = Integer.parseInt(col3);

        long sendTime;
        while ((sendTime = currentTimeMicros() - startTime) <= time) {
          // Wait until the correct time to send the packet
        }

        /*System.out.println("Transmitting packet #" + seqNo +
                           ": packetTime=" + time +
                           ", sendTime=" + sendTime);*/

        byte[] buf = new byte[size];
        DatagramPacket p = new DatagramPacket(buf, buf.length, addr, 4444);
        socket.send(p);
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

    sendPackets(addr, "poisson3.data");
  }
}
