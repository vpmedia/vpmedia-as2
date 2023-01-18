/*
Class	BasicPreloader
Package	ch.preload
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	9 nov. 2005
*/

/**
 * Basic loader of {@code MovieClip}. Especially used
 * to load the {@code _root} or very light anims.
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		9 nov. 2005
 * @version		1.0
 */
class ch.preload.BasicPreloader
{
	//---------//
	//Constants//
	//---------//
	
	/**
	 * Interval time for the preloading.
	 * <p>Constant value : 20.</p>
	 */
	public static function get INTERVAL():Number { return 20; }
	
	//---------//
	//Variables//
	//---------//
	private var 	_mc:MovieClip; //root clip
	private var		_interval:Number; //interval
	
	/**
	 * Function called when the MovieClip is loaded.<br>
	 * <code>myBasicPreloader.onLoad = function(Void):Void { ... }</code>
	 */
	public var		onLoad:Function;
	
	/**
	 * Function called when the load is progressing.<br>
	 * <code>myBasicPreloader.onProgress = function(loaded:Number, total:Number):Void { ... }</code>
	 */
	public var 		onProgress:Function;
	
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new BasicPreloader.
	 * 
	 * @param	clip	The clip to listen.
	 * @throws	Error	If {@code clip} is {@code null}.
	 */
	public function BasicPreloader(clip:MovieClip)
	{
		if (clip == null)
		{
			throw new Error(this+".<init> : clip is undefined");
		}
		
		_mc = clip;
		_interval = null;
		onLoad = null;
		onProgress = null;
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Start the loading.
	 */
	public function start(Void):Void
	{
		_interval = setInterval(this, "updateLoading", INTERVAL);
	}
	
	/**
	 * Stop the loading.
	 */
	public function stop(Void):Void
	{
		//stop the interval
		clearInterval(_interval);
		_interval = null;
	}
	
	/**
	 * Get the loaded clip.
	 * 
	 * @return	The {@code MovieClip}.
	 */
	public function getClip(Void):MovieClip
	{
		return _mc;
	}
	
	/**
	 * Represent the current instance into a String.
	 *
	 * @return	A String representing the BasicPreloader instance.
	 */
	public function toString(Void):String
	{
		return "ch.preload.BasicPreloader";
	}
	
	//---------------//
	//Private methods//
	//---------------//
	
	/**
	 * Update the loading.
	 */
	private function updateLoading(Void):Void
	{
		//get the data
		var tot:Number = _mc.getBytesTotal();
		var loa:Number = _mc.getBytesLoaded();	
		//check if the basic data are loaded
		if (loa != tot)
		{
			//progress
			this.onProgress(loa, tot);
		}
		else if (tot == loa && _mc._currentframe >= 1)
		{
			//stop the listening
			this.stop();

			//event
			this.onLoad();
		}
	}
}