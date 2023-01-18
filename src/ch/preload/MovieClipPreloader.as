/*
Class	MovieClipPreloader
Package	ch.preload
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	2 nov. 2005
*/

//import
import ch.preload.AbstractPreloader;
import ch.preload.Preloader;
import ch.preload.FileData;

/**
 * Preloader of MovieClip.
 * <p>The event methods are invoked in the following order :<br>
 * 	<code><ul>
 * 		<li>onLoadStart</li>
 * 		<li>onLoadProgress / onLoadInit / onLoadError</li>
 * 		<li>onLoadComplete</li>
 * 	</code></ul><br>
 * Note that the {@link ch.preload.PreloadListener#onLoadComplete} event
 * is every time called the last if the {@link ch.preload.PreloadListener#onLoadError}
 * method is not called.
 * </p>
 * <p><strong>Using :</strong><br><br><code>
 * var cl:MovieClip = this.createEmptyMovieClip("clip", 0);<br>
 * var fi:FileData = FileDataFactory.create("url.swf", cl);<br>
 * var mc:MovieClipPreloader = new MovieClipPreloader();<br>
 * <br>
 * //listen the file<br>
 * fi.onLoadError = function(code:String):Void { trace(code); }; <br>
 * fi.onLoadComplete = function(Void):Void { trace("loading complete"); }; <br>
 * fi.onLoadProgress = function(ratio:Number):Void { trace("loaded at "+(ratio*100)+"%"); }; <br>
 * fi.onLoadStart = function(Void):Void { trace("loading started"); }; <br>
 * fi.onLoadInit = function(Void):Void { trace("plaing..."); }; <br>
 * <br>
 * //launch the loading<br>
 * mc.load(fi);
 * </code></p>
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		2 nov. 2005
 * @version		1.0
 * @see			ch.preload.PreloaderFactory
 * @see			ch.preload.massload.SimpleMassLoader
 */
class ch.preload.MovieClipPreloader extends AbstractPreloader implements Preloader
{
	//---------//
	//Variables//
	//---------//
	private var		_loader:MovieClipLoader; //the loader
	private var		_timeoutWaiter:Number; //timeout checker
	private var		_isLoadComplete:Boolean; //if the load is complete
	private var		_isLoadInit:Boolean; //if the load is init
	private var		_isComplete:Boolean; //loader complete
	private var		_isInit:Boolean; //loader init
	
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new MovieClipPreloader.
	 */
	public function MovieClipPreloader(Void)
	{
		super();
		
		//init
		_loader = new MovieClipLoader();
		_loader.addListener(this);
		_timeoutWaiter = null;
		_isComplete = false;
		_isInit = false;
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Begin the loading of a file.
	 * 
	 * @param	file	The file to load.
	 * @throws	Error	If {@code file} is {@code null}.
	 * @throws	Error	If another file is currently being loaded.
	 */
	public function load(file:FileData):Void
	{
		//call the super method
		super.load(file);
		
		//begin the loading
		_loader.loadClip(file.getURL(), file.getTarget());
		
		//timeout checker
		defineTimeoutChecker(MovieClip(file.getTarget()));
	}
	
	/**
	 * Clear the loader.
	 * <p>This method <strong>sould not</strong> be called.</p>
	 */
	public function clear(Void):Void
	{
		//clear the timeout
		clearInterval(_timeoutWaiter);
		_isComplete = false;
		_isInit = false;
		
		super.clear();
	}
	
	/**
	 * Represent the current instance into a String.
	 *
	 * @return	A String representing the MovieClipPreloader instance.
	 */
	public function toString(Void):String
	{
		return "ch.preload.MovieClipPreloader";
	}
	
	//---------------//
	//Private methods//
	//---------------//
	
	private function onLoadStart(target:MovieClip):Void
	{
		getCurrentFile().onLoadStart();						//file event
		broadcastMessage("onLoadStart", getCurrentFile());	//listeners event
	}
	
	private function onLoadProgress(target:MovieClip, loaded:Number, total:Number):Void
	{
		//reset the timeout
		defineTimeoutChecker(target);
		
		getCurrentFile().onLoadProgress(loaded/total);							//file event
		broadcastMessage("onLoadProgress", getCurrentFile(), loaded, total);	//listeners event
	}
	
	private function onLoadComplete(target:MovieClip):Void
	{
		_isComplete = true;
		
		//if the clip is not init, we stop
		if (!_isInit) return;
		
		var f:FileData = getCurrentFile();
		
		//clearing
		clear();
		
		f.onLoadComplete();							//file event
		broadcastMessage("onLoadComplete", f);		//listeners event
	}
	
	private function onLoadInit(target:MovieClip):Void
	{
		var f:FileData = getCurrentFile();
		
		f.onLoadInit();								//file event
		broadcastMessage("onLoadInit", f);			//listeners event
		
		_isInit = true;
		if (_isComplete) onLoadComplete(target); //call the complete if the loading
												 //is finished
	}
	
	private function onLoadError(target:MovieClip, code:String):Void
	{
		var f:FileData = getCurrentFile();
		
		//stop the loading
		clear();
		
		f.onLoadError(code);							//file event
		broadcastMessage("onLoadError", f, code);		//listeners event
	}
	
	private function defineTimeoutChecker(target:MovieClip):Void
	{
		if (useTimeout())
		{
			clearInterval(_timeoutWaiter);
			_timeoutWaiter = setInterval(this, "onLoadError", getTimeout(),
										 target, "serverTimeout");
		}
	}
}