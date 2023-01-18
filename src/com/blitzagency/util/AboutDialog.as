// ** AUTO-UI IMPORT STATEMENTS **
import com.blitzagency.flash.extensions.mtasc.controls.IconButton;
// ** END AUTO-UI IMPORT STATEMENTS **
import mx.utils.Delegate;
//import mx.events.EventDispatcher;
import com.blitzagency.util.SimpleDialog;

class com.blitzagency.util.AboutDialog extends SimpleDialog {
// Constants:
	public static var CLASS_REF = com.blitzagency.util.AboutDialog;
	public static var LINKAGE_ID:String = "com.blitzagency.util.AboutDialog";
// Public Properties:
	//public var addEventListener:Function;
	//public var removeEventListener:Function;
// Private Properties:
	//private var dispatchEvent:Function;
// UI Elements:

// ** AUTO-UI ELEMENTS **
	private var logo:IconButton;
// ** END AUTO-UI ELEMENTS **

// Initialization:
	private function AboutDialog() 
	{
		super();
		//EventDispatcher.initialize(this)
	}
	private function onLoad():Void { super.configUI(); initUI(); }

// Public Methods:	
	private function initUI():Void
	{
		logo.addEventListener("click", Delegate.create(this, logoClick));
		logo.message = "Visit Blitzagency.com";
	}
	
	private function logoClick(evtObj:Object):Void
	{
		getURL("http://www.blitzagency.com", "_blank");
	}
}