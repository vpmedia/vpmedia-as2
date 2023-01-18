/*
Class	PreloadListener
Package	ch.preload
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	2 nov. 2005
*/

//import
import ch.preload.FileData;

/**
 * Listener for a {@code Preloader}.
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		2 nov. 2005
 * @version		1.0
 */
interface ch.preload.PreloadListener
{
	/**
	 * Called when the loading starts.
	 * 
	 * @param	file	The file being loaded.
	 */
	public function onLoadStart(file:FileData):Void;
	
	/**
	 * Called when the loading progresses.
	 * 
	 * @param	file	The file being loaded.
	 * @param	loaded	The loaded bytes.
	 * @param	total	The total bytes.
	 */
	public function onLoadProgress(file:FileData, loaded:Number, total:Number):Void;
	
	/**
	 * Called when the loading is complete.
	 * 
	 * @param	file	The file loaded.
	 */
	public function onLoadComplete(file:FileData):Void;
	
	/**
	 * Called when the clip is arrived in Flash and begins to play
	 * (only for {@link ch.preload.FileData#TYPE_MOVIECLIP}).
	 * 
	 * @param	file	The file being loaded.
	 */
	public function onLoadInit(file:FileData):Void;
	
	/**
	 * Called when an error occurs.
	 * 
	 * @param	file	The file being loaded.
	 * @param	code	The error code.
	 */
	public function onLoadError(file:FileData, code:String):Void;
}