
public class MyString
{
	private char[] letters;
	
	public MyString( String other )
	{	
		letters=new char[other.length()];
		for (int i=0;i < other.length(); i++)
			letters[i]=other.charAt(i);
		
	}
	public MyString( MyString other )
	{	
		letters=new char[other.length()];
		for (int i=0;i < other.length();i++)
			letters[i]=other.charAt(i);
	}	
	public int length()
	{
		return letters.length;
	}
	public char charAt(int index)
	{
		return letters[index];
	}
	int compareTo(MyString other)
	{
		for (int i=0;i<other.length() && i<this.length();i++)
		{
			if(this.charAt(i)-other.charAt(i)<0)
				return -1;
			if(this.charAt(i)-other.charAt(i)>0)
				return 1;
		}
		
		if (this.length()<other.length())
			return -1;
		if (this.length()>other.length())
			return 1;
		
		return 0; //no differences
	}	
	public boolean equals(MyString other)
	{
		if (this.compareTo(other)==0)
			return true;
		return false;
	}
	public int indexOf(int ch)	
	{
		return -1;	
	}
	public int indexOf(MyString other)
	{
		for (int i=0;i+other.length()-1<this.length();i++)
		{
			int j =i;
			for (int k=0;k<other.length();k++)
			{
				if (this.charAt(j++)-other.charAt(k)!=0)
					break;
				return i; //only returns if all chars match
			}
		}
		return -1; //if all tests fail return -1
	}
	public String toString()
	{
		String s ="";
		for (int i=0;i<length();i++)
			s+=charAt(i);
		return s;
	}
} // END MYSTRING CLASS
