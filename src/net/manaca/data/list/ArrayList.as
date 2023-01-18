import net.manaca.data.List;
import net.manaca.data.list.AbstractList;
import net.manaca.data.Iterator;
import net.manaca.data.iterator.ListIterator;
//Source file: D:\\Wersling WAS Framework\\javacode\\net\\manaca\\util\\ArrayList.java

//package net.manaca.data;


/**
 * 在添加大量元素前，应用程序可以使用 ensureCapacity 操作来增加 ArrayList 
 * 实例的容量。这可以减少递增式再分配的数量。
 * 
 * @author Wersling
 * @version 1.0
 */
class net.manaca.data.list.ArrayList extends AbstractList implements List
{
	
	/**
	 * @roseuid 4382E7DB037A
	 */
	public function ArrayList(arg:Array) 
	{
		super();
		if (arg) {
			_items = arg.concat();
		} else {
			_items = new Array();
		}
	}
	/** 
	 * 添加一个元素，这里并不保证添加的元素是否非空
	 * @param o - 要添加的元素.
	 * @return Boolean 添加是否成功
	 */
	public function Add(o : Object) : Boolean {
		_items.push(o);
		return true;
	}
	/**
	 * 将数组中的元素转换为字符串、在元素间插入指定的分隔符、连接这些元素然后返回结果字符串。
	 * @param delimiter - 在返回字符串中分隔数组元素的字符或字符串。如果省略此参数，则使用逗号 (,) 作为默认分隔符。
	 * @return String
	 * @roseuid 43851E2503A9
	 */
	public function join(delimiter:String) : String
	{
		return _items.join(delimiter);
	}
	
	/**
	 * 删除数组中最后一个元素，并返回该元素的值。
	 * @return Object
	 * @roseuid 43851E730280
	 */
	public function pop() : Object
	{
		return _items.pop();
	}
	
	/**
	 * 将一个或多个元素添加到数组的结尾，并返回该数组的新长度。
	 * @param o
	 * @return Number
	 * @roseuid 43851EA503B9
	 */
	public function push(o:Object) : Number
	{
		return _items.push(o);
	}
	
	/**
	 * 在当前位置倒转数组。
	 * @return Void
	 * @roseuid 43851EC6005D
	 */
	public function reverse() : Void
	{
		_items.reverse();
	}
	
	/**
	 * 删除数组中第一个元素，并返回该元素。
	 * @return Object
	 * @roseuid 4385214900AB
	 */
	public function shift() : Object
	{
		return _items.shift();
	}
	
	/**
	 * 返回由原始数组中某一范围的元素构成的新数组，而不修改原始数组。
	 * @param startIndex	开始位置
	 * @param endIndex		结束位置
	 * @return ArrayList	由原始数组中某一范围的元素构成的新数组
	 * @roseuid 438521670157
	 */
	public function slice(startIndex:Number, endIndex:Number) : ArrayList
	{
		return new ArrayList(_items.slice(startIndex,endIndex),2,3);
	}
	
	/**
	 * 根据数组中的一个或多个字段对数组中的元素进行排序。数组应具有下列特性： 
	 * 
	 * 该数组是索引数组，不是关联数组。 
	 * 该数组的每个元素都包含一个具有一个或多个属性的对象。 
	 * 所有这些对象都至少有一个公用属性，该属性的值可用于对该数组进行排序。这样的属性称为 field。 
	 * 如果您传递多个 fieldName 参数，则第一个字段表示主排序字段，第二个字段表示下一个排序字段，依此类推。
	 * Flash 根据 Unicode 值排序。（ASCII 是 Unicode 的一个子集。）如果所比较的两个元素中的任何一个不包含在
	 *  fieldName 参数中指定的字段，则认为该字段为 undefined，并且在排序后的数组中不按任何特定顺序连续放置这
	 *  些元素。
	 * 
	 * 默认情况下，Array.sortOn() 按以下方式进行排序：
	 * 
	 * 排序区分大小写（Z 优先于 a）。 
	 * 按升序排序（a 优先于 b）。 
	 * 修改该数组以反映排序顺序；在排序后的数组中不按任何特定顺序连续放置具有相同排序字段的多个元素。 
	 * 数值字段按字符串方式进行排序，因此 100 优先于 99，因为 "1" 的字符串值比 "9" 的低。 
	 * Flash Player 7 添加了 options 参数，您可以使用该参数覆盖默认排序行为。若要对简单数组（例如，仅具有
	 * 一个字段的数组）进行排序，或要指定一种 options 参数不支持的排序顺序，请使用 Array.sort()。
	 * 
	 * 若要传递多个标志，请使用按位"或"(|) 运算符分隔它们
	 * @param fieldName - 一个标识要用作排序值的字段的字符串，或一个数组，其中的第一个元素表示主排序字段，
	 * 第二个元素表示第二排序字段，依此类推。
	 * 
	 * @param options - [可选] - 所定义常数的一个或多个数字或名称，相互之间由 bitwise OR (|) 运算符隔开，
	 * 它们可以更改排序行为。options 参数可接受以下值： 
	 * 
	 * Array.CASEINSENSITIVE 或 1 
	 * Array.DESCENDING 或 2 
	 * Array.UNIQUESORT 或 4 
	 * Array.RETURNINDEXEDARRAY 或 8 
	 * Array.NUMERIC 或 16 
	 * 如果您使用标志的字符串形式（例如，DESCENDING），而不是数字形式 (2)，则启用代码提示。
	 * @return ArrayList 返回值取决于是否传递任何参数： 
	 * 			如果您为 options 参数指定值 4 或 Array.UNIQUESORT，并且要排序的两个或多个元素具有相
	 * 	同的排序字段，则返回值 0 并且不修改数组。 
	 * 			如果为 options 参数指定值 8 或 Array.RETURNINDEXEDARRAY，则返回反映排序结果的数组并且不修改数组。
	 * 			否则，不返回任何结果并修改该数组以反映排序顺序。
	 * @roseuid 438523B003C8
	 */
	public function sortOn(fieldName:Object,options:Object) : ArrayList
	{
		return new ArrayList(_items.sortOn(fieldName,options));
	}
	
	/**
	 * 给数组添加元素以及从数组中删除元素。此方法会修改数组但不制作副本。
	 * @param startIndex - 一个整数，它指定插入或删除动作开始处的数组中元素的索引。
	 * 您可以指定一个负整数来指定相对于数组结尾的位置（例如，-1 是数组的最后一个元素）。
	 * @param deleteCount - [可选] - 一个整数，它指定要删除的元素数量。该数量包括 startIndex 参数中指定的元素。
	 * 如果没有为 deleteCount 参数指定值，则该方法将删除从 startIndex 元素到数组中最后一个元素之间的所有值。
	 * 如果该参数的值为 0，则不删除任何元素。
	 * @param value - [可选] - 指定要在 startIndex 参数中指定的插入点处插入到数组中的值。
	 * 
	 * @return net.manaca.data.list.ArrayList
	 * @roseuid 438524360280
	 */
	public function splice(startIndex:Number,deleteCount:Number,value:Object) : Array
	{
		return _items.splice(startIndex,deleteCount,value);
	}
	
	/**
	 * 将一个或多个元素添加到数组的开头，并返回该数组的新长度。
	 * @param o - 一个或多个要插入到数组开头的数字、元素或变量。
	 * @return Number
	 * @roseuid 438524A501F3
	 */
	public function unshift(o:Object) : Number
	{
		return _items.unshift(o);
	}
	
	public function iterator():Iterator 
	{
		return (new ListIterator(this));
	}
}
