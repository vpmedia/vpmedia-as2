/*
Class	Preloader
Package	ch.preload
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	2 nov. 2005
*/

//import
import ch.preload.FileData;
import ch.preload.PreloadListener;

/**
 * Represent a preloader.
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		2 nov. 2005
 * @version		1.0
 */
interface ch.preload.Preloader
{
	/**
	 * Add a listener to the {@code Preloader}.
	 * 
	 * @param	listener	The listener to add.
	 */
	public function addListener(listener:PreloadListener):Void;
	
	/**
	 * Remove a listener from the {@code Preloader}.
	 * 
	 * @param	listener	The listener to remove.
	 */
	public function removeListener(listener:PreloadListener):Void;
	
	/**
	 * Begin the loading of a file.
	 * 
	 * @param	file	The file to load.
	 * @throws	Error	If {@code file} is {@code null}.
	 * @throws	Error	If another file is currently being loaded.
	 */
	public function load(file:FileData):Void;
	
	/**
	 * Indicates if the {@code Preloader} is currently loading
	 * a file.
	 * 
	 * @return	{@code true} if a file is being currently loaded.
	 */
	public function isLoading(Void):Boolean;
}