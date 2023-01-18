/*
Class	PreloadFactory
Package	ch.preload
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	2 nov. 2005
*/

//import
import ch.preload.FileData;
import ch.preload.Preloader;
import ch.preload.MovieClipPreloader;
import ch.preload.DataPreloader;

/**
 * Manage the preloader types.
 * <p>If you want to load basically a swf, check the {@link ch.preload.BasicPreloader}
 * class who isn't a {@code Preloader} !</p>
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		2 nov. 2005
 * @version		1.0
 */
class ch.preload.PreloaderFactory
{
	//---------//
	//Variables//
	//---------//
	private var			_mcPreloader:MovieClipPreloader; //loader of movieclip
	private var			_dtPreloader:DataPreloader; //loader of data
	
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new PreloaderFactory.
	 */
	public function PreloaderFactory(Void)
	{
		_mcPreloader = new MovieClipPreloader();
		_dtPreloader = new DataPreloader();
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Get a {@code Preloader} depending the type of a {@code FileData}.
	 * 
	 * @return	The associated {@code Preloader}.
	 */
	public function getPreloader(file:FileData):Preloader
	{
		return (file.getType() == FileData.TYPE_MOVIECLIP) ? getMovieClipPreloader() : getDataPreloader();
	}
	
	/**
	 * Get the {@code MovieClipPreloader} of the factory.
	 * 
	 * @return	The {@code MovieClipPreloader}.
	 */
	public function getMovieClipPreloader(Void):MovieClipPreloader
	{
		return _mcPreloader;
	}
	
	/**
	 * Get the {@code DataPreloader} of the factory.
	 * 
	 * @return	The {@code DataPreloader}.
	 */
	public function getDataPreloader(Void):DataPreloader
	{
		return _dtPreloader;
	}
}