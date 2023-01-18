class com.vpmedia.events.DoLater
{
	static var _methodTable_arr:Array;
	static var _tmp_mc:MovieClip;
	static function callFunc (obj:Object, fn:String, mc:MovieClip):Void
	{
		var extraArgs = arguments.slice (3);
		if (_tmp_mc == undefined)
		{
			_tmp_mc = mc;
		}
		if (_methodTable_arr == undefined)
		{
			_methodTable_arr = new Array ();
		}
		for (var prop in _methodTable_arr)
		{
			if (_methodTable_arr[prop].fn == fn && _methodTable_arr[prop].obj == obj)
			{
				// account for possible changed arguments!
				var res = checkArguments (extraArgs, _methodTable_arr[prop].arg);
				if (!res)
				{
					_methodTable_arr[prop].arg = extraArgs;
				}
				return;
			}
		}
		_methodTable_arr.push ({obj:obj, fn:fn, arg:extraArgs});
		_tmp_mc.onEnterFrame = doLaterDispatcher;
	}
	static function checkArguments (arg1, arg2)
	{
		for (var prop in arg1)
		{
			if (arg1[prop] != arg2[prop])
			{
				return false;
			}
		}
		return true;
	}
	// callback that then calls queued functions
	static function doLaterDispatcher (Void):Void
	{
		delete _tmp_mc.onEnterFrame;
		// make a copy of the _methodTable_arr so methods called can 
		// requeue themselves w/o putting us in an infinite loop
		var __methodTable:Array = _methodTable_arr;
		// new doLater calls will be pushed here
		_methodTable_arr = new Array ();
		// now do everything else
		if (__methodTable.length > 0)
		{
			var m:Object;
			while ((m = __methodTable.shift ()) != undefined)
			{
				m.obj[m.fn].apply (m.obj, m.arg);
			}
		}
	}
	/**
	 * cancel all queued functions
	 */
	static function cancelAllDoLaters (Void):Void
	{
		delete _tmp_mc.onEnterFrame;
		_methodTable_arr = new Array ();
	}
}
