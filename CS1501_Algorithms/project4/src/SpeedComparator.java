import java.util.*;
/**
 *
 * @author trana
 */
public class SpeedComparator implements Comparator<Edge>{
    @Override
    public int compare(Edge a, Edge b) {
        if(b.getLatency()-a.getLatency()>0) {
            return -1;
        }else if(b.getLatency()-a.getLatency()<0) {
            return 1;
        } else {
            return 0;
        }
    }
}
