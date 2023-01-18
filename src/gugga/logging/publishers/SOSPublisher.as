/**
 * @author todor
 */
 
import gugga.logging.Level;
import gugga.logging.LogRecord;
import gugga.logging.publishers.DefaultPublisher;
import gugga.utils.SOSTraceUtil;
import gugga.collections.HashTable;
import gugga.utils.DebugUtils;

class gugga.logging.publishers.SOSPublisher extends DefaultPublisher 
{
	/**
	*	@see logging.IPublisher
	*/	
	public function publish(logRecord:LogRecord):Void
	{
		if (this.isLoggable(logRecord)) 
		{
			var logMessage:String = logRecord.getMessage();
			var logLevel : Level = logRecord.getLevel();
			
			if(logLevel != Level.WARNING && logLevel != Level.SEVERE)
			{
				var traceStr:String = this.getFormatter().format(logRecord);
				
				if(isFoldedMessageString(logMessage))
				{
					var parsedMessage : Object = parseFoldedMessageString(logMessage);
					SOSTraceUtil.traceFoldedMessage(parsedMessage["title"], parsedMessage["text"]);
				}
				else
				{
					SOSTraceUtil.trace(traceStr);
				}
			}
			else
			{
				if(!SOSTraceUtil.isKeyColorSet("GuggaLibWarning"))
				{
					SOSTraceUtil.setKeyColor("GuggaLibWarning", 0xFFFFBB);
					SOSTraceUtil.setKeyColor("GuggaLibSevere", 0xFFBBBB);
				}
				
				if(logLevel == Level.WARNING)
				{
					if(isFoldedMessageString(logMessage))
					{
						var parsedMessage : Object = parseFoldedMessageString(logMessage);
						SOSTraceUtil.traceFoldedMessageWithKey(parsedMessage["title"], parsedMessage["text"], "GuggaLibWarning");
					}
					else
					{
						var traceStr:String = this.getFormatter().format(logRecord);
						SOSTraceUtil.traceMessageWithKey(traceStr, "GuggaLibWarning");
					}
				}
				else if(logLevel == Level.SEVERE)
				{
					if(isFoldedMessageString(logMessage))
					{
						var parsedMessage : Object = parseFoldedMessageString(logMessage);
						SOSTraceUtil.traceFoldedMessageWithKey(parsedMessage["title"], parsedMessage["text"], "GuggaLibSevere");
					}
					else
					{
						var traceStr:String = this.getFormatter().format(logRecord);
						SOSTraceUtil.traceMessageWithKey(traceStr, "GuggaLibSevere");
					}
				}
			}
		}
	}
	
	public static function getFoldedMessagePackage(aTitle:String, aText:String) : String
	{
		return "<?xml version='1.0' encoding='utf-8'?><SOSPublisher_foldedmessage><title><![CDATA[" + aTitle + "]]></title><text><![CDATA[" + aText + "]]></text></SOSPublisher_foldedmessage>";
	}

	private static function isFoldedMessageString(aString:String) : Boolean
	{	
		if(aString.indexOf("<?xml version='1.0' encoding='utf-8'?><SOSPublisher_foldedmessage><title><![CDATA[") == 0)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	
	private function parseFoldedMessageString(aString:String) : Object
	{	
		var result : Object = new Object();
		var foldedMessageXml : XML = new XML(aString);
		
		result["title"] = foldedMessageXml.firstChild.firstChild.firstChild.nodeValue;
		result["text"] = foldedMessageXml.firstChild.lastChild.firstChild.nodeValue;
		
		return result;
	}
}