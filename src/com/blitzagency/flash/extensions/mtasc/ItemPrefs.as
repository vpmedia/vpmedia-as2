// ** AUTO-UI IMPORT STATEMENTS **
import mx.controls.CheckBox;
import com.blitzagency.flash.extensions.mtasc.Help;
import mx.controls.NumericStepper;
import com.blitzagency.flash.extensions.mtasc.controls.AddPackage;
import com.blitzagency.flash.extensions.mtasc.controls.AddFile;
import com.blitzagency.flash.extensions.mtasc.controls.IconButton;
import com.blitzagency.flash.extensions.mtasc.HarvestClasses;
import com.blitzagency.flash.extensions.mtasc.controls.RemoveAll;
import com.blitzagency.flash.extensions.mtasc.controls.Remove;
import mx.controls.Button;
import mx.controls.List;
import mx.controls.TextInput;
import mx.containers.Window;
// ** END AUTO-UI IMPORT STATEMENTS **
import mx.utils.Delegate;
import mx.events.EventDispatcher;
import com.blitzagency.flash.extensions.mtasc.AssetLocator;
import com.blitzagency.xray.ui.Tooltip; 
import com.blitzagency.util.SimpleDialog;
import com.blitzagency.util.ConfirmationDialog;
import com.blitzagency.flash.extensions.mtasc.MainContainer;
import com.blitzagency.flash.extensions.mtasc.SOManager;
import com.blitzagency.flash.extensions.mtasc.ValueEditor;
import com.blitzagency.flash.extensions.mtasc.MtascTags;
import mx.controls.listclasses.DataProvider;

class com.blitzagency.flash.extensions.mtasc.ItemPrefs extends MovieClip {
// Constants:
	public static var CLASS_REF = com.blitzagency.flash.extensions.mtasc.ItemPrefs;
	public static var LINKAGE_ID:String = "com.blitzagency.flash.extensions.mtasc.ItemPrefs";
// Public Properties:
	public var addEventListener:Function;
	public var removeEventListener:Function;
// Private Properties:
	private var dispatchEvent:Function;
	private var formLocation:MovieClip;
	private var currentMtascTags:Object;
	private var editMode:Boolean;
	private var alert:SimpleDialog;
	private var confirmation:ConfirmationDialog;
	//private var baseClassLocation:Array;
	private var valueEditor:ValueEditor;
	private var mtascTagsEditor:MtascTags;
	private var packagesToAdd:Array;
	private var processQueSI:Number; // interval for adding class packs
// UI Elements:

// ** AUTO-UI ELEMENTS **
	private var addClassPath:IconButton;
	private var addFile:AddFile;
	private var addPackage:AddPackage;
	private var batchFile:TextInput;
	private var browseForBatchFile:IconButton;
	private var browseForOutput:IconButton;
	private var browseForSWF:IconButton;
	private var cancel:Button;
	private var classList:List;
	private var classReferenceHelp:Help;
	private var cleanName:TextInput;
	private var confirm:Button;
	private var existingSWF:CheckBox;
	private var FPS:NumericStepper;
	private var harvestClasses:HarvestClasses;
	private var hiddenBG:Button;
	private var launch:CheckBox;
	private var outputPath:TextInput;
	private var removeAll:RemoveAll;
	private var removeItem:Remove;
	private var setHeader:CheckBox;
	private var showMtascTags:Button;
	private var swf:TextInput;
	private var swfHeight:NumericStepper;
	private var swfWidth:NumericStepper;
	private var version:NumericStepper;
	private var window:Window;
// ** END AUTO-UI ELEMENTS **

// Initialization:
	private function ItemPrefs() {EventDispatcher.initialize(this);}
	private function onLoad():Void { configUI(); }

// Public Methods:
	public function hide():Void
	{
		MainContainer.resetView();
		editMode = false;
		_visible = false;
	}
	
