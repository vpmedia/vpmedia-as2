import com.bourre.log.Logger;
import wilberforce.util.string.stringUtilities;

class wilberforce.util.text.structuredTextParser
{
	public static var START_NODE_IDENTIFIER:String="[";
	public static var END_NODE_IDENTIFIER:String="]";
	public static var CLOSE_NODE_IDENTIFIER:String="/";
	public static var PROPERTY_ASSIGNMENT:String="=";
	
	static function parseStructuredText(text:String):Array
	{
		//trace("Parsing");
		var tNodeStack:Array=new Array();
		var lastPhraseEndIndex:Number=0;
		var tCurrentNodeName:String;
		var tStructuredWordsArray:Array=new Array();
		// Ok, we'll need to go through and parse all attributes
		var tCharLength=text.length;
		for (var i:Number=0;i<tCharLength;i++)
		{
			
			//Strace("Checking  "+text.charAt(i));
			if (text.charAt(i)==START_NODE_IDENTIFIER)
			{
				
				var tPhrase:String=text.substring(lastPhraseEndIndex,i);
				var tNode=parseNode(text,i);
				// Store a duplicate of the phrase up to this point
				tStructuredWordsArray.push({phrase:tPhrase,nodes:tNodeStack.concat()});
				//trace("Phrase "+tPhrase+" NODES "+tNodeStack.length);
				
				if (tNode.closing) {
					// Take one off the stack. TODO - Type check
					tNodeStack.pop();
				}
				else {
					tNodeStack.push(tNode);
				}
				// Move the position to the end of the tag
				var tStartPosIndex=text.indexOf(END_NODE_IDENTIFIER,i)+1;
				lastPhraseEndIndex=i=tStartPosIndex;
				
			}
		}
		// Add on the remaining text
		var tPhrase:String=text.substring(lastPhraseEndIndex);
		tStructuredWordsArray.push({phrase:tPhrase,nodes:tNodeStack.concat()});
		//trace("Phrase "+tPhrase+" NODES "+tNodeStack.length);
		return tStructuredWordsArray;
	}
	
	private static function parseNode(text:String,startPosition:Number)
	{
		var tEndPos:Number=text.indexOf(END_NODE_IDENTIFIER,startPosition);
		// Now Split by spaces
		var tNodeData=text.substring(startPosition+1,tEndPos);
		var tNodeSplit:Array=tNodeData.split(" ");
		var tNodeName=tNodeSplit[0];
		var tClosing:Boolean=false;
		if (tNodeName.charAt(0)==CLOSE_NODE_IDENTIFIER) tClosing=true;
		//trace("Nodename is "+tNodeName);
		
		var tPropertyList:Object={};
		for (var i:Number=1;i<tNodeSplit.length;i++)
		{
			var tPropertyText:String=tNodeSplit[i];
			var tPropertySplit:Array=tPropertyText.split(PROPERTY_ASSIGNMENT);
			var tPropertyName=tPropertySplit[0];
			var tPropertyValue=tPropertySplit[1];
			tPropertyValue=stringUtilities.replaceText(tPropertyValue,"\"","");
			tPropertyValue=stringUtilities.replaceText(tPropertyValue,"'","");
			tPropertyList[tPropertyName]=tPropertyValue;
		}
		//trace("Found tag "+tNodeName);
		for (var i in tPropertyList) 
		{
			//trace("\t Property:"+i+" - "+tPropertyList[i]);
		}
		return {nodeName:tNodeName,properties:tPropertyList,closing:tClosing};
		//Logger.LOG("Unclosed tag");
	}
	
	
}