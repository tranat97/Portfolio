// Lab2.java

import java.io.*; // BufferedReader
import java.util.*; // Scanner to read from a text file

public class Lab2
{
	public static void main (String args[]) throws Exception // we NEED this 'throws' clause
	{
		// ALWAYS TEST FIRST TO VERIFY USER PUT REQUIRED CMD ARGS
		if (args.length < 3)
		{
			System.out.println("\nusage: C:\\> java Lab2 <input file name> <lo>  <hi>\n\n"); 
			// i.e. C:\> java Lab2 P2input.txt 1 30
			System.exit(0);
		}
		// grab args[0] and store into a String var named infile
		String infileName=args[0];
		// grab args[1] and conver to int then store into a var named lo
		int lo=Integer.parseInt(args[1]);
		// grab args[2] and conver to int then store into a var named hi
		int hi=Integer.parseInt(args[2]);
		// STEP #1: OPEN THE INPUT FILE AND COMPUTE THE MIN AND MAX. NO OUTPUT STATMENTS ALLOWED
		Scanner infile = new Scanner( new File(infileName) );
		int min,max,currentNum;
		min=max=infile.nextInt(); // WE ASSUME INPUT FILE HAS AT LEAST ONE VALUE
		while ( infile.hasNextInt() )
		{
			currentNum=infile.nextInt();
			if(currentNum>max)
				max=currentNum;
			else if(currentNum<min) //Only check if the number is not the max
				min=currentNum;
		}
		System.out.format("min: %d max: %d\n",min,max); // DO NOT REMOVE OR MODIFY IN ANY WAY


		// STEP #2: DO NOT MODIFY THE REST OF MAIN. USE THIS CODE AS IS 
		// WE ARE TESTING EVERY NUMBER BETWEEN LO AND HI INCLUSIVE FOR
		// BEING PRIME AND/OR BEING PERFECT 
		for ( int i=lo ; i<=hi ; ++i)
		{
			System.out.print( i );
			if ( isPrime(i) ) System.out.print( " prime ");
			if ( isPerfect(i) ) System.out.print( " perfect ");
			System.out.println();
		}
	} // END MAIN
	
	// *************** YOU FILL IN THE METHODS BELOW **********************
	
	// RETURNs true if and only if the number passed in is perfect
	static boolean isPerfect( int n )
	{	
		int sum=0,remainder,max=n/2; //max is the highest multiple that is needed to be checked
		int mult; //checks every multiple
		boolean status=false; //method will return false by default
		
		for(mult=1;mult<=max;mult++)
		{
			remainder=n%mult;
			if (remainder==0) //if the remainder is 0, mult is a multiple of n
				sum=sum+mult;
		}
		
		if (sum==n && n!=1) //if sum of multiples is equal to n, set status =to true
		{
			status=true;
		}
		
		return status;
	}
	// RETURNs true if and only if the number passed in is prime
	static boolean isPrime( int n )
	{	
		boolean status=false;
		int remainder, max=(int)Math.sqrt(n), sum=0;
		int mult, even=n%2;
	
		//if the number is even, no need to check for primality
		if(even==0 && n!=2)
			status=false;
		else
		{
			for(mult=1;mult<=max;mult++)
			{
				remainder=n%mult;
				if (remainder==0) //if the remainder is 0, mult is a multiple of n
					sum=sum+mult;
			}
			
			if (sum==1 && n!=1) //if sum = 1 then there are no multiples of n other than 1
				status=true;
		}
		
		
		return status; 
	}
} // END Lab2 CLASS











