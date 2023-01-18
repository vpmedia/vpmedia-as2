import com.bumpslide.util.*;
import mx.events.EventDispatcher;

class com.bumpslide.ui.Slider extends MovieClip implements com.bumpslide.ui.IResizable
{
	
	static public var EVENT_VALUE_CHANGE:String = "onValueChange";
	
	// children
	private var bg_mc:MovieClip;
	private var line_mc:MovieClip;
	private var dragger_mc:MovieClip;
	private var indicator_mc:MovieClip;
	
	// style
	public var style:Object;
	
	// private
	private var _dragInt:Number  = -1;
	private var _updateInt : Number = -1;	
	private var _min:Number = 0;
	private var _max:Number = 100;
	private var _value:Number = 0;
	private var height : Number = 32;
	private var width : Number = 200;
	private var padding : Number = 6;
	private var lineHeight : Number = 4;
	
	public var keepRounded : Boolean = false;
	public var showDragger : Boolean = true;
	
	/**
	* Static method to create an instance
	* 
	* No need to create a dummy clip in our library this way.
	* 
	* @param	instance_name
	* @param	timeline_mc
	* @return
	*/
	public static function create( instance_name:String, timeline_mc:MovieClip ) : Slider {
		return Slider( ClassUtil.createMovieClip(instance_name, timeline_mc, Slider) );
	} 
	
	function Slider() {
		
		EventDispatcher.initialize( this );
		
		style = {
			backgroundColor: 0xffffff,
			backgroundAlpha: 0,
			lineColor: 0x444444,
			indicatorColor: 0xaaaaaa,
			draggerColor: 0x777777,
			draggerOverColor: 0xdddddd
		}
		
		init();
	}
	
	function init() {
		redraw();
	}
	
	function onUnload() {
		clearInterval( _updateInt );
		clearInterval( _dragInt );
		delete onEnterFrame;
	}
	
	/**
	* Current slider value
	* 
	* @return
	*/
	public function get value():Number
	{
		return _value;
	}
	
	/**
	* Current Slider value
	* @param	val
	*/
	public function set value( val:Number ):Void
	{
		_value = Math.max(min, Math.min(max, val));
		update();
	}
	
	/**
	* Minimum slider value
	* 
	* @return
	*/
	public function get min():Number
	{
		return _min;
	}
	
	/**
	* Minimum slider value
	* 
	* @param	val
	*/
	public function set min( val:Number ):Void
	{
		_min = val;
		update();
	}
		
	/**
	* Maximum slider value
	* 
	* @return max number
	*/
	public function get max():Number
	{
		return _max;
	}
	
	/**
	* Sets max slider value
	* 
	* @param	val
	*/
	public function set max( val:Number ):Void
	{
		_max = val;
		update();		
	}
	
	/**
	* Sets component's size (width and height)
	* @param	w	width
	* @param	h	height
	*/
	public function setSize( w:Number, h:Number ) {
		width = (w!=null) ? Math.round(w) : width;
		height = (h!=null) ? Math.round(h) : height;
		redraw()
	}
	
	private function update() {	
		updateDragger();
		updateIndicator();
		draggerOut();
	}
	
	private function updateDragger() {
		var ratio = value/(max-min);
		dragger_mc._x = padding + ratio * (width-padding*2);		
		dragger_mc._x = Math.round( dragger_mc._x );
	}
	/**
	* If we have a display indicator separate from the dargger, we update that here.
	*/
	private function updateIndicator() {					
		var ratio = value/(max-min);
		var w = ratio * (width - padding*2);	
		var indicator_mc = createEmptyMovieClip( 'indicator_mc', 3 );
		Draw.box( indicator_mc, w, 2, style.indicatorColor, 100 );
		indicator_mc._x = padding;
		Align.middle( indicator_mc, height );
	}
	
	private function redraw() {

		drawBackground();
		drawLine();
		drawDragger();
		
		rewireButtonEvents();
		
		update();		
	}
	
	function rewireButtonEvents() {
		bg_mc.onPress = Delegate.create( this, backgroundPress );
		bg_mc.onRelease = bg_mc.onReleaseOutside = Delegate.create( this, stopDragging );
		bg_mc.onRollOver = Delegate.create( this, draggerOver );
		bg_mc.onRollOut = Delegate.create( this, draggerOut );
		dragger_mc.onRollOver = Delegate.create( this, draggerOver );
		dragger_mc.onRollOut = Delegate.create( this, draggerOut );
		dragger_mc.onRelease = dragger_mc.onReleaseOutside = Delegate.create( this, stopDragging );
		dragger_mc.onPress = Delegate.create( this, startDragging );
	}
	
	function drawBackground() {		
		createEmptyMovieClip( 'bg_mc', 1 );				
		Draw.box( bg_mc, width, height, style.backgroundColor, style.backgroundAlpha );		
	}
	
	function drawLine() {
		createEmptyMovieClip( 'line_mc', 2 );			
		Draw.box( line_mc, width-padding*2, lineHeight, style.lineColor, 100 );
		line_mc._x = padding;
		Align.middle( line_mc, height );
	}
	
	function drawDragger() {
		createEmptyMovieClip( 'dragger_mc', 4 );	
		
		dragger_mc.createEmptyMovieClip('art_mc', 1);
		dragger_mc.art_mc._x = -4;
		Draw.box( dragger_mc.art_mc, 8, 18, style.draggerColor, 100 );		
		Align.middle( dragger_mc, height );
		
		if(!showDragger) dragger_mc._alpha = 0;
	}
	
	function draggerOver () {
		var c:Color = new Color( dragger_mc );
		c.setRGB( style.draggerOverColor );
	}
	
	function draggerOut () {
		var c:Color = new Color( dragger_mc );
		c.setRGB( style.draggerColor );
	}
	
	function backgroundPress() {
		dragger_mc._x = _xmouse;
		startDragging();
	}
	
	function startDragging() {
		trace('startdragging');
		clearInterval( _dragInt );
		_dragInt = setInterval( this, 'whileDragging', 50);	
		//onEnterFrame = whileDragging;		
		var y = Math.round( dragger_mc._y);
		dragger_mc.startDrag( false, padding, y, width-padding, y);
		whileDragging();
	}

	function whileDragging() {		
		var ratio:Number = (dragger_mc._x-padding)/(width-padding*2);
		var oldValue = _value;
		_value = (max-min)*ratio + min;
		if(keepRounded) _value = Math.round( _value );
		updateIndicator();
		if(_value!=oldValue) dispatchEvent( {type:EVENT_VALUE_CHANGE, target:this, value: value} );	
	}
	
	function stopDragging() {
		clearInterval( _dragInt );
		delete onEnterFrame;
		
		dragger_mc.stopDrag();
		dragger_mc._x = Math.round(dragger_mc._x);
		whileDragging();
		if(!hitTest(_parent._xmouse, _parent._ymouse)) draggerOut();
	}
	
	public var addEventListener    : Function;
 	public var removeEventListener : Function;
 	private var dispatchEvent      : Function;
 	private var dispatchQueue      : Function;
	
}