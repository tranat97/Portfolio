import java.util.Random;
import java.math.BigInteger;
//NOTES: DIVISION BY REPEATED SUBTRACTION TO FIND MOD AND Q
public class LargeInteger {
	
	private final byte[] ONE = {(byte) 1};

	private byte[] val;

	/**
	 * Construct the LargeInteger from a given byte array
	 * @param b the byte array that this LargeInteger should represent
	 */
	public LargeInteger(byte[] b) {
		val = b;
	}
        public LargeInteger(byte b) {
		val = new byte[1];
                val[0] = b;
	}
        
        //deep copy
        public LargeInteger(LargeInteger copy) {
            val = new byte[copy.length()];
            byte[] temp = copy.getVal();
            for(int i=0;i<copy.length();i++) {
                val[i]=temp[i];
            }
        }

	/**
	 * Construct the LargeInteger by generatin a random n-bit number that is
	 * probably prime (2^-100 chance of being composite).
	 * @param n the bitlength of the requested integer
	 * @param rnd instance of java.util.Random to use in prime generation
	 */
	public LargeInteger(int n, Random rnd) {
		val = BigInteger.probablePrime(n, rnd).toByteArray();
	}
	
	/**
	 * Return this LargeInteger's val
	 * @return val
	 */
	public byte[] getVal() {
		return val;
	}

	/**
	 * Return the number of bytes in val
	 * @return length of the val byte array
	 */
	public int length() {
		return val.length;
	}

	/** 
	 * Add a new byte as the most significant in this
	 * @param extension the byte to place as most significant
	 */
	public void extend(byte extension) {
		byte[] newv = new byte[val.length + 1];
		newv[0] = extension;
		for (int i = 0; i < val.length; i++) {
			newv[i + 1] = val[i];
		}
		val = newv;
	}

	/**
	 * If this is negative, most significant bit will be 1 meaning most 
	 * significant byte will be a negative signed number
	 * @return true if this is negative, false if positive
	 */
	public boolean isNegative() {
		return (val[0] < 0);
	}

	/**
	 * Computes the sum of this and other
	 * @param other the other LargeInteger to sum with this
	 */
	public LargeInteger add(LargeInteger other) {
		byte[] a, b;
		// If operands are of different sizes, put larger first ...
		if (val.length < other.length()) {
			a = other.getVal();
			b = val;
		}
		else {
			a = val;
			b = other.getVal();
		}

		// ... and normalize size for convenience
		if (b.length < a.length) {
			int diff = a.length - b.length;

			byte pad = (byte) 0;
			if (b[0] < 0) {
				pad = (byte) 0xFF;
			}

			byte[] newb = new byte[a.length];
			for (int i = 0; i < diff; i++) {
				newb[i] = pad;
			}

			for (int i = 0; i < b.length; i++) {
				newb[i + diff] = b[i];
			}

			b = newb;
		}

		// Actually compute the add
		int carry = 0;
		byte[] res = new byte[a.length];
		for (int i = a.length - 1; i >= 0; i--) {
			// Be sure to bitmask so that cast of negative bytes does not
			//  introduce spurious 1 bits into result of cast
			carry = ((int) a[i] & 0xFF) + ((int) b[i] & 0xFF) + carry;

			// Assign to next byte
			res[i] = (byte) (carry & 0xFF);

			// Carry remainder over to next byte (always want to shift in 0s)
			carry = carry >>> 8;
		}

		LargeInteger res_li = new LargeInteger(res);
	
		// If both operands are positive, magnitude could increase as a result
		//  of addition
		if (!this.isNegative() && !other.isNegative()) {
			// If we have either a leftover carry value or we used the last
			//  bit in the most significant byte, we need to extend the result
			if (res_li.isNegative()) {
				res_li.extend((byte) carry);
			}
		}
		// Magnitude could also increase if both operands are negative
		else if (this.isNegative() && other.isNegative()) {
			if (!res_li.isNegative()) {
				res_li.extend((byte) 0xFF);
			}
		}

		// Note that result will always be the same size as biggest input
		//  (e.g., -127 + 128 will use 2 bytes to store the result value 1)
		return res_li;
	}

	/**
	 * Negate val using two's complement representation
	 * @return negation of this
	 */
	public LargeInteger negate() {
		byte[] neg = new byte[val.length];
		int offset = 0;

		// Check to ensure we can represent negation in same length
		//  (e.g., -128 can be represented in 8 bits using two's 
		//  complement, +128 requires 9)
		if (val[0] == (byte) 0x80) { // 0x80 is 10000000
			boolean needs_ex = true;
			for (int i = 1; i < val.length; i++) {
				if (val[i] != (byte) 0) {
					needs_ex = false;
					break;
				}
			}
			// if first byte is 0x80 and all others are 0, must extend
			if (needs_ex) {
				neg = new byte[val.length + 1];
				neg[0] = (byte) 0;
				offset = 1;
			}
		}

		// flip all bits
		for (int i  = 0; i < val.length; i++) {
			neg[i + offset] = (byte) ~val[i];
		}

		LargeInteger neg_li = new LargeInteger(neg);
	
		// add 1 to complete two's complement negation
		return neg_li.add(new LargeInteger(ONE));
	}

