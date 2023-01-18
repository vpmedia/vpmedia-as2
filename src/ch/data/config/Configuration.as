/*
Class	Configuration
Package	ch.data
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	5 nov. 2005
*/

/**
 * Configuration data.
 * <p><strong>Using :</strong><br><br>The txt (config.txt) file :<br><code>
 * [myConfigurationFile]<br>
 * myVariable=myValue<br>
 * myOtherVariable=myOtherValue<br>
 * </code><br><br>The code :<br><code><br>
 * var cl:ConfigurationLoader = new ConfigurationLoader("[myConfigurationFile]");<br>
 * cl.onLoad = function(ok:Boolean):Void<br>
 * {<br>
 * 	 var c:Configuration = this.getConfiguration();<br>
 * 	 trace(c.getField("myVariable"));<br>
 * 	 trace(c.getField("myOtherVariable"));<br>
 * }<br>
 * cl.load("config.txt");<br>
 * </code></p>
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		5 nov. 2005
 * @version		1.0
 */
class ch.data.config.Configuration
{
	//---------//
	//Constants//
	//---------//
	
	/**
	 * String for the line separator.
	 * <p>Constant value : "\n".</p>
	 */
	public static function get LINE_SEPARATOR():String { return "\n"; }
	
	/**
	 * String for the fields separator.
	 * <p>Constant value : "=".</p>
	 */
	public static function get FIELD_SEPARATOR():String { return "="; }
	
	/**
	 * String for the comments line.
	 * <p>Constant value : "#".</p>
	 */
	public static function get CHAR_COMMENT():String { return "#"; }
	
	//---------//
	//Variables//
	//---------//
	private var				_fields:Object;//objets
	
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new Configuration.
	 */
	public function Configuration(Void)
	{
		_fields = new Object();
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Parse a source string that contain
	 * the configuration values.
	 * 
	 * @param	src		The source.
	 * @throws	Error	If the file is invalid.
	 */
	public function parse(src:String):Void
	{
		var fields:Array = src.split(LINE_SEPARATOR);
		var length:Number = fields.length;
		
		//parse each fields
		for (var i:Number=0 ; i<length ; i++)
		{
			var c:String = fields[i];
			
			//check if it's a ligne comment
			if (c.charAt(0) == CHAR_COMMENT || c.length==0)
			{
				//jump to the next line
				continue;
			}
			
			//get the index of the separator
			var id:Number = c.indexOf(FIELD_SEPARATOR);
			
			//check the index
			if (id == -1)
			{
				throw new Error(this+".parse : invalid id for '"+c+"'");
			}
			
			var n:String = c.substring(0, id);
			var v:String = c.substring(id+1, c.length);
			
			//add the field
			addField(n, v);
		}
	}
	
	/**
	 * Get the value of a field.
	 * 
	 * @param	name	The field name.
	 * @return	The value of the field.
	 * @throws	Error	If the field {@code name} does not exist.
	 */
	public function getField(name:String):String
	{
		var fn:String = _fields[name];
		
		if (fn == null)
		{
			throw new Error(this+".getField : the field '"+name+"' does not exist");
		}
		
		return fn;
	}
	
	/**
	 * Add a field to the configuration.
	 * 
	 * @param	name	The name of the field.
	 * @param 	value	The value of the field.
	 * @throws	Error	If the field {@code name} already exist.
	 */
	public function addField(name:String, value:String):Void
	{
		if (_fields[name] != null)
		{
			throw new Error(this+".addField : field '"+name+"' already exist");
		}
		
		_fields[name] = value;
	}
	
	/**
	 * Remove a field from the {@code Configuration}.
	 * 
	 * @param	name	The field to remove.
	 */
	public function removeField(name:String):Void
	{
		_fields[name] = null;
	}
	
	/**
	 * Get the source file.
	 * <p>This method returns the file how it must be saved to be parsed. That means
	 * if you use the String returned by this method for saving your file, it would
	 * be parsable with the {@link #parse()} method.</p>
	 * 
	 * @param	header	[optional] - header of the file (needed for a {@link ch.data.config.ConfigurationLoader}).
	 * @return	The source file.
	 */
	public function getSource(header:String):String
	{
		var s:String = (header==null) ? "" : header+"\n";
		
		for (var i:String in _fields)
		{
			s += i+"="+_fields[i]+"\n";
		}
		
		return s;
	}
	
	/**
	 * Represent the current instance into a String.
	 *
	 * @return	A String representing the ConfigurationParser instance.
	 */
	public function toString(Void):String
	{
		return "ch.astorm.snowpark.config.Configuration";
	}
}