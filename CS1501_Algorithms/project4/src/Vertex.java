/**
 *
 * @author tranat
 */
public class Vertex {
    private int data;
    private Vertex next;
    
    public Vertex(int n) {
        this(n, null);
    }
    
    public Vertex(int n, Vertex neighbor) {
        data = n;
        next = neighbor;
    }
    
    public void setNext(Vertex neighbor) {
        next = neighbor;
    }
    
    public Vertex getNext() {
        return next;
    }
    
    public int get() {
        return data;
    }
    
    @Override
    public String toString() {
        String s = "";
        s += data;
        if (next != null) {
            s += " -> "+ next.toString();
        }
        return s;
    }
}
