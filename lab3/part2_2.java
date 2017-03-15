import TokenBucket.TokenBucket;

public class part2_2 {
	public static void main(String[] args) {
		// listen on port 4444, send to localhost:4445,
		 // max. size of received packet is 1024 bytes,
		// buffer capacity is 100*1024 bytes,
		// token bucket has 10000 tokens, rate 5000 tokens/sec, and
		// records packet arrivals to bucket.txt).
    // 2.2.1 - size_TB = 100
    // 2.2.2 - size_TB = 500
    // 2.2.3 - size_TB = 100
    int size_TB = 500;
    int rate_TB = 250000; // 2 Mbps = 0.250 Mbps
		 TokenBucket lb = new TokenBucket(4444, "localhost", 4445,
       100, 100*100, size_TB, rate_TB, "bucket_2.2.2.txt");
		 new Thread(lb).start();
	 }
}
