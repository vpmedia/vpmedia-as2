// ** AUTO-UI IMPORT STATEMENTS **
import com.blitzagency.flash.extensions.mtasc.controls.EditItem;
import com.blitzagency.flash.extensions.mtasc.controls.IconButton;
import com.blitzagency.flash.extensions.mtasc.controls.DeleteItem;
import com.blitzagency.flash.extensions.mtasc.controls.AddItem;
import mx.controls.Button;
import mx.controls.ComboBox;
import mx.controls.List;
// ** END AUTO-UI IMPORT STATEMENTS **
import mx.utils.Delegate;
import mx.events.EventDispatcher;
import com.blitzagency.util.ConfirmationDialog;
import com.blitzagency.util.SimpleDialog;
import mx.controls.Menu;
import com.blitzagency.flash.extensions.mtasc.SOManager;
import com.blitzagency.xray.ui.Tooltip;
import com.blitzagency.flash.extensions.mtasc.Compiler;
import com.blitzagency.flash.extensions.mtasc.ImportExport;
import com.blitzagency.flash.extensions.mtasc.ValueEditor;

class com.blitzagency.flash.extensions.mtasc.MtascBatch extends MovieClip {
// Constants:
	public static var CLASS_REF = com.blitzagency.flash.extensions.mtasc.MtascBatch;
	public static var LINKAGE_ID:String = "com.blitzagency.flash.extensions.mtasc.MtascBatch";
// Public Properties:
	public var addEventListener:Function;
	public var removeEventListener:Function;
// Private Properties:
	private var dispatchEvent:Function;
	private var formLocation:MovieClip;
	private var itemPrefs:MovieClip;
	private var confirmation:ConfirmationDialog;
	private var alert:SimpleDialog;
	private var menuData:XML;
	private var menu:Menu;
	private var currentBatchName:String;
	private var currentBatch; // should be Array, but typing it causes compile error - list.dataProvider apparently is seen as an object
	private var batchList:Array;
	private var valueEditor:ValueEditor;
// UI Elements:

// ** AUTO-UI ELEMENTS **
	private var addFile:AddItem;
	private var batchLoader:ComboBox;
	private var compileBatch:Button;
	private var down:IconButton;
	private var editItem:EditItem;
	private var importProject:IconButton;
	private var launch:IconButton;
	private var list:List;
	private var logoButton:MovieClip;
	private var removeFile:DeleteItem;
	private var up:IconButton;
// ** END AUTO-UI ELEMENTS **

// Initialization:
	private function MtascBatch() {EventDispatcher.initialize(this);}
	private function onLoad():Void {}

// Public Methods:
	public function registerAlert(p_confirmation:ConfirmationDialog, p_alert:SimpleDialog):Void
	{
		confirmation = p_confirmation;
		confirmation.addEventListener("onConfirm", Delegate.create(this, confirmationOnConfirm));
		confirmation.addEventListener("onCancel", Delegate.create(this, confirmationOnCancel));
		
		alert = p_alert;
		alert.addEventListener("onConfirm", Delegate.create(this, alertConfirmation));
	}
	
	public function createNewBatch(evtObj:Object):Void
	{
		// clear list
		list.dataProvider = new Array();
		
		// add to dropdown
		if(checkDuplicates(evtObj.value))
		{
			alert.show("Batch already exists.");			
		}else
		{
			batchLoader.addItem({label:evtObj.value});
			batchLoader.selectedIndex = batchLoader.length-1;
			updateBatchList();
			currentBatchName = String(batchLoader.value);
		}
	}
	
