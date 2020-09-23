import java.util.*;
public class PriceComparator  implements Comparator<Apartment>{
    @Override
    public int compare(Apartment a1, Apartment a2){
        return a2.getPrice() - a1.getPrice();
    }
}
