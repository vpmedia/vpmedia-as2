// ** AUTO-UI IMPORT STATEMENTS **
import mx.controls.List;
import com.blitzagency.flash.extensions.mtasc.HarvestClasses;
import com.blitzagency.flash.extensions.mtasc.Help;
import mx.controls.Button;
import com.blitzagency.flash.extensions.mtasc.controls.IconButton;
import mx.controls.TextInput;
import mx.controls.CheckBox;
import mx.controls.Label;
import mx.containers.Window;
// ** END AUTO-UI IMPORT STATEMENTS **
import mx.utils.Delegate;
import com.blitzagency.flash.extensions.mtasc.SOManager;
import com.blitzagency.flash.extensions.mtasc.AssetLocator;
import com.blitzagency.xray.ui.Tooltip;
import com.blitzagency.util.SimpleDialog;
import com.blitzagency.util.ConfirmationDialog;
import com.blitzagency.flash.extensions.mtasc.MainContainer;

class com.blitzagency.flash.extensions.mtasc.Preferences extends MovieClip {
// Constants:
	public static var CLASS_REF = com.blitzagency.flash.extensions.mtasc.Preferences;
	public static var LINKAGE_ID:String = "com.blitzagency.flash.extensions.mtasc.Preferences";
// Public Properties:
// Private Properties:
	private var formLocation:MovieClip;
	private var alert:SimpleDialog;
	private var confirmation:ConfirmationDialog;
// UI Elements:

// ** AUTO-UI ELEMENTS **
	private var addClassPath:IconButton;
	private var cancel:Button;
	private var classList:List;
	private var classPathsLabel:Label;
	private var confirm:Button;
	private var customParms:TextInput;
	private var customStringLabel:Label;
	private var customStringsHelp:Help;
	private var flashClassesLocation:TextInput;
	private var flashClassesLocator:IconButton;
	private var harvestClasses:HarvestClasses;
	private var hiddenBG:Button;
	private var mtascLabel:Label;
	private var mtascLocation:TextInput;
	private var mtascLocator:IconButton;
	//private var pauseConsole:CheckBox;
	private var removeClassPath:IconButton;
	private var showMtascTags:Button;
	private var targetPath:Button;
	private var traceHelp:Help;
	private var traceMethod:TextInput;
	private var traceMethodLabel:Label;
	private var window:Window;
// ** END AUTO-UI ELEMENTS **

// Initialization:
	private function Preferences() {}
	private function onLoad():Void {}

// Public Methods:
	public function hide():Void
	{
		MainContainer.resetView();
		_visible = false;
	}
	
	public function show():Void
	{
		initClassPaths();
		_visible = true;
	}
	
	public function configUI():Void 
	{
		var location = SOManager.getMtascLocation() != undefined ? SOManager.getMtascLocation() : "select mtasc.exe location";
		mtascLocation.text = location;
		
		var flashLocation = SOManager.getFlashClassesLocation() != undefined ? SOManager.getFlashClassesLocation() : "select core Flash classes location";
		flashClassesLocation.text = flashLocation;
		//trace("Preferences.flashLocation :: " + flashLocation + " :: "+ flashLocation.length);
		if(flashLocation == "select core Flash classes location" || flashLocation.length <= 0) checkBaseIDEClassPath();
		updateFlashClassesLocation();
		
		//pauseConsole.selected = SOManager.getPauseConsole();
		
		initClassPaths();
		
		traceMethod.text = SOManager.getTraceMethod() != undefined ? SOManager.getTraceMethod() : "trace method";
		customParms.text = SOManager.getCustomParms() != undefined ? SOManager.getCustomParms() : "custom parms";
		
		showMtascTags.addEventListener("click", Delegate.create(formLocation, formLocation.showMtascTags));
		confirm.addEventListener("click", Delegate.create(this, doConfirm));
		cancel.addEventListener("click", Delegate.create(this, doCancel));
		
		mtascLocator.addEventListener("click", Delegate.create(this, locateMtasc));
		mtascLocator.message = "";
		mtascLocator.addEventListener("rollOver", Delegate.create(this, showMtascLocationTip));
		
		flashClassesLocator.addEventListener("click", Delegate.create(this, locateFlashClasses));
		flashClassesLocator.message = "";
		flashClassesLocator.addEventListener("rollOver", Delegate.create(this, showFlashLocationTip));
		
		
		addClassPath.addEventListener("click", Delegate.create(this, locateNewPath));
		addClassPath.message = "Add new class path";
		removeClassPath.addEventListener("click", Delegate.create(this, removeListItem));
		removeClassPath.message = "Remove selected class path";
		
		classList.addEventListener("itemRollOver", Delegate.create(this, listRollOver));
		classList.addEventListener("itemRollOut", Delegate.create(this, listRollOut));
		
		mtascLocation.addEventListener("change", Delegate.create(this, updateMtascLocation));
		flashClassesLocation.addEventListener("change", Delegate.create(this, updateFlashClassesLocation));
		traceMethod.addEventListener("change", Delegate.create(this, updateTraceMethod));
		customParms.addEventListener("change", Delegate.create(this, updateCustomParms));
		
		
		traceHelp.onRollOver = Delegate.create(this, showTraceHelp);
		customStringsHelp.onRollOver = Delegate.create(this, showCustomStringsHelp);
		
		window.addEventListener("click", Delegate.create(this, closeWindow));
		//window.onRelease = undefined;
		
		//pauseConsole.addEventListener("click", Delegate.create(this, setPauseConsole));
		

		mtascLocation.tabIndex = 1;
		flashClassesLocation.tabIndex = 2;
		traceMethod.tabIndex = 3;
		customParms.tabIndex = 4;
		showMtascTags.tabIndex = 5;
		//pauseConsole.tabIndex = 6;
		confirm.tabIndex = 6;
		
		

		hide();
	}
// Semi-Private Methods:
// Private Methods:

