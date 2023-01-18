import mx.transitions.OnEnterFrameBeacon;

/**
 * The Tween class is used to create tweens or in-between values providing
 * a beginning and ending point, usually numbers, over a period of time
 * measured in steps.  This is typically used for animation. The events provided
 * are simple callbacks used like onPress for buttons.  
 */
class com.senocular.Tween {
	
	public static var version:String = "0.7.2"; // 01/18/06
	
	/** The starting value of the tween. */
	public var begin:Number = 0;
	/** The ending value of the tween. */
	public var end:Number = 1;
	/** The number of steps needed to complete a tween. */
	public var steps:Number = 100;

	/** The current step in the tween. This will be between 0 and steps. */
	public var currentStep:Number = 0;
	/** The value of the tween between begin and end. */
	public var value:Number = 0;
	/** The progress of the tween in percent (0-1) not including ease. */
	public var progress:Number = 0;
	/** The progress of the tween in percent (usually 0-1) including ease. */
	public var easeProgress:Number = 0;

	/** The function used to ease the tween progress. */
	public var ease:Function;

	/** Direction of movement, 1 for forward, -1 for reverse. */
	public var direction:Number = 1;
	/** Determines if tween is enabled. If not enabled, tween steps result in no change. */
	public var enabled:Boolean = true;
	/** Determines if tween loops or yoyos or behaves normally. Acceptable values are
	 * "loop" and "yoyo". Anything else results in a normal tween ending after reaching end. */
	public var behavior:String = "default";

	/** Identifies the automatic tween. Values can be "enterFrame" or "interval". */
	public var event:String = "enterFrame";	// enterFrame or interval

	/** When true, smooths looped and yoyoed tweens.  Smoothing prevents repetition
	 * of tween values at their end points alloing for smoother transitions. */
	public var smooth:Boolean = false;
	/** When true, the tween rounds its resulting value each step */
	public var round:Boolean = false;
	/** When true, the tween's value never goes below begin and never above end. */
	public var clamp:Boolean = false;

	// Private
	private var affects:Array;		// object/property list
	private var skipDelay:Number = 0;	// delay counter for skipping frames
	private var interval:Number;		// timed interval id
	private var skip:Number;			// frame delay or interval

	// Events
	/** Called when an automatic tween is started */
	public var onStart:Function;
	/** Called when an automatic tween is stopped */
	public var onStop:Function;
	/** Called when an automatic tween is not looping or yoyoing and completes */
	public var onComplete:Function;
	/** Called when a tween loops */
	public var onLoop:Function;
	/** Called when a tween Changes direction during a yoyo */
	public var onYoyo:Function;
	/** Called during each step */
	public var onStep:Function;

	/**
	 * Constructor: Creates a new Tween instance. New tween instances
	 * do not start tweening until you explicitly instruct them to.
	 * @param begin (Optional) The starting value of the tween. Default: 0.
	 * @param end (Optional) The ending value of the tween. Default: 1.
	 * @param steps (Optional) The number of steps needed to complete a tween. Default: 100.
	 * @param behavior (Optional) "loop", "yoyo", or "default" behavior. Default: "default".
	 * @param smooth (Optional) Smooths looped and yoyoed tweens. Default: false.
	 * @param ease (Optional) Ease function. Default: undefined.
	 * @param round (Optional) Round tween value. Default: false.
	 * @param clamp (Optional) Clamp tween value between begin and end. Default: false.
	 */
	function Tween(begin:Number, end:Number, steps:Number, behavior:String, smooth:Boolean, ease:Function, round:Boolean, clamp:Boolean){
		if (begin != undefined)		this.begin = begin;
		if (end != undefined)		this.end = end;
		if (steps != undefined)		this.steps = steps;
		if (behavior != undefined)	this.behavior = behavior;
		if (smooth != undefined)		this.smooth = smooth;
		if (ease != undefined)		this.ease = ease;
		if (round != undefined)		this.round = round;
		if (clamp != undefined)		this.clamp = clamp;
		this.affects = new Array();
		
		OnEnterFrameBeacon.init();
		this.update();
	}
	
