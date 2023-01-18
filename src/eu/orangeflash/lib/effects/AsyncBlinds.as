import mx.transitions.Blinds;
import mx.transitions.Transition;
import mx.transitions.TransitionManager;
import mx.transitions.Tween;

class eu.orangeflash.lib.effects.AsyncBlinds extends Blinds
{
	private var tweenPositions:Array = new Array();
	private var actualFrameRate:Number = 25;
	private var totalFramesInAnimation:Number;
	private var currentFrame:Number=0;
	private var needDispatchEvent:Boolean=false;
	private var delay:Number;
	
	public function AsyncBlinds (content:MovieClip, transParams:Object, manager:TransitionManager)
	{
		this.init(content,transParams,manager);
	}
	private function init(content,transParams,manager):Void
	{
		super.init(content,transParams,manager);
		actualFrameRate = transParams.fps;
		totalFramesInAnimation = actualFrameRate*this.duration-4;
		delay = Math.floor(totalFramesInAnimation/this._numStrips);
	}
	
	
	
	private function _resetTween():Void
	{
		currentFrame = 0;
		needDispatchEvent=false;
		// do clean-up of possibly existing tween
		this._twn.stop();
		this._twn.removeListener (this);
		this._twn.stop();
		this._twn = new Tween (this,
										   null, 
										   this.easing, 
										   0, 
										   1, 
										   this.duration/2,
										   true);
		// need to first stop the tween and THEN set the prop to avoid rendering glitches
		this._twn.stop();
		this._twn.prop = "progress";
		this._twn.addListener (this);
	}
	
	private function _render (p:Number):Void 
	{
		if(!needDispatchEvent)
		{
			this.tweenPositions.push(p);
		}
		var h:Number = 100/this._numStrips;
		var mask:MovieClip = this._innerMask;
		mask.clear();
		var i:Number = this._numStrips;
		mask.beginFill (0xFF0000);
		for(var i:Number=0;i<=this._numStrips;i++)
		{
			if(currentFrame>=i)
			{
				var f:Number = (currentFrame+i<this.tweenPositions.length-1)?Math.floor(currentFrame+i):this.tweenPositions.length-1;
				var s:Number = this.tweenPositions[f]*h;
				this.drawBox (mask, -50, i*h - 50, 100, s);
			}
			
		}
		mask.endFill();
		currentFrame++;
		
	};
	function onMotionFinished (src:Object):Void {
		if(needDispatchEvent)
		{
			if (this.direction) {
				this.dispatchEvent ({type:"transitionOutDone", target:this});
			} else {
				this.dispatchEvent ({type:"transitionInDone", target:this});
			}
			delete this._twn;
		}else{
			needDispatchEvent = true;
			this._twn.yoyo();
		}
	}
}