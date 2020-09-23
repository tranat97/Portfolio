
/**
 *
 * @author trana
 */
public class Queue<T> {
    private Object[] Q;
    private int n, max;
    
    public Queue(int size) {
        Q = new Object[size];
        n = 0;
        max = size;
    }
    
    public Queue () {
        this(16);
    }
    
    public void push(T data) {
        if(n==max) resize();
        Q[n++] = data;
    }
    
    public T pop() {
        if(n>0)
            return (T)Q[--n];
        return null;
    }
    
    public boolean isEmpty() {
        return n==0;
    }
    
    private void resize() {
        Object[] temp = new Object[max*2];
        for (int i=0; i<max; i++)
            temp[i] = Q[i];
        Q=temp;
        max = max*2;
    }
}
