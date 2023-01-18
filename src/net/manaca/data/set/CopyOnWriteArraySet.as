//Source file: D:\\Wersling WAS Framework\\javacode\\net\\manaca\\util\\set\\CopyOnWriteArraySet.java

//package net.manaca.data.set;

import net.manaca.data.Collection;
import net.manaca.data.Iterator;
import net.manaca.data.set.AbstractSet;

/**
 * 对其所有操作使用 CopyOnWriteArrayList 的 Set。因此，它共享以下相同的基本属性： 
 * 
 * 它最适合于 set 大小通常保持很小、只读操作远多于可变操作以及需要在遍历期间防止线程间冲突的应用程序。 
 * 它是线程安全的。 
 * 因为通常需要复制整个基础数组，所以可变操作（添加、设置、移除，等等）的开销巨大。 
 * 迭代器不支持可变移除操作。 
 * 使用迭代器进行遍历的速度很快，并且不会与其他线程发生冲突。在构造迭代器时，迭代器依赖于不变的数组快照。 @author Wersling
 * @version 1.0
 */
class net.manaca.data.set.CopyOnWriteArraySet extends AbstractSet 
{
	
	/**
	 * @roseuid 4382EC4D0290
	 */
	public function CopyOnWriteArraySet() 
	{
		
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4382EC4D02BF
	 */
	public function Add(o:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4382EC4D032C
	 */
	public function remove(o:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @param c
	 * @return Boolean
	 * @roseuid 4382EC4D03A9
	 */
	public function containsAll(c:Collection) : Boolean
	{
		return null;
	}
	
	/**
	 * @param c
	 * @return Boolean
	 * @roseuid 4382EC4E003E
	 */
	public function addAll(c:Collection) : Boolean
	{
		return null;
	}
	
	/**
	 * @param c
	 * @return Boolean
	 * @roseuid 4382EC4E00BB
	 */
	public function removeAll(c:Collection) : Boolean
	{
		return null;
	}
	
	/**
	 * @param c
	 * @return Boolean
	 * @roseuid 4382EC4E0157
	 */
	public function retainAll(c:Collection) : Boolean
	{
		return null;
	}
	
	/**
	 * @return Void
	 * @roseuid 4382EC4E01E4
	 */
	public function clear() : Void
	{
		//return null;
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4382EC4E0213
	 */
	public function equals(o:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @return Boolean
	 * @roseuid 4382EC4E029F
	 */
	public function isEmpty() : Boolean
	{
		return null;
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 4382EC4E02CE
	 */
	public function contains(o:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @return Iterator
	 * @roseuid 4382EC4E036A
	 */
	public function iterator() : Iterator
	{
		return null;
	}
	
	/**
	 * @return Number
	 * @roseuid 4382EDBA0213
	 */
	public function size() : Number
	{
		return null;
	}
	
	/**
	 * @return Array
	 * @roseuid 4382EDBA0232
	 */
	public function toArray() : Array
	{
		return null;
	}
	
	/**
	 * @param o
	 * @return Boolean
	 * @roseuid 43847B9901A5
	 */
	public function offer(o:Object) : Boolean
	{
		return null;
	}
	
	/**
	 * @return Object
	 * @roseuid 43847B9901F3
	 */
	public function poll() : Object
	{
		return null;
	}
	
	/**
	 * @return Object
	 * @roseuid 43847B990213
	 */
	public function peek() : Object
	{
		return null;
	}
}
