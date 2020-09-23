import java.io.*;
import java.util.*;

class test
{
	public static void main(String[] args) throws Exception
	{
		BufferedReader dict = new BufferedReader(new FileReader("dictionary1.txt"));
		
		HashSet<String> prefixes = new HashSet<String>();
		while (dict.ready())
		{
			String s = dict.readLine();
			StringBuilder builder = new StringBuilder();
			for (int i=0;i<s.length();i++)
			{
				builder.append(s.charAt(i));
				prefixes.add(builder.toString());
			}
		}
		
		System.out.println(prefixes);
	}
	
}