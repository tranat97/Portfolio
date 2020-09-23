import java.io.*;
import java.util.*;
import java.nio.file.*;

public class ac_test 
{
		public static void main (String args[])
		{
			Node<Character> dictionary = new Node<Character>();
			Node<Character> history = new Node<Character>();
			Scanner scanner = new Scanner(System.in);
			double startTime, finalTime, averageTime = 0;
			int numRuns=0;
			StringBuilder word = new StringBuilder(); 
			String input = "";
			ArrayList<FreqString> suggestions = new ArrayList<FreqString>();
			boolean done = false, valid;
			
			//Create the dictionary DLB
			BufferedReader reader = null;
			try
			{
				reader = new BufferedReader(new FileReader("dictionary.txt"));
				System.out.println("\"dictionary.txt\" found");
			}
			catch (FileNotFoundException e)
			{
				System.out.println("\"dictionary.txt\" not found");
			}
			dictionary = buildTrie(reader);
			
			try
			{
				reader = new BufferedReader(new FileReader("user_history.txt"));
				System.out.println("\"user_history.txt\" found");
			}
			catch (FileNotFoundException e)
			{
				System.out.println("\"user_history.txt\" not found");
			}
			history = buildTrie(reader);
			
			System.out.println("\nKey:\n($): Add current word into user history\n(@): Reset inputs\n(!): Exit program\n");
			
			//Start
			while (!done)
			{
				int numSug = 0;
				//ask for user input
				do
				{
					//reset values;
					valid = true;
					
					System.out.print("Enter character: " + word.toString());
					input = scanner.next();
					
					switch(input)
					{
						case "1":
						case "2":
						case "3":
						case "4":
						case "5":
							
							try
							{
								word = new StringBuilder((suggestions.get(Integer.parseInt(input)-1)).toString());
								System.out.println("\nWORD COMPLETED: "+ word.toString() +"\n");
								addToTrie(history, word.toString()+"$");
								word = new StringBuilder();
							}
							catch (IndexOutOfBoundsException e)
							{
								System.out.println("Invalid input");
								valid = false;
							}
							break;
						case "!": //exit
							done = true;
							break;
						case "$": //finish
							System.out.println("\nWORD COMPLETED: "+ word.toString() +"\n");
						
							addToTrie(history, word.toString()+"$"); 
							word = new StringBuilder();
							break;
						case "@": //reset
							System.out.println("Reset: entry NOT added to user history\n");
							word = new StringBuilder();
							break;
						default:
							if(input.length() !=1)
							{
								System.out.println("Only input 1 character at a time");
								valid = false;
								break;
							}
						
							suggestions.clear();
							word = word.append(input);
							//Make suggestions
							startTime = System.nanoTime();
							suggest(find(history, word.toString()), word, suggestions);
							if(suggestions.size() < 5)
								suggest(find(dictionary, word.toString()), word, suggestions);
							finalTime = System.nanoTime() - startTime;
							System.out.printf("\n(%.6f s)\n",(finalTime*Math.pow(10,-9)));
							averageTime = (averageTime + finalTime) / ++numRuns;
							
							if(suggestions.size() == 0)
								System.out.print("No suggestions found.");
							else
							{
								Collections.sort(suggestions, new FreqStringComparator());
								int i=0;
								while (i < suggestions.size() && i < 5)
									System.out.print("("+ (i+1) +") "+ suggestions.get(i++) +"     ");
							}
							System.out.println();
							
							break;
					}
				
				}while(!valid);
				
			}
			System.out.printf("\nAverage Time: %.6f s\n",(averageTime*Math.pow(10,-9)));
			
			//Write user history to file
			try
			{
				Files.write(Paths.get("user_history.txt"), (toString(history, new StringBuilder())).getBytes());
			}
			catch(IOException e){}
		}
		
		//buildTree creates the DLBTrie given the txt file and returns the root of the trie
		private static Node<Character> buildTrie (BufferedReader dict)
		{
			Node<Character> root = new Node<Character>();
			String word = null;
			try
			{
				while (dict.ready())
				{
					word = dict.readLine() + "$";
					addToTrie(root, word);
				}
			}
			catch(IOException e)
			{
				System.out.print("Dictionary error");
				System.exit(0);
			}
			
			return root;
		}
		
		//word being added must be in char[] form and assumes the '$' terminating character is included
		private static void addToTrie(Node<Character> currentNode, String input)
		{
			char[] word = input.toCharArray();
			int i = 0;
			while (i<word.length)
			{
				if (currentNode.getData() == null)
				{
					currentNode.setData(word[i]);
				}
				if ((currentNode.getData()).equals(word[i]))
				{
					currentNode.addFreq();
					if(!currentNode.hasNext() && !(currentNode.getData()).equals('$'))
						currentNode.setNext(new Node<Character>());
					currentNode = currentNode.getNext();
					i++;
				}
				else //current node is not equal 
				{
					if (!currentNode.hasNeighbor())
						currentNode.setNeighbor(new Node<Character>());
					currentNode = currentNode.getNeighbor();
				}
				
				
			}
		}
		
		//Print entire DLB (for testing)
		private static String toString(Node<Character> currentNode, StringBuilder word)
		{
			String s = "";
			if((currentNode.getData()).equals('$'))
			{
				for(int i=0; i<currentNode.getFreq(); i++)
					s = s + word.toString() + "\n";
			}
			
			else
			{
				word = word.append(currentNode.getData());
				s = s + toString(currentNode.getNext(), word);
				word = word.deleteCharAt(word.length()-1);
			}
			if(currentNode.hasNeighbor())
				s = s + toString(currentNode.getNeighbor(), word);
			return s;
		}
		
		
		private static void suggest(Node<Character> currentNode, StringBuilder word, ArrayList<FreqString> suggestions)
		{
			if(currentNode.getData() != null)
			{
				if((currentNode.getData()).equals('$'))
				{
					if (!suggestions.contains(new FreqString(word.toString())))
						suggestions.add(new FreqString(word.toString(),currentNode.getFreq()));
				}
				else
				{
					word = word.append(currentNode.getData());
					suggest(currentNode.getNext(), word, suggestions);
					word = word.deleteCharAt(word.length()-1);
				}
				if(currentNode.hasNeighbor())
					suggest(currentNode.getNeighbor(), word, suggestions);
			}
		}
		
		//finds if the prefix is included in the DLB
		private static Node<Character> find(Node<Character> currentNode, String target)
		{
			char[] prefix = target.toCharArray();
			int i = 0;
			while (i < prefix.length && currentNode.getData() != null)
			{
				if ((currentNode.getData()).equals(prefix[i]))
				{
					if(currentNode.hasNext())
						currentNode = currentNode.getNext();
					i++;
				}
				else
				{
					if (!currentNode.hasNeighbor())
					{
						return new Node<Character>();
					}
					currentNode = currentNode.getNeighbor();
				}
			}
			return currentNode;
		}
}