import java.io.*;
import java.util.*;

public class AptTracker {
    
    public static void main(String[] args) {
        Heap allPrice = new Heap(new PriceComparator());
        Heap allSqFt = new Heap(new SqFtComparator());
        HashMap<String, Heap> cityPrice = new HashMap<String, Heap>();
        HashMap<String, Heap> citySqFt = new HashMap<String, Heap>();
        boolean done = false;
        int choice;
        Scanner input = new Scanner(System.in);
        input.useDelimiter("\n");
        String address, num, city, zip, key;
        int price, sqft;
        
        BufferedReader inFile = null;
        try{
            inFile = new BufferedReader(new FileReader(new File("apartments.txt")));
        }
        catch (FileNotFoundException e){}
        
        try {
            inFile.readLine();
            while (inFile.ready()) {
                String apt = inFile.readLine();
                String[] info = apt.split(":");
                Apartment x = new Apartment(info[0], info[1], info[2], info[3], Integer.parseInt(info[4]), Integer.parseInt(info[5]));
                info[2] = info[2].toLowerCase();
                checkCity(info[2], cityPrice, new PriceComparator());
                checkCity(info[2], citySqFt, new SqFtComparator());
                allPrice.insert(x);
                allSqFt.insert(x);
                (cityPrice.get(info[2])).insert(x);
                (citySqFt.get(info[2])).insert(x);
            }
        } catch (IOException e) {}
        
        System.out.println("Welcome to Apartment Tracker!");
            System.out.println("Options:");
            System.out.println("\t1) Add an Apartment");
            System.out.println("\t2) Update an Apartment");
            System.out.println("\t3) Remove an Apartment from consideration");
            System.out.println("\t4) Show the lowest price Apartment");
            System.out.println("\t5) Show the highest square footage Apartment");
            System.out.println("\t6) Show the lowest price Apartment by city");
            System.out.println("\t7) Show the highest square footage Apartment by city");
            System.out.println("\t8) Exit\n\n");
        
        do {
            System.out.print("Please choose an option: ");
            choice = input.nextInt();
            input.nextLine();
            switch (choice) {
                case 1:
                case 2:
                case 3:
                    System.out.print("Street Address: ");
                    address = input.nextLine();
                    
                    System.out.print("Apartment Number: ");
                    num = input.nextLine();
                    
                    System.out.print("City: ");
                    city = input.nextLine();
                    
                    System.out.print("Zip Code: ");
                    zip = input.nextLine();
                    
                    key = address+num+city+zip;
                    if (choice == 1) {
                        if(!allPrice.contains(key)) {
                            System.out.print("Price: ");
                            price = input.nextInt();
                            System.out.print("Square Footage: ");
                            sqft = input.nextInt();
                            
                            Apartment x = new Apartment(address, num, city, zip, price, sqft);
                            city = city.toLowerCase();
                            checkCity(city, cityPrice, new PriceComparator());
                            checkCity(city, citySqFt, new SqFtComparator());
                            allPrice.insert(x);
                            allSqFt.insert(x);
                            (cityPrice.get(city)).insert(x);
                            (citySqFt.get(city)).insert(x);
                        }else {
                            System.out.println("This Apartment has already been added.");
                        }
                        break;
                    }
                    
                    if (choice == 2) {
                        if (allPrice.contains(key)) {
                            System.out.print("Updated price: ");
                            price = input.nextInt();
                            city = city.toLowerCase();
                            checkCity(city, cityPrice, new PriceComparator());
                            checkCity(city, citySqFt, new SqFtComparator());
                            allPrice.update(key, price);
                            allSqFt.update(key, price);
                            (cityPrice.get(city)).update(key, price);
                            (citySqFt.get(city)).update(key, price);
                        }else {
                            System.out.println("This Apartment has not been added yet.");
                        } 
                        break;
                    }
                    
                    if (choice == 3) {
                        allPrice.remove(key);
                        allSqFt.remove(key);
                        if (cityPrice.containsKey(city.toLowerCase())) {
                            (cityPrice.get(city)).remove(key);
                            (citySqFt.get(city)).remove(key);
                        }
                    }
                    break;
                case 4:
                    System.out.println("Apartment with the lowest cost: "+ (allPrice.top()).toString());
                    break;
                case 5:
                    System.out.println("Apartment with the highest square footage: "+ (allSqFt.top()).toString());
                    break;
                case 6:
                    System.out.print("City: ");
                    city = input.nextLine();
                    if (cityPrice.containsKey(city.toLowerCase())) {
                        System.out.println("Apartment with the lowest cost in "+city+": "+ ((cityPrice.get(city.toLowerCase())).top()).toString());
                    } else {
                        System.out.println("There are no Apartments added in "+city);
                    }
                    break;
                case 7:
                    System.out.print("City: ");
                    city = input.nextLine();
                    if (citySqFt.containsKey(city.toLowerCase())) {
                        System.out.println("Apartment with the highest square footage in "+city+": "+ ((citySqFt.get(city.toLowerCase()).top())).toString());
                    } else {
                        System.out.println("There are no Apartments added in "+city);
                    }
                    break;
                case 8:
                    done = true;
                    break;
                default:
                    
            }
        }while (!done);
        
    }
    
    public static void checkCity(String city, HashMap<String, Heap> heap, Comparator com) {
        if(!heap.containsKey(city.toLowerCase())) {
                    heap.put(city, new Heap(com));
         }
    }
    
}
