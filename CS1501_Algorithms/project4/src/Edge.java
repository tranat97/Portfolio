/**
 *
 * @author tranat
 * Symmetric edges
 */

public class Edge {
    private static final double FLOATING_POINT_EPSILON = 1E-10;
    private int from;
    private int to;
    private double capacity;
    private double flow;
    private int length;
    private String medium;
    private double latency;
    private Edge next;
    
    public Edge (int a, int b, String med, int bw, int len) {
        from = a;
        to = b;
        medium = med;
        capacity = (double)bw;
        flow = 0.0;
        length = len;
        //latency = len;
        if(med.equals("copper")) {
            latency = (double)len/230000000*1000000000;
        }else {
            latency = (double)len/200000000*1000000000;
        }
        next = null;
    }
    
    public void setBandwidth(int bw) {
        capacity = bw;
    }
    
    public void setLength(int len) {
        length = len;
    }
    
    public void setNext(Edge neighbor) {
        next = neighbor;
    }
    
    public int to() {
        return to;
    }
    
    public int from() {
        return from;
    }
    
    public double capacity() {
        return capacity;
    }
    
    public int length() {
        return length;
    }
    
    public String medium() {
        return medium;
    }
    
    public double latency() {
        return latency;
    }
    
    public Edge next() {
        return next;
    }
    
    public double flow() {
        return flow;
    }
    
    
    public double residualCapacity() {
        return capacity-flow;
    }
    
    public void addResidualFlow(double delta) {
        if (!(delta >= 0.0)) throw new IllegalArgumentException("Delta must be nonnegative");

        flow += delta;

        // round flow to 0 or capacity if within floating-point precision
        if (Math.abs(flow) <= FLOATING_POINT_EPSILON)
            flow = 0;
        if (Math.abs(flow - capacity) <= FLOATING_POINT_EPSILON)
            flow = capacity;

        if (!(flow >= 0.0))      throw new IllegalArgumentException("Flow is negative");
        if (!(flow <= capacity)) throw new IllegalArgumentException("Flow exceeds capacity");
    }


    
    @Override
    public String toString() {
        return ("<"+from+", "+to+", "+medium+", "+capacity+", "+length+">");
    }
}
    
