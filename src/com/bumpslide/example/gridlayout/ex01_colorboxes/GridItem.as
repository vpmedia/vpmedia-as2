
/**
* Simple Grid Item 
* 
* _gridItemData and _gridIndex are given to us via 
* the initObj when this clip is attached by the GridLayout class
* 
* @author David Knape
*/
class GridItem extends MovieClip {
		
	// our grid item index and data
	private var _gridIndex:Number;
	private var _gridItemData:Object;
		
	// timeline clips
	public var box_mc:MovieClip;
	public var index_txt:TextField;
	
	// onload, update our display
	private function onLoad() : Void {
		super.onLoad();
		update();
	}
	
	// updates the display for this clip
	public function update() : Void {
		
		// display our index position
		index_txt.text = "Index #"+_gridIndex;		
				
		// colorize our box using this value
		var c:Color = new Color( box_mc );
		c.setRGB( Number(_gridItemData) );
	}
}