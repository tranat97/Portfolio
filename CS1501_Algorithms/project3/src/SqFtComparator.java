import java.util.*;
public class SqFtComparator implements Comparator<Apartment> {
    @Override
    public int compare(Apartment a1, Apartment a2){
        return a1.getSqFt() - a2.getSqFt();
    }
}