	/**
	 * Implement subtraction as simply negation and addition
	 * @param other LargeInteger to subtract from this
	 * @return difference of this and other
	 */
	public LargeInteger subtract(LargeInteger other) {
		return this.add(other.negate());
	}

	/**
	 * Compute the product of this and other
	 * @param other LargeInteger to multiply by this
	 * @return product of this and other
	 */
	public LargeInteger multiply(LargeInteger other) { 
            LargeInteger sum = new LargeInteger((byte)0x00);
            LargeInteger partial;
            int result;
            byte x[]=other.getVal();
            int shiftAmnt = other.length()+val.length-2;
            for (int i=0; i<other.length(); i++) {
                for (int j=0; j<val.length; j++) {
                    result = ((int)x[i] & 0xFF) * ((int)val[j] & 0xFF);
                    //System.out.println(result);
                    partial = new LargeInteger((byte)result);
                    result = result >> 8;
                    partial.extend((byte)result);
                    if((byte)result < 0)
                        partial.extend((byte)0x00); //pad with zeroes to keep value positive
                    partial.shiftLeft(shiftAmnt-j);
                    sum = sum.add(partial);
                }
                shiftAmnt--;
            }
            //sum.cut();
            return sum;
	}
        
        //results[0] = quotient, results[1] = remainder(mod)
        public LargeInteger[] divide(LargeInteger other) {
            LargeInteger quotient = new LargeInteger((byte)0x00);
            LargeInteger remainder = new LargeInteger(other);
            LargeInteger a = new LargeInteger(this);
            LargeInteger temp = new LargeInteger((byte)0x00);
            
            while(!temp.isNegative()) {
                temp = a.subtract(remainder);
                if (!temp.isNegative()) {
                    quotient=quotient.add(new LargeInteger((byte)0x01));
                    a = new LargeInteger(temp);
                } else {
                    remainder = new LargeInteger(a);
                    //remainder.cut();
                }
            }
            
            return new LargeInteger[] {quotient, remainder};
        }
        
        public LargeInteger mod(LargeInteger other) {
            LargeInteger[] temp = divide(other);
            return temp[1];
        }
        
        public LargeInteger quotient(LargeInteger other) {
            LargeInteger[] temp = divide(other);
            return temp[0];
        }
	
	/**
	 * Run the extended Euclidean algorithm on this and other
	 * @param other another LargeInteger
	 * @return an array structured as follows:
	 *   0:  the GCD of this and other
	 *   1:  a valid x value
	 *   2:  a valid y value
	 * such that this * x + other * y == GCD in index 0
	 */
	 public LargeInteger[] XGCD(LargeInteger other) {
            if(other.zero()) {
                return new LargeInteger[] {this, new LargeInteger((byte)0x01), new LargeInteger((byte)0x00)};
            }
            LargeInteger[] division = this.divide(other);
            LargeInteger[] results = other.XGCD(division[1]);
            LargeInteger gcd = results[0];
            LargeInteger x = results[2];
            LargeInteger y = results[1].subtract((division[0]).multiply(x));
            return new LargeInteger[] {gcd, x, y};
	 }

	 /**
	  * Compute the result of raising this to the power of y mod n
	  * @param y exponent to raise this to
	  * @param n modulus value to use
	  * @return this^y mod n
	  */
	 public LargeInteger modularExp(LargeInteger y, LargeInteger n) {
		LargeInteger exp = new LargeInteger(y);
                LargeInteger partial = new LargeInteger((byte)0x01);
                
                if (!exp.isNegative()) {
                    while (!exp.zero()) {
                        partial = (partial.multiply(this)).mod(n);
                        exp = exp.subtract(new LargeInteger((byte)0x01));
                    }
                } else {
                    return this;
                }
		return partial;
	 }
         
         private boolean zero() {
             for(byte b:val)
                 if (b!=0) return false;
             
             return true;
         }
         
         private void shiftLeft(int amount) {
             if (amount > 0) {
                byte temp[] = new byte[val.length+amount];
                int i;
                for(i=0;i<val.length;i++) {
                    temp[i]=val[i];
                }
                for(int j=0;j<amount;j++) {
                    temp[i]=(byte)0x00;
                }
                val = temp;
             }
         }
         
         private void cut() {
             int i=0;
             while (val[i]==0 && i<val.length-1) {
                 i++;
             }
             byte temp[] = new byte[val.length-i];
             for(int j=0;i<val.length;j++,i++)
                 temp[j] = val[i];
             val = temp;
         }
         
         public void print() {
             for(byte b:val) {
                 System.out.format("%x", b);
             }
             System.out.println();
         }
}