	public function addNewItem(p_obj:Object):Void
	{
		// to add a new item, there has to be a current batch.
		if(currentBatchName == undefined)
		{
			alert.show("Please create a new batch before adding SWF's");
		}else
		{
			addItemToBatch(p_obj);
		}
	}
	
// Semi-Private Methods:
// Private Methods:
	public function configUI():Void 
	{		
		// create menu
		createMenu();
		
		// fill batchLoader
		batchList = SOManager.getBatchNames();
		if(batchList != undefined)
		{
			batchLoader.dataProvider = batchList;
			loadFirstBatch();
		}
		
		addFile.addEventListener("click", Delegate.create(this, showItemPrefs));
		removeFile.addEventListener("click", Delegate.create(this, confirmRemoveListItem));
		
		logoButton.onRelease = Delegate.create(this, showMenu);
		logoButton.onRollOver = Delegate.create(this, showLogoTip);
		logoButton.onRollOut = Delegate.create(this, hideLogoTip);
		
		batchLoader.addEventListener("change", Delegate.create(this, changeBatch));
		
		editItem.addEventListener("click", Delegate.create(this, editItemPrefs));
		
		up.message = "Move item up in list";
		up.addEventListener("click", Delegate.create(this, moveItemUp));
		down.message = "Move item down in list";
		down.addEventListener("click", Delegate.create(this, moveItemDown));
		
		launch.addEventListener("click", Delegate.create(this, launchSWF));
		launch.message = "Launch SWF";
		
		list.addEventListener("change", Delegate.create(this, listChange));
		list.addEventListener("itemRollOver", Delegate.create(this, listRollOver));
		list.addEventListener("itemRollOut", Delegate.create(this, listRollOut));
		
		itemPrefs.addEventListener("onItemPrefsConfirm", Delegate.create(this, itemPrefsConfirm));
		itemPrefs.addEventListener("onItemPrefsUpdateConfirm", Delegate.create(this, itemPrefsUpdateConfirm));
		
		compileBatch.addEventListener("click", Delegate.create(this, runBatch));
		
		//list.tabIndex = 1;
		addFile.tabIndex = 1;
		removeFile.tabIndex = 2;
		compileBatch.tabIndex = 3;		
	}
	
	private function runBatch():Void
	{
		if(list.selectedItem == undefined) 
		{
			alert.show("Please select a project from the list to compile.");
			return;
		}

		Compiler.startTimer();
		Compiler.compile(list.selectedItems);
	}
	
	private function launchSWF():Void
	{
		if(list.selectedItem == undefined) 
		{
			alert.show("Please select a project from the list to launch.");
			return;
		}
		
		var launchCommand = Compiler.getLaunchCommand(list.selectedItem);
		Compiler.launchApp(launchCommand);
	}
	
	private function moveItemUp(evtObj:Object):Void
	{
		// check to see if at top
		// if not, then copy object in slot above this one into a temp prop
		// use replaceItemAt() to put selected object into slot above
		// use replaceItemAt() to put copied object into selected slot
		_global.tt("moveUp", list.selectedIndex);
		if(list.selectedIndex <= 0) return;
		
		var currentIndex:Number = list.selectedIndex;
		var copyObj = list.getItemAt(currentIndex-1);
		var moveObj = list.getItemAt(currentIndex);
		list.replaceItemAt(currentIndex-1, moveObj);
		list.replaceItemAt(currentIndex, copyObj);
		list.selectedIndex = currentIndex-1;
	}
	
	private function moveItemDown(evtObj:Object):Void
	{
		_global.tt("moveDown", list.selectedIndex);
		if(list.selectedIndex >= list.length - 1) return;
		
		var currentIndex:Number = list.selectedIndex;
		var copyObj = list.getItemAt(currentIndex+1);
		var moveObj = list.getItemAt(currentIndex);
		list.replaceItemAt(currentIndex+1, moveObj);
		list.replaceItemAt(currentIndex, copyObj);
		list.selectedIndex = currentIndex+1;
	}
	
	private function exportPrefs():Void
	{
		if(list.selectedItem == undefined) 
		{
			alert.show("Please select a project from the list.");
			return;
		}
		
		var xmlDoc:XML = ImportExport.exportProject(list.selectedItem);
		MMExecute("fl.trace('" + xmlDoc.toString() + "');");
		System.setClipboard(xmlDoc.toString());
		alert.show("Project Exported to clipboard.");	
	}
	
	private function importPrefs():Void
	{
		valueEditor.show({value:"", action:"Import Project"});
	}
	
	private function handleNewValue(evtObj:Object):Void
	{
		if(evtObj.action.indexOf("Import Project") > -1)
		{
			// if no xml was entered, just return
			if(evtObj.value.length < 1) return;
			
			// add new global class Path
			// evtObj.value
			var obj:Object = ImportExport.importProject(evtObj.value);
			obj.EXPORT.splice(0,1);
			_global.tt("import", obj.EXPORT.label);
			list.addItem({label:obj.EXPORT.label, data:obj.EXPORT.data})
		}
	}
	
	private function listRollOver(evtObj):Void
	{
		var item = list.getItemAt(evtObj.index);
		if(item.label != undefined) 
		{
			var tags:String = getTags(item);
			var tip:String = "";
			if(item.data.swf != undefined) tip += item.data.swf + "\n\n";
			if(item.data.outputPath != undefined) tip += item.data.outputPath + "\n\n";
			//tip += item.data.classPath + "\n\n";
			tip += Compiler.processHeader(item.data) + "\n\n";
			tip += "Tags:\n" + tags;
			Tooltip.show(tip);
		}
	}
	
