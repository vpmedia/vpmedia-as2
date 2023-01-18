import com.blitzagency.util.LSOUserPreferences;
//import mx.utils.Delegate;
class com.blitzagency.flash.extensions.mtasc.SOManager 
{
// Constants:
	public static var CLASS_REF = com.blitzagency.flash.extensions.mtasc.SOManager;
// Public Properties:
	//public static var loaded:Boolean = initManager();
// Private Properties:
	private static var SO;

// Initialization:
	public static function initManager():Boolean
	{
		SO = LSOUserPreferences;
		SO.load("MTASC_PANEL");
		//LSOUserPreferences.addEventListener("onSave", Delegate.create(SOManager, save));
		return true;
	}
	
	public static function getMatchingCPList(p_path:String):String
	{
		var list:Array = getClassPaths();
		var path = unescape(p_path);
		//_global.tt("getmatching called", path);
		for(var i:Number=0;i<list.length;i++)
		{
			//_global.tt("getmatching cp", list[i].data, path);
			if(path.indexOf(list[i].data) > -1) return list[i].data;
		}
		
		return null;
	}
	
	public static function setShowErrors(p_showErrors:Boolean):Void
	{
		SO.setPreference("showErrors", p_showErrors, true);
	}
	
	public static function getShowErrors():Boolean
	{
		return SO.getPreference("showErrors");
	}
	
	public static function setShowBatchCommand(p_showBatchCommand:Boolean):Void
	{
		SO.setPreference("showBatchCommand", p_showBatchCommand, true);
	}
	
	public static function getShowBatchCommand():Boolean
	{
		return SO.getPreference("showBatchCommand");
	}
	
	public static function setPauseConsole(p_pause:Boolean):Void
	{
		SO.setPreference("pauseConsole", p_pause, true);
	}
	
	public static function getPauseConsole():Boolean
	{
		return SO.getPreference("pauseConsole");
	}
	
	public static function setLaunchApp(p_launchApp:Boolean):Void
	{
		SO.setPreference("launchApp", p_launchApp, true);
	}
	
	public static function getLaunchApp():Boolean
	{
		return SO.getPreference("launchApp");
	}
	
	public static function getCustomParms():String
	{
		return SO.getPreference("customParms");
	}
	
	public static function setCustomParms(p_customParms:String):Void
	{
		SO.setPreference("customParms", p_customParms, true);
	}
	
	public static function getTraceMethod():String
	{
		return SO.getPreference("traceMethod");
	}
	
	public static function setTraceMethod(p_traceMethod:String):Void
	{
		SO.setPreference("traceMethod", p_traceMethod, true);
	}
	
	public static function getClassPaths():Array
	{
		return SO.getPreference("classPaths");
	}
	
	public static function setClassPaths(p_classPaths):Void
	{
		SO.setPreference("classPaths", p_classPaths, true);
	}
	
	public static function getFlashClassesLocation():String
	{
		return SO.getPreference("flashClassesLocation");
	}
	
	public static function setFlashClassesLocation(p_mtascLocation):Void
	{
		SO.setPreference("flashClassesLocation", p_mtascLocation, true);
	}
	
	public static function getMtascLocation():String
	{
		return SO.getPreference("mtascLocation");
	}
	
	public static function setMtascLocation(p_mtascLocation):Void
	{
		SO.setPreference("mtascLocation", p_mtascLocation, true);
	}
	
	public static function save(evtObj:Object):Void
	{
		_global.tt("SO Save", evtObj);
	}
	
	public static function setMtascTags(p_obj):Void
	{
		SO.setPreference("MtascTags", p_obj, true);
	}
	
	public static function getMtascTags():Object
	{
		return SO.getPreference("MtascTags");
	}
	
	public static function setBatchNames(p_batchNames:Array):Void
	{
		SO.setPreference("batchNames", p_batchNames, true);
	}
	
	public static function getBatchNames():Array
	{
		return SO.getPreference("batchNames");
	}
	
	public static function setCurrentBatchIndex(p_batchIndex:Number):Void
	{
		SO.setPreference("currentBatchIndex", p_batchIndex, true);
	}
	
	public static function getCurrentBatchIndex():Number
	{
		return SO.getPreference("currentBatchIndex");
	}
	
	public static function setBatch(p_batchName:String, p_batch:Array):Void
	{
		SO.setPreference(p_batchName, p_batch, true);
	}
	
	public static function removeBatch(p_batchName:String):Void
	{
		SO.setPreference(p_batchName, undefined, false);
	}
	
	public static function getBatch(p_batchName:String):Array
	{
		return SO.getPreference(p_batchName);
	}

// Public Methods:
// Semi-Private Methods:
// Private Methods:

}