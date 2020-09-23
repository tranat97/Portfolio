/*
	Exercise2.java

	- requires you to try/catch recovery from a format mismatch error
*/
import java.io.*;
import java.util.*;

public class Exercise2
{
	public static class OutOfRangeException extends Exception
	{
		public OutOfRangeException()
		{}
		
		public OutOfRangeException(Throwable t)
		{
			super(t);
		}
		public OutOfRangeException(String s)
		{
			super(s);
		}
		
	}
	
	public static void main( String args[] )
	{
		boolean success=false;
		do
		{
			try
			{
				Scanner kbd = new Scanner(System.in);
				System.out.print("Enter a number between 1 and 100 ");
				int n = kbd.nextInt();
				if (n<1 || n>100)
				{
					throw new OutOfRangeException("Must be in 1...100");
				}
				success = true;
				System.out.printf("You entered %d\n", n );
			}
			catch (InputMismatchException ime)
			{
				System.out.println("Input not a number. Try again.");
			}
			catch (OutOfRangeException oore)
			{
				System.out.println("Out of Range Exception. Must be in 1...100");
			}
		} while (!success);

	} //END main

} //EOF