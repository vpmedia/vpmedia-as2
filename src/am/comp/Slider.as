dynamic class am.comp.Slider extends MovieClip {

	private var value: Number;
	private var align: String;
	private var min: Number;
	private var max: Number;

	private var top: Number;
	private var bottom: Number;
	private var way: Number;

	private var ty: Number;

	public var onChanged: Function;
	public var onActivate: Function;

	function Slider ()
	{
		init();
	}

	private function init(): Void
	{
		if ( align == "bottom" )
		{
			value = min;
			bottom = ty = _y;
			top = ty - way;
		}
		else
		{
			value = max;
			top = ty = _y;
			bottom = ty + way;
		}
	}

	function setValue ( newVal: Number ): Void
	{
		if ( newVal < min ) newVal = min
		else if ( newVal > max ) newVal = max;
		_y = bottom - ( newVal - min ) * way / max;
	}

	function getValue (): Number
	{
		return value;
	}

	function onPress ()
	{
		startDrag( this , false , _x , top , _x , bottom );
		onActivate();
		onEnterFrame = function ()
		{
			value = int( min + ( bottom - _y ) / way * ( max - min ) );
			onChanged( value );
		}
	}

	function onRelease (): Void
	{
		stopDrag();
		onChanged( value );
		delete onEnterFrame;
	}

	function onReleaseOutside (): Void
	{
		stopDrag();
		onChanged( value );
		delete onEnterFrame;
	}

}