/*
Class	ConfigurationLoader
Package	ch.data.config
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	5 nov. 2005
*/

//import
import ch.data.config.Configuration;

/**
 * Loader of a {@code Configuration}.
 * <p>Note that the onLoad event is fully available but you <strong>should not</strong>
 * erease the onData event !</p>
 * <p><strong>Using :</strong><br><code><br>
 * var cl:ConfigurationLoader = new ConfigurationLoader("[header]");<br>
 * cl.onLoad = function(ok:Boolean):Void<br>
 * {<br>
 * 	 trace(this.getConfiguration());<br>
 * }<br>
 * cl.load("config.txt");<br>
 * </code></p>
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		5 nov. 2005
 * @version		1.0
 */
class ch.data.config.ConfigurationLoader extends LoadVars
{
	//---------//
	//Variables//
	//---------//
	private var				_configuration:Configuration; //the configuration
	private var				_header:String; //file header
	
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new ConfigurationLoader.
	 * 
	 * @param	header	Header of the configuration file or {@code null}
	 * 					if there is no header.
	 */
	public function ConfigurationLoader(header:String)
	{
		super();

		_header = header;
		_configuration = new Configuration();
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Get the header needed for the file.
	 * 
	 * @return	The header.
	 */
	public function getHeader(Void):String
	{
		return _header;
	}
	
	/**
	 * Get the {@code Configuration}.
	 * <p>The {@code Configuration} is created event if the
	 * file is not loaded.</p>
	 * 
	 * @return	The {@code Configuration}.
	 */
	public function getConfiguration(Void):Configuration
	{
		return _configuration;
	}
	
	/**
	 * Represent the current instance into a String.
	 *
	 * @return	A String representing the ConfigurationLoader instance.
	 */
	public function toString(Void):String
	{
		return "ch.data.config.ConfigurationLoader";
	}
	
	/**
	 * onData function.
	 * <p>This method check the header and parse the file. <strong>Should not</strong>
	 * be ereased !</p>
	 * 
	 * @param	src		Source file.
	 */
	public function onData(src:String):Void
	{
		//format the source
		var source:String = src.split(chr(13)).join("");
		var toParse:Array = source.split(Configuration.LINE_SEPARATOR);
		var header:String = toParse[0];
		
		//check the header
		if (_header != null)
		{
			if (header == _header)
			{
				toParse.splice(0, 1);
			}
			//error 
			else
			{
				throw new Error(this+".onData : the header does not match with '"+_header+"' ("+header+")");
			}
		}
		
		//parse the source
		source = toParse.join(Configuration.LINE_SEPARATOR);
		_configuration.parse(source);
		
		//launch the functions
		onLoad(true);
	}
}