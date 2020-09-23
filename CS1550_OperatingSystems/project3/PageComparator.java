import java.util.*;
class PageComparator implements Comparator<Page>{
    
    public int compare (Page p1, Page p2)
    {
        if (p1.getCount() == p2.getCount())
            return 0;
        else if (p1.getCount() < p2.getCount())
            return 1;
        else
            return -1;
    }

}