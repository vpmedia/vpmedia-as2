import gugga.crypt.GUID;
import gugga.utils.DebugUtils;

/**
 * @author Todor Kolev
 */
class gugga.utils.DoLaterUtil 
{
	private static var mOnEnterFrameBeacon : MovieClip;
	private static var mDoLaterMethods : Array;
	
	public static function doLater(aScopeObject:Object, aMethod:Function, aArguments:Array, aFramesDelay:Number)
	{
		if(!mOnEnterFrameBeacon)
		{
			var guid : String = GUID.create();
			mOnEnterFrameBeacon = _level0.createEmptyMovieClip("OnEnterFrameBeacon_" + guid, _level0.getNextHighestDepth());
		}
		
		if(!mDoLaterMethods)
		{
			mDoLaterMethods = new Array();
		}
		
		var framesDelay:Number = 1;
		
		if(aFramesDelay)
		{
			framesDelay = aFramesDelay;
		}
		
		var doLaterMethodDescriptor : Object = {
			scopeObject: aScopeObject,
			method: aMethod,
			arguments: aArguments,
			framesDelay: framesDelay
		};
		
		mDoLaterMethods.push(doLaterMethodDescriptor);
		
		mOnEnterFrameBeacon.onEnterFrame = onBeaconEnterFrame;
	}
		
	private static function onBeaconEnterFrame() : Void 
	{
		if(mDoLaterMethods.length == 0)
		{
			mOnEnterFrameBeacon.onEnterFrame = null;
		}
		
		var doLaterMethodDescriptor : Object;
		for (var i:Number = 0; i < mDoLaterMethods.length; i++)
		{
			doLaterMethodDescriptor = mDoLaterMethods[i];
			
			doLaterMethodDescriptor.framesDelay--;
			if(doLaterMethodDescriptor.framesDelay <= 0)
			{
				doLaterMethodDescriptor.method.apply(doLaterMethodDescriptor.scopeObject, doLaterMethodDescriptor.arguments);
				mDoLaterMethods.splice(i, 1);
			}
		}
	}
}