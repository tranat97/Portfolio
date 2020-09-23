/*
	Coin.java THIS IS THE ONLY FILE YOU HAND IN
	THERE IS NO MAIN METHOD IN THIS CLASS!
*/
import java.util.Random;
public class Coin
{
	private Random ht;
	private int side;
	private int hCount=0;
	private int tCount=0;
	
	public Coin(int seed)
	{
		ht=new Random(seed);
	}
	public char flip()
	{
		side=ht.nextInt(2);
		if (side==0)
		{
			tCount++;
			return 'T';
		}
		else
		{
			hCount++;
			return 'H';
		}
			
	}
	
	public int getNumHeads()
	{
		return hCount;
	}
	
	public int getNumTails()
	{
		return tCount;
	}
	
	private void setNumHeads(int num)
	{
		hCount=num;
	}
	
	private void setNumTails(int num)
	{
		tCount=num;
	}
	
	public void reset()
	{
		setNumHeads(0);
		setNumTails(0);
	}
	
	

} // END COIN CLASS