import java.io.*;
import java.util.*;
public class Exercise1
{
	public static void main( String args[] )
	{
		if (args.length < 1)
		{
			System.out.println("\nYou must enter an input filename on cmd line!\n");
			System.exit(0);
		}
		String infileName = args[0];
		boolean found = false;
		Scanner infile =null;
		do
		{
			try
			{
				infile = new  Scanner ( new File( infileName) );
				found = true;
			}
			catch (FileNotFoundException fnf)
			{
				Scanner tryagain = new Scanner(System.in);
				System.out.print("=(\tEnter a valid file name: ");
				infileName = tryagain.next();
			}
		} while (!found);
		
		int tokenCnt=0;
		while (infile.hasNext())
		{
			String token = infile.next(); // read a string from infile
			System.out.printf("%d: %s\n", tokenCnt++, token);
		}

	}
} //End class