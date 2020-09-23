import java.util.*;
import java.io.*;
/**
 * NOTES: USE FORD FULKERSON
 * @author tranat
 */
public class NetworkAnalysis {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        Scanner input=null;
        Scanner scan = new Scanner(System.in);
        Edge[] adjList = null;
        Edge[] copperList = null; //adj list but only contains copper connections
        boolean done = false;
        int to, from, bw, len, N=0, choice=0;
        String med;
        
        try {
            input=new Scanner(new File(args[0]));
            N = input.nextInt();
            adjList = new Edge[N];//create an array of verices
            copperList = new Edge[N];
            while(input.hasNext()) {
                from = input.nextInt();
                to = input.nextInt();
                med = input.next();
                bw = input.nextInt();
                len = input.nextInt();

                //Build adjacency list
                adjList[from] = addEdge(adjList[from], new Edge(from, to, med, bw, len));
                adjList[to] = addEdge(adjList[to], new Edge(to, from, med, bw, len));
                if (med.compareTo("copper")==0) {
                    copperList[from] = addEdge(copperList[from], new Edge(from, to, med, bw, len));
                    copperList[to] = addEdge(copperList[to], new Edge(to, from, med, bw, len));
                }
            }
        }
        catch(FileNotFoundException e) {
            System.out.println("File not found");
            System.exit(0);
        }
        catch(IOException e){
            System.out.println("File formatted incorrectly");
            System.exit(0);
        }

        
        //START MENU
        System.out.println("MENU:");
        System.out.println("0) Show adjacency list.");
        System.out.println("1) Find the lowest latency path between 2 points.");
        System.out.println("2) Determine whether or not the graph is copper-only connected.");
        System.out.println("3) Find maximum amount of data that can be transmitted from one vertex to another.");
        System.out.println("4) Determine whether or not the graph would remain connected if any 2 vertices were to fail.");
        System.out.println("5) Quit.");
        do {
            System.out.print("Please choose an option (0-5): ");
            choice = scan.nextInt();
            System.out.println();
            switch (choice) {
                case 0:                  
                    for(int i=0;i<N;i++) {
                    String s = ""+i;
                    Edge e = adjList[i];
                    while(e!=null) {
                        s += "->"+e.to();
                        e = e.next();
                    }
                    System.out.println(s);
                    }
                    System.out.println();
                    break;
                case 1:
                case 3:
                    int start, end;
                    do {
                        System.out.printf("Starting vertex (0-%d): ", N-1);
                        start = scan.nextInt();
                    }while(start<0 || start>N-1);
                    
                    do {
                        System.out.printf("End vertex (0-%d): ", N-1);
                        end = scan.nextInt();
                    }while(end<0 || end>N-1);
                    
                    if (choice == 1) {
                        Dijkstra path = new Dijkstra(adjList, start);
                        path.printPath(end);
                    } else {
                        FordFulkerson maxBW = new FordFulkerson(adjList, start, end);
                        System.out.printf("Max Bandwidth across the graph: %.0fbits/sec\n",maxBW.max());
                    }
                    break;
                case 2:
                    Dijkstra copper = new Dijkstra(copperList, 0);
                    if (copper.isConnected())
                        System.out.println("The graph is copper-only connected.");
                    else
                        System.out.println("The graph is NOT copper-only connected.");
                    break;
                
                case 4:
                    boolean pair = true;
                    int falseCount = 0;
                    int artPnt = 0;
                    for(int i=0;i<N;i++) {
                        Biconnected b = new Biconnected(adjList, i);
                        pair = b.pairExists();
                        if(!pair) {
                            falseCount++;
                            artPnt = i;                         
                        }
                    }
                    
                    if (falseCount==0)
                        System.out.println("The graph will become disconnected from at least 2 vertex failures.");
                    else if(falseCount==1)
                        System.out.printf("The graph will become disconnected from at least 2 vertex failures. (Articulation point at vertex %d)", artPnt);
                    else
                        System.out.println("There are no 2 vertex failures that will cause the graph to become disconnected.");
                    break;
                case 5:
                    done = true;
                    break;
                default:
                    System.out.println("MENU:");
                    System.out.println("0) Show adjacency list.");
                    System.out.println("1) Find the lowest latency path between 2 points.");
                    System.out.println("2) Determine whether or not the graph is copper-only connected.");
                    System.out.println("3) Find maximum amount of data that can be transmitted from one vertex to another.");
                    System.out.println("4) Determine whether or not the graph would remain connected if any 2 vertices were to fail.");
                    System.out.println("5) Quit.");
                    break;
                    
            }
            System.out.println();
        }while (!done);
    }
    
    //returns first vertex in the list
    public static Edge addEdge(Edge currentEdge, Edge newEdge) {
        Edge first = currentEdge;
        if(currentEdge == null) {
            return newEdge;
        }
        while(currentEdge.next() != null) {
            currentEdge = currentEdge.next();
        }
        currentEdge.setNext(newEdge);
        return first;
    }
     
}
