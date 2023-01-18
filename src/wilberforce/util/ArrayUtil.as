class wilberforce.util.ArrayUtil
{
	public static function createRandomisedArray(sourceArray:Array,count:Number):Array
	{
		if (!count) count=sourceArray.length;
		
		var tNumArray:Array=new Array();
		for (var i=0;i<sourceArray.length;i++) tNumArray.push(i);
		
		var tOutputArray:Array=new Array();
		for (var i=0;i<count;i++)
		{
			var tRandomIndex=random(tNumArray.length);
			tOutputArray.push(sourceArray[tNumArray[tRandomIndex]]);
			tNumArray.splice(tRandomIndex,1);
		}
		return tOutputArray;
	}
}