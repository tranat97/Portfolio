// Demonstrates JPanel, GridLayout and a few additional useful graphical features.
// adapted from an example by john ramirez (cs prof univ pgh)
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import java.util.*;
import java.io.*;

public class SimpleCalc
{
	JFrame window;  // the main window which contains everything
	Container content ;
	JButton[] digits = new JButton[12]; 
	JButton[] ops = new JButton[4];
	JTextField expression;
	JButton equals;
	JTextField result;
	
	
	public SimpleCalc()
	{
		window = new JFrame( "Simple Calc");
		window.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		content = window.getContentPane();
		content.setLayout(new GridLayout(2,1)); // 2 row, 1 col
		ButtonListener listener = new ButtonListener();
		
		// top panel holds expression field, equals sign and result field  
		// [4+3/2-(5/3.5)+3]  =   [3.456]
		
		JPanel topPanel = new JPanel();
		topPanel.setLayout(new GridLayout(1,3)); // 1 row, 3 col
		
		expression = new JTextField();
		expression.setFont(new Font("verdana", Font.BOLD, 16));
		expression.setText("");
		
		equals = new JButton("=");
		equals.setFont(new Font("verdana", Font.BOLD, 20 ));
		equals.addActionListener( listener ); 
		
		result = new JTextField();
		result.setFont(new Font("verdana", Font.BOLD, 16));
		result.setText("");
		
		topPanel.add(expression);
		topPanel.add(equals);
		topPanel.add(result);
						
		// bottom panel holds the digit buttons in the left sub panel and the operators in the right sub panel
		JPanel bottomPanel = new JPanel();
		bottomPanel.setLayout(new GridLayout(1,2)); // 1 row, 2 col
	
		JPanel  digitsPanel = new JPanel();
		digitsPanel.setLayout(new GridLayout(4,3));	
		
		for (int i=0 ; i<10 ; i++ )
		{
			digits[i] = new JButton( ""+i );
			digitsPanel.add( digits[i] );
			digits[i].addActionListener( listener ); 
		}
		digits[10] = new JButton( "C" );
		digitsPanel.add( digits[10] );
		digits[10].addActionListener( listener ); 

		digits[11] = new JButton( "CE" );
		digitsPanel.add( digits[11] );
		digits[11].addActionListener( listener ); 		
	
		JPanel opsPanel = new JPanel();
		opsPanel.setLayout(new GridLayout(4,1));
		String[] opCodes = { "+", "-", "*", "/" };
		for (int i=0 ; i<4 ; i++ )
		{
			ops[i] = new JButton( opCodes[i] );
			opsPanel.add( ops[i] );
			ops[i].addActionListener( listener ); 
		}
		bottomPanel.add( digitsPanel );
		bottomPanel.add( opsPanel );
		
		content.add( topPanel );
		content.add( bottomPanel );
	
		window.setSize( 640,480);
		window.setVisible( true );
	}

	// We are again using an inner class here so that we can access
	// components from within the listener.  Note the different ways
	// of getting the int counts into the String of the label
	
	class ButtonListener implements ActionListener
	{
		public void actionPerformed(ActionEvent e)
		{
			Component whichButton = (Component) e.getSource();
			// how to test for which button?
			// this is why our widgets are 'global' class members
			// so we can refer to them in here
			
			for (int i=0 ; i<10 ; i++ )
				if (whichButton == digits[i])
					expression.setText( expression.getText() + i );
					
			if(whichButton==digits[10])
				expression.setText("");
			
			if(whichButton==digits[11])
			{
				String s=expression.getText();
				char c[]= s.toCharArray();
				s="";
				for (int i=0;i<c.length-1;i++)
					s+=c[i];
				expression.setText(s);
			}
			
			if(whichButton==ops[0])
				expression.setText( expression.getText() + "+" );
			if(whichButton==ops[1])
				expression.setText( expression.getText() + "-" );
			if(whichButton==ops[2])
				expression.setText( expression.getText() + "*" );
			if(whichButton==ops[3])
				expression.setText( expression.getText() + "/" );
			
			if (whichButton==equals)
			{
				result.setText("");
				String expr=expression.getText(); 
				ArrayList<String> operatorList = new ArrayList<String>();
				ArrayList<String> operandList = new ArrayList<String>();
				// StringTokenizer is like an infile and calling .hasNext()
				StringTokenizer st = new StringTokenizer( expr,"+-*/", true );
				while (st.hasMoreTokens())
				{
					String token = st.nextToken();
					if ("+-/*".contains(token))
						operatorList.add(token);
					else
						operandList.add(token);
				}
				
				//check that there are less operators than operands
				if (operatorList.size()<operandList.size())
				{
					while (operatorList.contains("*") || operatorList.contains("/"))
					{
						int index = operatorList.indexOf("*");
						if (index<0) //no * was found, find /
							index = operatorList.indexOf("/");
						String s = operatorList.get(index);
						double n1 = Double.parseDouble(operandList.get(index));
						double n2 = Double.parseDouble(operandList.get(index+1));
						if (s.compareTo("*")==0)
						{
							operandList.add(index, ""+(n1*n2));
							operatorList.remove("*");
						}
						
						else
						{
							operandList.add(index, ""+(n1/n2));
							operatorList.remove("/");
						}
						operandList.remove(index+1);
						operandList.remove(index+1);
					}
					
					//switch all - to + a negative
					while (operatorList.contains("-"))
					{
						int index = operatorList.indexOf("-");
						operatorList.add(index, "+");
						operatorList.remove(index+1);
						
						double n = Double.parseDouble(operandList.get(index+1));
						operandList.add(index+1, ""+(n*-1));
						operandList.remove(index+2);
					}
					
					while (operatorList.contains("+"))
					{
						int index = operatorList.indexOf("+");
						double n1 = Double.parseDouble(operandList.get(index));
						double n2 = Double.parseDouble(operandList.get(index+1));
						operandList.add(index, ""+(n1+n2));
						
						operatorList.remove(index);
						operandList.remove(index+1);
						operandList.remove(index+1);
					}
					
					result.setText(operandList.get(0));
				}
				
				else
				{
					result.setText("ERROR");
				}
			}
		}
			
	}

	public static void main(String [] args)
	{
		new SimpleCalc();
	}
}
