import net.manaca.lang.exception.IllegalArgumentException;
/**
 * 功能：数组增强类
 * 类型：类
 * 描述：增强的数组操作类
 * 		 添加了一些常用的数组处理方法，静态类
 * 
 * @author  Wersling
 * @version 1.0, 2005.08.26
 * @see Array
 * @since 1.0
 */
class net.manaca.util.ArrayUtil
{	
	/* 私有构造函数。（不可实例化） */
	private function ArrayUtil(Void)
	{
	}
	
	/**
	 * 从指定的源索引开始，复制 Array 中的一系列元素，将它们粘贴到另一 Array 中（从指定的目标索引开始）。
	 * 
 	 * @param sourceArray 包含要复制的数据
	 * @param sourceIndex 表示 sourceArray 中复制开始处的索引。
	 * @param destinationArray 接收数据
	 * @param destinationIndex 表示 destinationArray 中存储开始处的索引。
	 * @param length 表示要复制的元素数目。
	 */
	public static function Copy(sourceArray:Array,sourceIndex:Number,destinationArray:Array,destinationIndex:Number,length:Number):Void
	{
		if(sourceArray.length == 0 || destinationArray.length == 0) throw new IllegalArgumentException("数组不能为空!",eval["th"+"is"],arguments);
		if(sourceIndex < 0 || sourceIndex > (sourceArray.length - 1) || destinationIndex < 0 || destinationIndex > destinationArray.length || length < 0) throw new IllegalArgumentException("参数越界!",eval["th"+"is"],arguments);
		if(length > (sourceArray.length - sourceIndex)) throw new IllegalArgumentException("要复制的元素数目出错!",eval["th"+"is"],arguments);
		var count:Number = destinationArray.length - destinationIndex;
		if(count > 0)
		{
			for(var i:Number = count - 1;i>=0;i--)
			{
				destinationArray[destinationIndex + length + i] = destinationArray[destinationIndex + i];
			}
		}
		for(var i:Number = 0;i<length;i++)
		{
			destinationArray[destinationIndex+i] = sourceArray[sourceIndex+i];
		}
	}
	
	/**
	 * 数组复制
	 * Clones an Array.
	 * @param array the Array to be cloned
	 * @return a clone of the passed in Array
	 */
	public static function Clone(array:Array):Array
	{
		return array.concat();
	}
	
	/**
	 * 移除数组中指定位置的元素
	 * <p>如果index为-1，则移除最后一个元素
	 * 
	 * @param array 目标数组
	 * @param index 需要移除元素的位置
	 * @throws IllegalArgumentException 如果数组中不存在该索引
	 */
	public static function RemoveIndex(array:Array, index:Number):Object
	{
		if(index == -1) RemoveIndex(array, array.length-1);
		var _element:Object = array[index]	;
		if(_element == undefined) throw new IllegalArgumentException("数组 ["+array+"] 中不存在索引为 ["+index+"] 的元素!",eval("th" + "is"),arguments);
		array.splice(index,1);
		return _element;
	}
	
	/**
	 * 移除某数组中指定的元素
	 * Removes a specific element out of the Array.
	 *
	 * @param array the Array to remove the element out of
	 * @param element the element to be removed
	 * @throws IllegalArgumentException if the element could not be found in the Array
	 */
	public static function RemoveElement(array:Array, element:Object):Void
	{
		var _index:Number = IndexOf(array,element);
		if(_index >= 0) {
			RemoveIndex(array,_index);
			return;
		}
		Tracer.warn("数组 ["+array+"] 中不存在元素 ["+element+"]!",eval("th" + "is"));
		//throw new IllegalArgumentException("数组 ["+array+"] 中不存在元素 ["+element+"]!",eval("th" + "is"),arguments);
		/*
		var l:Number = array.length;
		for (var i:Number = 0; i <= l; i++) {
			if (array[i] === element) {
				array.splice(i, 1);
				return;
			}
		}
		throw new IllegalArgumentException("数组 ["+array+"] 中不存在元素 ["+element+"]!",eval("th" + "is"),arguments);
		*/
	}
	
	/**
	 * 检测某数组是否包含某个元素
	 * Checks if the array already contains the passed object.
	 * It checks the content with a for-in loop. In this way all arrays can
	 * be passed in.
	 * @param array The array that shall contain the object.
	 * @param value The object that shall be checked for availability.
	 * @return true if the array contains the object else false
	 */
	public static function Contains(array:Array, value:Object):Boolean
	{
		return IndexOf(array,value) >= 0;
	}
	
