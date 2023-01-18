import com.bourre.transitions.FPSBeacon;
import com.bourre.transitions.TweenFPS;
import wilberforce.events.simpleEventHelper;

import com.bourre.events.BasicEvent;
import com.bourre.events.EventType;

class wilberforce.animation.movieClipArrayAnimation extends simpleEventHelper implements com.bourre.transitions.IFrameListener 
{
	private var _clipArray:Array;
	private var _currentClipIndex:Number;
	
	private var _animationPropertyArray:Array;
	private var _frameDelay:Number;
	
	public static var MOVIECLIP_ANIMATION_COMPLETE_EVENT:EventType=new EventType("onMovieClipAnimationComplete");
	
	function movieClipArrayAnimation(clipArray:Array,frameDelay:Number)
	{
		super();
		_clipArray=clipArray;
		_animationPropertyArray=[];
		_frameDelay=frameDelay;
		for (var i in _clipArray)
		{
			//_clipArray[i]._alpha=50;
		}
	}
	
	public function setVisible(value:Boolean)
	{
		for (var i in _clipArray)
		{
			_clipArray[i]._visible=value;
		}
	}
	
	public function addAnimationProperty(name:String,start:Number,end:Number,frames:Number,relative:Boolean,animationFunction:Function)
	{
		_animationPropertyArray.push({name:name,start:start,end:end,frames:frames,relative:relative,animationFunction:animationFunction});
	}
	
	public function execute()
	{
		_currentClipIndex=0;
		FPSBeacon.getInstance().addFrameListener(this);
	}
	
	public function onEnterFrame() : Void
	{
		var tClip:MovieClip=_clipArray[_currentClipIndex];
		tClip._visible=true;
		for (var i in _animationPropertyArray)
		{
			var tProperty:Object=_animationPropertyArray[i];
			var tTween:TweenFPS
			if (tProperty.relative)
			{
				
				tTween=new TweenFPS(tClip,tProperty.name,tClip[tProperty.name]+tProperty.end,tProperty.frames,tClip[tProperty.name]+tProperty.start,tProperty.animationFunction);
				tTween.execute();
			}
			else {
				tTween=new TweenFPS(tClip,tProperty.name,tProperty.end,tProperty.frames,tProperty.start,tProperty.animationFunction);
				tTween.execute();
			}
		}
		_currentClipIndex++;
		if (_currentClipIndex>=_clipArray.length)
		{
			_oEB.broadcastEvent(new BasicEvent(MOVIECLIP_ANIMATION_COMPLETE_EVENT,this));
			FPSBeacon.getInstance().removeFrameListener(this);
		}
	}
}