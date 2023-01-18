/**
* The WaveMotion class encapsulates oscillation and
* allows easy manipulation of wave properties.
* 
* @author Robert Penner (AS 1.0)
* © 2002 Robert Penner
* http://www.robertpenner.com
* 
* @author Mark Walters (AS 2.0)
* © 2006 DigitalFlipbook
* http://www.digitalflipbook.com
* 
* @version	1.0
* 
* @since	ActionScript 2.0; Flash Player 6
*/
[Event ("onMotionChanged")]
[Event ("onMotionFinished")]
[Event ("onMotionLooped")]
[Event ("onMotionResumed")]
[Event ("onMotionStarted")]
[Event ("onMotionStopped")]
class com.robertpenner.effects.WaveMotion extends mx.transitions.Tween {
	/*
	* CLASS PROPERTIES
	*/
	private var $amp:Number = 0;
	private var $period:Number = 0;
	private var $timeShift:Number = 0;
	private var $offset:Number = 0;
	/*
	* EVENTS
	*/
	/**
	* Event broadcast with each change in the tweened object's property that is being animated.
	* 
	* @usage 	<pre><code>
	* myTween.onMotionChanged = function() {
	    * 	// ...
	* };
	* </code></pre>
	*/
	public var onMotionChanged:Function;
	/**
	* Event broadcast when the Tween object finishes its animation.
	* 
	* @usage 	<pre><code>
	* myTween.onMotionFinished = function() {
	    * 	// ...
	* };
	* </code></pre>
	*/
	public var onMotionFinished:Function;
	/**
	* Event broadcast when the Tween object loops.
	* 
	* @usage 	<pre><code>
	* myTween.onMotionLooped = function() {
	    * 	// ...
	* };
	* </code></pre>
	*/
	public var onMotionLooped:Function;
	/**
	* Event broadcast when the Tween.resume() method is called, causing the tweened animation to resume.
	* 
	* @usage 	<pre><code>
	* myTween.onMotionResumed = function() {
	    * 	// ...
	* };
	* </code></pre>
	*/
	public var onMotionResumed:Function;
	/**
	* Event broadcast when the Tween.start() method is called, causing the tweened animation to start.
	* 
	* @usage 	<pre><code>
	* myTween.onMotionStarted = function() {
	    * 	// ...
	* };
	* </code></pre>
	*/
	public var onMotionStarted:Function;
	/**
	* Event broadcast when the Tween.stop() method is called, causing the tweened animation to stop.
	* 
	* @usage 	<pre><code>
	* myTween.onMotionStopped = function() {
	    * 	// ...
	* };
	* </code></pre>
	*/
	public var onMotionStopped:Function;
	/*
	* *********************************************************
	* CONSTRUCTOR
	* *********************************************************
	*
	*/
	/**
	* Creates an instance of the WaveMotion class.
	* 
	* @param	obj			The object which the WaveMotion targets.
	* @param	prop		The name of the property (in obj) that will be affected.
	* @param	amp			The magnitude of the wave's oscillation.
	* @param	period		The length of time it takes for the wave to go through one oscillation.
	* @param	offset		The amount to shift the wave vertically on the position axis.
	* @param	duration	The length of time of the motion; set to infinity if negative, 0 or omitted.
	* @param	useSeconds	A flag specifying whether to use seconds instead of frames, defaults to false.
	* 
	* @usage
	* <pre><code>
	* var myWave:WaveMotion = new WaveMotion(this, "_x", 100, 1, 0, 0, true);
	* </code></pre>
	*/
	function WaveMotion (obj:Object, prop:String, amp:Number, period:Number, offset:Number, duration:Number, useSeconds:Boolean) {
		super (obj, prop, null, offset, null, duration, useSeconds);
		this.offset = offset;
		this.amp = amp;
		this.period = period;
	}
	/*
	* *********************************************************
	* PRIVATE METHODS
	* *********************************************************
	* 
	*/
	/**
	* Returns the position of the WaveMotion at a specified time.
	* 
	* @param	t	The time to check the object's position; set to the current time if omitted.
	* @return	The position of the wave.
	* 
	* @usage
	* <pre><code>
	* trace (myWave.getPosition());
	* </code></pre>
	*/
	private function getPosition (t:Number):Number {
		if (t == undefined) {
			t = this.time;
		}
		return this.amp * Math.sin ((t - this.timeShift) * (2 * Math.PI) / this.period) + this.offset;
	}
	/*
	* *********************************************************
	* PUBLIC METHODS
	* *********************************************************
	* 
	*/
	/**
	* Sets the amp, period, timeShift, and offset of the wave.
	* 
	* @param	amp			The magnitude of the wave's oscillation.
	* @param	period		The length of time it takes for the wave to go through one oscillation.
	* @param	timeShift	The amount to shift the wave horizontally on the time axis.
	* @param	offset		The amount to shift the wave vertically on the position axis.
	* 
	* @usage
	* <pre><code>
	* myWave.setWavePhysics(80,2,.5,3);
	* </code></pre> 
	*/
	public function setWavePhysics (amp:Number, period:Number, timeShift:Number, offset:Number):Void {
		this.amp = amp;
		this.period = period;
		this.timeShift = timeShift;
		this.offset = offset;
	}
	/**
	* Instructs the tweened animation to continue from its current value to a new value.
	* 
	* @param	finish		A number indicating the ending value of the target object property that is to be tweened.
	* @param	duration	A number indicating the length of time or number of frames for the tween motion.
	* 
	* @usage
	* <pre><code>
	* myTween.continueTo(myFinish, myDuration);
	* </code></pre>
	*/
	public function continueTo (finish:Number, duration:Number):Void {
		super.continueTo (finish, duration);
	}
	/**
	* Forwards the tweened animation directly to the end of the animation.
	* 
	* @usage
	* <pre><code>
	* myTween.fforward();
	* </code></pre>
	*/
	public function fforward ():Void {
		super.fforward ();
	}
	/**
	* Forwards the tweened animation to the next frame.
	* 
	* @usage
	* <pre><code>
	* myTween.nextFrame();
	* </code></pre>
	*/
	public function nextFrame ():Void {
		super.nextFrame ();
	}
	/**
	* Directs the tweened animation to the frame previous to the current frame.
	* 
	* @usage
	* <pre><code>
	* myTween.prevFrame();
	* </code></pre>
	*/
	public function prevFrame ():Void {
		super.prevFrame ();
	}
	/**
	* Resumes a tweened animation from its stopped point in the animation.
	* 
	* @usage
	* <pre><code>
	* myTween.resume();
	* </code></pre>
	*/
	public function resume ():Void {
		super.resume ();
	}
	/**
	* Rewinds a tweened animation to the beginning of the tweened animation.
	* 
	* @usage
	* <pre><code>
	* myTween.rewind();
	* </code></pre>
	*/
	public function rewind ():Void {
		super.rewind ();
	}
	/**
	* Starts the tweened animation from the beginning.
	* 
	* @usage
	* <pre><code>
	* myTween.start();
	* </code></pre>
	*/
	public function start ():Void {
		super.start ();
	}
	/**
	* Stops the tweened animation at its current position.
	* 
	* @usage
	* <pre><code>
	* myTween.stop();
	* </code></pre>
	*/
	public function stop ():Void {
		super.stop ();
	}
	/**
	* Returns the class name, "[WaveMotion]".
	* 
	* @return	Returns the class name, "[WaveMotion]".
	* 
	* @usage
	* <pre><code>
	* trace (myWave.toString());
	* trace (myWave);
	* </code></pre>
	*/
	public function toString ():String {
		return "[WaveMotion]";
	}
	/**
	* Instructs the tweened animation to play in reverse from its last direction of tweened property increments.
	* 
	* @usage
	* <pre><code>
	* myTween.yoyo();
	* </code></pre>
	*/
	public function yoyo ():Void {
		super.yoyo ();
	}
	/*
	* *********************************************************
	* GETTERS/SETTERS
	* *********************************************************
	* 
	*/
	/**
	* The amplitude of the wave.
	* 
	* @usage
	* <pre><code>
	* myWave.amp = 80;
	* </code></pre>
	*/
	public function get amp ():Number {
		return this.$amp;
	}
	public function set amp (a:Number):Void {
		if (a != undefined) {
			this.$amp = a;
		}
	}
	/**
	* The period of the wave.
	* 
	* @usage
	* <pre><code>
	* myWave.period = 2;
	* </code></pre>
	*/
	public function get period ():Number {
		return this.$period;
	}
	public function set period (p:Number):Void {
		if (p != undefined) {
			this.$period = p;
		}
	}
	/**
	* The frequency of the wave.
	* 
	* @usage
	* <pre><code>
	* myWave.freq = .5;
	* </code></pre>
	*/
	public function get freq ():Number {
		return (1 / this.period);
	}
	public function set freq (f:Number):Void {
		this.period = (1 / f);
	}
	/**
	* The timeshift of the wave.
	* 
	* @usage
	* <pre><code>
	* myWave.timeShift = .5;
	* </code></pre>
	*/
	public function get timeShift ():Number {
		return this.$timeShift;
	}
	public function set timeShift (t:Number):Void {
		if (t != undefined) {
			this.$timeShift = t;
		}
	}
	/**
	* The offset of the wave.
	* 
	* @usage
	* <pre><code>
	* myWave.offset = 3;
	* </code></pre>
	*/
	public function get offset ():Number {
		return this.$offset;
	}
	public function set offset (f:Number):Void {
		if (f != undefined) {
			this.$offset = f;
		}
	}
	/**
	* The duration of the tweened animation in frames or seconds.
	* 
	* @usage
	* <pre><code>
	* trace (myTween.duration);
	* </code></pre>
	*/
	public function get duration ():Number {
		return super.duration;
	}
	public function set duration (d:Number):Void {
		super.duration = d;
	}
	/**
	* The last tweened value for the end of the tweened animation.
	* 
	* @usage
	* <pre><code>
	* trace (myTween.finish);
	* </code></pre>
	*/
	public function get finish ():Number {
		return super.finish;
	}
	public function set finish (f:Number):Void {
		super.finish = f;
	}
	/**
	* The number of frames per second of the tweened animation.
	* 
	* @usage
	* <pre><code>
	* trace (myTween.FPS);
	* </code></pre>
	*/
	public function get FPS ():Number {
		return super.FPS;
	}
	public function set FPS (fps:Number):Void {
		super.FPS = fps;
	}
	/**
	* The current value of the target movie clip's property being tweened.
	* 
	* @usage
	* <pre><code>
	* trace (myTween.position);
	* </code></pre>
	*/
	public function get position ():Number {
		return super.position;
	}
	public function set position (p:Number):Void {
		super.position = p;
	}
	/**
	* The current time within the duration of the animation.
	* 
	* @usage
	* <pre><code>
	* trace (myTween.time);
	* </code></pre>
	*/
	public function get time ():Number {
		return super.time;
	}
	public function set time (t:Number):Void {
		super.time = t;
	}
}
