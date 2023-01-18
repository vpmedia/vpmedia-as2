import com.blitzagency.flash.extensions.mtasc.SOManager;
import com.blitzagency.util.SimpleDialog;
import com.blitzagency.flash.extensions.mtasc.AssetLocator;
import com.blitzagency.util.FlashVersion;

class com.blitzagency.flash.extensions.mtasc.Compiler {
// Constants:
	public static var CLASS_REF = com.blitzagency.flash.extensions.mtasc.Compiler;
	public static var LF:String = chr(10);
	public static var CR:String = chr(13);
// Public Properties:
// Private Properties:
	private static var alert:SimpleDialog;
	private static var beginningTime:Number;
	private static var endingTime:Number;
	private static var si:Number;
	private static var launchCommand:String;
// Public Methods:
	public static function compile(p_obj:Object):Void
	{
		var obj:Object = p_obj["0"];
		var fileToExecute:String = "";
		var command:String = "";
		
		if(SOManager.getMtascLocation().length <= 0)
		{
			alert.show("Please specify the location of MTASC.exe.");
			return;
		}
		
		if(obj.data.swf.length <= 0 && obj.data.outputPath.length <= 0)
		{
			alert.show("Please specify an SWF location to compile to.");
			return;
		}
		
		if(obj.data.classList.length <= 0)
		{
			alert.show("You've not specified any classes to compile.");
			return;
		}
		
		if(FlashVersion.OS.toLowerCase() == "mac") command += "#!/bin/sh \\n\\n";
		command += "\\\"" + cleanOSPath(SOManager.getMtascLocation()) + "\\\" ";
		
		if(obj.data.existingSWF) command += "-swf \\\"" + cleanOSPath(obj.data.swf) + "\\\" ";
		if(!obj.data.existingSWF && obj.data.outputPath.length > 0)command += "-swf \\\"" + cleanOSPath(obj.data.outputPath) + "\\\" ";
		if(obj.data.outputPath.length > 0 && obj.data.existingSWF) command += "-out \\\"" + cleanOSPath(processOutputPath(obj.data)) + "\\\" ";
		
		command += processMtascTags(obj.data.MtascTags) + " ";
		command += processClassPaths() + " ";
		
		if(obj.data.classList.length > 0)
		{
			/*
			if(obj.data.baseClassLocation.length > 0)
			{
				for(var i:Number=0;i<obj.data.baseClassLocation.length;i++)
				{
					command += "-cp \\\"" + obj.data.baseClassLocation[i] + "\\\" "
				}
			}
			*/
			// add all global paths
			var list:Array = SOManager.getClassPaths();
			for(var i:Number=0;i<list.length;i++)
			{
				command += " -cp " + "\\\"" + cleanOSPath(list[i].data) + "\\\" ";
			}
			
			//  add local paths
			for(var i:Number=0;i<obj.data.classList.length;i++)
			{
				if(obj.data.classList[i].type == "cp")command += " -cp " + "\\\"" + cleanOSPath(obj.data.classList[i].data) + "\\\" ";
				if(obj.data.classList[i].type == "class")command += "\\\"" + cleanOSPath(obj.data.classList[i].data) + "\\\" ";
				if(obj.data.classList[i].type == "package")command += "-pack \\\"" + (obj.data.classList[i].data) + "\\\" ";
			}
		}
		command += parseCustomTags();
		command += processCustomTrace() + " ";
		
		if(obj.data.setHeader) command += processHeader(obj.data) + " ";
		if(obj.data.version != undefined) command += "-version " + obj.data.version + " ";
		
		var errorsLocation:String = "";
		if(FlashVersion.OS.toLowerCase() == "win" && SOManager.getShowErrors()) 
		{
			var configDirectory = MMExecute("fl.configDirectory").split("\\").join("/");
			//var configDirectory = MMExecute("fl.configURI");
			errorsLocation = configDirectory + "Commands/FLASC/errors.txt";
			command += " 2\\> \"" + errorsLocation + "\"";
		}
		if(SOManager.getPauseConsole()) command += "\\npause ";
		if(SOManager.getLaunchApp())
		{			
			launchCommand = getLaunchCommand(obj);
			if(SOManager.getLaunchApp()) si = setInterval(com.blitzagency.flash.extensions.mtasc.Compiler.launchApp, 250, launchCommand);
		}
	
		// show batch if preferences say to
		if(SOManager.getShowBatchCommand()) 
		{
			System.setClipboard(command);
			MMExecute("fl.trace('" + command + "')");
		}
		
		// write to batch file
		var batchLocation:String = "";
		var batchCommand:String = "";
		if(obj.data.batchFile.length > 0 && FlashVersion.OS.toLowerCase() == "win")
		{
			batchLocation = convertURLToURI(obj.data.batchFile);
			MMExecute("FLfile.write('" + batchLocation + "', '" + command + "')");
			//if(FlashVersion.OS.toLowerCase() == "mac") MMExecute("FLfile.write('" + batchLocation + "', '" + command + "')");
			//if(FlashVersion.OS.toLowerCase() == "win") MMExecute("FileSystem.saveTextFile('" + command + "', '" + batchLocation + "', 1)");
			batchCommand = "\\\"" + obj.data.batchFile + "\\\"";
		}else
		{
			batchLocation = MMExecute("fl.configURI") + "Commands/FLASC/runMtasc.bat";
			MMExecute("FLfile.write(fl.configURI + 'Commands/FLASC/runMtasc.bat', '" + command + "')");
			//if(FlashVersion.OS.toLowerCase() == "mac") MMExecute("FLfile.write(fl.configURI + 'Commands/FLASC/runMtasc.bat', '" + command + "')");
			//if(FlashVersion.OS.toLowerCase() == "win") MMExecute("FileSystem.saveTextFile('" + command + "', fl.configURI + 'Commands/FLASC/runMtasc.bat', 1)");
			batchCommand = "\\\"" + AssetLocator.cleanPath(MMExecute("fl.configURI")) + "Commands/FLASC/runMtasc.bat" + "\\\"";
		}		
		
		if(FlashVersion.OS.toLowerCase() == "win") var runSuccessful = MMExecute("FLfile.runCommandLine(\"" + batchCommand + "\")");
		
		if(FlashVersion.OS.toLowerCase() == "win" && SOManager.getShowErrors()) getErrors(errorsLocation);
		// using guy's dll - 
		//var runSuccessful = MMExecute("FileSystem.executeApplication(fl.configURI + 'Commands/FLASC/runMtasc.bat')");

		stopTimer();
	}
	