	/**
	 * Takes the tween to the next step of its tweening process updating all tween properties to
	 * reflect the new position. This can be called manually or automatically using startEnterFrame or
	 * startInterval.
	 * @return The current value associated with the Tween instance
	 */
	public function step(Void):Number {
		if (!this.enabled) return this.value;
		
		var loopEvt:Boolean = false;
		var yoyoEvt:Boolean = false;
		var completeEvt:Boolean = false;
		
		// update step, check for looping/yoyo
		if (this.direction == 1 && this.currentStep >= this.steps){
			if (this.behavior == "loop"){
				this.currentStep = (this.smooth) ? 1 : 0;
				loopEvt = true;
			}else if (this.behavior == "yoyo") {
				this.direction = -1;
				this.currentStep = (this.smooth) ? this.steps - 1 : this.steps;
				yoyoEvt = true;
			}
		}else if (this.direction == -1 && this.currentStep <= 0){
			if (this.behavior == "loop"){
				this.currentStep = (this.smooth) ? this.steps - 1 : this.steps;
				loopEvt = true;
			}else if (this.behavior == "yoyo") {
				this.direction = 1;
				this.currentStep = (this.smooth) ? 1 : 0;
				yoyoEvt = true;
			}
		}else{
			this.currentStep += this.direction;
			if (this.currentStep > this.steps) this.currentStep = this.steps; // assure integrety
			else if (this.currentStep < 0) this.currentStep = 0;
		}
		// check for complete
		if ((this.direction == 1 && this.currentStep >= this.steps)
		||  (this.direction == -1 && this.currentStep <= 0)){
			completeEvt = true;
		}
		
		// update value/progress
		// this is done prior to events being fired
		this.update();
		
		// events
		if (loopEvt){
			this.onLoop(this.value);
		}
		if (yoyoEvt){
			this.onYoyo(this.value);
		}
		this.onStep(this.value);
		if (completeEvt){
			this.onComplete(this.value);
			if (this.behavior != "loop" && this.behavior != "yoyo") this.stop();
		}
		return this.value;
	}
	
	/**
	 * Reverses the direction of a tween
	 * @param progress (Optional) A percentage progress value to update the tween with
	 * @return The current value associated with the Tween instance
	 */
	public function update(progress:Number):Number {
		// evaluate progress
		this.progress = (progress == undefined) ? this.currentStep/this.steps : progress;
		if (this.ease){
			this.easeProgress = this.ease(this.progress);
			if (this.clamp){
				if (this.easeProgress > 1) this.easeProgress = 1;
				else if (this.easeProgress < 0) this.easeProgress = 0;
			}
		}else{
			this.easeProgress = this.progress;
		}
		
		// evaluate value
		this.value = this.begin + (this.end - this.begin)*this.easeProgress;
		if (this.round){
			this.value = Math.round(this.value);
		}
		
		// apply value to affected objects
		var i:Number = this.affects.length;
		var v, a:Object;
		while (i--) {
			a = this.affects[i];
			
			// unique tween to values
			if (a.isUniq){
				if (a.interp){
					v = a.interp(a.end, a.begin, this.easeProgress);
				}else{
					v = a.begin + (a.end - a.begin)*this.easeProgress;
				}
				
				// rounding if applicable
				if (this.round && !isNaN(v)){
					v = Math.round(v);
				}
			}else{
				v = (this.round) ? Math.round(this.value) : this.value;
			}
			
			// apply new value as call or prop value
			if (a.isCall){
				a.o[a.p](v);
			}else{
				a.o[a.p] = v;
			}
		}
		
		// update if called from a non-frame event
		_global.updateAfterEvent();
		
		return this.value;
	}
	
	/**
	 * Reverses the direction of a tween
	 * @param backwards (Optional) If true forces a tween to play backwards (in reverse). If true
	 * the tween's direction is forced forward.  Omitting the value toggles the direction.
	 */
	public function reverse(backwards:Boolean):Void {
		if (backwards == undefined) this.direction *= -1;
		else this.direction = (backwards) ? -1 : 1;
	}

