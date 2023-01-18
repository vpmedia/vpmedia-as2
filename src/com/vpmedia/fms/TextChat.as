// Implementations
import mx.events.EventDispatcher;
import com.vpmedia.events.Delegate;
// Define Class
class com.vpmedia.fms.TextChat extends MovieClip
{
	// START CLASS
	public var className:String = "TextChat";
	public static var version:String = "0.0.1";
	// EventDispatcher
	public var addEventListener:Function;
	public var removeEventListener:Function;
	public var dispatchEvent:Function;
	public var dispatchQueue:Function;
	//
	var chatHistory_array:Array = new Array ();
	// to do: make this user changeble
	var chatHistoryLength:Number = 50;
	var chatLastMessage:String = "";
	// Constructor
	function TextChat ()
	{
		EventDispatcher.initialize (this);
	}
	public function createHtmlMessage (scope, mess:String, color:Color):String
	{
		var _msg:String = "<TEXTFORMAT>";
		var _suffix:String = "</TEXTFORMAT>";
		var _mess = mess;
		scope.chatBold_cb.selected ? _msg += "<B>" : null;
		scope.chatItalic_cb.selected ? _msg += "<I>" : null;
		_suffix = "</FONT>";
		scope.chatItalic_cb.selected ? _suffix += "</I>" : null;
		scope.chatBold_cb.selected ? _suffix += "</B>" : null;
		_msg += "<FONT COLOR='";
		_msg += color + "'>" + _mess + _suffix;
		_msg = escape (_msg);
		return _msg;
	}
	public function chatMsgUpdate (input, output)
	{
		var chatMessageText:String = unescape (input);
		if (chatMessageText != chatLastMessage)
		{
			chatLastMessage = chatMessageText;
			chatHistory_array.push (chatMessageText);
		}
		// refresh             
		output.text = "";
		var tempChatHistory_array:Array = chatHistory_array;
		if (tempChatHistory_array.length > chatHistoryLength)
		{
			var startIndex:Number = tempChatHistory_array.length - chatHistoryLength;
		}
		else
		{
			var startIndex:Number = 0;
		}
		var endIndex:Number = tempChatHistory_array.length;
		for (var i = startIndex; i < endIndex; i++)
		{
			output.text += "" + tempChatHistory_array[i] + "";
		}
		output.vPosition = output.maxVPosition;
		output.redraw ();
	}
	public function createDigit (__digit, __str)
	{
		for (var i = 0; i < __digit; i++)
		{
			__str = __str.length < __digit ? "0" + __str : __str;
		}
		return __str;
	}
	public function getSelectedColor (__color)
	{
		var decValue = __color;
		var hexValue = decValue.toString (16).toUpperCase ();
		var realHexValue = createDigit (6, hexValue);
		return "#" + realHexValue;
	}
	// Get version
	public function toString ():String
	{
		return ("[" + className + "]");
	}
	// END CLASS
}
