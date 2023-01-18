import net.manaca.data.IComparator;
import net.manaca.lang.IObject;
//Source file: D:\\Wersling WAS Framework\\javacode\\net\\manaca\\util\\ObjectComparator.java

//package net.manaca.data;


/**
 * 实现对象之间的比较
 * @author Wersling
 * @version 1.0
 */
class net.manaca.data.ObjectComparator implements IComparator 
{
	
	/**
	 * @roseuid 4386ACA0028D
	 */
	public function ObjectComparator() 
	{
		
	}
	
	/**
	 * 比较对象是否相等。
	 * @param obj1 - 一个对象
	 * @param obj2 - 一个对象
	 * @return Boolean
	 * @roseuid 4386ACA002AC
	 */
	public function equals(obj1:IObject,obj2:IObject) : Boolean
	{
		return (obj1.getClass() == obj2.hashCode() && obj1 == obj2);
	}
}
