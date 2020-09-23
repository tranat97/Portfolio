import java.io.*;
import java.util.*;

class Boggle
{
	public static void main (String[] args) throws Exception
	{
		BufferedReader dict = new BufferedReader(new FileReader(args[0]));
		Scanner file = new Scanner(new File(args[1]));
		
		HashSet<String> dictionary = new HashSet<String>();
		HashSet<String> prefixes = new HashSet<String>();
		ArrayList<String> words = new ArrayList<String>(); 
		while (dict.ready())
		{
			String s = dict.readLine();
			if (s.length()>2)
			{
				dictionary.add(s);
				StringBuilder builder = new StringBuilder();
				for (int i=0;i<s.length();i++)
				{
					builder.append(s.charAt(i));
					prefixes.add(builder.toString());
				}
			}
		}
		dict.close();
		
		int dim = file.nextInt();
		String[][] board = new String[dim][dim];
		
		while (file.hasNext())
		{
			for (int r=0;r<dim;r++)
				for(int c=0;c<dim;c++)
					board[r][c]=file.next();
				
		}
		
		for (int r=0;r<dim;r++)
			for(int c=0;c<dim;c++)
				DFS(board,"", r, c, prefixes, dictionary, words);
			
		Collections.sort(words);
		for (int i=0;i<words.size();i++)
			System.out.println(words.get(i));
	}
	
	static void DFS(String[][] board, String start, int r, int c, HashSet<String> prefixes, HashSet<String> dictionary, ArrayList<String> words)
	{
		start=start+board[r][c];
		board[r][c]=board[r][c]+"0";
		String marked = board[r][c];
		
		if (prefixes.contains(start))
		{
			if (dictionary.contains(start) && words.contains(start)==false)
				words.add(start);
		}
		else
		{
			board[r][c]=marked.replaceFirst("0","");
			return;
		}
		
		for (int i=r-1;i<=r+1;i++)
			for (int j=c-1;j<=c+1;j++)
				if (i>=0&&i<board.length&&j>=0&&j<board.length)
					DFS(board, start, i, j, prefixes, dictionary, words);
				
		board[r][c]=marked.replaceFirst("0","");
			
	}
}