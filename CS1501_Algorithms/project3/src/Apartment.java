public class Apartment {
    String address, city, aptNum, zip, key;
    int price, sqft;
    
    public Apartment (String add, String apt, String c, String z, int p, int sf){
        address = add;
        aptNum = apt;
        city = c;
        zip = z;
        price = p;
        sqft = sf;
        key = address+aptNum+city+zip;
        key = key.toLowerCase();
    }
    
    /**
     * 
     * @return address 
     */
    public String getAddress(){
        return address;
    }
    
    /**
     * 
     * @return aptNum
     */
    public String getAptNum (){
        return aptNum;
    }
           
    /**
     * 
     * @return zip
     */
    public String getZip (){
        return zip;
    }
    
    /**
     * 
     * @return price
     */
    public int getPrice (){
        return price;
    }
    
    /**
     * 
     * @return sqft
     */
    public int getSqFt (){
        return sqft;
    }
    
    /**
     * 
     * @return city
     */
    public String getCity (){
        return city;
    }
    
    /**
     * 
     * @return key
     */
    public String getKey (){
        return key;
    }
    
    /**
     * 
     */
    public void updatePrice(int newPrice) {
        price = newPrice;
    }
    
    public String toString() {
        return aptNum+" "+address+", "+city+" "+zip +"($"+price+", "+sqft+"sqft)";
    }
    
}
