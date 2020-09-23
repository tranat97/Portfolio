// Lab1.java     STARTER FILE

import java.io.*; // I/O
import java.util.*; // Scanner class

public class Lab1
{
	public static void main( String args[] ) throws Exception
	{
		final double MILES_PER_MARATHON = 26.21875; // i.e 26 miles 285 yards

		Scanner kbd = new Scanner (System.in);
		double aveMPH=0, aveMinsPerMile=0, aveSecsPerMile=0; // YOU CALCULATE THESE BASED ON ABOVE INPUTS
		System.out.print("Enter marathon time in hrs minutes seconds: "); // i.e. 3 49 37
		// DO NOT WRITE OR MODIFY ANYTHING ABOVE THIS LINE
		
		double hh=kbd.nextDouble();
		double mm=kbd.nextDouble();
		double ss=kbd.nextDouble();
		double hourTotal=0, secTotal=0, mileSec=0;
		
		//Convert all units to hours and find total hours
		hourTotal = hh+(mm/60)+(ss/3600);
		//Calculate aveMPH
		aveMPH=MILES_PER_MARATHON/hourTotal;
		
		//Use hourTotal to calculate secTotal then calculate seconds per mile (mileSec)
		secTotal=hourTotal*3600;
		mileSec=secTotal/MILES_PER_MARATHON;
		
		//convert mileSec to minutes and seconds
		aveMinsPerMile=Math.floor(mileSec/60);
		aveSecsPerMile=mileSec%60;
		
		// DO NOT WRITE OR MODIFY ANYTHING BELOW THIS LINE. LET MY CODE PRINT THE VALUES YOU CALCULATED
		System.out.println();
		System.out.format("Average MPH was: %.2f mph\n", aveMPH  );
		System.out.format("Average mile split was %.0f mins %.1f seconds per mile", aveMinsPerMile, aveSecsPerMile );
		System.out.println();

	} // END MAIN METHOD
} // END LAB1 CLASS