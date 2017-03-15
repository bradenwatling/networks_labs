import TokenBucket.TokenBucket;

public class part2_4 {
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
    int size_TB = 19240;
    int rate_TB = 1000000000;
		 TokenBucket lb = new TokenBucket(4444, "localhost", 4445,
       1480, 100*1480, size_TB, rate_TB, "bucket_2.4.txt");
		 new Thread(lb).start();
	 }
}
