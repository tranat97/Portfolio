import java.io.*;
import java.util.*;

public class Project4
{
	public static void main( String[] args ) throws Exception
	{
		BufferedReader infile1 = new BufferedReader( new FileReader(args[0]) );
		BufferedReader infile2 = new BufferedReader( new FileReader(args[1]) );
		
		ArrayList<String> dictionary = new ArrayList<String>();
		ArrayList<String> canDict = new ArrayList<String>();
		ArrayList<String> jumbles = new ArrayList<String>();
		ArrayList<String> canJumbles = new ArrayList<String>();
		ArrayList<String> temp = new ArrayList<String>();
		
		//Fill array lists/ make ordered parallel lists
		while (infile1.ready())
			dictionary.add(infile1.readLine());
		paraList(dictionary, temp);
		Collections.sort(temp);
		split(dictionary, canDict, temp);
		
		while (infile2.ready())
			jumbles.add(infile2.readLine());
		paraList(jumbles, temp);
		Collections.sort(temp);
		split(jumbles, canJumbles, temp);
		
		//reduce dictionary array into answer array
		int i=0;
		String answer="";
		while (i+1<dictionary.size())
		{
			String can1=canDict.get(i);
			String can2=canDict.get(i+1);
			if (can1.compareTo(can2)==0)
			{
				String str=dictionary.get(i+1);
				dictionary.remove(i+1); //remove after the value is copied
				canDict.remove(i+1);
				answer=answer+" "+str;
			}
			else
			{
				String str=dictionary.get(i);
				dictionary.set(i++,str+answer);
				answer="";
			}
		}
		
		i=0;
		for (String s:canJumbles)
		{
			int index=bSearch(s, canDict);
			if(index>=0)
			{
				String str1=jumbles.get(i);
				String str2=dictionary.get(index);
				jumbles.set(i, str1+" "+str2);
			}
			i++;
		}
		Collections.sort(jumbles);
		printArray(jumbles);
	}
	
	static String canonical(String unordered)
	{
		char[] ordered; 
		ordered=unordered.toCharArray();//change the jumbled words(string) to a char array
		Arrays.sort(ordered); //sort the char array
		return new String(ordered);
	}
	
	//Prints both jumbled letters and canonical form
	static void printArray(ArrayList<String> arr)
	{
		for (String s: arr )
			System.out.println(s);
	}
	
	static void paraList(ArrayList<String> original, ArrayList<String> withCan)
	{
		for(String s: original) //making parallel lists
		{
			String canonical=canonical(s);
			withCan.add(canonical+" "+s); //concatenate word with canonical version
		}
	}
	
	static void split(ArrayList<String> original,ArrayList<String> canonical, ArrayList<String> temp)
	{
		original.clear();
		//split list into 2 lists
		for (String s:temp)
		{
			String[] split = s.split(" ");
			original.add(split[1]);
			canonical.add(split[0]);
		}
		temp.clear();
	}
	
	static int bSearch(String canJumbles, ArrayList<String> canDict)
    {
        int lo=0, hi=canDict.size()-1, mid=0;
		
        while ( lo <= hi )
        {
            mid =lo+(hi-lo)/2;
			String dict=canDict.get(mid);
            if(canJumbles.compareTo(dict)<0)
            {
                hi=mid-1;
            }
            else if (canJumbles.compareTo(dict)>0)
            {
                lo=mid+1;
            }
            else
            {
                return mid;
            }
        }
		return -(lo-1);
    }
	
}