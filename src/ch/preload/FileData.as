/*
Class	FileData
Package	ch.preload
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	2 nov. 2005
*/

/**
 * Represent a file that can be used by a preloader.
 * <p>In order to create correct {@code FileData}, use the
 * {@link ch.preload.FileDataFactory} class which allows you to
 * create automatically {@code FileData}.</p>
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		2 nov. 2005
 * @version		1.0
 */
class ch.preload.FileData
{
	//---------//
	//Constants//
	//---------//
	
	/**
	 * {@code FileData} for a MovieClip.
	 * <p>It can be an swf, jpg, png, bmp to load.</p>
	 * <p>Constant value : 0</p>
	 */
	public static function get TYPE_MOVIECLIP():Number { return 0; }
	
	/**
	 * {@code FileData} for a file that will be loaded in the cache.
	 * <p>It can be an swf, jpg, png, bmp to load.</p>
	 * <p>A MovieClip in the cache mean that it would be loaded in
	 * a LoadVars instead of a MovieClip.</p>
	 * <p>Constant value : 1</p>
	 */
	public static function get TYPE_MOVIECLIP_CACHE():Number { return 1; }
	
	/**
	 * {@code FileData} for a LoadVars.
	 * <p>It can be a txt or other file.</p>
	 * <p>Constant value : 2</p>
	 */
	public static function get TYPE_LOADVARS():Number { return 2; }
	
	/**
	 * {@code FileData} for an XML.
	 * <p>It can be an xml.</p>
	 * <p>Constant value : 3</p>
	 */
	public static function get TYPE_XML():Number { return 3; }
	
	/**
	 * {@code FileData} for a Sound.
	 * <p>It can be a Sound.</p>
	 * <p>Constant value : 4.</p>
	 */
	public static function get TYPE_SOUND():Number { return 4; }
	
	//---------//
	//Variables//
	//---------//
	private var			_url:String; //url of the file
	private var			_target:Object; //target of the file
	private var			_type:Number; //type
	private var			_priority:Number; //priority for the load
	private var			_forceLoading:Boolean; //if the load must be from the server everytime
	
	/**
	 * Linked object of the {@code FileData}.
	 * <p>This variable can be useful if you want a persistent
	 * data tought the loading of a {@code MovieClip}.<p>
	 */
	public var			linkedObject:Object;
	
	/**
	 * Name of the {@code FileData}.
	 * <p>You can use this variable if you want to display
	 * some information about the name of the file in a visual
	 * preloader.</p>
	 */
	public var			name:String;
	
	/**
	 * Called when the file is loaded.
	 * <p><code>myFilePreload.onLoadComplete = function(Void):Void {...}</code></p>
	 */
	public var			onLoadComplete:Function;
	
	/**
	 * Called when the file begin the loading.
	 * <p><code>myFilePreload.onLoadStart = function(Void):Void {...}</code></p>
	 */
	public var			onLoadStart:Function;
	
	/**
	 * Called when the file progress the loading.
	 * <p><code>myFilePreload.onLoadProgress = function(ratio:Number):Void {...}</code></p>
	 */
	public var			onLoadProgress:Function;
	
	/**
	 * Called when the MovieClip begin to play (only for TYPE_MOVIECLIP).
	 * <p><code>myFilePreload.onLoadInit = function(Void):Void {...}</code></p>
	 */
	public var			onLoadInit:Function;
	
