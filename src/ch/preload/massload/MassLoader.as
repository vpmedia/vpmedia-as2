/*
Class	MassLoader
Package	ch.preload.massload
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	2 nov. 2005
*/

//import
import ch.preload.FileData;
import ch.preload.massload.MassLoadListener;

/**
 * Loader of many files.
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		2 nov. 2005
 * @version		1.0
 */
interface ch.preload.massload.MassLoader
{
	/**
	 * Add a listener to the {@code MassLoader}.
	 * 
	 * @param	listener	The listener to add.
	 */
	public function addListener(listener:MassLoadListener):Void;
	
	/**
	 * Remove a listener from the {@code MassLoader}.
	 * 
	 * @param	listener	The listener to remove.
	 */
	public function removeListener(listener:MassLoadListener):Void;
	
	/**
	 * Add a file to the {@code MassLoader}.
	 * 
	 * @param	file	The file to add.
	 */
	public function addFile(file:FileData):Void;
	
	/**
	 * Remove a file from the {@code MassLoader}.
	 * 
	 * @param	file	The file to remove.
	 */
	public function removeFile(file:FileData):Void;
	
	/**
	 * Start the loading of the {@code MassLoader}.
	 * 
	 * @throws	Error	If the  {@code MassLoader} is loading.
	 */
	public function start(Void):Void;
	
	/**
	 * Indicates if the {@code MassLoader} is loading.
	 * 
	 * @return	{@code true} if the {@code MassLoader} is loading.
	 */
	public function isLoading(Void):Boolean;
	
	/**
	 * Get the number of files that must be loaded.
	 * 
	 * @return	The number of files.
	 */
	public function getFileCount(Void):Number;
}