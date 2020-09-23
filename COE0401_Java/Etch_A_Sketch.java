import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class Etch_A_Sketch implements MouseListener, MouseMotionListener  // NOTE multiple interfaces
{
	JFrame window;
	Container content;
	int mouseX,mouseY,oldX,oldY;
	JButton colors;
	Graphics g;
	Color c=Color.black;

	public Etch_A_Sketch()
	{
		JFrame window = new JFrame("Classic Etch a Sketch");
		window.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		content = window.getContentPane();
		content.setLayout( new FlowLayout() );
		colors = new JButton("Click to change colors.");
		colors.setFont(new Font("TimesRoman", Font.ITALIC + Font.BOLD, 32));
		content.add(colors); 
		
		myListener repaint = new myListener();
		colors.addActionListener(repaint);
		
		content.addMouseListener(this);        // "this" is the class that implements that listener
		content.addMouseMotionListener(this);  // "this" is the class that implements that listener
		window.setSize(640,480);
		window.setVisible(true);
	}
	// ..............................................................
	// IMPLEMENTING MOUSELISTENER REQUIRES YOU TO WRITE (OVER-RIDE) THESE METHODS 

	public void actionPerformed(ActionEvent e)
	{
			
	}
	//when you press & release with NO MOVEMENT while pressed
	public void mouseClicked( MouseEvent me)
	{
		mouseX = me.getX();
		mouseY = me.getY();
		
		
	}
	
	// when you press 
	public void mousePressed( MouseEvent me)
	{
		mouseX = me.getX();
		mouseY = me.getY();
		
	}

	//when you let release after dragging
	public void mouseReleased( MouseEvent me)
	{
		mouseX = me.getX();
		mouseY = me.getY();
	}

	// the mouse just moved off of the JFrame
	public void mouseExited( MouseEvent me)
	{
		mouseX = me.getX();
		mouseY = me.getY();
	}
	
	// the mouse just moved onto the JFrame
	public void mouseEntered( MouseEvent me)
	{
		mouseX = me.getX();
		mouseY = me.getY();
	}
	// ...............................................................
	// IMPLEMENTING MOUSEMOTIONLISTENER REQUIRES YOU WRITE (OVER-RIDE) THESE METHODS 

	// mouse is moving while pressed
	public void mouseDragged( MouseEvent me)
	{
		mouseX = me.getX();
		mouseY = me.getY();

		if (oldX ==0 )
		{
			oldX=mouseX;
			oldY=mouseY;
			return;
		}
		
		// draw  dot (actually small line segment) between old (x,y) and current (x,y)
		
		g = content.getGraphics(); // use g to draw onto the pane
		change();
		g.drawLine( oldX,oldY, mouseX, mouseY );
		oldX = mouseX;
		oldY = mouseY;
	}
	
	// moved mouse but not pressed
	public void mouseMoved( MouseEvent me)
	{
		mouseX = me.getX();
		mouseY = me.getY();
	}
	
	class myListener implements ActionListener
	{
		Color[] theColors= {Color.black, Color.red, Color.green, Color.blue};
		int i = 0;
		
		public void actionPerformed (ActionEvent e)
		{
			i = (i+1)%theColors.length;
			c = theColors[i];
		}
	}

	// ..............................................................

	public static void main( String[] args)
	{
		new Etch_A_Sketch();
	}
	
	private void change()
	{
		g.setColor(c);
	}
}//EOF