	/**
	 * Called when the an error occurs during the loading.
	 * <p><code>myFilePreload.onLoadError = function(code:String):Void {...}</code></p>
	 */
	public var			onLoadError:Function;
	
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new FileData.
	 * <p>The {@code url} indicates the URL of the file. It must exist
	 * in order to load the file correctly. The {@code target} can be
	 * of different type : {@code MovieClip}, {@code LoadVars} or {@code XML}.
	 * The {@code type} is the type of the {@code FileData} (see constants) and
	 * the priority indicats, in some mass load the place of the file into
	 * the list. More the priority is high, sooner will the file be loaded.</p>
	 * 
	 * @param	url				Url of the file to load.
	 * @param	target			Target to load the file.
	 * @param	type			The type of the file.
	 * @param	priority		The priority of the file (0 by default).
	 * @param	forceLoading	Force the loading of the file event if it is in the cache (false by default).
	 * @throws	Error	If {@code url} is {@code null}.
	 * @throws	Error	If {@code target} is {@code null}.
	 * @throws	Error	If {@code type} is {@code null}.
	 */
	public function FileData(url:String, target:Object, type:Number, priority:Number, forceLoading:Boolean)
	{
		//check the parameters
		if (url == null)
		{
			throw new Error(this+".<init> : url is undefined");
		}
		if (target == null)
		{
			throw new Error(this+".<init> : target is undefined");
		}
		if (type == null)
		{
			throw new Error(this+".<init> : type is undefined");
		}
		
		//init
		_forceLoading = forceLoading || false;
		_url = url;
		_target = target;
		_type = type;
		_priority = (priority == null) ? 0 : priority;
		
		name = null;
		linkedObject = null;
		onLoadError = null;
		onLoadInit = null;
		onLoadComplete = null;
		onLoadStart = null;
		onLoadProgress = null;
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Get the URL of the {@code FileData}.
	 * 
	 * @return	The URL.
	 */
	public function getURL(Void):String
	{
		return _url;	
	}
	
	/**
	 * Get the target of the {@code FileData}.
	 * 
	 * @return	The target.
	 */
	public function getTarget(Void):Object
	{
		return _target;
	}
	
	/**
	 * Get the type of the {@code FileData}.
	 * 
	 * @return	The type.
	 */
	public function getType(Void):Number
	{
		return _type;
	}
	
	/**
	 * Get the priority of the {@code FileData}.
	 * 
	 * @return	The priority.
	 */
	public function getPriority(Void):Number
	{
		return _priority;
	}
	
	/**
	 * Set/remove the forcing to load the file.
	 * <p>That's mean that the file will be loaded from
	 * the server even if it is already in the cache.</p>
	 * 
	 * @param	value	{@code true} if the file must be loaded
	 * 					on the server everytime.
	 */
	public function setForceLoading(value:Boolean):Void
	{
		_forceLoading = value;
	}
	
	/**
	 * Get if the file must be loaded from the server
	 * instead of the cache.
	 * 
	 * @return	{@code true} if the file must be loaded from
	 * 			the serveur. 
	 */
	public function isForceLoaded(Void):Boolean
	{
		return _forceLoading;
	}
	
	/**
	 * Launch the loading of the {@code FileData}.
	 * <p>The load methods are :<br>
	 * 	<ul>
	 * 		<li>MovieClip : loadMovie(url)</li>
	 * 		<li>Sound : loadSound(url, false)</li>
	 * 		<li>LoadVars : load(url)</li>
	 * 		<li>XML : load(url)</li>
	 * 	</ul>
	 * </p>
	 */
	public function load(Void):Void
	{
		var url:String = _url;
		
		if (isForceLoaded())
		{
			url += "?"+(new Date()).getTime();
		}
		
		switch(_type)
		{
			//if the type is movie clip
			case TYPE_MOVIECLIP:
				_target.loadMovie(url);
				break;
				
			//if the type is a sound
			case TYPE_SOUND:
				_target.loadSound(url, false);
				break;
				
			//in the other case
			default :
				_target.load(url);
		}
	}
	
	/**
	 * Get the bytes loaded.
	 * 
	 * @return	The bytes loaded.
	 */
	public function getBytesLoaded(Void):Number
	{
		return _target.getBytesLoaded();
	}
	
	/**
	 * Get the bytes total.
	 * 
	 * @return	The bytes total.
	 */
	public function getBytesTotal(Void):Number
	{
		return _target.getBytesTotal();
	}
	
	/**
	 * Represent the current instance into a String.
	 *
	 * @return	A String representing the FileData instance.
	 */
	public function toString(Void):String
	{
		return "ch.preload.FileData";
	}
}