
import java.util.*;

public class Heap {
    
    int DEFAULT_SIZE = 10, n;
    Apartment[] pq;
    HashMap<String, Integer> index;
    Comparator com;

    public Heap(Comparator c) { 
        pq = new Apartment[DEFAULT_SIZE];
        index = new HashMap<String, Integer>();
        n = 0;
        com = c;
    } 
    
    public void insert(Apartment x) {
        // double size of array if necessary
        if (n == pq.length) resize(2 * pq.length);

        // add x, and percolate it up to maintain heap invariant
        pq[n] = x;
        index.put(x.getKey(), n);
        swim(n++);
    }
    
    public Apartment remove(String key) {
        if (index.containsKey(key))
            return remove(index.get(key));
        return null;
    }
    
    public Apartment get(String key) {
        return pq[index.get(key.toLowerCase())];
    }
    public Apartment top() {
        return pq[0];
    }
    
    public boolean contains(String key) {
        return index.containsKey(key);
    }
    
    public Apartment update(String key, int newPrice) {
        if (contains(key)) {
            Apartment x = get(key);
            x.updatePrice(newPrice);
            sink(index.get(key));
            swim(index.get(key));
            
            return x;   
        }
        return null;
    }
    
    public String toString() {
        String output = "";
        for (int i = 0; i<n; i++)
            output = output + pq[i].getKey() + "\n";
        return output;
    }

   /***************************************************************************
    * Helper functions to restore the heap invariant.
    ***************************************************************************/
    
    private Apartment remove(int i) {
        
        Apartment removal = pq[i];
        exch(i, --n);
        System.out.println("i = "+i);
        swim(i);
        sink(i);
        return removal;
    }
    
    private void swim(int x) {
        while (x > 0 && compare(x, (x-1)/2, com)) {
            exch(x, (x-1)/2);
            x = (x-1)/2;
        }
    }
    
    private void sink(int x){
        int child = 2*x+1;
        
        while (child < n) {
            if (child+1 < n && compare(child+1, child, com)) {
                child += 1;
            }
            if (compare(child, x, com))
                exch(x, child);
            else
                break;
            x = child;
            child = 2*x+1;
        }
        
    }
    
    //returns true if pq[i] has higher priority than pq[j]
    private boolean compare(int i, int j, Comparator com) {
        return com.compare(pq[i], pq[j]) > 0;
    }

    private void exch(int i, int j) {
        index.replace(pq[j].getKey(), i);
        index.replace(pq[i].getKey(), j);
        Apartment swap = pq[i];
        pq[i] = pq[j];
        pq[j] = swap;
    }
    
    private void resize(int capacity) {
        assert capacity > n;
        Apartment[] temp = new Apartment[capacity];
        for (int i = 1; i <= n; i++) {
            temp[i] = pq[i];
        }
        pq = temp;
    }

}