	private function initClassPaths():Void
	{
		classList.dataProvider = SOManager.getClassPaths();
	}
	
	private function checkBaseIDEClassPath():Void
	{
		var configURI = MMExecute("fl.configURI");
		var path:String = AssetLocator.cleanPath(unescape(configURI + "Classes"));
		var exists:Boolean = checkPathDuplicates(path);
		if(!exists)
		{
			//classList.addItem({label:path, data:path});
			flashClassesLocation.text = path;
			//updateClassPaths();
		}
	}
	
	private function closeWindow(evtObj:Object):Void
	{
		doConfirm();
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
	}
	
	/*
	private function setPauseConsole():Void
	{
		SOManager.setPauseConsole(pauseConsole.selected);
	}
	*/
	
	private function showTraceHelp():Void
	{
		traceHelp.showTip("Add a custom trace method.\nExample:\n\nXray.trace\nFlashout.traceReplacer");
	}
	
	private function showCustomStringsHelp():Void
	{
		customStringsHelp.showTip("Add a custom string parms.\nExample:\n\n -group");
	}
	
	private function locateNewPath():Void
	{
		listRollOut();
		var obj = AssetLocator.getFolderLocation();
		var exists:Boolean = checkPathDuplicates(unescape(obj.path));
		if(obj != null && !exists) 
		{
			classList.addItem({label:unescape(obj.path), data:unescape(obj.path)});
			updateClassPaths();
		}else if(exists)
		{
			alert.show("Class path already exists");
		}
	}
	
	private function checkPathDuplicates(p_path:String):Boolean
	{
		for(var i:Number=0;i<classList.length;i++)
		{
			var item = classList.getItemAt(i);
			if(item.label == p_path) return true;
		}
		
		return false;
	}
	
	private function removeListItem():Void
	{
		if(classList.selectedIndex == undefined) return;
		confirmation.show("Are you sure you want to remove this class path?");
	}
	
	private function updateMtascLocation():Void
	{
		SOManager.setMtascLocation(mtascLocation.text);
	}
	
	private function updateFlashClassesLocation():Void
	{
		SOManager.setFlashClassesLocation(flashClassesLocation.text);
	}
	
	private function updateClassPaths():Void
	{
		SOManager.setClassPaths(classList.dataProvider);
	}
	
	private function updateTraceMethod():Void
	{
		SOManager.setTraceMethod(traceMethod.text);
	}
	
	private function updateCustomParms():Void
	{
		SOManager.setCustomParms(customParms.text);
	}
	
	private function locateMtasc():Void
	{
		var obj = AssetLocator.getFileLocation();
		
		if(obj != null) 
		{
			mtascLocation.text = obj.path;
			SOManager.setMtascLocation(obj.path);
		}
	}
	
	private function locateFlashClasses():Void
	{
		var obj = AssetLocator.getFolderLocation();
		
		if(obj != null) 
		{
			flashClassesLocation.text = obj.path;
			SOManager.setFlashClassesLocation(obj.path);
		}
	}
	
	private function showMtascLocationTip():Void
	{
		var tip = mtascLocation.text;
		Tooltip.show(tip);
	}
	
	private function showFlashLocationTip():Void
	{
		var tip = flashClassesLocation.text;
		Tooltip.show(tip);
	}
	
	private function listRollOver(evtObj):Void
	{
		var item = classList.getItemAt(evtObj.index);
		if(item.label != undefined) 
		{
			var tip = item.data;
			Tooltip.show(tip);
		}
	}
	
	private function confirmationOnConfirm(evtObj:Object):Void
	{
		//_global.tt("confirmationOnConfirm", evtObj);
		if(evtObj.msg.indexOf("Are you sure you want to remove this class path") > -1)
		{
			classList.removeItemAt(classList.selectedIndex);
			updateClassPaths();
		}
	}
	
	private function listRollOut(evtObj):Void
	{
		Tooltip.hide();
	}

	public function registerFormLocation(p_formLocation:MovieClip):Void 
	{
		formLocation = p_formLocation;
	}
	
	public function registerAlert(p_confirmation:ConfirmationDialog, p_alert:SimpleDialog):Void
	{
		confirmation = p_confirmation;
		confirmation.addEventListener("onConfirm", Delegate.create(this, confirmationOnConfirm));
		
		alert = p_alert;
	}
}