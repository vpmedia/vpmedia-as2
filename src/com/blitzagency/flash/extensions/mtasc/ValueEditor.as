// ** AUTO-UI IMPORT STATEMENTS **
import mx.controls.Button;
import mx.controls.TextInput;
import mx.containers.Window;
// ** END AUTO-UI IMPORT STATEMENTS **
import mx.utils.Delegate;
import mx.events.EventDispatcher;
class com.blitzagency.flash.extensions.mtasc.ValueEditor extends MovieClip {
// Constants:
	public static var CLASS_REF = com.blitzagency.flash.extensions.mtasc.ValueEditor;
	public static var LINKAGE_ID:String = "com.blitzagency.flash.extensions.mtasc.ValueEditor";
// Public Properties:
public var addEventListener:Function;	
	public var removeEventListener:Function;
// Private Properties:
	private var dispatchEvent:Function;
	private var formLocation:MovieClip;
	private var caller:Object;
// UI Elements:

// ** AUTO-UI ELEMENTS **
	private var cancel:Button;
	private var confirm:Button;
	private var hiddenBG:Button;
	private var value:TextInput;
	private var window:Window;
// ** END AUTO-UI ELEMENTS **

// Initialization:
	private function ValueEditor() {EventDispatcher.initialize(this)}
	private function onLoad():Void { configUI(); }

// Public Methods:
	public function hide():Void
	{
		_visible = false;
	}
	
	public function show(obj:Object):Void
	{
		window.title = obj.action != undefined ? obj.action : "New";
		value.text = obj.value != undefined ? obj.value : "";
		_visible = true;
	}
// Semi-Private Methods:
// Private Methods:
	public function configUI():Void 
	{
		window.onRelease = undefined;
		
		confirm.addEventListener("click", Delegate.create(this, doConfirm));
		cancel.addEventListener("click", Delegate.create(this, doCancel));	
		
		hide();
	}
	
	private function doCancel():Void 
	{
		hide();
	}

	/**
	* @method doConfirm
	* @return Void
	*/
	private function doConfirm():Void 
	{
		hide();
		dispatchEvent({type:"onDoConfirm", value:value.text, action:window.title});
	}
	
	function registerFormLocation(p_formLocation:MovieClip):Void 
	{
		formLocation = p_formLocation;
	}
}