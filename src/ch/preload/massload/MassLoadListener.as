/*
Class	MassLoadListener
Package	ch.preload.massload
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	2 nov. 2005
*/

//import
import ch.preload.FileData;

/**
 * Interface MassLoadListener.
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		2 nov. 2005
 * @version		1.0
 */
interface ch.preload.massload.MassLoadListener
{
	/**
	 * Called when the {@code MassLoader} start to load.
	 */
	public function onMassloadStart(Void):Void;
	
	/**
	 * Called when a loading progresses.
	 * 
	 * @param	loaded	The loaded bytes.
	 * @param	total	The total bytes.
	 */
	public function onMassloadProgress(loaded:Number, total:Number):Void;

	/**
	 * Called when a {@code FileData} has not been loaded.
	 * 
	 * @param	error	The {@code FileData} not loaded.
	 * @param	code	The error code.
	 */
	public function onMassloadError(error:FileData, code:String):Void;
	
	/**
	 * Called when all the files are loaded.
	 */
	public function onMassloadComplete(Void):Void;
}