import vegas.core.CoreObject;
import vegas.core.IComparable;
import vegas.core.IComparator;
import vegas.errors.ClassCastError;
import vegas.errors.NullPointerError;

/**
 * A Comparator that compares IComparable objects.
 * @author eKameleon
 */
class vegas.util.comparators.ComparableComparator extends CoreObject implements IComparator 
{
	
	/**
	 * Creates a new ComparableComparator instance.
	 * This constructor whose use should be avoided.
	 */
	public function ComparableComparator() 
	{
		super();
	}

	/**
	 * Returns an integer value to compare two objects in parameters.
	 * @param o1 the first object to compare.
	 * @param o2 the second object to compare.
	 * @return <p>
	 * <li>-1 if o1 is "lower" than (less than, before, etc.) o2 ;</li>
	 * <li> 1 if o1 is "higher" than (greater than, after, etc.) o2 ;</li>
	 * <li> 0 if o1 and o2 are equal.</li>
	 * </p>
	 * @throws NullPointerError when the {@code o1} object is {@code null} or {@code undefined}.
	 * @throws ClassCastError it the {@code o1} object is not a {@code IComparable} object.
	 */
	public function compare(o1, o2) : Number 
	{
		if (o1 == null)
		{
			throw new NullPointerError(this + " compare method failed, the o1 object is 'null' or 'undefined'.") ;	
		}
		if ( o1 instanceof IComparable )
		{
			return IComparable(o1).compareTo(o2) ;	
		}
		else
		{
			throw new ClassCastError(this + " compare method failed, the o1 object is not a IComparable object : " + o1) ; 	
		}
	}
	
	/**
	 * Returns the singleton instance of a ComparableComparator.
	 * Developers are encouraged to use the comparator returned from this method instead of constructing a new instance to reduce allocation and GC overhead when multiple comparable comparators may be used in the same application.
	 * @return the singleton instance of a ComparableComparator.
	 */
	static public function getInstance():ComparableComparator
	{
		if (_instance == null)
		{
			_instance = new ComparableComparator() ;
		}
		return _instance ;	
	}

	/**
	 * The internal static singleton of this class.
	 */
	static private var _instance:ComparableComparator ;

}