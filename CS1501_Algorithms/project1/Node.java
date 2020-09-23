import java.io.*;
import java.util.*;
class Node <T> 
{
	private T data;
	private Node<T> nextNode;
	private Node<T> neighbor;
	int freq;
	
	//Constructors
	public Node()
	{
		this (null);
	}
	
	public Node(T newData)
	{
		this (newData, null, null,0);
		
	}
	
	public Node(T newData, int f)
	{
		this (newData, null, null,f);
	}
	
	public Node(T newData, Node<T> down, Node<T> side, int f)
	{
		data = newData;
		nextNode = down;
		neighbor = side;
		freq = f;
	}
	//End Constructors
	
	public T getData() 
	{
        return data;
    } // end getData
	
	public void setData(T newData) 
	{
        data = newData;
    } // end setData

    public Node<T> getNext() 
	{
        return nextNode;
    } // end getNext

    public void setNext(Node<T> down) 
	{
        nextNode = down;
    } // end setNext

    public boolean hasNext() 
	{
        return nextNode != null;
    } // end hasNext

    public Node<T> getNeighbor() 
	{
        return neighbor;
    } // end getNeighbor

    public void setNeighbor(Node<T> side) 
	{
        neighbor = side;
    } // end setNeighbor

    public boolean hasNeighbor() 
	{
        return neighbor != null;
    } // end hasNeighbor
	
	public void addFreq()
	{
		freq++;
	} // end addFreq
	
	public int getFreq()
	{
		return freq;
	} // end getFreq
	
	public void setFreq(int f)
	{
		freq = f;
	}
	
	
}