	/**
	 * 搜索指定的元素，并返回整个数组中第一个匹配项的从零开始的索引。
	 * Checks the index of a object within a array.
	 * It checks the content of a array by counting to the array length.
	 * It will return the first occurency of the object within the array.
	 * If the object wasn't found -1 will be returned.
	 *
	 * @param array The array that shall contain the object.
	 * @param object The object to get the position from.
	 * @return The number of the object within the array (if it was not found -1)
	 */
	public static function IndexOf(array:Array, value:Object):Number
	{
		for (var i : Number = 0; i < array.length; i++) {
			if(array[i] === value) {
				return i;
			}
		}
		return -1;
	}
	
	/**
	 * 打乱某个数组，即随机改变数组中元素的顺序
	 * Shuffles the passed array.
	 * 
	 * @param array Array that should get shuffled.
	 */
	public static function Shuffle(array:Array):Void
	{
		var len:Number = array.length;
		var rand:Number;
		var temp:Object;
		
		for (var i:Number=len-1; i>=0; i--){
			rand = Math.floor(Math.random()*len);
			temp = array[i];
			array[i] = array[rand];
			array[rand] = temp;
		}
	}
	
	//最小值

	public static function getMin (_Arr : Array):Number
	{
		var min : Number = _Arr [0];
		var j : Number;
		for (j in _Arr) if (_Arr [j] < min) min = _Arr [j]; 
		return min;
	}
	
	//最大值

	public static function getMax (_Arr : Array):Number
	{
		var max : Number = _Arr [0];
		var j : Number;
		for (var i:String in _Arr) if (_Arr [i] > max) max = _Arr [i]; 
		return max;
	}
	//数据处理
	public static function map (_Arr : Array, fun : Function) : Array
	{
		var result : Array = new Array ();
		for (var i:String in _Arr) result.push (fun (_Arr [i])); 
		return result;
	}
	//过滤
	public static function filter (_Arr : Array, fun : Function) : Array
	{
		var result : Array = new Array ();
		for (var i:String in _Arr)
		{
			if (fun (_Arr [i]))
			{
				result.push (_Arr [i]);
			};
		}
		return result;
	}
	
	//查找满足两数据和为n
	public static function pairSums (_Arr : Array, n : Number) : Array
	{
		var l : Array = _Arr.slice ();
		var k : Array = new Array ();
		var o1 : Number;
		var o2 : Number;
		while ((o1 = l.length - 1) > 0)
		{
			for (o2 = o1; o2 -- > 0; "")
			{
				if (l [o1] + l [o2] == n) k.push ([l [o1] , l [o2]]);
			}
			l.pop ();
		}
		return k;
	}
	//查重
	public static function delRepeat (_Arr : Array) : Array
	{
		var k : Array = new Array ();
		for (var i:String in _Arr)
		{
			var y:Boolean = false;
			for (var j:String in k)
			{
				if (_Arr [i] == k [j])
				{
					y = true;
				}
			}
			if ( ! y)
			{
				k.push (_Arr [i]);
			}
		}
		return k;
	}
	//复制
	public static function copy (_Arr : Array) : Array
	{
		return _Arr.slice ();
	}
	//比较
	public static function contains(array:Array, object):Boolean {
		for (var i:String in array) {
			if (array[i] === object) {
				return true;
			}
		}
		return false;
	}
	
	/**
	 * 根据 (v2-v1)*t 方式计算新值，并返回一个新的数组
	 * @param ary1 Array
	 * @param ary2 Array
	 * @param t 值为（0-1）
	 */
	public static function interpolateArrays(ary1:Array, ary2:Array, t:Number):Array{
		var result:Array = (ary1.length >= ary2.length) ? ary1.slice() : ary2.slice();
		var i = result.length;
		while(i--) result[i] = ary1[i] + (ary2[i] - ary1[i])*t;
		return result;
	}
	
	/**
     *  Ensures that an Object can be used as an Array.
	 *
     *  <p>If the Object is already an Array, it returns the object. 
     *  If the object is not an Array, it returns an Array
	 *  in which the only element is the Object.
	 *  As a special case, if the Object is null,
	 *  it returns an empty Array.</p>
	 *
     *  @param obj Object that you want to be an array.
	 *
     *  @return Original Object if already an Array,
	 *  or a new Array whose only element is the Object,
	 *  or an empty Array if the Object was null.
     */
    public static function toArray(obj:Object):Array
    {
//		if (!obj) 
//			return [];
//		
//		else if (obj is Array)
//			return obj as Array;
//		
//		else
		 	return [ obj ];
    }
}