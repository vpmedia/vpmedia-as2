import net.manaca.data.Iterator;
//Source file: D:\\Wersling WAS Framework\\javacode\\was\\lang\\Iterable.java

//package was.lang;



/**
 * 实现这个接口允许对象成为 "foreach" 语句的目标。
 * @author Wersling
 * @version 1.0
 */
interface net.manaca.lang.Iterable 
{
	
	/**
	 * 返回一个在一组元素上进行迭代的迭代器。
	 * 返回：
	 * 一个迭代器。
	 * @return was.util.Iterator
	 * @roseuid 43806454034B
	 */
	public function iterator() : Iterator;
}
