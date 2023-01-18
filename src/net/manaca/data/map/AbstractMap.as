import net.manaca.lang.BObject;
//Source file: D:\\Wersling WAS Framework\\javacode\\net\\manaca\\util\\AbstractMap.java

//package net.manaca.data;


/**
 * 此类提供了 Map 接口的骨干实现，从而最大限度地减少了实现此接口所需的工作。
 * 
 * 要实现不可修改的映射，程序员只需扩展此类并提供 entrySet 方法的实现即可，该方法将返回映射的映射关系 Set 视图。
 * 通常，返回的 Set 将依次在 AbstractSet 上实现。此 Set 不支持 add 或 remove 方法，其迭代器也不支持 remove 方法。
 * 
 * 要实现可修改的映射，程序员还必须另外重写此类的 put 方法（否则将抛出 UnsupportedOperationException），
 * 并且由 entrySet().iterator() 所返回的迭代器必须另外实现其 remove 方法。
 * 
 * 按照 Map 接口规范中的推荐，程序员通常应该提供一个 void（无参数）构造方法和 map 构造方法。
 * 
 * 此类中每个非抽象方法的文档详细描述了其实现。如果要实现的映射允许更有效的实现，则可以重写这些方法中的每个方法。
 */
class net.manaca.data.map.AbstractMap extends BObject
{
	
	/**
	 * @roseuid 4386ABAA0387
	 */
	private function AbstractMap() 
	{
		super();
	}
	/**
	 * 将传入的对象中的键与值导入到这个MAP中来。
	 * @param source 传入的对象
	 */
	private function populate(source):Void {
		if (source) {
			for (var i:String in source) {
				this["put"](i, source[i]);
			}
		}
	}
}
