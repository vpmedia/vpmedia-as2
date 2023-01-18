import com.bumpslide.util.*;
import com.bumpslide.events.Event;

/**
 * A Simple button with selected and disabled states
 * as well as some simple focus management.
 * 
 * For dispatching ASAP Framework LocalController command events,
 * use CommandButton.
 *
 * @author David Knape  
 */

class com.bumpslide.ui.Button extends com.bumpslide.core.BaseClip 
{		
	// ASAP style buttons events
	public static var ON_ROLLOVER:String = "onEventButtonRollOver";
	public static var ON_ROLLOUT:String = "onEventButtonRollOut";
	public static var ON_PRESS:String = "onEventButtonPress";
	public static var ON_RELEASE:String = "onEventButtonRelease"; 	
	
	// Override these in a subclass to change frame labels
	// or, to get fancy, override the view state functions ... 
	// (_over(), _off(), _down(), _selected(), etc.)
	
	private var FRAME_OFF 			: String = "off";
	private var FRAME_OVER 			: String = "over";
	private var FRAME_SELECTED 		: String = "selected";
	private var FRAME_SELECTED_OVER : String = "selected_over";
	private var FRAME_DISABLED 		: String = "disabled";
	private var FRAME_DOWN 			: String = "down";
	
	
	private var mSelected:Boolean = false;
	private var mDisabled:Boolean = false;
	private var _focusListener:Object;
	
	// some common sub clips
	var label_txt:TextField;
	var bg_mc:MovieClip;
	private var mLabel:String;
	var centerLabel = false;
	
	/**
	* sets label text (assuming there is a label_txt)
	* 
	* @param	s
	*/
	function set label (s:String) {
		mLabel = s;
		label_txt.autoSize = true;
		label_txt.text = s;
		if(centerLabel) label_txt._x = Math.round((_width - label_txt.textWidth)/2);
	}
	
	/**
	* whether or not this button is in the selected state
	* @return
	*/
	public function get selected () : Boolean {
		return mSelected;
    }	
	
	/**
	* set this button as selected
	* 
	* puts the button in the selected state
	* 
	* @param	isSelected
	*/
	public function set selected (isSelected:Boolean) : Void {	
		//debug('selected=' + isSelected );
		mSelected = isSelected;
		if(isSelected) _selected();
		else _off();
		afterStateChange();
    }
    
	/**
	* disable this button
	* 
	* this is negative to differentiate from the enabled state in movieclips
	* 
	* @param	isDisabled
	*/
    public function set disabled (isDisabled:Boolean) : Void {
		
		var wasDisabled:Boolean = !enabled;
		
		enabled = !(mDisabled = isDisabled);
		
		if(mDisabled) {
			_disabled();
		} else {
			// if we were disabled, but now are not, then go to the off state
			if(wasDisabled) _off();	
		}		
		afterStateChange();		
    }
    
	/**
	* whether or not this button is disabled
	* @return
	*/
    public function get disabled () : Boolean {
		return mDisabled;
    }	
	
	/**
	* Shortcut to mName for backwards compatability
	* 
	* @return
	*/
	public function get buttonName() : String {
		return mName;
	}
		
	/**
	* Constructor - sets up our focus listener and enables tab support
	*/
	function Button() 
	{
		super();
		
		stop();
		
		//debug('New Button');
		
		_focusListener = new Object();
		_focusListener.onSetFocus = d( onFocusChanged );
		Selection.addListener( _focusListener );
		
		tabEnabled = true;
	}
		
	/**
	* on unload, remove focus and key listeners
	*/
	private function onUnload() : Void 
	{
		super.onUnload();
		
		Selection.removeListener( _focusListener );
		Key.removeListener( this );
	}
		
	/**
	* Selection.onSetFocus event listener
	* 
	* Checks to see whether or not this clip just received focus, and updates accordingly
	* 
	* @param	oldFocus
	* @param	newFocus
	*/
	private function onFocusChanged( oldFocus:Object, newFocus:Object ) {
		if(newFocus==this) {
			onFocus();
		} else {
			onBlur();
		}
	}
	