	private function getTags(p_obj:Object):String
	{
		var str = "";
		var obj = p_obj.data.MtascTags;
		for(var items:String in obj)
		{
			str += items + ": " + obj[items] + "\n";
		}
		return str;
	}
	
	private function listRollOut(evtObj):Void
	{
		Tooltip.hide();
	}
	
	private function listChange(evtObj:Object):Void
	{
		Tooltip.hide();
		if(Key.isDown(Key.SHIFT)) 
		{
			editItemPrefs();
		}
	}
	
	private function checkDuplicates(p_label:String):Boolean
	{
		for(var i:Number=0;i<batchLoader.length;i++)
		{
			if(batchLoader.getItemAt(i).label == p_label) return true;
		}
		return false;
	}
	
	private function loadFirstBatch():Void
	{
		var lastBatchIndex:Number = SOManager.getCurrentBatchIndex();
		
		if(lastBatchIndex != undefined) batchLoader.setSelectedIndex(lastBatchIndex);
		currentBatch = SOManager.getBatch(String(batchLoader.value));
		currentBatchName = String(batchLoader.value);
		
		list.dataProvider = currentBatch;
	}
	
	private function changeBatch():Void
	{
		// get batch from SO's
		currentBatch = SOManager.getBatch(String(batchLoader.value));
		SOManager.setCurrentBatchIndex(batchLoader.selectedIndex);

		currentBatchName = String(batchLoader.value);
		list.dataProvider = currentBatch;
	}
	
	private function editItemPrefs():Void
	{
		var item = list.selectedItem;
		if(item != undefined) itemPrefs.show(item);
		if(item == undefined) alert.show("Please select a project to edit.");
	}
	
	private function showItemPrefs():Void
	{
		itemPrefs.show();
	}
	
	private function itemPrefsConfirm(evtObj:Object):Void
	{
		//_global.tt("itemPrefsConfirm", evtObj);
		addNewItem(evtObj.obj);
	}
	
	private function itemPrefsUpdateConfirm(evtObj:Object):Void
	{
		//_global.tt("itemPrefsUpdateConfirm", evtObj.obj);
		updateItemInBatch(evtObj.obj);
	}
	
	private function updateItemInBatch(p_obj:Object):Void
	{
		list.replaceItemAt(list.selectedIndex,{label:p_obj.cleanName, data:p_obj});
		updateCurrentBatch();
	}
	
	private function addItemToBatch(p_obj:Object):Void
	{
		//_global.tt("addItemToBatch", p_obj);
		list.addItem({label:p_obj.cleanName, data:p_obj});
		updateCurrentBatch();
	}
	
	private function updateCurrentBatch():Void
	{
		currentBatch = list.dataProvider;
		
		// update the SO
		SOManager.setBatch(currentBatchName, currentBatch);
	}
	
	private function updateBatchList():Void
	{
		batchList = batchLoader.dataProvider;
		
		// update the SO
		SOManager.setBatchNames(batchList);
	}
	
	private function deleteBatch():Void
	{
		var value = batchLoader.value;
		if(value != undefined)
		{
			batchLoader.value = "";
			for(var i:Number=0;i<batchLoader.length;i++)
			{
				if(batchLoader.getItemAt(i).label == value) batchLoader.removeItemAt(i);
			}
			// remove from SO
			SOManager.removeBatch(value);
			
			// clear the current batch name
			currentBatchName = undefined;
			
			// reset batchList
			updateBatchList();
			
			// after we delete a batch, we have to set it to the first one as a default
			batchLoader.selectedIndex = 0;
			// set the value
			batchLoader.value = batchLoader.getItemAt(batchLoader.selectedIndex).label;
			// get the items in the new batch
			changeBatch();
			
			// notify user
			alert.show("Batch \"" + value + "\" successfully removed");
		}else
		{
			alert.show("Please select a batch to remove");
		}
	}
	
	private function confirmRemoveListItem():Void
	{
		if(list.selectedIndex != undefined) confirmation.show("Are you sure you want to delete the selected file?");
	}
	
	private function removeListItem():Void
	{
		list.removeItemAt(list.selectedIndex);
		updateCurrentBatch();
		alert.show("File successfully removed");
	}
	
