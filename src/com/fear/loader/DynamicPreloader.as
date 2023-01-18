class com.fear.loader.DynamicPreloader extends MovieClip
{
	// watcher
	private var monitorInterval:Number;
	// bar holder and sizes
	private var barHolder:MovieClip;
	private var swfLoadingBar:MovieClip;
	private var swfLoadingBarBox:MovieClip;
	// string for url of swf to load
	private var swfURL:String;
	// content holder
	public var swf:MovieClip;
	// some numbers
	private var loaded:Number;
	private var total:Number;
	private var percent:Number;
	private var instanceDepth:Number;
	// defaults
	public var boxLineColor:Number = 0xFFFFFF;
	public var boxFillColor:Number = 0xCA0000;
	public var barWidth:Number = 900;
	public var barHeight:Number = 3;
	// variables
	public var barXPosition = 0;
	public var barYPosition = 0;
	private var loadCompleteInvoked:Boolean;
	private var $context:MovieClip;
	
	private function pTrace(str):Void
	{
		trace("[com.fear.loader.DynamicPreloader] "+str);
	}
	function DynamicPreloader(target:MovieClip, id:String)
	{
		pTrace("constructor invoked w/ id: "+id);
		// we are the default context
		this.$context = this;
		// load my content ...
		this.swf = target.createEmptyMovieClip(id, target.getNextHighestDepth());
		// ... into an empty clip
		barHolder =  target.createEmptyMovieClip("barHolder", target.getNextHighestDepth());
	}
	public function monitorProgress(loader:DynamicPreloader)
	{
		trace('[com.fear.loader.DynamicPreloader] monitorProgress running');
		loader.swfProgressBarRun(loader.swf);
		loader.removeSWFBar();
		loader.monitorLoad();
	//	swfSquash();
	//	swfCenter();
		loader.fadeSWFIn(loader.swf);
	}
	// public load method
	public function doLoad(url:String,barX:Number,barY:Number):Void 
	{
		pTrace("doLoad invoked w/ url: "+url);
		barXPosition = barX;
		barYPosition = barY;
		swfURL = url;
		swfLoad(swfURL);
		swfProgressBar();
	}
	// load handler
	public function get context():MovieClip
	{
		return this.$context;
	}
	public function set context(mc:MovieClip):Void
	{
		this.$context = mc;
	}
	public function onLoadComplete(context:MovieClip):Void
	{
		trace('onLoadComplete invoked w/ context: ' + context);
	}
	public function onIntroComplete():Void
	{
		trace('intro complete');
	}
	// some accessors
	public function getLoadedBytes():Number
	{
		return loaded;
	}
	public function getTotalBytes():Number
	{
		return total;
	}
	public function getLoadedRatio():Number
	{
		return percent;
	}

	private function swfLoad(url) 
	{
		pTrace('swfLoad invoked w/ url:'+url);
		this.monitorInterval = setInterval(this.monitorProgress, 100, this)
		this.loadCompleteInvoked = false;
		swf._alpha = 0;
		swf.loadMovie(url);
	}

	private function swfProgressBar() 
	{
		trace("swfProgressBar invoked");
		if (barHeight<5) 
		{
			barHeight = 5;
		}
		//bar
		trace('barWidth: '+barWidth)
		swfLoadingBar = barHolder.createEmptyMovieClip("swfLoadingBar", barHolder.getNextHighestDepth());
		swfLoadingBar.lineStyle(.25, boxLineColor, 0);
		swfLoadingBar.beginFill(boxFillColor, 100);
		swfLoadingBar.lineTo(barWidth, 1);
		swfLoadingBar.lineTo(barWidth, barHeight);
		swfLoadingBar.lineTo(1, barHeight);
		swfLoadingBar.lineTo(1, 1);
		swfLoadingBar.endFill();
		swfLoadingBar._xscale = 0;
		//box
		swfLoadingBarBox = barHolder.createEmptyMovieClip("swfLoadingBarBox", barHolder.getNextHighestDepth());
		swfLoadingBarBox.lineStyle(.25, boxLineColor, 100);
		swfLoadingBarBox.lineTo(barWidth, 0);
		swfLoadingBarBox.lineTo(barWidth, barHeight);
		swfLoadingBarBox.lineTo(0, barHeight);
		swfLoadingBarBox.lineTo(0, 0);
		// uncomment the following 2 lines to position the bar dynamically
		// relative to the size of the swf being loaded
		// swfLoadingBarBox._x = swfLoadingBar._x=swf._x/2;
		// swfLoadingBarBox._y = swfLoadingBar._y=swf._y/2;
		// uncomment the following 2 lines to position the bar statically
		swfLoadingBarBox._x = swfLoadingBar._x = barXPosition;//105;
		swfLoadingBarBox._y = swfLoadingBar._y = barYPosition;//150;
	}
	
	public function swfProgressBarRun(mc:MovieClip) 
	{
		loaded = mc.getBytesLoaded()/1024;
		total = mc.getBytesTotal()/1024;
		percent = (loaded/total) * 100;
		//trace("[com.fear.loader.DynamicPreloader] monitorProgress loaded:"+loaded);
		/*
		barHolder.txtLoading.text = "Loading " 
										 + Math.round(percent)
										 + "%";
		*/
		var xScale:Number = (mc.getBytesLoaded() / mc.getBytesTotal()) * 100;
		if(xScale > 0)
		{
			swfLoadingBar._xscale = xScale;
		}
		trace('swfLoadingBar._xscale = '+(mc.getBytesLoaded() / mc.getBytesTotal()) * 100);
		
		//todo - implement this customization hack better
		_parent.loadFill._yscale = (mc.getBytesLoaded() / mc.getBytesTotal()) * 100;
		_parent.loadFill2._yscale = (mc.getBytesLoaded() / mc.getBytesTotal()) * 100;
	}
	
	private function removeSWFBar() 
	{
		if (swfLoadingBar._xscale>=100) 
		{
			barHolder.txtLoading.text = "";
			swfLoadingBar.removeMovieClip();
			swfLoadingBarBox.removeMovieClip();
		}
	}

	private function alphaFullCheck()
	{
		return (this.swf._alpha >= 100);
	}
	public function get loadComplete():Boolean
	{
		return (this.swf.getBytesLoaded() == this.swf.getBytesTotal() && this.swf._alpha < 100 && this.swf._width>0) 
	}
	private function monitorLoad()
	{
		if(this.loadComplete == true && this.loadCompleteInvoked == false)
		{
			this.onLoadComplete(this.$context);
			this.loadCompleteInvoked = true;
		}
	}
	// Begin Fading functions
	private function fadeSWFIn(mc) 
	{
		if(this.alphaFullCheck() == true)
		{
			this.onIntroComplete();
			clearInterval(this.monitorInterval);
		}
		if (mc.getBytesLoaded() == mc.getBytesTotal() && mc._alpha < 100 && mc._width>0) 
		{
			if (mc._alpha<100) 
			{
				mc._alpha += 10;
			}
		}
	}
	private function loadOut(mc) 
	{
		mc._alpha -= 10;
	}
	// End Fading functions

	public function swfCenter() 
	{
		if (swf._width > 0) 
		{
			var r1 = false;
			if (r1 != true) 
			{
				var pIX = swf._x;
				var pIY = swf._y;
				r1 = true;
			}
			swf._x = pIX + (swf._width)/2;
			swf._y = pIY + (swf._height)/2;
		}
	}
}