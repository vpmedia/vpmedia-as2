import com.cetdemi.Timeline.*
import mx.utils.Delegate;

/** * Creates a period with associated data */
class com.cetdemi.Timeline.Period
{
	/**
	* Color of the period
	*/
	var color:String;
	/**
	* Name of the period (may be used in caption)
	*/
	var name:String;
	/**
	* A unique number for this period
	*/
	var num:Number;
	/**
	* Start date of the period
	*/
	private var _startDate:DateWrapper;
	/**
	* End date of the period
	*/	private var _endDate:DateWrapper;
	/**
	* Associated movieclip reference
	*/
	var mc:MovieClip;
	/**
	* Movieclip's color object
	*/
	var colorObject:Color;
	
	/**
	* Rollout color
	*/
	var color1:Number;
	/**
	* Rollover color
	*/
	var color2:Number;
	
	/**
	* Start position from the left
	*/
	var _startPos:Number = -1;
	/**
	* End position from the left
	*/
	var _endPos:Number = -1;	/**	 * Constructor	 * 	 * @param startDate The start of the period
	 * @param color The color of the period
	 * @param name The name of the period, as viewed on rollover
	 * @param num The number of the period, indexed from the left of the screen
	 */
	function Period(startDate:String, color:String, name:String, num:Number)
	{
		this.startDate = startDate;
		this.color = color;
		this.name = name;
		this.num = num;
	}
	
	/**	 * Creates the movieclip associated with the period
	 */
	function createVisual()
	{		var root = Referencer.getRoot();
		mc = root.mcPeriods.attachMovie("mcPeriod", "mcPeriod_" + num, num);
		
		colorObject = new Color(mc);
		colorObject.setRGB(Number("0x" + color));
		
		var r = Number("0x" + this.color.substr(0, 2));
		var g = Number("0x" + this.color.substr(2, 2));
		var b = Number("0x" + this.color.substr(4, 2));
		
		var r2 = Math.round(255 - (255 - r)*1.10);
		var g2 = Math.round(255 - (255 - g)*1.10);
		var b2 = Math.round(255 - (255 - b)*1.10);
		
		color1 = Number("0x" + this.color);
		color2 = r2*256*256 + g2*256 + b2;
		
		mc._visible = false;
		
		mc.onRollOver = Delegate.create(this, handlePeriodRollOver);
		mc.onRollOut = Delegate.create(this, handlePeriodRollOut);
		mc.onRelease = Delegate.create(this, handlePeriodRelease);
		
		mc.num = this.num;
	}
	
	/**	 * Handle period rollover
	 */
	function handlePeriodRollOver()
	{		colorObject.setRGB(color2);
	}
	
	/**
	* Handles period rollout
	*/
	function handlePeriodRollOut()
	{
		colorObject.setRGB(color1);
	}
	
	/**
	* Called when a period rectangle is clicked. 
	* Fires an animation . 
	* Notice how we still see some of the other periods on the left and right thanks to the 0.1 factor in determining 
	* left and right. 
	*/
	function handlePeriodRelease()
	{
		var ctrl = Referencer.getController();
		
		//Set up a new anim
		var left = Math.max(0, startPos - 0.1*(endPos - startPos));
		var right = Math.min(1, endPos + 0.1*(endPos - startPos));
		
		ctrl.anim.begin(ctrl.renderer.offset, ctrl.renderer.zoom, left, 1/(right - left));
	}
	
	/**
	 * Sets the end date of a period
	 */
	function set startDate(paramDate:String)
	{
		_startDate = new DateWrapper(paramDate);
	}
	
	/**
	 * Returns the end date of the period
	 */
	function get startDate():DateWrapper
	{
		return _startDate;
	}
	
	/**
	 * Sets the end date of a period
	 */
	function set endDate(paramDate:String)
	{
		_endDate = new DateWrapper(paramDate);
	}
	
	/**
	 * Returns the end date of the period
	 */
	function get endDate():DateWrapper
	{
		return _endDate;
	}	/**
	 * Sets the end date of a period
	 */
	function get endPos():Number
	{
		if(_endPos == -1)
		{
			_endPos = endDate.pos;
		}
		return _endPos;
	}
	
	/**
	 * Returns the end date of the period
	 */
	function get startPos():Number
	{
		if(_startPos == -1)
		{
			_startPos = startDate.pos;
		}
		return _startPos;
	}
}
