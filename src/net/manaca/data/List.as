import net.manaca.data.Collection;

//Source file: D:\\Wersling WAS Framework\\javacode\\was\\util\\List.java

//package was.util;


/**
 * 个异常，也可能成功，这取决于实现的选择。此接口的规范中将这样的异常标记为“可选”
 * 。 
 * @author Wersling
 * @version 1.0
 */
interface net.manaca.data.List extends Collection 
{
	/**
    * 在列表的指定位置插入指定元素（可选操作）。将当前处于该位置的元素（如果有的话）和
    * 所有后续元素向右移动（在其索引中加 1）。
    * @param o - 要插入的元素。
    * @param index - 要在其位置插入指定元素的索引。
    * @return Boolean 如果原数据改变,则返回true
    * @roseuid 43847B16031C
    */
	public function addIn(o:Object, index:Number):Boolean;
	/**
	 * 返回列表中指定位置的元素。
	 * @param index - 要返回的元素的索引。
	 * @return Object 
	 * @roseuid 4384445B001F
	 */
	public function Get(index:Number) : Object;
	
	/**
	 * 用指定元素替换列表中指定位置的元素（可选操作）。
	 * @param index - 要替换的元素的索引。
	 * @param element - 要在指定位置存储的元素。
	 * @return Object 以前在指定位置的元素。
	 * @roseuid 4384449D01D4
	 */
	public function Set(index:Number,element:Object) : Object;
	
	/**
	 * 返回列表中首次出现指定元素的索引，或者如果列表不包含此元素，则返回 -1。
	 * @param o - 要搜索的元素。
	 * @return Number
	 * @roseuid 438445B80399
	 */
	public function indexOf(o:Object) : Number;
	
	/**
	 * -1。更正式地说，返回满足下面条件的最高索引 i：(o==null ? get(i)==null 
	 * :o.equals(get(i)))，或者如果没有这样的索引，则返回 -1。
	 * @param o - 要搜索的元素。
	 * @return Number
	 * @roseuid 438445E4009C
	 */
	public function lastIndexOf(o:Object) : Number;
}
