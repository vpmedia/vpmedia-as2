import mx.events.EventDispatcher;

import gugga.crypt.GUID;
import gugga.utils.DebugUtils;
import mx.utils.Delegate;

[Event("onEnterFrame")]

/**
 * @author Todor Kolev
 */
class gugga.utils.OnEnterFrameBeacon extends EventDispatcher 
{
	private static var mBeaconClip : MovieClip;
	
	private static var mInstance : OnEnterFrameBeacon;
	public static function get Instance() : OnEnterFrameBeacon 
	{	
		if(!mInstance)
		{
			mInstance = new OnEnterFrameBeacon();
		}
			
		return mInstance; 
	}
	
	private function OnEnterFrameBeacon() 
	{
		if(!mBeaconClip)
		{
			var guid : String = GUID.create();
			mBeaconClip = _level0.createEmptyMovieClip("GlobalOnEnterFrameBeacon_" + guid, _level0.getNextHighestDepth());
		}	
		
		mBeaconClip.onEnterFrame = Delegate.create(this, onBeaconClipEnterFrame);
	}
	
	private function onBeaconClipEnterFrame() : Void 
	{
		dispatchEvent({type: "onEnterFrame", target: this});
	}
}