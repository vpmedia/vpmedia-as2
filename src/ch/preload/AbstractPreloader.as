/*
Class	AbstractPreloader
Package	ch.preload
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	2 nov. 2005
*/

//import
import ch.event.EventDispatcher;
import ch.preload.PreloadListener;
import ch.preload.FileData;
import ch.preload.Preloader;

/**
 * Contains some methods for the preloaders.
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		2 nov. 2005
 * @version		1.0
 */
class ch.preload.AbstractPreloader extends EventDispatcher implements Preloader
{
	//---------//
	//Constants//
	//---------//
	
	/**
	 * The default timeout in ms for a file.
	 * <p>Constant value : 2500.</p>
	 */
	public static function get DEFAULT_TIMEOUT():Number { return 2500; }
	
	//---------//
	//Variables//
	//---------//
	private var		_isLoading:Boolean; //indicates if the abstractpreloader is loading
	private var		_file:FileData; //current file
	private var		_timeout:Number; //timeout of the files
	private var		_useTimeout:Boolean; //is the timeout must be used
	
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new AbstractPreloader.
	 */
	private function AbstractPreloader(Void)
	{
		super();
		
		//init
		_isLoading = false;
		_file = null;
		_timeout = DEFAULT_TIMEOUT;
		_useTimeout = true;
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Add a listener to the {@code AbstractPreloader}.
	 * 
	 * @param	listener	The listener to add.
	 */
	public function addListener(listener:PreloadListener):Void
	{
		super.addListener(listener);
	}
	
	/**
	 * Remove a listener from the {@code AbstractPreloader}.
	 * 
	 * @param	listener	The listener to remove.
	 */
	public function removeListener(listener:PreloadListener):Void
	{
		super.removeListener(listener);
	}
	
	/**
	 * Indicates if the {@code Preloader} is currently loading
	 * a file.
	 * 
	 * @return	{@code true} if a file is being currently loaded.
	 */
	public function isLoading(Void):Boolean
	{
		return _isLoading;
	}
	
	/**
	 * Set the timeout for the {@code AbstractPreloader}.
	 * 
	 * @param	value	The timeout in ms.
	 */
	public function setTimeout(value:Number):Void
	{
		_timeout = value;
	}
	
	/**
	 * Get the timeout of the {@code AbstractPreloader}.
	 * 
	 * @return	The timeout.
	 */
	public function getTimeout(Void):Number
	{
		return _timeout;
	}
	
	/**
	 * Define if the timeout must be used or not.
	 * 
	 * @param	value	{@code true} if the timeout must be used.
	 */
	public function useTimeout(value:Boolean):Void
	{
		_useTimeout = value;
	}
	
	/**
	 * Get if the timeout is used or not.
	 * 
	 * @return	{@code true} if the timeout is used.
	 */
	public function isTimoutUsed(Void):Boolean
	{
		return _useTimeout;
	}
	
	/**
	 * Begin the loading of a file.
	 * 
	 * @param	file	The file to load.
	 * @throws	Error	If {@code file} is {@code null}.
	 * @throws	Error	If another file is currently being loaded.
	 */
	public function load(file:FileData):Void
	{
		//check if the file exists
		if (file == null)
		{
			throw new Error(this+".load : file is undefined");
		}
		
		//check if we are already loading
		if (_isLoading)
		{
			throw new Error(this+".load : already loading a file");
		}
		
		_file = file;
		_isLoading = true;
	}
	
	/**
	 * Clear the loader.
	 * <p>A subclasses should call this method when the loading is complete.</p>
	 * <p>This method sould be used only into the subclasses of
	 * {@code AbstractPreloader} in order to stay in a legal state.</p>
	 */
	public function clear(Void):Void
	{
		_isLoading = false;
		_file = null;
	}
	
	/**
	 * Get the current file being loaded.
	 * <p>This method returns {@code null} if no file is being
	 * currently loaded.</p>
	 * 
	 * @param	The file being loaded or {@code null}.
	 */
	public function getCurrentFile(Void):FileData
	{
		return _file;
	}
	
	/**
	 * Represent the current instance into a String.
	 *
	 * @return	A String representing the AbstractPreloader instance.
	 */
	public function toString(Void):String
	{
		return "ch.preload.AbstractPreloader";
	}
}