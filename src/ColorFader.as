class ColorFader extends Color{
	private var _id:Number; // id for setInterval call
	private var _interval:Number = 33; // default interval for fading
	private var _colorFrom:Object; // information about starting color
	private var _colorTo:Object; // information about the color fading to
	private var _remains:Number; // number of updates remaining for a fade
	private var _total:Number; // total number of updates being used for a fade
	
	// constructor
	function ColorFader(mc){
		super(mc); // based off the Color Object
	}
		
	/**
	 * hexTo: hex to fade to
	 * duration: length of time to spend fading to hexTo
	 * opt_interval: (optional) the rate at which the fade updates. Default: 33 milliseconds
	 */
	public function fadeTo (hexTo, duration, opt_interval):Void {
		clearInterval(_id); // stop any existing fade
		var rgb = getRGB(); // assign color objects
		_colorFrom = {r:rgb>>16, g:(rgb >> 8)&0xff, b:rgb&0xff, hex:rgb};
		_colorTo = {r:hexTo>>16, g:(hexTo >> 8)&0xff, b:hexTo&0xff, hex:hexTo};
		var interval = (opt_interval != undefined) ? opt_interval : _interval; // determine interval
		_remains = _total = Math.ceil(duration/interval); // calc updates needed in fade
		_id = setInterval(this, "doFade", interval); // call doFade to update fading every interval milliseconds
	}
	private function doFade():Void {
		if (_remains){ // if remaining updates exist
			_remains--;
			var t = 1 - _remains/_total; // process fade between colors
			setRGB((_colorFrom.r+(_colorTo.r-_colorFrom.r)*t) << 16 | (_colorFrom.g+(_colorTo.g-_colorFrom.g)*t) << 8 | (_colorFrom.b+(_colorTo.b-_colorFrom.b)*t));
		}else{ // if no more remains
			setRGB(_colorTo.hex); // set to hex of color fading to
			clearInterval(_id); // clear/stop interval
		}
		updateAfterEvent();		
	}
}