	public static function getErrors(errorsLocation:String):Void
	{		
		var errors = cleanErrors(MMExecute("FLfile.read('" + convertURLToURI(errorsLocation) + "');"));
		//var errors = cleanErrors(MMExecute("FLfile.read('" + (errorsLocation) + "');"));
		//var lf:Number = errors.indexOf(chr(10));
		//var cr:Number = errors.indexOf(chr(13));
		//_global.tt("errors", lf, cr);
		MMExecute("fl.trace(\"" + errors + "\")");
	}
	
	public static function launchApp(p_launchCommand):Void
	{
		clearInterval(si);
		
		// LAUNCHES INTERNAL IN THE IDE
		MMExecute("fl.openScript(" + p_launchCommand + ");");

		/* works
		MMExecute("fl.trace('" + launchCommand + "')");
		MMExecute("fl.runScript(fl.configURI + \"Commands/FLASC/getFlashLocation.jsfl\", \"launchApp\", '" + launchCommand + "')");
		*/		
	}
	
	public static function getLaunchCommand(obj:Object):String
	{
		var fileToExecute = obj.data.outputPath != undefined ? obj.data.outputPath : obj.data.swf;
		launchCommand = "\"" + convertURLToURI(fileToExecute) + "\"";
		return launchCommand;
	}
	
	private static function cleanErrors(p_err:String):String
	{
		// have to strip off the LF's and CR's		
		p_err = p_err.split("`").join("'");
		p_err = p_err.split(LF).join("");
		p_err = p_err.split(CR).join("\\n");
		return p_err;
	}
	
	private static function cleanOSPath(p_value:String):String
	{
		if(System.capabilities.os.indexOf("Mac") > -1)
		{
			var temp:Array = p_value.split("/");
			temp.shift()
			return prepPathURL("/" + temp.join("/"));
		}else
		{
			return prepPathURL(p_value);
		}
	}
	
	private static function prepPathURL(p_value:String):String
	{
		//var returnValue:String = MMExecute("fl.mapPlayerURL(\"" + p_value + "\", false);" );
		
		//var ary:Array = p_value.split("/");
		//for(var i:Number=1;i<ary.length-1;i++) ary[i] = escape(ary[i]);
		//var returnValue = ary.join("/");
		//MMExecute("fl.trace('" + returnValue + "')");
		return p_value;
	}
	
	private static function parseCustomTags():String
	{
		var ct:String = SOManager.getCustomParms();
		var str:String = "";
		if(ct != "" && ct != undefined) str = ct + " ";
		return str;
	}
	
	private static function calcTime():Number
	{
		return endingTime - beginningTime;
	}
	
	public static function startTimer():Void
	{
		beginningTime = getTimer();
	}
	
	public static function stopTimer():Void
	{
		endingTime = getTimer();
	}
	
	public static function convertURLToURI(p_url:String):String
	{
		var ary:Array = p_url.split(":")
		ary[0] = ary[0].toLowerCase();
		p_url = ary.join("|");
		
		return "file:///" + p_url;
	}
	
	public static function processHeader(p_obj:Object):String
	{
		var str:String = "-header ";
		str += p_obj.swfWidth + ":";
		str += p_obj.swfHeight + ":";
		str += p_obj.fps + " ";
		return str;
	}
	
	private static function processOutputPath(p_obj:Object):String
	{
		var str:String = "";
		var ary:Array = p_obj.outputPath.split("/");
		if(ary.length < 2)
		{
			var data = p_obj.swf.split("/");
			data.pop();
			str = data.join("/") + "/" + p_obj.outputPath;
		}else
		{
			str = p_obj.outputPath;
		}
		return str;
	}
	
	public static function registerAlert(p_alert:SimpleDialog):Void
	{
		alert = p_alert;
	}
	
	private static function processCustomTrace():String
	{
		var traceMethod:String = SOManager.getTraceMethod();
		var str:String = traceMethod != undefined && traceMethod != "" ? "-trace " + traceMethod : "";
		return str;
	}
	
	private static function processClassPaths():String
	{
		var str:String = SOManager.getFlashClassesLocation();
		if(str.length > 0) str = "-cp \\\"" + cleanOSPath(str) + "\\\"";
		
		return str;
	}
	
	private static function processMtascTags(p_obj:Object):String
	{
		var str:String = "";
		for(var items:String in p_obj)
		{
			var itemName = items.split("_")[1];
			if(p_obj[items]) str += "-" + itemName + " ";
		}

		return str;
	}
// Semi-Private Methods:
// Private Methods:

}