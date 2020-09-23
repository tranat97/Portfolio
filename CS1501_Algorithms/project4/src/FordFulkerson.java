public class FordFulkerson {
    private final int N;          // number of vertices
    private boolean[] marked;     
    private Edge[] edgeTo;    // edgeTo[v] = last edge on shortest residual s->v path
    private double max;  // current value of max flow
    private int source, sink;
    
    
    public FordFulkerson(Edge[] adj, int s, int t) {
        source = s;
        sink = t;
        N = adj.length;      
        max = 0.0;
        findMax(adj);
    }
    
    public void findMax(Edge[] adj) {
        while(hasAugmentingPath(adj)) {
            double bottle = Double.POSITIVE_INFINITY;
            Edge current = edgeTo[sink];
            do {
                bottle = Math.min(bottle, current.residualCapacity());
                current = edgeTo[current.from()];
            }while (current!=null);
            
            current = edgeTo[sink];
            do {
                current.addResidualFlow(bottle);
                current = edgeTo[current.from()];
            }while (current!=null);
            
            max+=bottle;
        }
        
    }
    
    public double max() {
        return max;
    }
    
    private boolean hasAugmentingPath(Edge[] adj) {
        marked = new boolean[N];
        edgeTo = new Edge[N];
        Queue<Integer> Q = new Queue<Integer>(N);
        Q.push(source);
        marked[source] = true;
        while(!Q.isEmpty() && !marked[sink]) {
            int from = Q.pop();
            Edge current = adj[from];
            while (current != null){
                int to = current.to();
                if(current.residualCapacity()>0 && !marked[to]) {
                    edgeTo[to] = current;
                    marked[to] = true;
                    Q.push(to);
                }
                current = current.next();
            }
        }
        
        return marked[sink];
    }
    
    
}