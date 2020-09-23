/*************************************************************************
 *  Compilation:  javac MyLZW.java
 *  Execution:    java MyLZW - mode < input.txt   (compress)
 *  Execution:    java MyLZW + < input.txt   (expand)
 *  Dependencies: BinaryIn.java BinaryOut.java
 *
 *  Compress or expand binary input from standard input using LZW.
 *
 *  WARNING: STARTING WITH ORACLE JAVA 6, UPDATE 7 the SUBSTRING
 *  METHOD TAKES TIME AND SPACE LINEAR IN THE SIZE OF THE EXTRACTED
 *  SUBSTRING (INSTEAD OF CONSTANT SPACE AND TIME AS IN EARLIER
 *  IMPLEMENTATIONS).
 *
 *  See <a href = "http://java-performance.info/changes-to-string-java-1-7-0_06/">this article</a>
 *  for more details.
 *
 *************************************************************************/
import java.lang.Math;
import java.util.Arrays;
 
public class MyLZW {
    private static final int R = 256;        // number of input chars
    private static int W = 9;         // codeword width
	private static int L = (int) Math.pow(2, W);       // number of codewords = 2^W

    public static void compress(String mode) { 
		double newRatio=0, oldRatio=0, dComp=0, dUncomp = 0;
		boolean monitor = false;
        String input = BinaryStdIn.readString();
		BinaryStdOut.write(mode, W); 	//write the mode of compression to file first
		
        TST<Integer> st = new TST<Integer>();
        for (int i = 0; i < R; i++)
            st.put("" + (char) i, i);
        int code = R+1;  // R is codeword for EOF
        while (input.length() > 0) {
			if(code == L)		//Codebook Full
			{
				if(W < 16) //increase Bit width (max 16 bits)
				{
					W++;
					L = (int) Math.pow(2, W);
				}
				else //max Bit width achieved, take action depending on argument
				{
					
					switch(mode)
					{
						case "m":
							if(!monitor)
							{
								oldRatio = newRatio;
								monitor = true;
								break;
							}
							if(oldRatio / newRatio > 1.1)
								monitor = false;
							else
								break;
						case "r":
							newRatio=0;
							oldRatio=0;
							dComp=0;
							dUncomp = 0;
							W = 9;
							L = (int) Math.pow(2, W);
							st = new TST<Integer>();
							for (int i = 0; i < R; i++)
								st.put("" + (char) i, i);
							code = R+1;
							break;
					}
				}
			}
			
            String s = st.longestPrefixOf(input);  // Find max prefix match s.
			dUncomp += (s.length() * 8);			// amount of bits in the uncompressed string input
			dComp += W;		//bits in compressed form
			
            BinaryStdOut.write(st.get(s), W);      // Print s's encoding.
            int t = s.length();
			if (t < input.length() && code < L)    // Add s to symbol table.
				st.put(input.substring(0, t + 1), code++);
            input = input.substring(t);            // Scan past s in input.
			
			newRatio = dUncomp / dComp;
        }
        BinaryStdOut.write(R, W);
        BinaryStdOut.close();
    } 


    public static void expand() {
        String[] st = new String[L];
        int i; // next available codeword value
		double newRatio=0, oldRatio=0, dComp=W, dUncomp = 8;
		boolean monitor = false;

        // initialize symbol table with all 1-character strings
        for (i = 0; i < R; i++)
            st[i] = "" + (char) i;
        st[i++] = "";
		// (unused) lookahead for EOF
		char mode = BinaryStdIn.readChar(W);  //Read the mode the file was compressed in
        int codeword = BinaryStdIn.readInt(W);
        if (codeword == R) return;           // expanded message is empty string
        String val = st[codeword];
		String s = "";
        while (true) {
			if(i == L-1)		//codebook full
			{
				if(W < 16) //increase Bit width (max 16 bits)
				{
					W++;
					L = (int) Math.pow(2, W);
					st = Arrays.copyOf(st, L);
				}
				else //max Bit width achieved, take action depending on argument
				{
					switch(mode)
					{
						case 'm':
							if(!monitor)
							{
								oldRatio = newRatio;
								monitor = true;
								break;
							}
							if(oldRatio / newRatio > 1.1)
								monitor = false;
							else
								break;
						case 'r':
							BinaryStdOut.write(val);
							newRatio=0;
							oldRatio=0;
							dComp=0;
							dUncomp = 0;
							W = 9;
							L = (int) Math.pow(2, W);
							st = new String[L];
							for (i = 0; i < R; i++)
								st[i] = "" + (char) i;
							st[i++] = "";
							codeword = BinaryStdIn.readInt(W);
							val = st[codeword];
							if (i == codeword) val = s + s.charAt(0);
							break;
					}
				}
			}
            BinaryStdOut.write(val);
            codeword = BinaryStdIn.readInt(W);
            if (codeword == R) break;
            s = st[codeword];
			
            if (i == codeword) s = val + val.charAt(0);   // special case hack
            if (i < L) st[i++] = val + s.charAt(0);
            val = s;
			
			dUncomp += (s.length() * 8); 
			dComp += W;
			newRatio = dUncomp / dComp;
			
			
        }
        BinaryStdOut.close();
    }



    public static void main(String[] args) {
        if      (args[0].equals("-")) compress(args[1]);
        else if (args[0].equals("+")) expand();
        else throw new IllegalArgumentException("Illegal command line argument");
    }

}
