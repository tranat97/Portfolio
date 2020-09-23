/******************************************************************************
 *  Compilation:  javac Biconnected.java
 *  Execution:    java Biconnected V E
 *  Dependencies: Graph.java GraphGenerator.java
 *
 *  Identify articulation points and print them out.
 *  This can be used to decompose a graph into biconnected components.
 *  Runs in O(E + V) time.
 *  Modified by tranat
 ******************************************************************************/

public class Biconnected {
    private int[] low;
    private int[] pre;
    private int cnt;
    private int ignore;
    private boolean[] articulation;

    public Biconnected(Edge[] adj, int ign) {
        int N = adj.length;
        ignore = ign;
        low = new int[N];
        pre = new int[N];
        articulation = new boolean[N];
        for (int v = 0; v < N; v++)
            low[v] = -1;
        for (int v = 0; v < N; v++)
            pre[v] = -1;
        
        for (int v = 0; v < N; v++)
            if (pre[v] == -1 && v!=ignore)
                dfs(adj, v, v);
    }

    private void dfs(Edge[] adj, int u, int v) {
        int children = 0;
        pre[v] = cnt++;
        low[v] = pre[v];
        Edge current = adj[v];
        while (current!=null) {
            int w =current.to();
            if (pre[w] == -1) {
                children++;
                dfs(adj, v, w);

                // update low number
                low[v] = Math.min(low[v], low[w]);

                // non-root of DFS is an articulation point if low[w] >= pre[v]
                if (low[w] >= pre[v] && u != v) 
                    articulation[v] = true;
            }

            // update low number - ignore reverse of edge leading to v
            else if (w != u)
                low[v] = Math.min(low[v], pre[w]);
            current = current.next();
            while(current!= null &&current.to() ==ignore)
                current = current.next();
        }

        // root of DFS is an articulation point if it has more than 1 child
        if (u == v && children > 1)
            articulation[v] = true;
    }

    // is vertex v an articulation point?
    public boolean pairExists() { 
        for(boolean b:articulation)
            if(b) return true;
        return false;  
    }
    
}
