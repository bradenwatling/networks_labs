import java.io.*;
import java.net.*;

class TrafficSink {
  private static long currentTimeMicros() {
    return System.nanoTime() / 1000;
  }

  public static void main(String[] args) throws IOException {
    DatagramSocket socket = new DatagramSocket(4445);
    byte[] buf = new byte[1500];
    DatagramPacket p = new DatagramPacket(buf, buf.length);
    System.out.println("Waiting ...");

    /*
     * Open file for output
     */
    FileOutputStream fout =  new FileOutputStream("trafficsink_eth.data");
	//trafficsick_poisson.data
	//trafficsick_eth.data
	//trafficsick_movie.data
    PrintStream pout = new PrintStream (fout);

    boolean receivedFirst = false;
    int i = 1;
    long startTime = currentTimeMicros();
    while (true) {
      socket.receive(p);

      long now = currentTimeMicros();
      if (!receivedFirst) {
        startTime = now;
        receivedFirst = true;
      }
      long arrivalTime = now - startTime;

      /*
       *  Write line to output file
       */
      pout.println(i++ + "\t" + arrivalTime + "\t" + p.getLength());
System.out.println(i + " : " + p.getLength());
    }
  }
}
