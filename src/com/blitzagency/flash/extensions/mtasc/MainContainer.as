// ** AUTO-UI IMPORT STATEMENTS **
import mx.containers.ScrollPane;
// ** END AUTO-UI IMPORT STATEMENTS **

class com.blitzagency.flash.extensions.mtasc.MainContainer extends MovieClip {
// Constants:
	public static var CLASS_REF = com.blitzagency.flash.extensions.mtasc.MainContainer;
	public static var LINKAGE_ID:String = "com.blitzagency.flash.extensions.mtasc.MainContainer";
	public static var _instance:MovieClip;
// Public Properties:
// Private Properties:
// UI Elements:

// ** AUTO-UI ELEMENTS **
	private var scrollPane:ScrollPane;
// ** END AUTO-UI ELEMENTS **

// Initialization:
	private function MainContainer() {}
	private function onLoad():Void { configUI(); }

// Public Methods:
// Semi-Private Methods:
// Private Methods:
	private function configUI():Void 
	{
		_instance = this;
		
		Stage.align = "TL";
		Stage.addListener(this);

		onResize();
	}
	
	public function onResize():Void
	{
		scrollPane.setSize(Stage.width, Stage.height);
	}
	
	public static function resetView():Void
	{
		MainContainer._instance.scrollPane.vPosition = 0;
	}
}