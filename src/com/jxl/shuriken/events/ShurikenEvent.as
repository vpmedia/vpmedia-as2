import com.jxl.shuriken.events.Event;
import com.jxl.shuriken.core.UIComponent;
import com.jxl.shuriken.containers.List;
import com.jxl.shuriken.controls.RadioButton;

class com.jxl.shuriken.events.ShurikenEvent extends Event
{
	public function ShurikenEvent(p_type:String, p_target:Object)
	{
		super(p_type, p_target);
	}
	
	// UIComponent
	public static var SIZE:String 									= "com.jxl.shuriken.events.ShurikenEvent.size";
	
	// Container
	public static var CHILD_CREATED:String 							= "com.jxl.shuriken.events.ShurikenEvent.childCreated";
	public static var CHILD_INDEX_CHANGED:String 					= "com.jxl.shuriken.events.ShurikenEvent.childIndexChanged";
	public static var CHILD_BEFORE_REMOVED:String 					= "com.jxl.shuriken.events.ShurikenEvent.beforeChildRemoved";
	public static var CHILD_REMOVED:String 							= "com.jxl.shuriken.events.ShurikenEvent.childRemoved";
	public static var BEFORE_ALL_CHILDREN_REMOVED:String 			= "com.jxl.shuriken.events.ShurikenEvent.beforeAllChildrenRemoved";
	public static var ALL_CHILDREN_REMOVED:String 					= "com.jxl.shuriken.events.ShurikenEvent.allChildrenRemoved";
	
	public var child:UIComponent;
	public var index:Number;
	public var oldIndex:Number;
	public var newIndex:Number;
	
	// Collection
	public static var COLLECTION_CHANGED:String 					= "com.jxl.shuriken.events.ShurikenEvent.collectionChanged";
	
	// operations
	public static var ADD:String 									= "com.jxl.shuriken.events.ShurikenEvent.add";
	public static var REMOVE:String 								= "com.jxl.shuriken.events.ShurikenEvent.remove";
	public static var UPDATE:String 								= "com.jxl.shuriken.events.ShurikenEvent.update";
	public static var UPDATE_ALL:String								= "com.jxl.shuriken.events.ShurikenEvent.updateAll";
	public static var REPLACE:String 								= "com.jxl.shuriken.events.ShurikenEvent.replace";
	public static var REMOVE_ALL:String 							= "com.jxl.shuriken.events.ShurikenEvent.removeAll";
	
	public var operation:String;
	
	// Loader
	public static var LOAD_COMPLETE:String							= "com.jxl.shuriken.events.ShurikenEvent.loadComplete";
	public static var LOAD_INIT:String								= "com.jxl.shuriken.events.ShurikenEvent.loadInit";
	
	public var loaderTarget:MovieClip;
	public var httpStatus:String;
	
	// SimpleButton
	public static var PRESS:String									= "com.jxl.shuriken.events.ShurikenEvent.press";
	public static var RELEASE:String								= "com.jxl.shuriken.events.ShurikenEvent.release";
	public static var RELEASE_OUTSIDE:String						= "com.jxl.shuriken.events.ShurikenEvent.releaseOutside";
	public static var ROLL_OVER:String								= "com.jxl.shuriken.events.ShurikenEvent.rollOver";
	public static var ROLL_OUT:String								= "com.jxl.shuriken.events.ShurikenEvent.rollOut";
	public static var MOUSE_DOWN_OUTSIDE:String						= "com.jxl.shuriken.events.ShurikenEvent.mouseDownOutside";
	
	// Button
	public static var SELECTION_CHANGED:String						= "com.jxl.shuriken.events.ShurikenEvent.selectionChanged";

	// List
	public static var COLUMN_WIDTH_CHANGED:String 				 	=  "com.jxl.shuriken.events.ShurikenEvent.columnWidthChanged";
	public static var ROW_HEIGHT_CHANGED:String						=  "com.jxl.shuriken.events.ShurikenEvent.rowHeightChanged";
	public static var SETUP_CHILD:String							=  "com.jxl.shuriken.events.ShurikenEvent.setupChild";
	
	public var list:List;
	// below already included in Container
	// public var child:UIComponent;
	
	// TweenComponent
	public static var EFFECT_MOVE_START:String						=  "com.jxl.shuriken.events.ShurikenEvent.effectMoveStart";
	public static var EFFECT_MOVE_END:String						=  "com.jxl.shuriken.events.ShurikenEvent.effectMoveEnd";
	public static var EFFECT_SIZE_START:String						=  "com.jxl.shuriken.events.ShurikenEvent.effectSizeStart";
	public static var EFFECT_SIZE_END:String						=  "com.jxl.shuriken.events.ShurikenEvent.effectSizeEnd";

	// ScrollableList
	public static var ITEM_CLICKED:String							= "com.jxl.shuriken.events.ShurikenEvent.itemClicked";
	public static var ITEM_SELECTION_CHANGED:String					= "com.jxl.shuriken.events.ShurikenEvent.itemSelectionChanged";
	
	public var item:Object;
	public var lastSelected:UIComponent;
	public var selected:UIComponent;
	
	// ButtonBar
	public static var ITEM_ROLL_OVER:String							= "com.jxl.shuriken.events.ShurikenEvent.itemRollOver";

	// RadioButtonGroup
	public static var RADIO_BUTTON_CLICKED:String 					= "com.jxl.shuriken.events.ShurikenEvent.radioButtonClicked";
	
	// NOTE: if not using RadioButton, comment out
	// for filesize & RAM savings
	public var radioButton:RadioButton;
	// NOTE: if not using RadioButton, comment out
	// for filesize & RAM savings
	public var lastRadioButton:RadioButton;
	public var lastIndex:Number;
	
	// MovieClipBuilderTicketVO
	//public static var MOVIE_CLIP_CREATED:String 					= "com.jxl.shuriken.events.ShurikenEvent.movieClipCreated";
	
	// MovieClipBuilderGroup
	//public static var MOVIE_CLIPS_CREATED:String					= "com.jxl.shuriken.events.ShurikenEvent.movieClipsCreated";

	// MDArray, NumericStepper
	public static var CHANGE:String 								= "com.jxl.shuriken.events.ShurikenEvent.change";

	public var row:Number;
	public var col:Number;
	public var value;
	
	public var oldValue;
}