/*
Class	DataPreloader
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
 * Preloader of data files (xml, loadvars, ...).
 * <p><strong>Using :</strong><br><br><code>
 * var lv:LoadVars = new LoadVars();<br>
 * var fi:FileData = FileDataFactory.create("url.txt", lv);<br>
 * var mc:DataPreloader = new DataPreloader();<br>
 * <br>
 * //listen the file<br>
 * fi.onLoadError = function(code:String):Void { trace("error : "+code); }; <br>
 * fi.onLoadComplete = function(Void):Void { trace("loading complete"); }; <br>
 * fi.onLoadProgress = function(ratio:Number):Void { trace("loaded at "+(ratio*100)+"%"); }; <br>
 * fi.onLoadStart = function(Void):Void { trace("loading started"); }; <br>
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
class ch.preload.DataPreloader extends AbstractPreloader implements Preloader
{
	//---------//
	//Constants//
	//---------//
	
	/**
	 * Speed of the check for the progress event.
	 * <p>Constant value : 15</p>
	 */
	public static function get SPEED_INTERVAL():Number { return 15; }
	
	//---------//
	//Variables//
	//---------//
	private var			_interval:Number; //interval
	private var			_oldLoaded:Number; //old bytes loaded
	private var			_waitTime:Number; //timeout checker
	
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new DataPreloader.
	 */
	public function DataPreloader(Void)
	{
		super();
		
		//init
		_interval = null;
		_oldLoaded = null;
		_waitTime = null;
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
		
		//prepare the loading
		var me:DataPreloader = this;
		file.getTarget().onLoad = function(ok:Boolean):Void
		{
			if (ok)
			{
				//loaded
				me.onLoadComplete();
			}
			else
			{
				//error
				me.onLoadError("URLNotFound");
			}
		};
		
		//launch the loading
		onLoadStart();
		file.load();
		
		//interval
		_waitTime = getTimer();
		_oldLoaded = -1;
		_interval = setInterval(this, "update", SPEED_INTERVAL);
	}
	
	/**
	 * Clear the loader.
	 * <p>This method <strong>sould not</strong> be called.</p>
	 */
	public function clear(Void):Void
	{
		clearInterval(_interval);
		
		getCurrentFile().getTarget().onLoad = null;
		_oldLoaded = null;
		_interval = null;
		
		super.clear();
	}
	
	/**
	 * Represent the current instance into a String.
	 *
	 * @return	A String representing the DataPreloader instance.
	 */
	public function toString(Void):String
	{
		return "ch.preload.DataPreloader";
	}
	
	//---------------//
	//Private methods//
	//---------------//
	
	private function onLoadStart(Void):Void
	{
		getCurrentFile().onLoadStart();						//file event
		broadcastMessage("onLoadStart", getCurrentFile());	//listeners event
	}
	
	private function onLoadProgress(loaded:Number, total:Number):Void
	{
		getCurrentFile().onLoadProgress(loaded/total);							//file event
		broadcastMessage("onLoadProgress", getCurrentFile(), loaded, total);	//listeners event
	}
	
	private function onLoadComplete(Void):Void
	{
		var f:FileData = getCurrentFile();
		
		//stop the loading
		clear();
		
		f.onLoadComplete();							//file event
		broadcastMessage("onLoadComplete", f);		//listeners event
	}
	
	private function onLoadError(code:String):Void
	{
		var f:FileData = getCurrentFile();
		
		//stop the loading
		clear();
		
		f.onLoadError(code);							//file event
		broadcastMessage("onLoadError", f, code);		//listeners event
	}
	
	private function update(Void):Void
	{
		//get the bytes
		var loaded:Number = getCurrentFile().getBytesLoaded();
		var total:Number = getCurrentFile().getBytesTotal();
		
		//check if the bytes have been modified
		if (loaded > _oldLoaded)
		{
			//update
			_oldLoaded = loaded;
			_waitTime = getTimer();
			
			//event
			onLoadProgress(loaded, total);
		}
		//timeout checking
		if (useTimeout() && (getTimer()-_waitTime) > getTimeout())
		{
			//error
			onLoadError("serverTimeout");
		}
	}
}