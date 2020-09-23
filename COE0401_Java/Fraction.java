/* Fraction.java  A class (data type) definition file
   This file just defines what a Fraction is
   This file is NOT a program
   ** data members are PRIVATE
   ** method members are PUBLIC
*/
public class Fraction
{
	private int numer;
	private int denom;

	// ACCESSORS
	public int getNumer()
	{
		return numer;
	}
	public int getDenom()
	{
		return denom;
	}
	public String toString()
	{
		return numer + "/" + denom;
	}

	// MUTATORS
	public void setNumer( int n )
	{
		numer = n;
	}
	public void setDenom( int d )
	{
		if (d!=0)
			denom=d;
		else
		{
			System.out.println("Error: denominator = 0");
			System.exit(0);
		}
	}

	// DEFAULT CONSTRUCTOR - no args passed in
	public Fraction(  )
	{
		this( 0, 1 ); // "this" means call a fellow constructor
	}

	// 1 arg CONSTRUCTOR - 1 arg passed in
	// assume user wants whole number
	public Fraction( int n )
	{
		this( n, 1 ); // "this" means call a fellow constructor

	}

	// FULL CONSTRUCTOR - an arg for each class data member
	public Fraction( int n, int d )
	{
		setNumer(n);
		setDenom(d);
		reduce();
	}


	public Fraction( Fraction other )
	{
		this( other.getNumer(), other.getDenom() );
	}

	private void reduce()
	{
		int gcd=getNumer(), rem=getDenom();
		while(rem!=0)
		{
			int temp=rem;
			rem=gcd%rem;
			gcd=temp;
		}
		setNumer(getNumer()/gcd);
		setDenom(getDenom()/gcd);
	
	}

	public Fraction add (Fraction other)
	{
		return new Fraction(other.getDenom()*this.getNumer()+this.getDenom()*other.getNumer(), other.getDenom()*this.getDenom());
	}
	
	public Fraction subtract (Fraction other)
	{
		return new Fraction(other.getDenom()*this.getNumer()-this.getDenom()*other.getNumer(), other.getDenom()*this.getDenom());
	}
	
	public Fraction multiply (Fraction other)
	{
		return new Fraction(this.getNumer()*other.getNumer(), this.getDenom()*other.getDenom());
	}
	
	public Fraction divide (Fraction other)
	{
		return new Fraction(this.getNumer()*other.getDenom(), this.getDenom()*other.getNumer());
	}
	
	public Fraction reciprocal ()
	{
		return new Fraction(getDenom(), getNumer());
	}


}// EOF