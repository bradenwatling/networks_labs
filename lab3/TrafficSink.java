import java.io.*;
import java.net.*;

class TrafficSink {
  private static long currentTimeNanos() {
    return System.nanoTime();
  }

  public static void main(String[] args) throws IOException {
    DatagramSocket socket = new DatagramSocket(4444);
    byte[] buf = new byte[1500];
    DatagramPacket p = new DatagramPacket(buf, buf.length);
    System.out.println("Waiting ...");

    /*
     * Open file for output
     */
    FileOutputStream fout =  new FileOutputStream("trafficsink.data");
    PrintStream pout = new PrintStream (fout);

    boolean receivedFirst = false;
    int i = 1;
    long startTime = currentTimeNanos();
    long previousTime = startTime;
    while (true) {
      socket.receive(p);

      long now = currentTimeNanos();
      if (!receivedFirst) {
        startTime = now;
        previousTime = startTime;
        receivedFirst = true;
      }
      long diffToPrevious = now - previousTime;

      /*
       *  Write line to output file
       */
      pout.println(i++ + "\t" + (diffToPrevious / 1000) + "\t" + p.getLength());

      previousTime = now;
    }
  }
}
