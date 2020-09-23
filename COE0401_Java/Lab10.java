import java.io.*;
import java.util.*;

public class Lab10
{
	public static void main(String[] args) throws Exception
	{
		BufferedReader big = new BufferedReader(new FileReader(args[0]));
		HashSet<String> text = new HashSet<String>();
		while (big.ready())
		{
			if (text.add(big.readLine())==false)
			{
				System.out.println("NOT UNIQUE");
				System.exit(0);
			}
		}
		System.out.println("UNIQUE");
	}
}