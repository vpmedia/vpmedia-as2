import net.manaca.lang.IObject;
//Source file: D:\\Wersling WAS Framework\\javacode\\net\\manaca\\util\\IComparator.java

//package net.manaca.data;


/**
 * 提供一个统一的对象比较接口
 * @author Wersling
 * @version 1.0
 */
interface net.manaca.data.IComparator 
{
	//Collection net.manaca.data.theCollection;
	
	/**
	 * 比较对象是否相等。
	 * @param obj1 - 一个对象
	 * @param obj2 - 一个对象
	 * @return Boolean
	 * @roseuid 4386A78000C8
	 */
	public function equals(obj1:IObject,obj2:IObject) : Boolean;
}
