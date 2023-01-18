//Source file: D:\\Wersling WAS Framework\\javacode\\was\\lang\\IObject.java

//package was.lang;


/**
 * 所有对象实现的接口
 * @author Wersling
 * @version 1.0
 */
interface net.manaca.lang.IObject
{
	
	/**
	 * 创建并返回此对象的一个副本。
	 * @return was.lang.IObject
	 * @roseuid 43844873034B
	 */
	public function clone() : IObject;
	
	/**
	 * 比较指定的对象与列表是否相等。当且仅当指定的对象也是一个列表、两个列表有相同的大小，
	 * 并且两个列表中的所有相应的元素对相等 时才返回 true（ 如果 (e1==null ? e2==null :e1.equals(e2))，
	 * 则两个元素 e1 和 e2 是相等 的）。换句话说，如果两个列表以相同的顺序包含相同的元素，
	 * 则定义它们是相等的。该定义确保了 equals 方法在 List 接口的不同实现间正常工作。 
	 * @param obj - 要与之比较的引用对象。
	 * @return Boolean
	 * @roseuid 43844891004E
	 */
	public function equals(obj:IObject) : Boolean;
	
	/**
	 * 返回一个对象的运行时类。
	 * @return String
	 * @roseuid 43844AA302CE
	 */
	public function getClass() : String;
	
	/**
	 * 返回该对象的哈希代码值。
	 * @return String
	 * @roseuid 43845B5D0176
	 */
	public function hashCode() : String;
}
