public class FreqString 
{
	private String s;
	private int freq;
	
	public FreqString()
	{
		this("");
	}
	
	public FreqString(String input)
	{
		this (input, 0);
	}
	
	public FreqString(String input, int n)
	{
		s = input;
		freq = n;
	}
	
	public int getFreq()
	{
		return freq;
	}

	public String toString()
	{
		return s;
	}
	
	@Override
	public boolean equals(Object other)
	{
		return s.equals(((FreqString)other).toString());
	}
	
}