import java.util.Comparator;

public class FreqStringComparator implements Comparator<FreqString>
{
	@Override
	public int compare(FreqString s1, FreqString s2)
	{
		return s2.getFreq() - s1.getFreq();
	}
}