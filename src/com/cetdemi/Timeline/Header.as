import com.cetdemi.Timeline.*;
import mx.utils.Delegate;
import mx.remoting.debug.NetDebug;

/**
 * Encapsulates headers (the things that are on top of the timelnie that can be clicked).
 * Headers are recycled, unlike events. That means that there are only a dozen or so
 * header clips on the main timeline at any time, despite the fact that there can be 
 * (numMonths) shown on the main timeline. This makes rendering a lot faster (less objects
 * = less render time).
 */
 class com.cetdemi.Timeline.Header 
 {
	 /**
	 * Associated movieclips
	 */
	 var mc:MovieClip;
	 /**
	 * The unique number of the header.
	 */
	 var num:Number;
	 /**
	 * The position of the header as an offset between 0 and 1
	 */
	 var pos:Number;
 
	/**
	* Constructor
	* 
	* @param num:Number The unique id number of the header
	*/
	function Header(num:Number)
	{
		var ctrl = Referencer.getController();
		var root = Referencer.getRoot()
		this.num = num;
		mc = root.mcHeader.attachMovie("mcHeader", "mc" + num, num);
		
		//Assign event handlers
		mc.onRelease = Delegate.create(this, handleHeaderRelease);
		mc.onRollover = Delegate.create(this,handleHeaderRollover);
		mc.onRollout = Delegate.create(this, handleHeaderRollout);
	}
	
	/**
	* Called when a header is clicked (initiate zoom in)
	*/
	function handleHeaderRelease()
	{
		var ctrl = Referencer.getController();
		var root = Referencer.getRoot();
		
		var span = ctrl.params.tlRules[ctrl.renderer.currLevel].x;
		var zoom = Math.min(0.8*ctrl.measurer.numMonths/span, ctrl.params.maxZoom);
		var offset = Math.min(pos - 0.1/zoom, 1 - 1/zoom);
	
		ctrl.anim.begin(ctrl.renderer.offset, ctrl.renderer.zoom, offset, zoom);
	}
	
	/**
	* Called when header is rolled over (rollover anim)
	*/
	function handleHeaderRollover()
	{
		this.mc.bg.gotoAndStop(2);
	}
	
	/**
	* Called when header is rolled out (rollout anim)
	*/
	function handleHeaderRollout()
	{
		this.mc.bg.gotoAndStop(1);
	}
}