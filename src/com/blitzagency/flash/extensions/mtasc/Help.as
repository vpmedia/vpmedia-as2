// ** AUTO-UI IMPORT STATEMENTS **
// ** END AUTO-UI IMPORT STATEMENTS **
import com.blitzagency.xray.ui.Tooltip;
import mx.utils.Delegate;
class com.blitzagency.flash.extensions.mtasc.Help extends MovieClip {
// Constants:
	public static var CLASS_REF = com.blitzagency.flash.extensions.mtasc.Help;
	public static var LINKAGE_ID:String = "com.blitzagency.flash.extensions.mtasc.Help";
// Public Properties:
// Private Properties:
// UI Elements:

// ** AUTO-UI ELEMENTS **
// ** END AUTO-UI ELEMENTS **

// Initialization:
	private function Help() {}
	private function onLoad():Void { configUI(); }

// Public Methods:
	public function showTip(p_tip:String):Void
	{
		Tooltip.show(p_tip);
	}
	
	public function hideTip():Void
	{
		Tooltip.hide();
	}
// Semi-Private Methods:
// Private Methods:
	private function configUI():Void 
	{
		onRollOut = Delegate.create(this, hideTip);
	}
}