	public function show(p_prefs):Void
	{
		//if(p_prefs.target._name != "addFile")
		if(p_prefs != undefined)
		{
			//_global.tt("what's the classpath on import?", p_prefs.data.classList);
			editMode = true;
			swf.text = p_prefs.data.swf != undefined ? p_prefs.data.swf : "" ;
			outputPath.text = p_prefs.data.outputPath != undefined ? p_prefs.data.outputPath : "" ;
			classList.removeAll();
			if(p_prefs.data.classList != undefined) processClassList(p_prefs.data.classList);
			if(p_prefs.data.classList == undefined) classList.dataProvider = new Array();
			//classList.dataProvider = p_prefs.data.classList != undefined ? p_prefs.data.classList : new Array();
			//baseClassLocation = p_prefs.data.baseClassLocation;
			//validateClassPaths();
			cleanName.text = p_prefs.data.cleanName;
			launch.selected = p_prefs.data.launchAfterPublish;
			swfWidth.value = p_prefs.data.swfWidth;
			swfHeight.value = p_prefs.data.swfHeight;
			FPS.value = p_prefs.data.fps;
			version.value = p_prefs.data.version;
			setHeader.selected = p_prefs.data.setHeader;
			existingSWF.selected = p_prefs.data.existingSWF;
			batchFile.text = p_prefs.data.batchFile != undefined ? p_prefs.data.batchFile : "";
			handleHeader();
			window.title = cleanName.text + " Preferences";
			currentMtascTags = p_prefs.data.MtascTags;
		}else
		{
			editMode = false;
			cleanName.text = "";
			swf.text = "";
			outputPath.text = "";
			batchFile.text = "";
			//baseClassLocation = new Array();
			//classPath.text = "";
			currentMtascTags = undefined;
			classList.dataProvider = new Array();
			existingSWF.selected = false;
			handleHeader();
			window.title = "SWF Preferences";
		}   

		handleExistingSWF();
		
		_visible = true;
	}
// Semi-Private Methods:
// Private Methods:
	private function configUI():Void 
	{
		confirm.addEventListener("click", Delegate.create(this, doConfirm));
		cancel.addEventListener("click", Delegate.create(this, hide));
		
		classList.addEventListener("itemRollOver", Delegate.create(this, listRollOver));
		classList.addEventListener("itemRollOut", Delegate.create(this, listRollOut));
		
		//harvestClasses.addEventListener("click", Delegate.create(this, browseClassLocation));
		
		addFile.addEventListener("click", Delegate.create(this, locateNewPath));
		addClassPath.addEventListener("click", Delegate.create(this, browseClassPathLocation));
		addClassPath.message = "Add new class path";
		addPackage.addEventListener("click", Delegate.create(this, browseClassLocation));
		removeItem.addEventListener("click", Delegate.create(this, removeListItem));
		removeAll.addEventListener("click", Delegate.create(this, removeAllItems));
		
		browseForOutput.addEventListener("click", Delegate.create(this, browseOutputLocation));
		browseForOutput.message = "";
		browseForOutput.addEventListener("rollOver", Delegate.create(this, showOutputToolTip));
		
		browseForSWF.addEventListener("click", Delegate.create(this, browseSWFLocation));
		browseForSWF.message = "";
		browseForSWF.addEventListener("rollOver", Delegate.create(this, showSWFToolTip));
		
		if(System.capabilities.os.indexOf("Win") > -1)
		{
			browseForBatchFile.addEventListener("click", Delegate.create(this, browseBatchLocation));
			browseForBatchFile.message = "";
			browseForBatchFile.addEventListener("rollOver", Delegate.create(this, showBatchFileToolTip));
		}else
		{
			browseForBatchFile.message = "Disabled";
		}
		showMtascTags.addEventListener("click", Delegate.create(this, getMtascTags));
		setHeader.addEventListener("click", Delegate.create(this, handleHeader));
		existingSWF.addEventListener("click", Delegate.create(this, handleExistingSWF));
		
		window.addEventListener("click", Delegate.create(this, closeWindow));
		//window.onRelease = undefined;
		
		classReferenceHelp.onRollOver = Delegate.create(this, showClassReferenceHelp);
		
		//baseClassLocation = new Array();
		
		
		
		cleanName.tabIndex = 1;
		swf.tabIndex = 2;
		browseForSWF.tabIndex = 3;
		outputPath.tabIndex = 4;
		browseForOutput.tabIndex = 5;
		setHeader.tabIndex = 6
		swfWidth.tabIndex = 7;
		swfHeight.tabIndex = 8;
		FPS.tabIndex = 9;
		showMtascTags.tabIndex = 10;
		version.tabIndex = 11;
		confirm.tabIndex = 12;
		cancel.tabIndex = 13;
		
		hide();
	}
	
