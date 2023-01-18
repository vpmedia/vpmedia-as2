// ** AUTO-UI IMPORT STATEMENTS **
import com.blitzagency.flash.extensions.mtasc.MtascTags;
import com.blitzagency.flash.extensions.mtasc.BatchPrefs;
import com.blitzagency.flash.extensions.mtasc.ItemPrefs;
import com.blitzagency.flash.extensions.mtasc.Preferences;
import com.blitzagency.flash.extensions.mtasc.MtascBatch;
import com.blitzagency.flash.extensions.mtasc.ValueEditor;
// ** END AUTO-UI IMPORT STATEMENTS **
//import mx.utils.Delegate;
import com.blitzagency.util.ConfirmationDialog;
import com.blitzagency.util.SimpleDialog;
import mx.utils.Delegate;
import com.blitzagency.xray.util.XrayLoader
import com.blitzagency.flash.extensions.mtasc.SOManager;
import com.blitzagency.flash.extensions.mtasc.Compiler;
import com.blitzagency.xray.ui.Tooltip;
import com.blitzagency.flash.extensions.mtasc.ImportExport;

class com.blitzagency.flash.extensions.mtasc.Main extends MovieClip {
// Constants:
	public static var CLASS_REF = com.blitzagency.flash.extensions.mtasc.Main;
	public static var LINKAGE_ID:String = "com.blitzagency.flash.extensions.mtasc.Main";
// Public Properties:
	public var alert:SimpleDialog;
	public var confirmation:ConfirmationDialog;
// Private Properties:
// UI Elements:

// ** AUTO-UI ELEMENTS **
	private var about:SimpleDialog;	
	private var batchPrefs:BatchPrefs;
	private var itemPrefs:ItemPrefs;
	private var mtascBatch:MtascBatch;
	private var mtascTags:MtascTags;
	private var preferences:Preferences;
	private var valueEditor:ValueEditor;
// ** END AUTO-UI ELEMENTS **

// Initialization:
	private function Main() {}
	private function onLoad():Void { configUI(); }

// Public Methods:
// Semi-Private Methods:
// Private Methods:
	private function configUI():Void 
	{
		//System.useCodepage = true;
		_level0._quality = "best";
		
		mx.styles.StyleManager.registerColorName("special_blue", 0xADD6FD);

		_global.style.setStyle ("themeColor", "special_blue");
		_global.style.setStyle("fontFamily", "_sans");
		_global.style.setStyle("fontSize", 10);

		SOManager.initManager();
		XrayLoader.loadConnector("xray.swf");
		Tooltip.options = {size:9, font:"_sans", corner:0}
		
		mtascTags.registerFormLocation(this);
		preferences.registerFormLocation(this);
		itemPrefs.registerFormLocation(this);
		batchPrefs.registerFormLocation(this);
		
		mtascBatch.registerFormLocation(this);
		mtascBatch.registerItemPrefs(itemPrefs);
		mtascBatch.registerAlert(confirmation, alert);
		mtascBatch.registerValueEditor(valueEditor);
		
		Compiler.registerAlert(alert);
		ImportExport.registerAlert(alert);
		itemPrefs.registerAlert(confirmation, alert);
		preferences.registerAlert(confirmation, alert);
		
		itemPrefs.registerValueEditor(valueEditor);
		itemPrefs.registerMtascTags(mtascTags);
		
		mtascBatch.addEventListener("onNewBatch", Delegate.create(this, showBatchPrefs));
		mtascBatch.addEventListener("onShowPrefs", Delegate.create(this, showPrefs))
		mtascBatch.addEventListener("onShowMtascTags", Delegate.create(this, showMtascTags));
		mtascBatch.addEventListener("onShowAbout", Delegate.create(this, showAbout));
		mtascBatch.addEventListener("onShowHelp", Delegate.create(this, showHelp));
		
		batchPrefs.addEventListener("onDoConfirm", Delegate.create(mtascBatch, mtascBatch.createNewBatch));
		
		mtascBatch.configUI();
		preferences.configUI();
		
	}
	
	private function showBatchPrefs(evtObj:Object):Void
	{
		batchPrefs.show();
	}
	
	private function showPrefs():Void
	{
		preferences.show();
	}
	
	private function showHelp():Void
	{
		getURL("http://www.osflash.org/flasc", "_blank");
	}
	
	private function showAbout():Void
	{
		about.show();
	}
	
	private function showMtascTags(p_returnValues:Object):Void
	{
		mtascTags.show(p_returnValues);
	}
	
	private function addFile():Void
	{
		itemPrefs.show();
	}
}