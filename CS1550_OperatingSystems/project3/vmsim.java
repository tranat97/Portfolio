import java.util.*;
import java.io.*;

public class vmsim 
{
    static int PAGE_SIZE = 4096; //4KB
    static BufferedReader buf;
    static Page[] pages; //Page table in memory
    //Summary Statistics
    static int accessCount = 0;
    static int faultCount = 0;
    static int writeCount = 0;

    public static void main (String[] args) 
    {
        String[] algorithms = {"OPT", "LRU", "SECOND"};
        int numFrames = 0;
        int mode = 0; // 0=opt, 1=lru, 2=second chance
        //Error checking
        try {
            buf = new BufferedReader(new FileReader(args[4]));
            for (int i=0; i<4; i=i+2) {
                if (args[i].equals("-n")) {
                    numFrames = Integer.parseInt(args[i+1]);
                } else if (args[i].equals("-a")) {
                    if (args[i+1].toLowerCase().equals("opt")) {
                        mode = 0;
                    } else if (args[i+1].toLowerCase().equals("lru")) {
                        mode = 1;
                    } else if (args[i+1].toLowerCase().equals("second")) {
                        mode = 2;
                    } else {
                        throw new Exception("Invalid mode");
                    }
                } else {
                    throw new Exception("Invalid argument");
                }
            }
        } catch (Exception e) {
            System.out.println(e.toString());
            System.out.println("Usage: java vmsim –n <numframes> -a <opt|lru|second> <tracefile>");
            System.exit(0);
        }

        //_______________________________________________________________________
        //Initialize page frames
        pages = new Page[numFrames];
        
        Hashtable<Integer, LinkedList<Integer>> references = null;
        //initialize the optimal count array if needed
        if(mode == 0) {
            references = optInit(args[4]);
        }

        char op;
        String address; 
        int pageCount = 0;
        int clockStart = 0; //The index the second chance algorithm starts with
        int line=0; //keeps track of which line number the trace file is on
        int pageNum;
        boolean hit;
        // double start = System.currentTimeMillis();
        try{
            while(buf.ready()) {
                //read in operation and address
                accessCount++;
                op = (char)buf.read();
                address = buf.readLine().split("x")[1];
                pageNum = upper(address); //determine the page number that contains the address
                hit = false;

                //only pop from linked list if in opt mode
                if(mode == 0) {
                    references.get(pageNum).pop();
                }

                //go through memory and look for a hit
                for (int i=0; i<pageCount; i++) {
                    //page hit
                    if (pages[i].getTag()==pageNum) {
                        if (op == 's') {
                            pages[i].setDirty(); //set dirty bit if a store operation is called
                        }
                        pages[i].reference(line); //set reference bit
                        hit = true;
                        break;
                    }
                }

                //PAGE FAULT
                if (!hit) {
                    faultCount++;
                    int evict = 0;
                    //if there is still space, add the required page
                    if(pageCount<pages.length) {
                        evict = pageCount++;
                    } else { //full so must evict
                        //Choose a PRA
                        switch(mode) {
                            case 0:
                                evict = optimal(pageNum, references);
                                break;
                            case 1:
                                evict = lru(pageNum);
                                break;
                            case 2:
                                evict = clock(pageNum, clockStart);
                                clockStart = (evict+1)%pages.length; //clock will start on the page after the one that was just added
                                break;
                        }

                        //If the page being evicted is dirty, disk must be written to
                        if (pages[evict].isDirty()) {
                            writeCount++;
                        }
                    }

                    pages[evict] = new Page(pageNum, line);
                    if (op == 's') {
                        pages[evict].setDirty(); //set dirty bit if a store operation is called
                    }
                }
                line++;
            }
        } catch (Exception e){System.out.println("Here: "+e.toString());}


        System.out.println("Algorithm: " + algorithms[mode]);
        System.out.println("Number of frames: " + numFrames);
        System.out.println("Total memory accesses: " + accessCount);
        System.out.println("Total page faults: " + faultCount);
        System.out.println("Total writes to disk: " + writeCount);
    }

    //Page Replacement Algorithms return the index of the page to be replaced
    //Optimal: returns the page number that has the fewest number of future references
    public static int optimal (int pageNum, Hashtable<Integer, LinkedList<Integer>> references) {
        int opt = 0;
        LinkedList<Integer> minList = references.get(pages[0].getTag());
        if (minList.size()==0) { 
            return opt;
        }
        //find the page with the fewest future references
        for (int i=1; i<pages.length; i++) {
            //Which is referenced latest
            LinkedList<Integer> current = references.get(pages[i].getTag());
            if (current.size()==0) {
                return i;
            } else if (current.peek()>minList.peek()) {
                opt = i;
                minList = references.get(pages[opt].getTag());
            }
        }

        return opt;
    }

    //Least Recently Used: Returns the page number that has the lowest count value (the oldest page)
    public static int lru (int pageNum) {
        int oldest = 0;
        //find the page with the lowest count value
        for (int i=1; i<pages.length; i++) {
            if (pages[i].getCount()<pages[oldest].getCount()) {
                oldest = i;
            }
        }
// System.out.println(oldest);
        return oldest;
    }

    //Second Chance
    public static int clock (int pageNum, int start) {
        int i=start;
        while (true) {
            if (pages[i].isReferenced()) {
                pages[i].dereference(); //if the page is referenced, dereference it and continue
            } else { //found a dereferenced page -> return the index
                return i;
            }

            i = (i+1)%pages.length; //continuously loop
        }
    }

    //Returns the upper 20 bits of the address (the page number)
    public static int upper (String fullAddress)
    {
        int add = Integer.parseUnsignedInt(fullAddress, 16)/PAGE_SIZE;
        return add;
    }

    //Initializes a hashtable that contains a key for every possible page number
    //Each page number has an ordered linked list of the lines they are referenced in the trace file
    public static Hashtable<Integer, LinkedList<Integer>> optInit (String fileName) 
    {
        Hashtable<Integer, LinkedList<Integer>> references = new Hashtable<Integer, LinkedList<Integer>>();
        BufferedReader buf = null;
        String address;
        int current;
        Integer lineNum = 0;

        try {
            buf = new BufferedReader(new FileReader(fileName));
            while (buf.ready()) {
                address = buf.readLine().split("x")[1];
                current = upper(address);
                if (references.containsKey(current)) {
                    references.get(current).add(lineNum);
                } else {
                    LinkedList<Integer> temp = new LinkedList<Integer>();
                    temp.add(lineNum);
                    references.put(current, temp);
                }
                lineNum++;
            }
            buf.close();
        } catch (Exception e){e.toString();}
        return references;
    }
}