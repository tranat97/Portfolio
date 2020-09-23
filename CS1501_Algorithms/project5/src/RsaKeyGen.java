import java.util.*;
import java.io.*;
import java.nio.file.*;
/**
 *
 * @author trana
 */
public class RsaKeyGen {
    public static void main (String args[]) {
        //Path outfile = Paths.get("pubkey.rsa");
        Random rnd = new Random();
        LargeInteger p = new LargeInteger(256, rnd);
        p.print();
        System.out.println(p.length());
        LargeInteger q = new LargeInteger(256, rnd);
        System.out.println("q");
        LargeInteger n = p.multiply(q);
        System.out.println("n");
        System.out.println(n.length());
        LargeInteger phi = (p.subtract(new LargeInteger((byte)0x01))).multiply(q.subtract(new LargeInteger((byte)0x01)));
        System.out.println("phi");
        LargeInteger e = new LargeInteger(new byte[] {(byte)0xff, (byte)0xff});//3 and 65537 are commonly used e values (3 is just easier to use)
        e = e.add(new LargeInteger((byte)0x02));
        System.out.println("e");
        LargeInteger[] gcd = phi.XGCD(e); //gcd[2] = d
        System.out.println("d");
        
        FileOutputStream stream = null;
        FileInputStream in = null;
        try{
            stream = new FileOutputStream("pubkey.rsa");
            stream.write(n.getVal());
        } catch(FileNotFoundException t) {}
        catch(IOException s){}
    }
}
