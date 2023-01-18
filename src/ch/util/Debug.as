/*
Class	Debug
Package	ch.util
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	2 nov. 2005
*/

/**
 * Class Debug.
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		2 nov. 2005
 * @version		1.0
 */
class ch.util.Debug
{
	//---------//
	//Constants//
	//---------//
	
	/**
	 * Target to create the {@code TextField}.
	 * <p>Constant value : _root.</p>
	 */
	public static function get FIELD_TARGET():MovieClip { return _root; }
	
	/**
	 * Depth to create the TextField.
	 * <p>Constant value : 16000.</p>
	 */
	public static function get FIELD_DEPTH():Number { return 16000; }
	
	/**
	 * Name of the TextField.
	 * <p>Constant value : txtDebug.</p>
	 */
	public static function get FIELD_NAME():String { return "txtDebug"; }
	
	/**
	 * TextFormat of the TextField.
	 */
	public static function get FIELD_FORMAT():TextFormat
	{
		var t:TextFormat = new TextFormat();
		t.color = 0x000000;
		t.size = 13;
		return t;
	}
	
	/**
	 * Initial properties of the TextField.
	 */
	public static function get FIELD_INIT():Object
	{
		var obj:Object = new Object();
		obj.autoSize = "left";
		obj.wordWrap = true;
		obj.multiline = true;
		return obj;
	}
	
	//---------//
	//Variables//
	//---------//
	private static var			__field:TextField;	
	
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new Debug.
	 */
	private function Debug(Void)
	{
		//empty
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Write a text into a debug {@code TextField}.
	 * 
	 * @param	txt		The text.
	 */
	public static function write(txt:String):Void
	{
		if (__field == null)
		{
			__field = initField();
		}
		
		__field.text += txt+"\n";
	}
	
	/**
	 * Clear the {@code TextField}.
	 */
	public static function clear(Void):Void
	{
		__field.text = "";
	}
	
	/**
	 * Get the {@code TextField}.
	 * 
	 * @return	The {@code TextField}.
	 */
	public static function getField(Void):TextField
	{
		return __field;
	}
	
	//---------------//
	//Private methods//
	//---------------//
	
	/**
	 * Init the TextField.
	 * 
	 * @return	The TextField.
	 */
	private static function initField(Void):TextField
	{
		FIELD_TARGET.createTextField(FIELD_NAME, FIELD_DEPTH, 0, 0, 400, 25);
		var t:TextField = FIELD_TARGET[FIELD_NAME];
		
		for (var i:String in FIELD_INIT)
		{
			t[i] = FIELD_INIT[i];
		}
		
		t.setNewTextFormat(FIELD_FORMAT);
		
		return t;
	}
}