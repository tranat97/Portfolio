import java.nio.*;
public class main {

    public static void main(String[] args) {
        byte[] a = {(byte)0x00, (byte)0x0d};
        byte[] b = {(byte)0x01, (byte)0xf1};
        LargeInteger x = new LargeInteger(a);
        LargeInteger y = new LargeInteger(b);
        LargeInteger c = new LargeInteger((byte)0x04);
        x.print();
        y.print();
        
        LargeInteger sum = x.mod(y);
        sum.print();
        
//        LargeInteger[] sum = x.XGCD(y);
//        sum[0].print();
//        sum[1].print();
//        sum[2].print();

        c.modularExp(x, y).print();
    }
    
}
