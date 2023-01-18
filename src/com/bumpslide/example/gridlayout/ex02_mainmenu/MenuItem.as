import com.bumpslide.util.FTween;

/**
* Menu Item
* 
* _gridItemData and _gridItemIndex are given to us via 
* the initObj when this clip is attached by the GridLayout class
* 
* @author David Knape
*/
class MenuItem extends MovieClip {
		
	// our grid item index and data
	private var _gridIndex:Number;
	private var _gridItemData:Object;
		
	// timeline clips
	public var bg_mc:MovieClip;
	public var label_txt:TextField;
	
	// interval for delayed reveal
	private var _revealInt:Number = -1;
	
	// initialize offscreen so we can drop in to reveal ourselves
	function MenuItem() {
		_y = -50;
	}
	
	// onload, update our display
	private function onLoad() : Void {
		super.onLoad();
		update();
	}
	
	// updates the display for this clip
	public function update() : Void {
		
		// update our label and width
		label_txt.autoSize = true;
		label_txt.text = _gridItemData.toString();		
		
		bg_mc._width = Math.round( label_txt.textWidth + 12 );
		
		// reveal after delay
		setInterval( this, 'reveal', 500 + _gridIndex*250 );
	}
	
	// reveal with a springing motion
	private function reveal() {
		FTween.spring( this, '_y', 0 );
	}
	
	// button states...
	//--------------------
	
	// onRollOver - tween alpha to 70%
	function onRollOver() {
		FTween.ease(this, '_alpha', 70, .7);
	}
	
	// onRollOut - tween alpha to 100%
	function onRollOut() {
		FTween.ease(this, '_alpha', 100, .15);
	}
	
	function onReleaseOutside() {
		onRollOut();
	}
}