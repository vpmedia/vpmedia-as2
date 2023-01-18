/*
Class	AbstractMassLoader
Package	ch.preload.massload
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	2 nov. 2005
*/

//import
import ch.event.EventDispatcher;
import ch.preload.FileData;
import ch.preload.massload.MassLoader;
import ch.preload.massload.MassLoadListener;

/**
 * Contains some methods for the massloaders.
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		2 nov. 2005
 * @version		1.0
 */
class ch.preload.massload.AbstractMassLoader extends EventDispatcher implements MassLoader
{
	//---------//
	//Variables//
	//---------//
	private var			_files:Array; //the files to load
	private var			_isLoading:Boolean; //if the loader is loading	

	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new AbstractMassLoader.
	 */
	private function AbstractMassLoader(Void)
	{
		super();
		
		//init
		_files = [];
		_isLoading = false;
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Add a listener to the {@code MassLoader}.
	 * 
	 * @param	listener	The listener to add.
	 */
	public function addListener(listener:MassLoadListener):Void
	{
		super.addListener(listener);
	}
	
	/**
	 * Remove a listener from the {@code MassLoader}.
	 * 
	 * @param	listener	The listener to remove.
	 */
	public function removeListener(listener:MassLoadListener):Void
	{
		super.addListener(listener);
	}
	
	/**
	 * Add a file to the {@code MassLoader}.
	 * 
	 * @param	file	The file to add.
	 */
	public function addFile(file:FileData):Void
	{
		_files.push(file);
	}
	
	/**
	 * Remove a file from the {@code MassLoader}.
	 * 
	 * @param	file	The file to remove.
	 */
	public function removeFile(file:FileData):Void
	{
		var ln:Number = _files.length;
		for (var i:Number=0 ; i<ln ;i++)
		{
			//check the file
			if (_files[i] == file)
			{
				_files.splice(i, 1);
				break;
			}
		}
	}
	
	/**
	 * Remove all the files from the {@code AbstractMassLoader}.
	 */
	public function removeAll(Void):Void
	{
		_files = [];
	}
	
	/**
	 * Start the loading of the {@code MassLoader}.
	 * 
	 * @throws	Error	If the  {@code MassLoader} is loading.
	 */
	public function start(Void):Void
	{
		//check
		if (_isLoading)
		{
			throw new Error(this+".start : already loading files");
		}
		
		_isLoading = true;
	}
	
	/**
	 * Indicates if the {@code MassLoader} is loading.
	 * 
	 * @return	{@code true} if the {@code MassLoader} is loading.
	 */
	public function isLoading(Void):Boolean
	{
		return _isLoading;
	}
	
	/**
	 * Get the number of files that must be loaded.
	 * 
	 * @return	The number of files.
	 */
	public function getFileCount(Void):Number
	{
		return _files.length;
	}
	
	/**
	 * Clear the {@code AbstractMassLoader}.
	 * <p>This method <strong>should not</strong> be called
	 * by another classes than a subclass.</p>
	 */
	public function clear(Void):Void
	{
		_isLoading = false;
	}
	
	/**
	 * Represent the current instance into a String.
	 *
	 * @return	A String representing the AbstractMassLoader instance.
	 */
	public function toString(Void):String
	{
		return "ch.preload.massload.AbstractMassLoader";
	}
}