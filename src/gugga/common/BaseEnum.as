/**
 * @author Barni
 */
class gugga.common.BaseEnum {
	
	private var mName:String;
	private var mOrderIndex:Number;

	public function toString():String
	{
		return mName;
	}
	
	public function valueOf():Number
	{
		return mOrderIndex;
	}
	
	private function BaseEnum(aName:String, aOrderIndex:Number)
	{
		mName = aName;
		mOrderIndex = aOrderIndex;
	}
	
	public static function parse(aType : Function, aValue : String) : Object
	{
		return aType[aValue];
	}
}