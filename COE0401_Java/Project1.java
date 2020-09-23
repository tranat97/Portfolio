// F16 CS 401 Speeding Ticket Project
// Project1.java Starter File

import java.io.*;
import java.util.*;

public class Project1
{
	public static void main (String args[])
	{
		// Create a scanner to read from keyboard
		Scanner kbd = new Scanner (System.in);

		String firstName="N/A",lastName="N/A";
		int age=0, speedLimit=0, actualSpeed=0, mphOverLimit=0;
		int baseFine=0, underAgeFine=0, zoneFine=0, totalFine=0;
		// DO NOT ADD TO OR MODIFY ABOVE THIS LINE
		
		//Other variables needed
		boolean conZone; //boolean for construction zone
		int fifthMiles=0; //how many 5mph over the speed limit

		//user input and assigning variables
		System.out.print("Enter your first and last name: ");
		firstName=kbd.next();
		lastName=kbd.next();
		
		System.out.print("Your age: ");
		age=kbd.nextInt();
		
		System.out.print("The speed limit: ");
		speedLimit=kbd.nextInt();
		
		System.out.print("Driver's actual speed: ");
		actualSpeed=kbd.nextInt();
		mphOverLimit=actualSpeed-speedLimit;
		
		System.out.print("Did the violation occur in a construction zone? (true/false): ");
		conZone=kbd.nextBoolean();
		
		//count every 5 mph over the speed limit
		fifthMiles=mphOverLimit/5;
		//assigning speeding fines
		if (mphOverLimit>20)
		{
			baseFine=fifthMiles*50;
		}
		else if (mphOverLimit<=20)
		{
			baseFine=fifthMiles*30;
		}
		//do not need statement for <5 because any # <5 would make fifthMiles=0 (all fines=0) anyway
		
		//assign construction zone fine
		if(conZone)
		{
			zoneFine=baseFine;
		}
		
		//check for underage AND over 20mph
		if (age<21 && mphOverLimit>20)
		{
			underAgeFine=300;
		}
		
		//calculate total fine
		totalFine=baseFine+zoneFine+underAgeFine;

		// DO NOT ADD TO OR MODIFY BELOW THIS LINE
		System.out.println("");
		System.out.format( "name: %s, %s\n",lastName,firstName );
		System.out.format( "age: %d yrs.\n",age );
		System.out.format( "actual speed: %d mph.\n",actualSpeed );
		System.out.format( "speed limit: %d mph.\n",speedLimit );
		System.out.format( "mph over limit: %d mph.\n",mphOverLimit );
		System.out.format( "base fine: $%d\n",baseFine );
		System.out.format( "zone fine: $%d\n",zoneFine );
		System.out.format( "under age fine: $%d\n",underAgeFine );
		System.out.format( "total fine: $%d\n",totalFine );
	} // END MAIN
} // END PROJECT1 CLASS