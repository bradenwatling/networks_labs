package PriorityScheduler;

import java.io.FileOutputStream;
import java.io.PrintStream;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.nio.ByteBuffer;


/**
 * Listens on specified port for incoming packets.
 * Packets are stored to queues.
 */
public class SchedulerReceiver implements Runnable
{
	// queues used to store incoming packets 
	private Buffer[] buffers;
	// port on which packets are received
	private int port;
	// name of output file
	private String fileName;
  private int packetID = 0;
	
	/**
	 * Constructor.
	 * @param buffers Buffers to which packets are stored. 
	 * @param port Port on which to lister for packets.
	 * @param fileName Name of output file.
	 */
	public SchedulerReceiver(Buffer[] buffers, int port, String fileName)
	{
		this.buffers = buffers;
		this.port = port;
		this.fileName = fileName;
	}

	/**
	 * Listen on port and send out or store incoming packets to buffers.
	 * This method is invoked when starting a thread for this class.
	 */  
	public void run()
	{		
		DatagramSocket socket = null;
		PrintStream pOut = null;	
		
		try
		{
			FileOutputStream fOut =  new FileOutputStream(fileName);
			pOut = new PrintStream (fOut);
			long previsuTime = 0;
			
			socket = new DatagramSocket(port);
			
			// receive and process packets
			while (true)
			{
				byte[] buf = new byte[Buffer.MAX_PACKET_SIZE];
				DatagramPacket packet = new DatagramPacket(buf, buf.length);
				
				// wait for packet, when arrives receive and recored arrival time
				socket.receive(packet);
				long startTime=System.nanoTime();

        // Record the packet number for this packet
        ByteBuffer bb = ByteBuffer.wrap(buf, Buffer.MAX_PACKET_SIZE - Integer.SIZE - Long.SIZE, Integer.SIZE + Long.SIZE);
        bb.putInt(packetID);
        bb.putLong(startTime);
				
				/*
				 * Record arrival to file in following format:
				 * elapsed time (microseconds), packet size (bytes), backlog in buffers ordered by index in array (bytes).
				 */
				// to put zero for elapsed time in first line
				if(previsuTime == 0)
				{
					previsuTime = startTime;
				}
				pOut.print((packetID++) + "\t" + (startTime-previsuTime)/1000 + "\t" + packet.getLength() + "\t");
				for (int i = 0; i<buffers.length; i++)
				{
					long bufferSize = buffers[i].getSizeInBytes();
					pOut.print(bufferSize + "\t");
				}
				previsuTime = startTime;
				
				/*
				 * Process packet.
				 */
				
        boolean droppedPacket;

        // Determine the index of the queue for this packet based on its priority
        int priority = ByteBuffer.wrap(buf).get();
        int priorityIndex = priority - 1;
        if (priorityIndex < buffers.length) {
          // add packet to a queue if there is enough space
          droppedPacket = buffers[priorityIndex].addPacket(new DatagramPacket(packet.getData(), packet.getLength())) < 0;
        } else {
          droppedPacket = true;
        }

        // Record whether the packet was dropped
        pOut.print((droppedPacket ? "1" : "0") + "\t");
        pOut.print(priority + "\t");
				pOut.println();
			}
		} 
		catch (Exception e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
	}
}
