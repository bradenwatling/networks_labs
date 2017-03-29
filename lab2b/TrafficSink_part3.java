import java.io.*;
import java.net.*;

class TrafficSink {
  private static long currentTimeNanos() {
    return System.nanoTime();
  }

  private static long currentTimeMicros() {
    return System.nanoTime()/ 1000;
  }

  private static long currentTimeMillis() {
    return System.nanoTime()/1000000;
  }

  public static void main(String[] args) throws IOException {
    DatagramSocket socket = new DatagramSocket(4445);
    byte[] buf = new byte[1500];
    DatagramPacket p = new DatagramPacket(buf, buf.length);
    System.out.println("Waiting ...");

    /*
     * Open file for output
     */
    FileOutputStream fout =  new FileOutputStream("trafficsink_ethernet3_2.data");
	//trafficsick_poisson.data
	//trafficsick_eth.data
	//trafficsick_movie.data
    PrintStream pout = new PrintStream (fout);
/*
    boolean receivedFirst = false;
    int i = 1;
    long startTime = currentTimeNanos();
    long previousTime = startTime;
    while (true) {
      socket.receive(p);

      long now = currentTimeNanos();
      if (!receivedFirst) {
        startTime = now;
        receivedFirst = true;
      }
      long diffToPrevious = now - previousTime;

*/

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
//System.out.println(i++ + "\t" + arrivalTime);

      /*
       *  Write line to output file
       */
      //pout.println(i++ + "\t" + (diffToPrevious / 1000) + "\t" + p.getLength());
      pout.println(i++ + "\t" + arrivalTime + "\t" + p.getLength());
      //previousTime = now;
//System.out.println(i + " : " + p.getLength());
    }
  }
}
