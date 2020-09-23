import java.util.*;
import java.io.*;

public class Lab4
{
	//static final int initial_capacity = 5;
	
	public static void main(String args[]) throws Exception
	{
		if (args.length < 1 )
		{
			System.out.println("\nusage: C:\\> java Lab4 jumbles.txt\n");
			System.exit(0);
		}
		
		Scanner infile = new Scanner( new File(args[0]) );
		//initialize array lists
		ArrayList<String> original = new ArrayList<String>();
		ArrayList<String> newList = new ArrayList<String>();
		
		//Fill array list
		while (infile.hasNext())
			original.add(infile.next());
		//sort array
		Collections.sort(original);
		
		//call method to convert jumbled letters into canonical form
		int last = original.size();
		for (int i=0; i<last;i++)
		{
			String unordered = original.get(i);
			newList.add(canonical(unordered));
		}
		
		//print array lists
		printArray(original, newList, last);
	}
	
	static String canonical(String unordered)
	{
		char[] ordered; 
		ordered=unordered.toCharArray();//change the jumbled words(string) to a char array
		Arrays.sort(ordered); //sort the char array
		return new String(ordered);
	}
	
	//Prints both jumbled letters and canonical form
	static void printArray(ArrayList<String> original, ArrayList<String> newList, int last)
	{
		for (int i=0; i<last;i++)
		{
			System.out.print(original.get(i));
			System.out.println("  "+ newList.get(i));
		}
	}
	
}