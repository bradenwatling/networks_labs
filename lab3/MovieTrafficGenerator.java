import java.io.*;
import java.net.*;
import java.util.*;
import java.nio.ByteBuffer;

class MovieTrafficGenerator {
  private static long currentTimeNanos() {
    return System.nanoTime() / 1000;
  }


  private static long currentTimeMicros() {
    return System.nanoTime() / 1000;
  }

  private static long currentTimeMillis() {
    return System.nanoTime()/1000000;
  }

  private static class Packet {
    int seqNo;
    double time;
    int size;
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

      List<Packet> packets = new ArrayList<Packet>();

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
        String col3 = st.nextToken(); // IBP char (not needed)
        String col4 = st.nextToken();

        Packet p = new Packet();

        /*
         *  Convert each element to desired data type
         */
        p.seqNo = Integer.parseInt(col1);
        p.time = Double.parseDouble(col2);
        p.size = Integer.parseInt(col4);
        packets.add(p);
      }

      long begin = currentTimeMicros();
      long MAX_TIME = 100_000_000;
      // Run until we've hit MAX_TIME
      while (currentTimeMicros() - begin < MAX_TIME) {
        long startTime = currentTimeMicros();

        /*
         * Send the data once the entire file has been read
         */
        for (Packet p : packets) {
          if (currentTimeMicros() - begin >= MAX_TIME) break;

          long sendTime;
          while ((sendTime = currentTimeMicros() - startTime) <= p.time*1000) {
            // Wait until the correct time to send the packet
          }

          /*System.out.println("Transmitting packet #" + seqNo +
                             ": packetTime=" + time +
                             ", sendTime=" + sendTime);*/

          // if movie packet is larger than 1480 (MAX size) split into smaller parts
          int size = p.size;
          while(size > 1480)
          {
            byte[] buf = new byte[1480];
            ByteBuffer.wrap(buf).put((byte) 2);
            DatagramPacket fragment = new DatagramPacket(buf, buf.length, addr, 4444);
            socket.send(fragment);
            size = size - 1480;
          }

          byte[] buf = new byte[size];
          ByteBuffer.wrap(buf).put((byte) 2);
          DatagramPacket d = new DatagramPacket(buf, buf.length, addr, 4444);
          socket.send(d);
        }
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

    sendPackets(addr, "movietrace.data");
  }
}
