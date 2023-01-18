// ** AUTO-UI IMPORT STATEMENTS **
// ** END AUTO-UI IMPORT STATEMENTS **
import mx.events.EventDispatcher;
import mx.utils.Delegate;
import com.blitzagency.xray.ui.Tooltip;
import com.blitzagency.flash.extensions.mtasc.Help;

class com.blitzagency.flash.extensions.mtasc.controls.IconButton extends Help {
// Constants:
	public static var CLASS_REF = com.blitzagency.flash.extensions.mtasc.controls.IconButton;
	public static var LINKAGE_ID:String = "com.blitzagency.flash.extensions.mtasc.controls.IconButton";
// Public Properties:
	public var addEventListener:Function;
	public var removeEventListener:Function;
	public var message:String = "Set Tool Tip";
// Private Properties:
	private var dispatchEvent:Function;
// UI Elements:

// ** AUTO-UI ELEMENTS **
// ** END AUTO-UI ELEMENTS **

// Initialization:
	private function IconButton() {EventDispatcher.initialize(this);}
	private function onLoad():Void { configUI(); }

// Public Methods:
// Semi-Private Methods:
// Private Methods:
	private function configUI():Void 
	{
		onRelease = Delegate.create(this, onClickHandler);
		onRollOver = Delegate.create(this, onRollOverHandler);
		onRollOut = Delegate.create(this, onRollOutHandler);
	}
	
	private function onClickHandler():Void
	{
		Tooltip.hide();
		dispatchEvent({type:"click"});
	}
	
	private function onRollOverHandler():Void
	{
		Tooltip.show(message);
		dispatchEvent({type:"rollOver"});
	}
	
	private function onRollOutHandler():Void
	{
		Tooltip.hide();
		dispatchEvent({type:"rollOut"});
	}

}