	/**
	* Fakes a rollover the moment we are focused, and starts listening
	* to key presses.
	*/
	private function onFocus() {
		//debug('focus' );
		onRollOver();
		Key.addListener( this );
	}
	
	/**
	* Fakes a rollover the moment we are no longer focused, and stops
	* listening to key presses.
	*/
	private function onBlur() {
		onRollOut();
		Key.removeListener( this );
	}
	
	/**
	* If button was focused, and enter was pushed, this function 
	* gets called to trigger an onRelease.
	*/
	private function onKeyDown() {
		if(Key.isDown(Key.ENTER) && enabled) {
			onRelease();
		}
	}
	
	public function onRelease() {
		super.onRelease();
		dispatchEvent( new Event( Button.ON_RELEASE, this, {buttonName:mName}) );
	}
	
	/**
	* onRollOver handler
	*/
	public function onRollOver () {
		if (mSelected) {
			_selected_over(); 
		} else {
			_over();	
		}
		afterStateChange();
		super.onRollOver();
		dispatchEvent( new Event( Button.ON_ROLLOVER, this, {buttonName:mName}) );
    }
    
	/**
	* onRollOut handler
	*/
    public function onRollOut () {
    	if (mSelected) { 
			_selected(); 
		} else {
			_off();
		}
		afterStateChange();
        super.onRollOut();
		dispatchEvent( new Event( Button.ON_ROLLOUT, this, {buttonName:mName}) );
    }
		
	/**
	* onPress handler
	*/
	public function onPress() {
		_down();
		afterStateChange();
		dispatchEvent( new Event( Button.ON_PRESS, this, {buttonName:mName}) );
	}
	
	/**
	* onReleaseOutside, just act as if we had rolled out
	*/
	public function onReleaseOutside () {
		onRollOut();
	}
	
	/**
	* onDragOver, do RollOver
	*/
	public function onDragOver () : Void {
		onRollOver();
	}

	/**
	* onDragOut, do RollOut
	*/
	public function onDragOut () : Void {
		//onRollOut();
	}
	
	/**
	* hook for programmatic updates (in subclass) on state changes
	*/
	function afterStateChange () {
		
	}
	
	// View states...
	
	function _off() {
		gotoAndStop(FRAME_OFF);
	}
	
	function _over() {
		gotoAndStop(FRAME_OVER);
	}
	
	function _selected() {
		gotoAndStop(FRAME_SELECTED);
	}
	
	function _selected_over() {
		gotoAndStop(FRAME_SELECTED_OVER);
	}
	
	function _disabled() {
		gotoAndStop(FRAME_DISABLED);
	}
	
	function _down() {
		gotoAndStop(FRAME_DOWN);
	}
		
	static function create(timeline:MovieClip, name:String, labelText:String ) : Button {
		if(labelText==null) labelText = "Click";
		var btn:Button = Button( timeline.createEmptyMovieClip( name, timeline.getNextHighestDepth() ) );
		ClassUtil.applyClassToObj( Button, btn );		
		Draw.box( btn.createEmptyMovieClip('bg_mc', 1), 200, 20, 0xdddddd, 100);
		btn._over = Delegate.create(btn, btn.colorizeBg, 0xeeeeee );
		btn._off = Delegate.create(btn, btn.colorizeBg, 0xdddddd );
		btn.createTextField( 'label_txt', 2, 4, 4, 200, 18 );
		btn.label_txt.setNewTextFormat( new TextFormat( 'Verdana', 10, 0x000000 ) );
		btn.label = labelText;
		return btn;
	}
	
	private function colorizeBg( hexColor:Number ) {
		var c:Color = new Color( this.bg_mc );
		c.setRGB( hexColor );		
	}
	
	
	

}