	private function locateNewPath():Void
	{
		listRollOut();
		var obj = AssetLocator.getFileLocation();
		var exists:Boolean = checkPathDuplicates(unescape(obj.path));

		if(obj != null && !exists) 
		{
			addSingleFile(obj, "class");
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
	
	private function closeWindow(evtObj:Object):Void
	{
		confirmation.show("Would you like to save changes?");
	}
	
	/*
	private function validateClassPaths():Void
	{
		// the point of this is to validate the current class paths with the global ones.
		// if a user removes a class path from the global prefs, then it's invalid for use in the projects, and needs to be removed
		
		
		for(var i:Number=0;i<baseClassLocation.length;i++)
		{
			if(SOManager.getMatchingCPList(baseClassLocation[i]) == null)
			{
				// remove from baseClassPath
				baseClassLocation.splice(i,1);
			}
		}
	}
	*/
	
	/*
	private function checkBasePathDuplicates(p_path:String):Boolean
	{
		for(var i:Number=0;i<baseClassLocation.length;i++)
		{
			var item = baseClassLocation[i];
			if(item == p_path) return true;
		}
		
		return false;
	}
	*/
	
	private function clearList():Void
	{
		classList.dataProvider = new Array();
	}
	
	private function removeAllItems():Void
	{
		confirmation.show("Are you sure you want to delete all items?");
	}
	
	private function removeListItem():Void
	{
		confirmation.show("Are you sure you want to delete the selected item?");
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
	
	private function listRollOut(evtObj):Void
	{
		Tooltip.hide();
	}
	
	private function showClassReferenceHelp():Void
	{
		Tooltip.show("Add either class files, class path locations or packages.  If selecting a folder/package, it will be given the '-pack' switch in the MTASC command.  \n\nIf you haven't defined the BASE classes location for these files yet, you'll be prompted to add it as a global class path.");
	}
	
	private function showSWFToolTip(evtObj:Object):Void
	{		
		Tooltip.show(swf.text);
	}
	private function showOutputToolTip(evtObj:Object):Void
	{		
		Tooltip.show(outputPath.text);
	}
	private function showBatchFileToolTip(evtObj:Object):Void
	{		
		Tooltip.show(batchFile.text);
	}
	
	private function hideButtonToolTip():Void
	{
		Tooltip.hide();
	}
	
	private function handleHeader(evtObj:Object):Void
	{
		if(!setHeader.selected)
		{
			swfWidth.enabled = false;
			swfHeight.enabled = false;
			FPS.enabled = false;
		}else
		{
			swfWidth.enabled = true;
			swfHeight.enabled = true;
			FPS.enabled = true;
		}
	}
	
	private function handleExistingSWF():Void
	{
		swf.enabled = existingSWF.selected;
	}
	
	private function getMtascTags():Void
	{
		mtascTagsEditor.show({returnValues:true, MtascTags:currentMtascTags});
	}
	
	private function setMtascTags(evtObj:Object):Void
	{
		currentMtascTags = evtObj.tags;
	}
	
	private function processClassList(obj:Object):Void
	{			
		for(var items:String in obj)
		{
			if(items == "length") continue;
			classList.addItem(obj[items]);
		}
	}
	
	private function gatherClassList():Object
	{
		var dp = classList.dataProvider;
		var obj:Object = new Object();
		var count:Number = 0;
		
		for(var items:String in dp)
		{
			obj[items] = new Object();
			obj[items].label = dp[items].label;
			obj[items].data = dp[items].data;
			obj[items].type = dp[items].type;
			count++;
		}
		obj.length = count;
		return obj;
	}
	
	private function doConfirm(evtObj:Object):Void
	{
		if(cleanName.text == "") 
		{
			alert.show("Please provide a friendly name.");
			return;
		}
		
		if((swf.text != "" || outputPath.text != ""))
		{
			MMExecute("fl.outputPanel.clear();")
			var obj:Object = new Object();
			obj.swf = swf.text;
			obj.classList = gatherClassList(); //classList.dataProvider;
			//obj.baseClassLocation = baseClassLocation;
			obj.outputPath = outputPath.text == "" ? undefined : outputPath.text;
			//_global.tt("tags", currentMtascTags, formLocation.mtascTags.getFormValues());
			obj.MtascTags = currentMtascTags == undefined ? formLocation.mtascTags.getFormValues() : currentMtascTags;
			obj.cleanName = cleanName.text;
			obj.launchAfterPublish = launch.selected;
			obj.swfWidth = swfWidth.value;
			obj.swfHeight = swfHeight.value;
			obj.fps = FPS.value;
			obj.version = version.value != undefined ? version.value : "8";
			obj.setHeader = setHeader.selected;
			obj.existingSWF = existingSWF.selected;
			obj.batchFile = batchFile.text;
			
			// if we're in edit mode, we need to send an update dispatch
			if(editMode) 
			{
				dispatchEvent({type:"onItemPrefsUpdateConfirm", obj:obj});
			}
			if(!editMode) 
			{
				dispatchEvent({type:"onItemPrefsConfirm", obj:obj});
			}
			
			// clear cleanName
			cleanName.text = "";
		}
		
		hide();
	}
	
	function registerFormLocation(p_formLocation:MovieClip):Void 
	{
		formLocation = p_formLocation;
	}

	private function browseSWFLocation():Void
	{
		if(!existingSWF.selected) return;
		
		var obj = AssetLocator.getFileLocation();
		if(obj != null) swf.text = obj.path
	}
	
	private function browseBatchLocation():Void
	{		
		var obj = AssetLocator.getFileLocation();
		if(obj != null) batchFile.text = obj.path
	}
	
	private function browseClassPathLocation():Void
	{		
		var obj = AssetLocator.getFolderLocation();
		if(obj != null) addSingleFile(obj, "cp");
	}
	
	private function browseOutputLocation():Void
	{
		var obj = AssetLocator.getFileLocation();
		if(obj != null) outputPath.text = obj.path;
	}
	
	private function browseClassLocation():Void
	{
		var obj = AssetLocator.getFolderLocation();
		if(obj == null) return;
		var classFiles = MMExecute("fl.runScript(fl.configURI + 'Commands/FLASC/getClassFiles.jsfl', 'getClasses','"+obj.URI+"', 'true')");
		var ary:Array = classFiles.split(",");
		
		confirmation.temp = obj;
		packagesToAdd = ary;
		addNewItem(obj);
	}
	
	private function addSingleFile(obj:Object, type:String):Void
	{
		if(!checkPathDuplicates(obj.path)) 
		{	
			classList.addItem({label:obj.path, data:obj.path, type:type});
		}
	}
	
	private function addNewItem(obj:Object):Void
	{
		var path = unescape(obj.path);
		var cp = locateCP(path);
		var exists:Boolean = checkPathDuplicates(path);
		// if cp == null, prompt user to add new -cp
		/*
		if(cp == null) 
		{
			// add a temporary object to confirmation for later use
			confirmation.show("A class location was not located for this package.  Please click \"ok\" to add the new class path.  You'll be able to edit the full path to this package location");
		}else
		{
			addSingleFile({path:cp}, "cp");
			var package:String = getPackageFromCP(cp, obj.path);
			finalizePackageAdd(package, cp);
		}
		*/
		
		if(!exists && cp == null) 
		{
			confirmation.show("A class location was not located for this package.  Please click \"ok\" to add the new class path.  You'll be able to edit the full path to this package location");
		}else
		{
			var package:String = cp;
			finalizePackageAdd(package);
		}
	}
	
	private function locateCP(p_path:String):String
	{
		for(var i:Number=0;i<classList.length;i++)
		{
			var ary:Array = p_path.split(classList.getItemAt(i).data);
			if(ary.length > 1) 
			{
				var str:String = ary[1].substr(0,1) == "/" ? ary[1].substr(1) : ary[1];
				return str;
			}
		}
		return null;
	}
	
	private function getPackageFromCP(p_cp, p_path):String
	{
		var ary:Array = p_path.split(p_cp);
		var package = ary.pop().toString();
		package = package.substr(0,1) == "/" ? package.substr(1) : package;
		
		return package;
	}
	
	private function finalizePackageAdd(p_package:String):Void
	{
		if(!checkPathDuplicates(p_package) && p_package.length > 0) 
		{
			classList.addItem({label:p_package, data:p_package, type:"package"});
		}
		
		if(processQueSI == undefined) processQueSI = setInterval(this, "checkPackageQue", 10);
	}
	
	private function populateList(p_classList:Array):Void
	{
		classList.dataProvider = p_classList;
	}
	
	private function confirmationOnConfirm(evtObj:Object):Void
	{
		//_global.tt("confirmationOnConfirm", evtObj);
		if(evtObj.msg.indexOf("delete the selected item") > -1) doRemoval(); //classList.removeItemAt(classList.selectedIndex);
		if(evtObj.msg.indexOf("delete all items") > -1) clearList();
		if(evtObj.msg.indexOf("save changes") > -1) doConfirm();
		if(evtObj.msg.indexOf("A class location was not located for this package") > -1) valueEditor.show({value:confirmation.temp.path, action:"Add Class Path"});
	}
	
	private function confirmationOnCancel(evtObj:Object):Void
	{
		hide();
	}
	
	private function doRemoval():Void
	{
		var ary:Array = new Array();
		for(var i:Number=0;i<classList.selectedItems.length;i++)
		{
			ary.push(classList.selectedItems[i]);
		}
		
		for(var i:Number=0;i<ary.length;i++)
		{
			for(var j:Number=0;j<classList.length;j++)
			{
				if(classList.getItemAt(j) == ary[i]) 
				{
					classList.removeItemAt(j);
				}
			}
		}
	}
	
	private function cleanNewCP(p_path):String
	{
		var ary:Array = p_path.split("/");
		if(ary[ary.length-1] == "") ary.pop();
		return ary.join("/");
	}
	
	private function handleNewValue(evtObj:Object):Void
	{
		if(evtObj.action.indexOf("Add Class Path") > -1)
		{
			/*
			// add new global class Path
			var list:Array = SOManager.getClassPaths();
			
			
			list.push({label:newCP, data:newCP});
			SOManager.setClassPaths(list);
			*/
			var newCP:String = cleanNewCP(evtObj.value);
			addSingleFile({path:newCP}, "cp")
			// add to THIS items baseClassPaths
			/*
			if(!checkBasePathDuplicates(newCP))
			{				
				baseClassLocation.push(newCP);
			}
			*/
			
			// finally, add new package
			var package:String = getPackageFromCP(newCP, confirmation.temp.path)
			
			confirmation.temp.currentCP = newCP;
			finalizePackageAdd(package, confirmation.temp.type, newCP);
		}
	}
	
	private function checkPackageQue():Void
	{
		if(packagesToAdd.length > 0) 
		{
			var package = packagesToAdd.pop();
			package = cleanNewCP(package.split(".").join("/"));
			addNewItem({path:package});
		}else
		{
			clearInterval(processQueSI);
			processQueSI = undefined;
		}
	}
	
	public function registerAlert(p_confirmation:ConfirmationDialog, p_alert:SimpleDialog):Void
	{
		confirmation = p_confirmation;
		confirmation.addEventListener("onConfirm", Delegate.create(this, confirmationOnConfirm));
		confirmation.addEventListener("onCancel", Delegate.create(this, confirmationOnCancel));
		
		alert = p_alert;
	}
	
	public function registerMtascTags(p_mtascTags):Void
	{
		mtascTagsEditor = p_mtascTags;
		mtascTagsEditor.addEventListener("onConfirm", Delegate.create(this, setMtascTags));
	}
	
	public function registerValueEditor(p_valueEditor):Void
	{
		valueEditor = p_valueEditor;
		valueEditor.addEventListener("onDoConfirm", Delegate.create(this, handleNewValue));
	}
}