import java.io.*;
import java.util.*;

// DO NOT!! IMPORT JAVA.LANG

public class Project9
{
  	// JUST FOR YOUR DEBUGGING - DLETE THIS METHOD AND ALL CLASS FOR HANDIN 
	// ----------------------------------------------------------------
	private static void printSwamp(String label, int[][] swamp )
	{
		System.out.println( label );
		System.out.print("   ");
		for(int c = 0; c < swamp.length; c++)
			System.out.print( c + " " ) ;
		System.out.print( "\n   ");
		for(int c = 0; c < swamp.length; c++)
			System.out.print("- ");
		System.out.print( "\n");

		for(int r = 0; r < swamp.length; r++)
		{	System.out.print( r + "| ");
			for(int c = 0; c < swamp[r].length; c++)
				System.out.print( swamp[r][c] + " ");
			System.out.println("|");
		}
		System.out.print( "   ");
		for(int c = 0; c < swamp.length; c++)
			System.out.print("- ");
		System.out.print( "\n");
	}
	// --YOU-- WRITE THIS METHOD (LOOK AT PRINTSWAMP FOR CLUES)
   	// ----------------------------------------------------------------
	private static int[][] loadSwamp( String infileName, int[] dropInPt  ) throws Exception
	{
		File file = new File (infileName);
		Scanner infile = new Scanner(file);
		int size = infile.nextInt();
		int swamp[][] = new int[size][size];
		dropInPt[0]= infile.nextInt(); dropInPt[1]= infile.nextInt();
		
		while(infile.hasNextInt())
			for (int r=0;r<size;r++)
				for (int c=0; c<size;c++)
					swamp[r][c]=infile.nextInt();
				
		infile.close();
		return swamp;
	}

	public static void main(String[] args) throws Exception
	{
		int[] dropInPt = new int[2]; 
		int[][] swamp = loadSwamp( args[0], dropInPt );
		int row=dropInPt[0], col = dropInPt[1];		
		String path= ""; 
		depthFirstSearch( swamp, row, col, path );
	} // END MAIN

	static void depthFirstSearch( int[][] swamp, int r, int c, String path )
	{
		swamp[r][c]=swamp[r][c]*-1;
		path=path+"["+r+","+c+"]";
		if (r==0 || c==0 || r==swamp.length-1 || c==swamp.length-1)
		{
			System.out.println(path);
			path.replace("["+r+","+c+"]", "");
			swamp[r][c]= swamp[r][c]*-1;
			return;
		}
		
		for (int i=r+1;i>=r-1;i--)
			for (int j=c-1;j<=c+1;j++)
				if (swamp[i][j]>0)
					depthFirstSearch(swamp, i, j, path);

		path.replace("["+r+","+c+"]", "");
		swamp[r][c]= swamp[r][c]*-1;
		return;	
		
	} // END DFS
}



