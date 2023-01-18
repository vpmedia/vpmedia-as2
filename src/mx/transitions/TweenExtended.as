//	****************************************************
//	TweenExtended
//	****************************************************
//	By "George Medve" <george [at] sqcircle.com>
//
//	TweenExtended extends mx.transitions.Tween 
//	multiple properties can be "Tweened" on one call
//	
//	EXAMPLE USAGE:
//	import mx.transitions.TweenExtended;
//	import mx.transitions.easing.*;
//	var _tween:TweenExtended = new TweenExtended(ball_mc, ["_x","_y","_alpha"], Regular.easeInOut, [ball_mc._x, ball_mc._y, ball_mc._alpha], [50, 350, 50], 5, true [,10 [, 20]] );
//	
//	_tween.onMotionFinished = function(obj) {
//		trace(obj.obj+" - onMotionFinished")
//		//_tween.continueTo([150, 50, 90],5);
//		//_tween.yoyo();
//	}
//
//	_tween.onMotionStopped = function(obj) {
//		trace(obj.obj+" - onMotionStopped")
//	}
//	****************************************************
//	Last Modified 1st November 2005
//	****************************************************
/////////////////////////////////////////////
//	IMPORTS
/////////////////////////////////////////////
// import mx.transitions.easing.*;
// import com.robertpenner.easing.Regular;
import mx.transitions.Tween;
import mx.transitions.BroadcasterMX;
import mx.transitions.OnEnterFrameBeacon;
/////////////////////////////////////////////
/////////////////////////////////////////////
class mx.transitions.TweenExtended extends Tween {
	// class tweenExtended.TweenExtended extends Tween {
	//
	public var className:String = "TweenExtended";
	public static var version:String = "1.0.6";
	//
	//	LISTENERS
	public var onMotionStarted:Function;
	public var onMotionStopped:Function;
	public var onMotionFinished:Function;
	public var onMotionChanged:Function;
	public var onMotionResumed:Function;
	public var onMotionLooped:Function;
	//
	public var aProps:Array;
	public var aBegin:Array;
	public var aChange:Array;
	public var aPrevPos:Array;
	//
	private var point1:Number;
	private var point2:Number;
	//
	// _aPos is my equivalent of _pos, in both cases it seems to have no purpose
	private var _aPos:Array;
	// 
	/////////////////////////////////////////////
	//	CONSTRUCTOR
	///////////////////////////////////////////// 
	// new Tween (obj, prop, func, begin, finish, duration, useSeconds [, bezier point1 [, bezier point2 ]]);
	function TweenExtended (target:Object, props:Array, easeFunc:Function, strt:Array, end:Array, dur:Number, useSecs:Boolean, p1:Number, p2:Number) {
		OnEnterFrameBeacon.init ();
		if (!arguments.length) {
			return;
		}
		//  
		this.aChange = [];
		this.obj = target;
		this.aProps = props;
		this.aBegin = strt;
		this.position = copyArray (strt);
		this.duration = dur;
		this.useSeconds = useSecs;
		if (easeFunc) {
			this.func = easeFunc;
		}
		this.finish = end;
		this.point1 = p1;
		this.point2 = p2;
		this._listeners = [];
		// aPrevPos = [];
		// _aPos = [];
		addListener (this);
		this.start ();
		//	
	}
	/////////////////////////////////////////////
	/////////////////////////////////////////////
	/////////////////////////////////////////////
	//	OVERRIDER METHODS
	/////////////////////////////////////////////
	private function update ():Void {
		this.position = this.getPosition (this._time);
	}
	function continueTo (fin:Array, dur:Number):Void {
		for (var i = 0; i < aProps.length; i++) {
			this.aBegin[i] = this.position[i];
		}
		finish = fin;
		if (dur != undefined) {
			this.duration = dur;
		}
		start ();
	}
	function yoyo ():Void {
		var aTemp:Array = this.copyArray (this.aBegin);
		this.continueTo (aTemp, this.time);
	}
	/////////////////////////////////////////////
	/////////////////////////////////////////////
	/////////////////////////////////////////////
	// 	GETTERS AND SETTERS
	/////////////////////////////////////////////
	function get position ():Array {
		return this.getPosition ();
	}
	function getPosition (t:Number):Array {
		// 
		if (t == undefined) {
			t = this._time;
		}
		var aPos:Array = [];
		for (var i = 0; i < aProps.length; i++) {
			var b:Number = Number (this.aBegin[i]);
			var c:Number = Number (this.aChange[i]);
			// Check for Bezier Points
			if ((this.point1 == undefined) && (this.point2 == undefined)) {
				// No Bezier Points, normal calculation
				aPos[i] = this.func (t, b, c, this._duration);
			}
			else if ((this.point1 != undefined) && (this.point2 == undefined)) {
				// Single Bezier point - tweenQuadBez or tweenQuadBezThru
				aPos[i] = this.func (t, b, c, this._duration, this.point1);
			}
			else if ((this.point1 != undefined) && (this.point2 != undefined)) {
				// Two Bezier points - tweenCubicBez
				aPos[i] = this.func (t, b, c, this._duration, this.point1, this.point2);
			}
		}
		return aPos;
	}
	function set position (p:Array):Void {
		this.setPosition (p);
	}
	function setPosition (p:Array):Void {
		for (var i = 0; i < this.aProps.length; i++) {
			// aPrevPos[i] = _aPos[i]; seems to serve no purpose
			this.obj[aProps[i]] = this._aPos[i] = p[i];
		}
		this.broadcastMessage ("onMotionChanged", this, p);
		// added updateAfterEvent for setInterval-driven motion
		updateAfterEvent ();
	}
	function set finish (f:Array):Void {
		for (var i = 0; i < aProps.length; i++) {
			this.aChange[i] = f[i] - this.aBegin[i];
		}
	}
	function get finish ():Array {
		var aTemp = [];
		for (var i = 0; i < this.aProps.length; i++) {
			aTemp[i] = this.aBegin[i] + this.aChange[i];
		}
		return aTemp;
	}
	function set loop (b:Boolean):Void {
		this.looping = b;
	}
	function get loop ():Boolean {
		return this.looping;
	}
	/////////////////////////////////////////////
	/////////////////////////////////////////////
	/////////////////////////////////////////////
	//	TOOLS
	/////////////////////////////////////////////
	private function copyArray (arr:Array):Array {
		var aTemp:Array = [];
		if (arr.length == 0) {
			for (var i in arr) {
				aTemp[i] = arr[i];
			}
		}
		for (var i = 0; i < arr.length; i++) {
			aTemp[i] = arr[i];
		}
		return aTemp;
	}
	/////////////////////////////////////////////
	/////////////////////////////////////////////
	public function toString ():String {
		return ("[" + className + "]");
	}
	/////////////////////////////////////////////
	//	CLOSE CLASS
	///////////////////////////////////////////// 	
}
//
