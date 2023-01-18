/*
Class	SimpleMassLoader
Package	ch.preload.massload
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	2 nov. 2005
*/

//import
import ch.event.EventDispatcher;
import ch.preload.FileData;
import ch.preload.massload.AbstractMassLoader;
import ch.preload.massload.MassLoader;
import ch.preload.PreloadListener;
import ch.preload.PreloaderFactory;

/**
 * Simple manager to load many files.
 * <p><strong>Using :</strong><br><code><br>
 * var cl1:MovieClip = this.createEmptyMovieClip("temp1", 0);<br>
 * var cl2:MovieClip = this.createEmptyMovieClip("temp2", 1);<br>
 * <br>
 * var f1:FileData = FileDataFactory.create("temp1.swf", cl1);<br>
 * var f2:FileData = FileDataFactory.create("temp2.swf", cl2);<br>
 * var f3:FileData = FileDataFactory.create("temp3.swf"); //load in the cache<br>
 * f3.onLoadError = function(code:String):Void { trace(code); }<br>
 * <br>
 * var sm:SimpleMassLoader = new SimpleMassLoader();<br>
 * <br>
 * //add the files<br>
 * sm.addFile(f1);<br>
 * sm.addFile(f2);<br>
 * sm.addFile(f3);<br>
 * <br>
 * //start the loading<br>
 * sm.start();<br>
 * </code></p>
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		2 nov. 2005
 * @version		1.0
 * @see			ch.preload.DataPreloader
 * @see			ch.preload.MovieClipPreloader
 * @see			ch.preload.PreloaderFactory
 */
class ch.preload.massload.SimpleMassLoader extends AbstractMassLoader implements MassLoader, PreloadListener
{
	//---------//
	//Variables//
	//---------//
	private var		_factory:PreloaderFactory; //the preloader factory
	private var		_currentIndex:Number; //current index of loading
	private var		_globalDispatcher:EventDispatcher; //dispatcher for global listeners
	
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new SimpleMassLoader.
	 */
	public function SimpleMassLoader(Void)
	{
		super();
		
		//init
		_factory = new PreloaderFactory();
		_factory.getDataPreloader().addListener(this);
		_factory.getMovieClipPreloader().addListener(this);
		_currentIndex = -1;
		_globalDispatcher = new EventDispatcher();
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Add a global listener to all the preloader
	 * used during the {@code SimpleMassLoader}.
	 * 
	 * @param	listener	The listener to add.
	 * @throws	Error		If {@code listener} is {@code null}.
	 */
	public function addGlobalListener(listener:PreloadListener):Void
	{
		if (listener == null)
		{
			throw new Error(this+".addGlobalListener : listener is undefined");
		}
		
		_globalDispatcher.addListener(listener);
	}
	
	/**
	 * Remove a global listener.
	 * 
	 * @param	listener	The listener to remove.
	 * @throws	Error		If {@code listener} is {@code null}.
	 */
	public function removeGlobalListener(listener:PreloadListener):Void
	{
		if (listener == null)
		{
			throw new Error(this+".removeGlobalListener : listener is undefined");
		}
		
		_globalDispatcher.removeListener(listener);
	}
	
	/**
	 * Start the loading of the {@code MassLoader}.
	 * 
	 * @throws	Error	If the  {@code MassLoader} is loading.
	 */
	public function start(Void):Void
	{
		//call the super method
		super.start();
		
		//start the loading
		broadcastMessage("onMassloadStart");
	
		//load the files
		nextFile();
	}
	
	/**
	 * Get the current index of the file that is being loaded.
	 * 
	 * @return	The index or -1 if the loading is not started.
	 */
	public function getCurrentIndex(Void):Number
	{
		return _currentIndex;
	}
	
	/**
	 * Get the current file being loaded.
	 * 
	 * @return	The file being loaded or {@code null} if the loading is not started.
	 */
	public function getCurrentFile(Void):FileData
	{
		return (_currentIndex == -1) ? null : _files[_currentIndex];
	}
	
	/**
	 * Clear the {@code SimpleMassLoader}.
	 * <p>This method <strong>should not</strong> be called
	 * by another classes than a subclass. This will dispatch the
	 * {@code onMassloadComplete} event.</p>
	 */
	public function clear(Void):Void
	{
		super.clear();
		
		_currentIndex = -1;
		broadcastMessage("onMassloadComplete");
	}
	
	/**
	 * Called when the loading starts.
	 * 
	 * @param	file	The file being loaded.
	 */
	public function onLoadStart(file:FileData):Void
	{
		_globalDispatcher.broadcastMessage("onLoadStart", file);
	}
	
	/**
	 * Called when the loading progresses.
	 * 
	 * @param	file	The file being loaded.
	 * @param	loaded	The loaded bytes.
	 * @param	total	The total bytes.
	 */
	public function onLoadProgress(file:FileData, loaded:Number, total:Number):Void
	{
		_globalDispatcher.broadcastMessage("onLoadProgress", file, loaded, total);
		broadcastMessage("onMassloadProgress", file.getBytesLoaded(), file.getBytesTotal());
	}
	
	/**
	 * Called when the loading is complete.
	 * 
	 * @param	file	The file loaded.
	 */
	public function onLoadComplete(file:FileData):Void
	{
		_globalDispatcher.broadcastMessage("onLoadComplete", file);
		broadcastMessage("onMassloadProgress", file.getBytesLoaded(), file.getBytesTotal());
		nextFile();
	}
	
	/**
	 * Called when the clip is arrived in Flash and begins to play
	 * (only for {@link ch.preload.FileData#TYPE_MOVIECLIP}).
	 * 
	 * @param	file	The file being loaded.
	 */
	public function onLoadInit(file:FileData):Void
	{
		_globalDispatcher.broadcastMessage("onLoadInit", file);
	}
	
	/**
	 * Called when an error occurs.
	 * 
	 * @param	file	The file being loaded.
	 * @param	code	The error code.
	 */
	public function onLoadError(file:FileData, code:String):Void
	{
		_globalDispatcher.broadcastMessage("onLoadError", file, code);
		broadcastMessage("onMassloadError", file, code);
		nextFile();
	}
	
	/**
	 * Represent the current instance into a String.
	 *
	 * @return	A String representing the SimpleMassLoader instance.
	 */
	public function toString(Void):String
	{
		return "ch.preload.massload.SimpleMassLoader";
	}
	
	//---------------//
	//Private methods//
	//---------------//
	
	/**
	 * Next index for the file loading.
	 */
	private function nextFile(Void):Void
	{
		_currentIndex++;
		
		//check if there is more files
		if (_currentIndex < getFileCount()) 
		{
			var f:FileData = getCurrentFile();
			_factory.getPreloader(f).load(f);
		}
		else
		{
			//mass load complete 
			clear();
		}
	}
}