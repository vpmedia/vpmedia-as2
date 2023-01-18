import com.cetdemi.Timeline.*;
import mx.utils.Delegate;
import mx.remoting.debug.NetDebug;

/**
 * Stores event, associated data, reference to linked movieclip and event handles for event movieclips.
 */
class com.cetdemi.Timeline.Event
{
	/**
	* Date object of the event
	*/
	var date:DateWrapper;
	/**
	* Caption text
	*/
	private var text:String;
	/**
	* Type of event
	*/
	var type:Number;
	/**
	* Number in event group
	*/
	var num:Number;
	/**
	* ID associated with event, used for links
	*/
	private var id:String;
	/**
	* Position of the event with regards to the left of the timline (offset)
	*/	private var _pos:Number = -1;
	
	/**
	* An associated event (in the case of spanning events)
	*/
	var associated:com.cetdemi.Timeline.Event;
	
	/**
	* Reference to associated movie clip
	*/
	var mc:MovieClip;
	var iconType:Number;
	var size:Number = 1;
	
	/**
	 * Prototype
	 *
	 * @param date The date of the event, as a string
	 * @param text The associated tooltip text for the event
	 * @param link An empty or non-empty reference to whether the event is linke or is orphaned
	 * @param type The type of event 
	 * @param num The number of the event, as indexed in the events[i][num] array
	 * @param iconType The number of the graphic associated with the event [0 to 3]
	 * @param id A unique id for linkage purposes
	 */
	function Event( date:String, text:String, type:Number, num:Number, iconType:Number, size:Number, id)
	{
		this.date = new DateWrapper(date);
		this.text = text.split('\\n').join('\n');
		this.type = type;
		this.num = num;
		this.iconType = iconType;
		this.size = (size != undefined) ? size : 1;
		this.id = id;
	}

	/**
	 * Creates the movieclip for the event, and initiates event handlers
	 * Registers the tooltip for this particular event as well.
	 */
	function createVisual()
	{		var root = Referencer.getRoot();
		//To manipulate squares efficiently, name them : mcEvent_type_num
		mc = root.mcEvents.attachMovie("mcEvent_" + iconType, "mcEvent_" + type + '_' + num, (type+1)*1000 + num);
		mc.useHandCursor = true;
		
		mc._x = 0;
		mc._y = root.ctrl.data.eventY[this.type];
		mc._xscale = 100 + (this.size - 1)*20 + 20;
		mc._yscale = 100 + (this.size - 1)*20 + 20;
		mc._visible = false;
		
		mc.onRollOver = Delegate.create(this,handleEventRollOver);
		mc.onRollOut  = Delegate.create(this,handleEventRollOut);
		mc.onReleaseOutside  = Delegate.create(this,handleEventRollOut);
		mc.onRelease  = Delegate.create(this,handleEventRelease);
		
		mc.num = this.num;
		mc.type = this.type;
		
		//Registers tooltip as required
		_global.tooltip.registerClip(mc, date.toString() + '\n' + text);
		
		var tt = this.text;
	}
	
	/**
	* Fired when an event is rolled over
	*/
	function handleEventRollOver()
	{
		_global.tooltip.showToolTip(mc);
		var root = Referencer.getRoot();
		mc.gotoAndStop(2);
		root.txtCaption.text = date.toString() + ': ' + text;
	}
	
	/**
	* Fired when an an event is rolled out
	*/
	function handleEventRollOut()
	{
		_global.tooltip.hideToolTip(false);
		var ctrl = Referencer.getController();
		if(ctrl.selectedEvent != this)
		{
			mc.gotoAndStop(1);
		}
	}
	
	/**
	* Fired when an event is released, calls getURL to link to HTML
	*/
	function handleEventRelease()
	{
		Referencer.getController().selectedEvent.mc.gotoAndStop(1);
		Referencer.getController().selectedEvent = this;
		getURL('iframe.asp?id=' + id, 'iframecontent');
		mc.gotoAndStop(2);	}
	
	/**
	* Handle getContent from localConnection
	*/
	function handleGetContent()
	{
		if(Referencer.getController().selectedEvent == null || associated != Referencer.getController().selectedEvent)
		{
			Referencer.getController().selectedEvent.mc.gotoAndStop(1);
			Referencer.getController().selectedEvent = this;
			mc.gotoAndStop(2);
		}
		getURL('javascript:getEvent("' + id + '")');
	}
	
	/**	 * Returns the position of the square	 */	function get pos()
	{
		if(_pos == -1)
		{
			_pos = date.pos;
		}
		return _pos;
	}
}