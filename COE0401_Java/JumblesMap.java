import java.io.*;
import java.util.*;

public class JumblesMap 
{
	public static void main(String args[]) throws Exception
	{
		BufferedReader infile0 = null;
		BufferedReader infile1 = null;
		try 
		{
			infile0 = new BufferedReader(new FileReader(args[0])); //dictionary
			infile1 = new BufferedReader(new FileReader(args[1])); //jumbles
		}
		catch (FileNotFoundException fnfe)
		{
			System.out.println("File not found");
			System.exit(0);
		}
		
		
		HashMap<String,String> key = new HashMap<String, String>();
		TreeMap<String,String> jumbles = new TreeMap<String, String>();
		TreeSet<String> dictionary = new TreeSet<String>();
		
		while (infile0.ready())
			dictionary.add(infile0.readLine());
		infile0.close();
		
		for (String s : dictionary)
		{
			String canonical = canonical(s);
			
			if (!key.containsKey(canonical))
				key.put(canonical, s);
			else
				key.put(canonical,key.get(canonical)+" "+s);
		}
		
		while (infile1.ready())
		{
			String s = infile1.readLine();
			String canonical = canonical(s);
			
			if (!key.containsKey(canonical))
				jumbles.put(s, "");
			else
				jumbles.put(s,key.get(canonical));
		}
		
		for (String s : jumbles.keySet())
		{
			System.out.println(s+" "+jumbles.get(s));
		}
	}
	
	static String canonical(String unordered)
	{
		char[] ordered; 
		ordered=unordered.toCharArray();//change the jumbled words(string) to a char array
		Arrays.sort(ordered); //sort the char array
		return new String(ordered);
	}
	
}