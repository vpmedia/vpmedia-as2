/*
	SharedObjectUtils
	
	Class created to decorate remote shared objects.  Since SharedObjects
	are created via a Factory method, it's hard to create a class
	that "extends" SharedObject.  Thus, once I create one, I decorate
	on the fly via this method, giving it EventDispatching capabilities.
    
    Created by Jesse R. Warden a.k.a. "JesterXL"
	jesterxl@jessewarden.com
	http://www.jessewarden.com
	jesse@universalmind.com
	http://www.universalmind.com
	
	This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/
*/

import mx.events.EventDispatcher;

class com.jxl.vidconverter.utils.SharedObjectUtils
{
	public static function getEventDispatchingRemoteSharedObject(p_name:String, p_ncURI:String, p_persistent:Boolean):SharedObject
	{
		var so:SharedObject = SharedObject.getRemote(p_name, p_ncURI, p_persistent);
		EventDispatcher.initialize(so);
		so.onSync = function(changeList:Array):Void
		{
			dispatchEvnet({type: "sync", target: this, changeList: changeList});
		};
		return so;
	}
}