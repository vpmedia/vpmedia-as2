import org.opensourceflash.data.XMLObject
import com.blitzagency.flash.extensions.mtasc.SOManager;
import com.blitzagency.util.SimpleDialog;

class com.blitzagency.flash.extensions.mtasc.ImportExport
{
// Constants:
	public static var CLASS_REF = com.blitzagency.flash.extensions.mtasc.ImportExport;
// Public Properties:
// Private Properties:
	private static var alert:SimpleDialog;

// Initialization:
// Public Methods:

	public static function exportProject(p_obj:Object):XML
	{
		var xmlDoc:XML = XMLObject.getXML(p_obj, "EXPORT");
		//_global.tt("export", xmlDoc.toString());
		return xmlDoc;
	}
	
	public static function importProject(p_xml:String):Object
	{
		var obj:Object = XMLObject.getObject(new XML(p_xml), false);
		
		_global.tt("import", obj);
		return obj;
	}
	
	public static function registerAlert(p_alert:SimpleDialog):Void
	{
		alert = p_alert;
	}
// Semi-Private Methods:
// Private Methods:

}