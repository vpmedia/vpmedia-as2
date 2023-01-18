/*
Class	FileDataFactory
Package	ch.preload
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	2 nov. 2005
*/

//import
import ch.preload.FileData;

/**
 * Create dynamically files that ca be loaded.
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		2 nov. 2005
 * @version		1.0
 */
class ch.preload.FileDataFactory
{
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new FileDataFactory.
	 */
	private function FileDataFactory(Void)
	{
		//empty
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Create a {@code FileData} from an {@code Object}.
	 * <p>The {@code target} can be of the following data type :
	 * 	<ul>
	 * 		<li>MovieClip</li>
	 * 		<li>LoadVars</li>
	 * 		<li>XML</li>
	 * 		<li>Sound</li>
	 * 		<li>null (MovieClip in cache)</li>
	 * 	</ul>
	 * </p>
	 * 
	 * @param	url				The url of the file.
	 * @param	target			The target of the file.
	 * @param	priority		The priority of the file (0 by default).
	 * @param	forceLoading	Indicates if the file must be loaded from the 
	 * 							server even if it is already in the cache (see {@link FileData}).
	 * @return	The {@code FileData} created.
	 * @throws	Error	If {@code target} is of an unknown type.
	 */
	public static function create(url:String, target:Object, priority:Number, forceLoading:Boolean):FileData
	{
		//movieclip type
		if (target instanceof MovieClip)
		{
			return new FileData(url, target, FileData.TYPE_MOVIECLIP, priority, forceLoading);
		}
		
		//loadvars type
		if (target instanceof LoadVars)
		{
			return new FileData(url, target, FileData.TYPE_LOADVARS, priority, forceLoading);
		}
		
		//xml type
		if (target instanceof XML)
		{
			return new FileData(url, target, FileData.TYPE_XML, priority, forceLoading);
		}
		
		//sound type
		if (target instanceof Sound)
		{
			return new FileData(url, target, FileData.TYPE_SOUND, priority, forceLoading);
		}
		
		//cache type
		if (target == null)
		{
			return new FileData(url, new LoadVars(), FileData.TYPE_MOVIECLIP_CACHE, priority, forceLoading);
		}
		
		//error
		throw new Error("ch.preload.FileDataFactory.create : target is of an invalid type (url="+url+")");
	}
	
	/**
	 * Get the types that can be created by the {@code FileDataFactory}.
	 * 
	 * @return	An array containing the types.
	 */
	public static function getTypes(Void):Array
	{
		return [FileData.TYPE_LOADVARS, FileData.TYPE_MOVIECLIP,
				FileData.TYPE_MOVIECLIP_CACHE, FileData.TYPE_XML,
				FileData.TYPE_SOUND];
	}
}