
public class Page 
{
    
    private int tag; //page number
    private int count; //when the last time this page was accessed
    // private double start;
    private boolean dirty; //dirty bit
    private boolean referenced; // R bit

    public Page (int hexAddress, int time) 
    {
        tag = hexAddress;
        // start = startTime;
        dirty = false;
        referenced = false;
        count = time; 
    }

    public int getTag() 
    {
        return tag;
    }

    public boolean isDirty() 
    {
        return dirty;
    }

    public void setDirty()
    {
        dirty = true;
    }

    public boolean isReferenced()
    {
        return referenced;
    }

    public void reference(int time)
    {
        referenced = true;
        count = time; //update t value
    }

    public void dereference()
    {
        referenced = false;
    }

    public double getCount() 
    {
        return count;
    }

}