import gugga.debug.Assertion;
/**
 * @author stefan
 */
class gugga.utils.HashUtil 
{
	private static var mCounter : Number = 0;
	
	public static function hash (aObject : Object) : String
	{
		Assertion.failIfFalse(
			(aObject instanceof Object),
			"variable to get hash for should be an instance of Object, it makes no sense to get hash for value types",
			HashUtil,
			arguments
		);
		
		var uid : String = HashUtil.generateUID();
		
		if(aObject["___hash"] == undefined)
		{
			aObject["___hash"] = uid;
			_global.ASSetPropFlags(aObject, "___hash", 1); // invisible and read-only	
		}
		
		return aObject["___hash"];		
	}
	
	private static function generateUID () : String
	{
		var date:Date = new Date();
		var id1:Number = date.getTime();
		var id2:Number = Math.random()*Number.MAX_VALUE;
		 
		HashUtil.mCounter++;
		
		return id1 + "_" + id2 + "_" + HashUtil.mCounter;
	}
}