class com.jxl.shuriken.managers.SetTimeoutManager
{
	
	private static var idHash:Object = {};
	private static var counterID:Number = 0;
	
	public static function setTimeout(pScope:Object, pFunction:String, pMilliseconds:Number, pTag):Number
	{
		//trace("----------------------");
		//trace("SetTimeoutManager::setTimeout");
		//trace("pScope: " + pScope);
		//trace("pFunction: " + pFunction);
		//trace("pMilliseconds: " + pMilliseconds);
		//trace("pTag: " + pTag);
		var o:Object = {};
		o.scope = pScope;
		o.func = pFunction;
		o.id = ++counterID;
		o.tag = pTag;
		trace("o.id: " + o.id);
		idHash[o.id] = o;
		arguments.shift();
		arguments.shift();
		arguments.shift();
		arguments.shift();
		o.args = arguments.concat();
		o.timeoutID = _global.setTimeout(runFunction, pMilliseconds, o);
		return o.timeoutID;
	}
	
	private static function runFunction(pObj:Object):Void
	{
		idHash[pObj] = undefined;
		var f:Function = pObj.scope[pObj.func];
		f.apply(pObj.scope, pObj.args);
	}
	
	public static function clearAllTimeouts(pTag):Void
	{
		trace("-------------------------");
		trace("SetTimeoutManager::clearAllTimeouts, pTag: " + pTag);
		if(pTag == null)
		{
			for(var p in idHash)
			{
				_global.clearTimeout(idHash[p].timeoutID);
				delete idHash[p];
			}
			delete idHash;
		}
		else
		{
			
			for(var p in idHash)
			{
				trace("p: " + p);
				trace("p.toString(): " + p.toString());
				trace("p.valueOf(): " + p.valueOf());
				trace("String(p): " + String(p));
				if(_global.timeoutDebug == null) _global.timeoutDebug = [];
				_global.timeoutDebug.push(p);
				for(var prop in p)
				{
					trace(prop + ": " + p[prop]);
				}
				var o:Object = idHash[p];
				if(o.tag == pTag)
				{
					_global.clearTimeout(idHash[p].timeoutID);
					delete idHash[p];
				}
			}
		}
	}
	
}