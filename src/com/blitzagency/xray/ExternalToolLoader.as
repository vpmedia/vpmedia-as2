/*
Copyright (c) 2005 John Grden | BLITZ

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions
of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
import mx.events.EventDispatcher;
/**
 * Singleton
 *
 * ExternalToolLoader will likely change in the very near future with the release of the Xray (AdminTool) interface.
 *
 * It was created to load external tools into the interface and add a tab for the loaded tool.  Originaly developed
 * and tested with FlashInspector.
 *
 * @author John Grden :: John@blitzagency.com
 */
class com.blitzagency.xray.ExternalToolLoader extends MovieClip
{
	var addEventListener:Function;
	var removeEventListener:Function;
	var dispatchEvent:Function;

	public var output_mc:MovieClip;
	public var propertyInspector_mc:MovieClip;
	public var externalAssets:Object; // contains list of externally loaded assets
	/**
     * @summary MovieClipLoader Object
	 */
	private var mcl:MovieClipLoader;
	/**
     * @summary right now, the containerWidth and Height are representing the available space in Xray's (The AdminTool) current configuration
	 */
	private var containerWidth:Number = 370;
	private var containerHeight:Number = 430;

	public static var _instance:ExternalToolLoader = null;

	public static function getInstance():ExternalToolLoader
	{
		if(ExternalToolLoader._instance == null)
		{
			ExternalToolLoader._instance = new ExternalToolLoader();
		}
		return ExternalToolLoader._instance;
	}

	private function ExternalToolLoader()
	{
		// private contructor insures that this will be the only instance

		// initialize event dispatcher
		EventDispatcher.initialize(this);

		// initialized the instance prop so it doesn't fire off when referenced
		ExternalToolLoader._instance = this;

		this.init();
	}

	function onLoad()
	{

	}

	private function init()
	{
		this.propertyInspector_mc._visible = false;

		// set up the loader
		this.mcl = new MovieClipLoader();
		this.mcl.addListener(this);

		//trace("ExternalToolLoader initialized");
	}


	public function restack(tab:Number, p_target:MovieClip)
	{
		//_level0.AdminTool.trace("restack", tab);
		switch(tab)
		{
			case 0:
				this.output_mc._visible = true;
				this.propertyInspector_mc._visible = false;
			break;

			case 1:
				this.output_mc._visible = false;
				this.propertyInspector_mc._visible = true;
			break;

			default:
				this.output_mc._visible = false;
				this.propertyInspector_mc._visible = false;
		}

		var obj:Object = this.externalAssets
		for(var items:String in obj)
		{
			if(typeof(obj[items]) == "object")
			{
				//var ary:Array = p_target.dataProvider;
				if(obj[items].tabIndex == tab)
				{
					trace(0);
					// we have a match
					obj[items].mc._visible = true;
				}else
				{
					trace(1);
					// hide
					obj[items].mc._visible = false;
				}
			//	_level0.AdminTool.trace("items", items, obj[items].mc, obj[items].mc._visible, tab);
			}
		}
	}

	public function loadExternal(p_location:String, p_label:String)
	{
		if(!this.externalAssets) this.externalAssets = new Object();

		// add tab
		_level0.main_mc.tabs_1.addItem({label:p_label, data:p_location});

		// load asset
		var mc = this.createEmptyMovieClip(p_label, this.getNextHighestDepth());

		//trace("mcl? - " + this.mcl.loadClip);
		this.mcl.loadClip(p_location, mc);

		// add to externalAssets object
		var ea = this.externalAssets[p_label] = new Object();
		ea.location = p_location;
		ea.label = p_label;
		ea.mc = mc;
		ea.tabIndex = _level0.main_mc.tabs_1.dataProvider.length-1; //zero based
		//trace("dataProvider.length - " + _level0.main_mc.tabs_1.dataProvider.length);
	}

	// called when loadClip() actually starts to load the file requested
	function onLoadStart(target_mc)
	{
		trace("LOAD START - " + target_mc);
	}

	/*
	Fired when the loaded SWF or JPG is completely loaded.

	NOTE:  this is NOT when the first frame of code is initialized or even available.  If there's a method
	or property in the loaded SWF that needs to be accessed immediately, use onLoadInit instead.
	*/

	public function onLoadComplete(target_mc)
	{
		//_global.tt("LOAD COMPLETE", target_mc);
	}

	// onLoadInit is fired when the first frame of code is initialized in the loaded SWF
	public function onLoadInit(target_mc)
	{
		//_level0.AdminTool.trace("LOAD INIT", target_mc);
		//trace("load init - " + target_mc);
		target_mc._visible = false;

		target_mc.w = this.containerWidth;
		target_mc.h = this.containerHeight;

		target_mc.app._uiController.onStageResize();

	}

	/*
	onLoadProgress includes 3 arguments:

	target_mc: movieclip being loaded
	loadedBytes: how many bytes have been loaded so far
	totalBytes: total file size in bytes
	*/
	public function onLoadProgress(target_mc, loadedBytes, totalBytes)
	{
		var percentLoaded:Number = Math.floor((loadedBytes/totalBytes)*100);
		//_level0.AdminTool.trace("LOAD PROGRESS", target_mc, percentLoaded);
	}

	/*
	The typical error is "file not found".

	You DEFINATELY want to include this anytime you use MovieClipLoader.
	*/

	public function onLoadError(target_mc, errorCode)
	{
		_level0.AdminTool.trace("LOAD ERROR", target_mc, errorCode);
		trace("load error - " + errorCode);
	}
}
