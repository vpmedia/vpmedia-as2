
/**
* Simple Grid Item 
* 
* _gridItemData and _gridItemIndex are given to us via 
* the initObj when this clip is attached by the GridLayout class
* 
* @author David Knape
*/
class GridItem extends MovieClip {
		
	// our grid item index and data
	private var _gridIndex:Number;
	private var _gridItemData:Object;
	private var _gridPosition:Number;
	// timeline clips
	public var bg_mc:MovieClip;
	public var label_txt:TextField;
	public var position_txt:TextField;
	
	// onload, update our display
	private function onLoad() : Void {
		super.onLoad();
		update();
	}
	
	// updates the display for this clip
	public function update() : Void {
		
		// display our index position
		label_txt.text = _gridItemData.name;
		position_txt.text = ""+_gridPosition;
	}
}