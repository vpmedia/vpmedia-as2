import com.fear.core.CoreObject;
import com.fear.loader.DynamicPreloader;

class com.fear.util.MovieClipUtil extends CoreObject
{
	private static var $checks:Object;

	public static function fadeIn(target:MovieClip, time:Number, context:Object, callback:Function)
	{
		target._alpha = 0;
		target._visible = true;
		var end = 100;
		if(arguments[3] != undefined)
		{
			end = arguments[1];
		}
		var ease  = mx.transitions.easing.Strong.easeIn;
		var time  = 1.68;
		var tween = new mx.transitions.Tween(target, "_alpha", ease, 0, end, time, true);
		tween.content.context = context;
		tween.content.callback = callback;
		tween.onMotionFinished = function(obj)
		{
			obj.content.callback(obj.content.context);
		}
		
	}
	public static function fadeOut(target:MovieClip, time:Number, context:Object, callback:Function)
	{
		var ease  = mx.transitions.easing.Strong.easeIn;
		var time  = .68;
		var tween = new mx.transitions.Tween(target, "_alpha", ease, 100, 0, time, true);
		tween.content.context = context;
		tween.content.callback = callback;
		tween.onMotionFinished = function(obj)
		{
			obj.content.callback(obj.content.context);
		}
	}
	public static function loadContent(target:MovieClip, url:String, x:Number, y:Number):Void
	{		
		var $loader = new DynamicPreloader(target, target._name + '_DyanamicPreloader')
		// check for load handler
		if(arguments[4] != undefined)
		{
			if((com.fear.util.ObjectUtil.isSet(arguments[4]) == true) && (typeof(arguments[5]) == typeof(Function)))
			{
				$loader.context = arguments[4];
				$loader.onLoadComplete = arguments[5];
			}
		}
		// load
		$loader.doLoad(url, x, y);
	}
	public static function drawMask(target:MovieClip, w:Number, h:Number):Void
	{
		target.$maskHeight = h;
		target.$maskWidth = w;
		// find target
		var maskTarget:MovieClip = target._parent;
		var maskId:String = target._name + '_mask';
		// destroy
		if(maskTarget[maskId] != undefined)
		{
			maskTarget[maskId].removeMovieClip();
		}
		// build
		target.$mask = maskTarget.createEmptyMovieClip(maskId, maskTarget.getNextHighestDepth());
		// position
		target._parent[maskId]._y = _parent[target._name]._y;
		target.$mask._x = target._x;
		//target.$mask._x = maskTarget[target._name]._x;
		// color 
		target.$mask.lineStyle(.25, 0x999999, 100);
		// size/fill
		target.$mask.beginFill(0x666666, 100);
		target.$mask.lineTo(target.$maskWidth, 0);
		target.$mask.lineTo(target.$maskWidth, target.$maskHeight);
		target.$mask.lineTo(0, target.$maskHeight);
		target.$mask.lineTo(0, 0);
		target.$mask.endFill();
		// make mask
		target.setMask(target.$mask);
	}
	public static function hasLoaded(target:MovieClip):Boolean{
		return (target.getBytesLoaded() >= target.getBytesTotal());
	}

	public static function getPercentLoaded(target:MovieClip):Number{
		return 100 * (target.getBytesLoaded() / target.getBytesTotal());
	}

	public static function setLoadCallbacks(target:MovieClip,
						dataCallbackObject:Object,
						dataCallbackMethod:Function,
						dataCallbackArgs:Object,
						completeCallbackObject:Object,
						completeCallbackMethod:Function,
						completeCallbackArgs:Object):Void{
		if(typeof $checks != 'object'){
			$checks = new Object();
		}
		var checksId = target;
		var key = '' + target + '';
		var o;
		if(typeof $checks[key] != 'object'){
			o = new Object();
		}
		o.target = target;
		o.dataCallbackObject = dataCallbackObject;
		o.dataCallbackMethod = dataCallbackMethod;
		o.dataCallbackArgs = dataCallbackArgs;
		o.completeCallbackObject = completeCallbackObject;
		o.completeCallbackMethod = completeCallbackMethod;
		o.completeCallbackArgs = completeCallbackArgs;
		o.begin = function(){
			this.interval = setInterval(this, 'checkData', 80);
		}
		o.oldData = -1;
		o.checkData = function(){
			var bl = this.target.getBytesLoaded();
			if(bl > 200 && this.oldData < bl){
				//	we got some new data loaded into (target)
				trace('calling: ' + this.dataCallbackMethod + ' on: ' + this.dataCallbackObject);
				if(typeof this.dataCallbackMethod == 'function'){
					this.dataCallbackMethod.apply(this.dataCallbackObject, this.dataCallbackArgs);
				}
				if(bl >= this.target.getBytesTotal()){
					if(typeof this.completeCallbackMethod == 'function'){ 
						this.completeCallbackMethod.apply(this.completeCallbackObject, this.completeCallbackArgs);
					}
					clearInterval(this.interval);
					delete(this);
				}
			}
		}
		$checks[key] = o;
		$checks[key].begin();
	}
}
