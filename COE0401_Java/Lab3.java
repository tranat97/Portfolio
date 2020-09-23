/* Lab3.java  InsertInOrder */

import java.util.*;
import java.io.*;

public class Lab3
{
	static final int INITIAL_CAPACITY = 5;

	public static void main( String args[] ) throws Exception
	{
		// ALWAYS TEST FOR REQUIRED INPUT FILE NAME ON THE COMMAND LINE
		if (args.length < 1 )
		{
			System.out.println("\nusage: C:\\> java Lab3 L3input.txt\n");
			System.exit(0);
		}
		// LOAD FILE INTO ARR USING INSERINORDER

		Scanner infile =  new Scanner( new File( args[0] ) );
		int[] arr = new int[INITIAL_CAPACITY];
		int count= 0;
		while (infile.hasNextInt())
		{
			int nextNum=infile.nextInt();
			if ( count == arr.length ) arr = upSize( arr );
			insertInOrder( arr, count, nextNum );
			++count; // WE JUST ADDED A VALUE - UP THE COUNT
		}
		infile.close();
		printArray( "SORTED ARRAY: ", arr, count );

	} // END MAIN
	// ################################################################

	// USE AS IS - DO NOT MODIFY
	static void printArray( String caption, int[] arr, int count  )
	{
		System.out.print( caption );
		for( int i=0 ; i<count ;++i )
			System.out.print(arr[i] + " " );
		System.out.println();
	}

	// YOU WRITE THIS METHOD - DO NOT MODIFY THIS FILE ANYWHERE ELSE
	// ################################################################
	static void insertInOrder( int[] arr, int count, int key   )
	{
		// YOUR CODE HERE
		int i=count;
		while (i>=0)
		{
			if(i==0) //check if i=0 (it is the first number or is < every other number currently in the array)
			{
				arr[i]=key;
				break;
			}
			else if(key<arr[i-1]) 
			{
				arr[i]=arr[i-1]; //copies value to next index up
				i--;
			}
			else //arr[i]=key when a number less than key is found
			{
				arr[i]=key;
				break;
			}	

		}
		
	}
	static int[] upSize( int[] fullArr )
	{
		// YOUR CODE HERE
		int newLength=fullArr.length+1;
        int[] newArr = new int[newLength];
         
        for(int i=0;i<fullArr.length;i++)
        {
            newArr[i]=fullArr[i];
        }
		return newArr; // CHANGE TO YOUR RETURN STATEMENT
	}
} // END LAB3