import java.io.*;
import java.net.*;
import java.util.*;

class MovieTrafficGenerator {
  private static long currentTimeMicros() {
    return System.nanoTime() / 1000;
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

      long startTime = currentTimeMicros();

      /*
       * Send the data once the entire file has been read
       */
      for (Packet p : packets) {
        long sendTime;
        while ((sendTime = currentTimeMicros() - startTime) <= p.time) {
          // Wait until the correct time to send the packet
        }

        /*System.out.println("Transmitting packet #" + seqNo +
                           ": packetTime=" + time +
                           ", sendTime=" + sendTime);*/

	// if movie packet is larger than 1024 split into smaller parts
	int size = p.size;
	while(size > 1024)
	{
		byte[] buf = new byte[1024];
		DatagramPacket fragment = new DatagramPacket(buf, buf.length, addr, 4444);
					
		socket.send(fragment);
		size = size - 1024;
	}

        byte[] buf = new byte[size];
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

    sendPackets(addr, "movietrace.data");
  }
}