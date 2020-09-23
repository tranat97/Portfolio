import java.util.*;
import java.io.*;

public class midterm
{
	public static void main(String args[])
	{
		Scanner inFile=null;
		try
		{
			inFile = new Scanner(new File("test.txt"));
		}
		catch(FileNotFoundException e)
		{
			
		}
		int depth = inFile.nextInt();
		int [] triangle = new int[depth*(depth +1)/2];
		for (int i=0;inFile.hasNext();i++)
			triangle[i] = inFile.nextInt();
		
		printTriangle(triangle,depth);
		
		int min = triangle[0];
		int k=0;
		for(int row=1; row<=depth;row++)
			for(int j=1;j<=row;j++)
				min = createTriangles(min, triangle, k++, depth, row);
			
		
		System.out.println("min = "+min);
		
		
		
		
	}
	
	public static void printTriangle(int[] triangle,int n)
	{
		int k =0;
		for(int i=0;i<n;i++)
		{
			for (int j=0;j<=i;j++)
				System.out.print(triangle[k++]+" ");
			System.out.println();
		}

	}
	
	public static int createTriangles(int min, int[] triangle,int start, int depth, int row)
	{
		int sum = triangle[start];
		if(sum<min)
			min=sum;
		//System.out.println("start = "+triangle[start]+ " , row = "+row);
		int k=1;
		for (int y=row;y<depth;y++)
		{
			for (int x=0;x<=k;x++)
			{
				//System.out.print(triangle[start+x+y]+" ");
				sum += triangle[start+x+y];
			}
			start+=y;
			k++;
			//System.out.println();
			if(sum<min)
				min=sum;
		}
		return min;
	}
	
	
	
	
	
	
	
}