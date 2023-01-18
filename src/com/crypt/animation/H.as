class com.crypt.animation.H {

	public static function g(guide:MovieClip, obj:Object):Object
	{
		trace('g > ' + guide + ' :: ' + obj);
		obj._alpha = guide._alpha;
		obj._x = guide._x;
		obj._y = guide._y;
		obj._xscale = guide._xscale;	
		obj._yscale = guide._yscale;	
		obj._rotation = guide._rotation;
		return obj;
	}
	
	
	public static function hideGuides(a:Array)
	{
		trace('hideGuides');
		for (var i:Number = 0; i<a.length; i++)	{ a[i]._visible = false; }
	}
	
	public static function pSaveArray(a:Array, phase:String)
	{
		for (var i:Number = 0; i<a.length; i++)	{ pS( a[i], phase ); }
	}
	
	public static function pLoadArray(a:Array, phase:String)
	{
		for (var i:Number = 0; i<a.length; i++)	{ pL( a[i], phase ); }
	}
	
	
	public static function pL(mc:Object, phase:String, obj:Object ):Object // load phase properties
	{
		
		obj._alpha		= mc["a"+phase];
		obj._x			= mc["x"+phase];
		obj._y			= mc["y"+phase];
		obj._xscale		= mc["sx"+phase];
		obj._yscale		= mc["sy"+phase];
		obj._rotation	= mc["r"+phase];
		return obj;
	}
	
	public static function pS(mc:Object, phase:String) // save phase properties
	{
		mc["a"+phase]	= mc._alpha;
		mc["x"+phase]	= mc._x;
		mc["y"+phase]	= mc._y;
		mc["sx"+phase]	= mc._xscale;
		mc["sy"+phase]	= mc._yscale;
		mc["r"+phase]	= mc._rotation;	
	}

}