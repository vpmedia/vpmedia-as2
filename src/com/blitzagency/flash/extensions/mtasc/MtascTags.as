// ** AUTO-UI IMPORT STATEMENTS **
import mx.controls.Button;
import mx.controls.CheckBox;
import mx.containers.Window;
// ** END AUTO-UI IMPORT STATEMENTS **
import mx.utils.Delegate;
import mx.events.EventDispatcher;
import com.blitzagency.flash.extensions.mtasc.SOManager;
import com.blitzagency.flash.extensions.mtasc.MainContainer;

class com.blitzagency.flash.extensions.mtasc.MtascTags extends MovieClip {
// Constants:
	public static var CLASS_REF = com.blitzagency.flash.extensions.mtasc.MtascTags;
	public static var LINKAGE_ID:String = "com.blitzagency.flash.extensions.mtasc.MtascTags";
// Public Properties:
	public var addEventListener:Function;
	public var removeEventListener:Function;
// Private Properties:
	private var dispatchEvent:Function;
	private var parmsList:Array;
	private var formLocation:MovieClip;
	private var returnValues:Boolean;
// UI Elements:

// ** AUTO-UI ELEMENTS **
	private var _infer:CheckBox;
	private var _keep:CheckBox;
	private var _main:CheckBox;
	private var _msvc:CheckBox;
	private var _mx:CheckBox;
	private var _separate:CheckBox;
	private var _strict:CheckBox;
	private var _v:CheckBox;
	private var _wimp:CheckBox;
	private var cancel:Button;
	private var confirm:Button;
	private var hiddenBG:Button;
	private var window:Window;
// ** END AUTO-UI ELEMENTS **

// Initialization:
	private function MtascTags() {EventDispatcher.initialize(this);}
	private function onLoad():Void { configUI(); }

// Public Methods:
// Semi-Private Methods:
// Private Methods:
	private function configUI():Void 
	{
		
		
		confirm.addEventListener("click", Delegate.create(this, doConfirm));
		cancel.addEventListener("click", Delegate.create(this, doCancel));		
		
		parmsList = new Array("_msvc", "_keep",  "_strict", "_separate", "_mx", "_main", "_v", "_wimp", "_infer");
		setTabs();
		_msvc.setFocus();
		
		// set initial values
		registerValues(SOManager.getMtascTags());
		
		window.onRelease = undefined;
		hide();
	}
	
	private function setTabs():Void
	{
		for(var i:Number=0;i<parmsList.length;i++)
		{
			this[parmsList[i]].tabIndex = i+1;
		}
		
		confirm.tabIndex = parmsList.length+1;
		cancel.tabIndex = parmsList.length+2;
	}
	
	private function doCancel():Void 
	{
		hide();
		//dispatchEvent({type:"onCancelTags"})
	}

	/**
	* @method doConfirm
	* @return Void
	*/
	private function doConfirm():Void 
	{
		var obj:Object = getFormValues();
		
		if(!returnValues) SOManager.setMtascTags(obj);
		
		dispatchEvent({type:"onConfirm", tags:obj});
		
		hide();
	}
	
	public function getFormValues():Object
	{
		var obj:Object = new Object();
		for(var i:Number=0;i<parmsList.length;i++)
		{
			obj[parmsList[i]] = new Object();
			obj[parmsList[i]] = this[parmsList[i]].selected;
		}
		return obj;
	}

	/**
	* @method getTags
	* @tooltip If no tags are passed in, then the default tags are retreived from SO's
	* @return Void
	*/
	public function getTags():Object 
	{
		return SOManager.getMtascTags();
	}

	/**
	* @method hide
	* @return Void
	*/
	public function hide():Void 
	{
		if(!returnValues) MainContainer.resetView();
		_visible = false;
	}

	/**
	* @method registerFormLocation
	* @return Void
	*/
	function registerFormLocation(p_formLocation:MovieClip):Void 
	{
		formLocation = p_formLocation;
	}

	/**
	* @method registerValues
	* @tooltip called by show
	* @return Void
	*/
	function registerValues(p_tags:Object):Void 
	{
		/*
		p_tags._mx
		p_tags._keep etc
		*/
		if(p_tags == undefined)
		{
			p_tags = getTags();
		}

		if(p_tags != undefined)
		{
			for(var items:String in p_tags)
			{
				this[items].selected = p_tags[items];
			}
		}
	}

	/**
	* @method show
	* @return Void
	*/
	public function show(p_itemPref:Object):Void 
	{
		// if p_itemPref, that means the single item is being edited so we want to return the values and not store them
		
		returnValues = p_itemPref.returnValues;
		
		// registerValues is sent when show is called by an item that already exists
		registerValues(p_itemPref.MtascTags);
		
		// show dialog
		_visible = true;
	}
}