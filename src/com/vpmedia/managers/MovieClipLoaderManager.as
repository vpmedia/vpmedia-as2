/*
Public Methods:
init(Void):Void
reset que / initialise
addItem(item:String, target:MovieClip):Void
add item to que
item 	= url of movie/image
target = target placeholder movieClip
load(Void):Void
start loading items in que
addEvent(type:String, func:Function):Void
removeEvent(type:String)Void
 Events:
{type:"onLoadError", target:_item.mc, src:_item.src, error:error}
{type:"onLoadProgress", target:_item.mc, src:_item.src, bytesLoaded:bytesLoaded, bytesTotal:bytesTotal}
{type:"onLoadStart", target:_item.mc, src:_item.src}
{type:"onLoadComplete", target:_item.mc, src:_item.src}
{type:"onLoadInit", target:_item.mc, src:_item.src}
{type:"allLoadInit", target:_item.mc, src:_item.src}
*/
import mx.events.EventDispatcher;
import com.vpmedia.Delegate;
class com.vpmedia.managers.MovieClipLoaderManager
{
	// VERSION
	private static var version = "v.1.0.0";
	// VARS
	private var loading:Boolean = false;
	private var _que:Array;
	private var _item:Object;
	// MOVIECLIPLOADER OBJ'S
	private var _listen:Object, _mcl:MovieClipLoader;
	// EVENT DISPATCHER FUNCS
	private var dispatchEvent:Function, addEventListener:Function, removeEventListener:Function;
	// CONSTRUCTOR //
	function MovieClipLoaderManager ()
	{
		trace ("Loaded: MovieClipLoaderManager: " + version);
		init ();
	}
	// INIT / RESET //
	public function init (Void):Void
	{
		// register with Event Dispatcher
		EventDispatcher.initialize (this);
		// define new objects
		_que = new Array ();
		_item = new Object ();
		_listen = new Object ();
		_mcl = new MovieClipLoader ();
		// set up functions
		_listen.onLoadError = Delegate.create (this, onLoadError);
		_listen.onLoadProgress = Delegate.create (this, onLoadProgress);
		_listen.onLoadStart = Delegate.create (this, onLoadStart);
		_listen.onLoadComplete = Delegate.create (this, onLoadComplete);
		_listen.onLoadInit = Delegate.create (this, onLoadInit);
		_mcl.addListener (_listen);
	}
	// ADD TO STACK //
	public function addItem (src:String, target:MovieClip):Void
	{
		_que.push ({src:src, mc:target});
	}
	// LOAD NEXT IN STACK //
	public function load (Void):Void
	{
		if (Boolean (que.length) && !loading)
		{
			loading = true;
			_item = que.shift ();
			_mcl.loadClip (_item.src, _item.mc);
		}
	}
	// LISTENER FUNCS //
	private function onLoadError (target:MovieClip, error:String):Void
	{
		dispatchEvent ({type:"onLoadError", target:_item.mc, src:_item.src, error:error});
	}
	private function onLoadProgress (target:MovieClip, bytesLoaded:Number, bytesTotal:Number):Void
	{
		dispatchEvent ({type:"onLoadProgress", target:_item.mc, src:_item.src, bytesLoaded:bytesLoaded, bytesTotal:bytesTotal});
	}
	private function onLoadStart (Void):Void
	{
		dispatchEvent ({type:"onLoadStart", target:_item.mc, src:_item.src});
	}
	private function onLoadComplete (Void):Void
	{
		dispatchEvent ({type:"onLoadComplete", target:_item.mc, src:_item.src});
	}
	private function onLoadInit (Void):Void
	{
		dispatchEvent ({type:"onLoadInit", target:_item.mc, src:_item.src});
		loading = false;
		if (_que.length)
		{
			load ();
		}
		else
		{
			dispatchEvent ({type:"allLoadInit", target:_item.mc, src:_item.src});
		}
	}
	// GETTERS/SETTERS //
	public function get que ():Array
	{
		return _que;
	}
	public function get item ():Object
	{
		return _item;
	}
	// ADD/REM EVENTS //
	public function addEvent (type:String, func:Function):Void
	{
		addEventListener (type, func);
	}
	public function removeEvent (type:String):Void
	{
		removeEventListener (type);
	}
}
