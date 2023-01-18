/**
 * @author Barni
 */
interface gugga.common.IComparator 
{
	/**
	 * @return
	 * <pre>1 if aValue1 &gt; aValue2
	 *	-1 if aValue1 &lt; aValue2
	 *	 0 if aValue1 = aValue2</pre>
	 */
	public function compare(aValue1 : Object, aValue2 : Object) : Number;	
}