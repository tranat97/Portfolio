
/**
 *
 * @author trana
 */
public class Dijkstra {
    Edge[] adj;
    int start, N;
    double[] distTo;
    int[] path;
    double [] bw;
    boolean[] visited;
    
    public Dijkstra (Edge[] adjList, int s) {
        adj = adjList;
        start = s;
        N = adj.length;
        distTo = new double[N];
        path = new int[N];
        visited = new boolean[N];
        bw = new double[N];
        for (int i=0; i<N; i++) {
            distTo[i] = Double.POSITIVE_INFINITY;
            path[i] = -1;
            visited[i] = false;
            bw[i] = Integer.MAX_VALUE;
        }
        findPath(start);
    }
    public Dijkstra (Edge[] adjList) {
        this(adjList, 0);
    }
    
    private void findPath(int x) {
        distTo[x] = 0;
        do {
            visited[x] = true;
            Edge current = adj[x];
            double cost = distTo[x];
            while (current != null) {
                if (!visited[current.to()] && cost+current.latency()<distTo[current.to()]) {
                    distTo[current.to()] = cost+current.latency();
                    path[current.to()] = x;
                    if (current.capacity()<bw[current.to()])
                        bw[current.to()] = current.capacity();
                }
                current = current.next();
            }
            x = next();
        }while (x != -1);
        
    }
    
    public void printPath(int end) {
        int cur = end;
        String s = ""+cur;
        while (path[cur]!=-1) {
            s = path[cur]+"->"+s;
            cur = path[cur];
        }
        if (cur == start) {
            System.out.printf("Shortest Path: %s\nLatency: %.2fns\n",s, distTo[end]);
            if (end != start)
                System.out.printf("Max Bandwidth along this path: %.0fbits/sec\n", bw[end]);
            else
                System.out.printf("Max Bandwidth along this path: N/A\n");
        } else {
            System.out.printf("There is no path between %d and %d\n", start, end);
        }
    }
    
    public boolean isConnected() {
        for(double x:distTo) {
            if (x==Double.POSITIVE_INFINITY)
                return false;
        }
        return true;
    }
    
    /*
     * HELPER FUNCTIONS
     */
    //finds next vertex to visit (lowest cost not visited)
    private int next () {
        double min = Double.POSITIVE_INFINITY;
        int target = -1;
        for(int i=0; i<visited.length;i++) {
            if(!visited[i] && distTo[i]<min) {
                min = distTo[i];
                target = i;
            }
        }
        return target;
    }
    
}
