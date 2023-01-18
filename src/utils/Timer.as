class utils.Timer
{
	private var tv:Number;
	private var rv:Number;
	private var sv:Number;
	private var rVal:Boolean;
	
	function Timer(callback)
	{
		rv = getTimer();
	}
	
	public function wait(tt:Number):Void
	{
		tv = tt;
		sv = Math.round(getTimer() - rv);
		if (sv > tv)
		{
			rv = getTimer();
			rVal = true;
		}
		else
		{
			rVal = false;
		}
	}
	
	public function get end():Boolean
	{
		return rVal;
	}
}