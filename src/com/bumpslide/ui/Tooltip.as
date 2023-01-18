
import com.bumpslide.util.*;


/**
 * Generic Tooltip component 
 * 
 */

class  com.bumpslide.ui.Tooltip extends com.bumpslide.core.BaseClip {

	// PUBLIC
	var tooltip_txt           : TextField;
	var bg_mc                 : MovieClip;
	var shadow_mc             : MovieClip;
	var border_mc             : MovieClip;
	
	private var _displayInt   : Number;
	private var _followInt    : Number;
	private var _defaultDelay : Number = 250;
	
	private var _style        : Object;
    private var _displayText  : String = "";
	private var _displayArgs  : Array;
	
	[Bindable]
	function set text (s:String ) {
		if(s=='') this.cancel();
		else this.display( s );
	}
	
	
	// CTOR
	function Tooltip() {		
		
		_visible = false;
		
		// default style
		_style = {
			fontFamily: 'Verdana', 
			fontSize: 10,
			fontWeight: 'normal', // or 'bold'
			fontStyle:  'normal', // or 'italic'
			color: 0x000000,
			backgroundColor: 0xFFFFCC,
			borderColor: 0xcccccc,
			embedFonts: false
		}
	}
	
	static public function create( instance_name:String, timeline_mc:MovieClip ) : Tooltip{
		return Tooltip( ClassUtil.createMovieClip( instance_name, timeline_mc, Tooltip ) );
	}
	
	function set defaultDelay( ms : Number ) {
		_defaultDelay = ms;
	}
	
	function get defaultDelay() : Number {
		return _defaultDelay;
	}	
	
	function setStyle( styleAttribute, val) {
		this._style[styleAttribute] = val;
	}
	
	/*
 	 * Function: display
	 * 
	 * Displays tooltip 
	 * 
	 * Paremeters: 
	 * str - string to display
	 * delay - optional delay in milliseconds
	 */
	public function display(str:String, delay:Number) {
		
		cancel();

		if(delay==null) delay = _defaultDelay;
		_displayText = str;		
		_displayArgs = new Array();
		for(var n=2; n<arguments.length; n++) _displayArgs.push(arguments[n]);
				
		if(delay==0) {
			doDisplay();
		} else {
			_displayInt = setInterval(this, "doDisplay", delay);
		}	
	}
	
	/*
 	 * Function: cancel
	 * 
	 * Hides tooltip with an optional delay.  
	 * 
	 * Paremeters: 
	 * hideDelay - milliseconds to wait before hiding tooltip
	 */
	public function cancel(hideDelay:Number) {
		// clear interval to prevent tooltip from showing if it hasn't yet
		clearInterval(_displayInt);
		
		// (even if there is a delayed hide, we should follow the mouse)
		stopFollowingMouse();
		
		if(hideDelay==0 || hideDelay==null) {
			doCancel();
		} else {
			_displayInt = setInterval( this, 'doCancel', hideDelay);
		}
	}
	

	
	private function doDisplay() {
		clearInterval(_displayInt);
	
		_visible = true;
		
		drawText();		
		drawBackground();		
			
		startFollowingMouse();
	}
	
	private function drawText() {
		//create a textfield, remove if already exists
		var txtDepth = getInstanceAtDepth(10) ? 11 : 10;
		if( tooltip_txt ) tooltip_txt.removeTextField();
		
		createTextField('tooltip_txt_' + txtDepth, txtDepth, 2,-1, 100, 16 );
		tooltip_txt = this['tooltip_txt_' + txtDepth];
		tooltip_txt.html = true;
		tooltip_txt.selectable = false;
		tooltip_txt.htmlText = _displayText;
		tooltip_txt.autoSize = true;
		tooltip_txt.setNewTextFormat( textFormat );	
		tooltip_txt.autoSize = true;
		tooltip_txt.embedFonts = _style.embedFonts;
		tooltip_txt.textColor = _style.color;
		tooltip_txt.wordWrap = tooltip_txt.multiline = false;
		
		
	}
	
	private function drawBackground() {	
		
		var w =  Math.round(tooltip_txt.textWidth + 8);
		var h =  Math.round(tooltip_txt.textHeight + 2);
	
		createEmptyMovieClip('shadow_mc', 2);
		createEmptyMovieClip('bg_mc', 3);
		createEmptyMovieClip('border_mc', 4);

		Draw.outline(border_mc, w, h, _style.borderColor, 1, 100);
		Draw.fill( bg_mc, w, h, _style.backgroundColor, 100);
		Draw.fill( shadow_mc, w, h, 0x000000, 50);
		shadow_mc._x = shadow_mc._y = 1;
		
	}	
	
	function doCancel() {
		clearInterval( _followInt );
		
		// hide clip
		_visible = false;
		
		// clear text
		tooltip_txt.removeTextField();
		tooltip_txt = null;
	}
	
	function get textFormat() : TextFormat {
		var fmt:TextFormat = new TextFormat();
		fmt.font = _style.fontFamily;
		fmt.size = _style.fontSize;
		fmt.italic = (_style.fontStyle == 'italic');
		fmt.bold = (_style.fontWeight=='bold');
		fmt.color = _style.color;	
		return fmt;
	}
	
	function updatePosition() {
		this._x = Math.round( Math.min(this._parent._xmouse + 10, Stage.width - this._width));
		this._y = Math.round( Math.max(this._parent._ymouse - this._height - 10, 0));
		updateAfterEvent();
	}
	
	function startFollowingMouse() {
		clearInterval( _followInt );
		_followInt = setInterval( this, 'updatePosition', 30);
		updatePosition();
	}
	
	function stopFollowingMouse() {
		clearInterval( _followInt );
	}

	
	
}


