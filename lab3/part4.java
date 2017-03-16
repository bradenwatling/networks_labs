import TokenBucket.TokenBucket;

public class part4 {
	public static void main(String[] args) {
		// listen on port 4444, send to localhost:4445,
		 // max. size of received packet is 1024 bytes,
		// buffer capacity is 100*1024 bytes,
		// token bucket has 10000 tokens, rate 5000 tokens/sec, and
		// records packet arrivals to bucket.txt).
    // 2.2.1 - size_TB = 100
    // 2.2.2 - size_TB = 500
    // 2.2.3 - size_TB = 100
    // 2.4 - Choose the maximum rate that we can fill the bucket, which is one token every nanosecond
    // 4 - Choose rate and size of TB1 and TB2
    int size_TB1 = 1480 * 3; // Can burst 3 packets
    int rate_TB1 = (int) (1480 / 0.000160); // No more than one packet every 160 us (approximately 200 packets for average I frame, 30 fps)
    int rate_TB2 = 4000000; // A little higher than the mean Bps of the movietrace
    int size_TB2 = rate_TB2 / 30; // Limit the packets according to the second bucket on a per-frame basis (30 fps)
		 TokenBucket lb = new TokenBucket(4444, "localhost", 4445,
       1480, (int) 7e7, size_TB1, rate_TB1, size_TB2, rate_TB2, "bucket_4.txt");
		 new Thread(lb).start();
	 }
}