	private function createMenu():Void
	{
		var menuItems:String = "<newBatch label='New Group' isBranch='true' />"
		menuItems += "<removeBatch label='Remove Group' isBranch='true' />"
		menuItems += "<separator type='separator'/>"
		menuItems += "<import label='Import Project' isBranch='true' />"
		menuItems += "<export label='Export Project' isBranch='true' />"
		menuItems += "<separator type='separator'/>"
		menuItems += "<options label='Options'>";
		menuItems += "<errors label='Show Errors in Output Panel?' type='check' selected='" + SOManager.getShowErrors() + "' isBranch='true' />"
		menuItems += "<showBatch label='Show batch command?' type='check' selected='" + SOManager.getShowBatchCommand() + "' isBranch='true' />"
		menuItems += "<pause label='Pause Command Prompt?' type='check' selected='" + SOManager.getPauseConsole() + "' isBranch='true' />"
		menuItems += "<launch label='Launch After Compile?' type='check' selected='" + SOManager.getLaunchApp() + "' isBranch='true' />"		
		menuItems += "</options>";
		menuItems += "<preferences label='Preferences' isBranch='true' />"
		menuItems += "<mtascParameters label='MTASC Default Parameters' isBranch='true' />"
		menuItems += "<separator type='separator'/>"
		menuItems += "<help label='FLASC Help' isBranch='true' />"
		menuItems += "<about label='About FLASC' isBranch='true' />"
		
		menuData = new XML(menuItems);
		
		menu = Menu.createMenu(this, menuData);
		menu.addEventListener("change", Delegate.create(this, menuChangeHandler));
	}
	
	private function menuChangeHandler(evtObj:Object):Void
	{
		var nav:String = evtObj.menuItem.nodeName;
		//_global.tt("menu", nav, evtObj.menuItem, "ding");
		
		switch(nav)
		{
			case "newBatch":
				dispatchEvent({type:"onNewBatch"});
			break;
			
			case "removeBatch":
				confirmation.show("Are you sure you want to delete this batch: " + batchLoader.value + "?");
				//deleteBatch();
				//dispatchEvent({type:"onRemoveBatch"});
			break;
			
			case "import":
				importPrefs();
			break;
			
			case "export":
				exportPrefs()
			break;
			
			case "preferences":
				dispatchEvent({type:"onShowPrefs"});
			break;
			
			case "mtascParameters":
				dispatchEvent({type:"onShowMtascTags"});
			break;
			
			case "help":
				dispatchEvent({type:"onShowHelp"});
			break;
						
			case "about":
				dispatchEvent({type:"onShowAbout"});
			break;
			
			case "pause":
				var doPause:Boolean = SOManager.getPauseConsole();
				SOManager.setPauseConsole(!doPause);
			break;
			
			case "launch":
				var launchApp:Boolean = SOManager.getLaunchApp();
				SOManager.setLaunchApp(!launchApp);
			break;
			
			case "showBatch":
				var showBatch:Boolean = SOManager.getShowBatchCommand();
				SOManager.setShowBatchCommand(!showBatch);
			break;
			
			case "errors":
				var showErrors:Boolean = SOManager.getShowErrors();
				SOManager.setShowErrors(!showErrors);
			break;
		}
	}
	
	private function showMenu():Void
	{
		menu.show(logoButton._x+(logoButton._width - 20), logoButton._y+(logoButton._height/3));
		hideLogoTip();
	}
	
	private function showLogoTip():Void
	{
		Tooltip.show("Options...");
	}
	
	private function hideLogoTip():Void
	{
		Tooltip.hide();
	}
	
	private function confirmationOnConfirm(evtObj:Object):Void
	{
		//_global.tt("confirmationOnConfirm", evtObj);
		if(evtObj.msg.indexOf("delete this batch") > -1) deleteBatch();
		if(evtObj.msg.indexOf("delete the selected file") > -1) removeListItem();
	}
	
	private function confirmationOnCancel(evtObj:Object):Void
	{
		
	}
	
	private function alertConfirmation(evtObj:Object):Void
	{
		
	}
	
	private function hide():Void
	{
		_visible = false;
	}
	
	function registerFormLocation(p_formLocation:MovieClip):Void 
	{
		formLocation = p_formLocation;
	}
	
	function registerItemPrefs(p_itemPrefs:MovieClip):Void 
	{
		itemPrefs = p_itemPrefs;
	}
	
	public function registerValueEditor(p_valueEditor):Void
	{
		valueEditor = p_valueEditor;
		valueEditor.addEventListener("onDoConfirm", Delegate.create(this, handleNewValue));
	}
}