	/**
	 * Resets a tween to its default position and direction
	 */
	public function reset(Void):Void {
		this.stop();
		this.currentStep = 0; // reset t to  direction end
		this.direction = 1; // reset t to  direction end
		this.update();
	}
	
	/**
	 * Adds a target-property combination to be affected by the tween
	 * @param target The object the tween will affect
	 * @param property The property of the object the tween's value is being assigned.
	 * if this represents a function, the function is called with the tween value passed
	 * to it as opposed to the property being assigned to equal the tween value
	 * @param begin (Optional) Starting value for the property if different from the tween's
	 * @param end (Optional) Ending value for the property if different from the tween's
	 * @param interpolate (Optional) A function to be used in interpolating the begin and end
	 * values if not numeric (if the begin and end values were points, for example).  The format
	 * of this function is interpolate(end, begin, percent) - similar to Flash 8's Point.interpolate;
	 * the higher the percent (tween progress), the closer to end.
	 */
	public function addTarget(target:Object, property:String, begin, end, interpolate:Function):Void {
		this.removeTarget(target, property);
		this.affects.push({
			o:target,
			p:property,
			isCall:(typeof target[property] == "function"),
			isUniq: (arguments.length > 2),
			begin:(begin == undefined) ? this.begin : begin,
			end:(end == undefined) ? this.end : end,
			interp:interpolate
		});
	}
	
	/**
	 * Removes a target-property combination from a tween's affect that was added with addTarget
	 * @param target The target object to be removed
	 * @param property The property relating to the target-property combination which is to be removed
	 * to it as opposed to the property being assigned to equal the tween value
	 * @return True or false depending on whether or not removal was successful
	 */
	public function removeTarget(target:Object, property:String):Boolean {
		var i:Number = this.affects.length;
		while(i--){
			if (this.affects[i].o == target
			&&  this.affects[i].p == property){
				this.affects.splice(i, 1);
				return true;
			}
		}
		return false;
	}
	
	/**
	 * Starts and automatic tween using an onEnterFrame event
	 * @param skip The number of frames to skip every frame before applying a tween step.
	 * This lets you slow tweens down to a rate that's slower than the FPS of the movie.
	 * 0  skips no frames, 1 tweens every other frame, 2 skips 2 frames etc.
	 */
	public function startEnterFrame(skip:Number):Void {
		this.event = "enterFrame";
		this.skipDelay = this.skip = skip;
		_global.MovieClip.addListener(this);
		this.onStart(this.value);
	}
	
	/**
	 * Starts and automatic tween using a timed interval event
	 * @param milliseconds (Optional) The number of milliseconds to play each tween step. Default: 1000.
	 */
	public function startInterval(milliseconds:Number):Void {
		this.event = "interval";
		this.skip = milliseconds;
		var time = (this.skip == undefined) ? 1000 : skip;
		_global.clearInterval(this.interval);
		this.interval = _global.setInterval(this, "step", time);
		this.onStart(this.value);
	}
	
	/**
	 * Starts and automatic tween using the last tween type used (enterFrame or interval).
	 * If startEnterFrame or startInterval has not been used prior to start(), 
	 * startEnterFrame is implied calling a tween step every frame.
	 */
	public function start(Void):Void {
		switch(this.event){
			case "enterFrame":
				this.startEnterFrame(this.skip);
				break;
			case "interval":
				this.startInterval(this.skip);
				break;
			default:
				this.startEnterFrame();
		}
	}
	
	/**
	 * Stops an automatic tween from continuing. Use startEnterFrame, startInterval,
	 * or start to resume the tween.
	 */
	public function stop(Void):Void {
		switch(this.event){
			case "enterFrame":
				_global.MovieClip.removeListener(this);
				break;
			case "interval":
				_global.clearInterval(this.interval);
				break;
		}
		this.onStop(this.value);
	}
	
	// Playback
	private function onEnterFrame(Void):Void {
		if (this.skip){
			this.skipDelay--;
			if (this.skipDelay < 0){
				this.skipDelay = this.skip;
				this.step();
			}
		}else{
			this.step();
		}
	}
}