import com.senocular.drawing.ShapeTweenKeyframe;
import com.senocular.drawing.ShapeTweenCommand;
/**
* @author Trevor McCauley, senocular.com
* @version 0.9.2
* @requires com.senocular.drawing.ShapeTweenKeyframe
* @requires com.senocular.drawing.ShapeTweenKeyframe
* @requires com.senocular.drawing.MxDrawingAPI
*/
class com.senocular.drawing.ShapeTween implements com.senocular.drawing.MxDrawingAPI {
	
	// PUBLIC PROPERTIES
	/**
	* The movie clip to draw in.
	*/
	public var target:Object;
	/**
	* The current frame within drawing. This is between 1 and _totalframes.
	* @see _totalframes
	*/
	public var _currentframe:Number = 1;
	/**
	* The total number of frames in a drawing
	* @see _currentframe
	*/
	public var _totalframes:Number = 1;
	/**
	* True or False depending on whether or not this ShapeTween is
	* currently playing or not
	* @see play
	* @see stop
	* @see gotoAndPlay
	* @see gotoAndStop
	*/
	public var isPlaying:Boolean = false;

	// PRIVATE PROPERTIES
	private var keyframes:Array; // those created with setKeyframe()
	private var keyframehash:Object; // quick ref to keyframes
	private var currentkeyframe:ShapeTweenKeyframe = null; // for drawing commands
	private var tweenKeyframes:Array = null; // list of keyframes involved in tween [0] = current (drawing) frame [1] = keyframe from [2] = keyframe to
	private var isDirty:Boolean = true; // determines when a tween needs to be evaluated, start keyframe of tween

	// CONSTRUCTOR
	/**
	* Class constructor; creates a ProgressiveDrawing instance.
	* @param target The target movie clip to draw in.
	*/
	function ShapeTween(target:Object) {
		this.target = (target) ? target : _root;
		this.keyframes = new Array();
		this.keyframehash = new Object();
	}
	
	// PUBLIC METHODS
	public function setKeyframe(frame:Number):Void {
		if (this.keyframehash[frame]) this.currentkeyframe = this.keyframehash[frame];
		else this.currentkeyframe = this.addKeyframe(frame);
	}
	public function duplicateKeyframe(frame:Number, duplicateframe:Number):Void {
		if (!this.keyframehash[frame]) return;
		var dup:ShapeTweenKeyframe = new ShapeTweenKeyframe(duplicateframe);
		var cmds:Array = this.keyframehash[frame].commands;
		var n:Number = cmds.length;
		var i:Number;
		// NOTE: same args array referenced
		for (i=0; i<n; i++) dup.addCommand(cmds[i].method, cmds[i].args);
		this.addKeyframe(duplicateframe, dup);
	}
	public function clearKeyframe(frame:Number):Boolean {
		this.isDirty = true;
		if (this.keyframehash[frame]){
			var n:Number = this.keyframes.length;
			var i:Number;
			for (i=0; i<n; i++){
				if (this.keyframes[i].frame == frame){
					delete this.keyframehash[frame];
					this.keyframes.splice(i, 1);
					if (this.keyframes.length){
						this.currentkeyframe = (this.keyframes[i-1]) ? this.keyframes[i-1] : this.keyframes[i];
						this._totalframes = this.keyframes[this.keyframes.length-1].frame;
					}else{
						this.currentkeyframe = null;
						this._totalframes = 1;
					}
					this.containCurrentFrame();
					return true;
				}
			}
		}
		return false;
	}
	public function play():Void {
		this.isDirty = true;
		this.isPlaying = true;
		MovieClip.addListener(this);
	}
	public function stop():Void {
		this.isDirty = true;
		this.isPlaying = false;
		this.render();
		MovieClip.removeListener(this);
	}
	public function gotoAndPlay(frame:Number):Void {
		if (!this._totalframes) return;
		this._currentframe = frame;
		this.containCurrentFrame();
		this.play();
	}
	public function gotoAndStop(frame:Number):Void {
		if (!this._totalframes) return;
		this._currentframe = frame;
		this.containCurrentFrame();
		this.stop();
	}
	public function nextFrame(Void):Void {
		if (!this._totalframes) return;
		this._currentframe++;
		this.containCurrentFrame();
		this.stop();
	}
	public function prevFrame(Void):Void {
		if (!this._totalframes) return;
		this._currentframe--;
		this.containCurrentFrame();
		this.stop();
	}

	/**
	* Allows you to add an ease method to the current keyframe.  The tweening is applied to
	* the progression of the tween from this keyframe to the next. Calling this method
	* with no arguments removes any previously added ease methods.
	* @param easeMethod The ease method to use to ease the motion of the drawing.
	* This method should accept at least one float between 0 and 1 that represents the current
	* position in the drawing and return an eased version of that value within the same range.
	* In addition to the easeMethod argument, any number of additional comma separated
	* arguments may be added to be used in the call to the ease method.
	* @return nothing.
	* @see render
	*/
	public function setEase(easeMethod:Function):Void {
		if (!this.currentkeyframe) return;
		this.currentkeyframe.setEase(easeMethod);
	}
	// Drawing API:
	/**
	* Drawing Command. Creates a lineStyle command, adding it to the drawing.
	* @param thick Line thickness.
	* @param col Color to be used for the line.
	* @param alpha Alpha transparency for the line.
	* @return nothing.
	* @see beginFill
	* @see beginGradientFill
	* @see endFill
	*/
	public function lineStyle(thick:Number, col:Number, alpha:Number):Void {
		this.updateKeyframes();
		this.currentkeyframe.addCommand("lineStyle", arguments);
	}
	/**
	* Drawing Command. Creates a beginFill command, adding it to the drawing.
	* @param col Color to be used in the fill.
	* @param alpha Alpha transparency of the fill.
	* @return nothing.
	* @see lineStyle
	* @see beginGradientFill
	* @see endFill
	*/
	public function beginFill(col:Number, alpha:Number):Void {
		this.updateKeyframes();
		this.currentkeyframe.addCommand("beginFill", arguments);
	}
	/**
	* Drawing Command. Creates a beginGradientFill command, adding it to the drawing.
	* @param fillType Type of fill for the gradient.
	* @param colors Colors to be used in the gradient.
	* @param alphas Alphas for transparency distribution.
	* @param ratios Ratios for color distribution.
	* @param matrix Matrix object describing the gradient.
	* @return nothing.
	* @see curveMoveTo
	* @see lineTo
	* @see curveTo
	*/
	public function beginGradientFill(fillType:String, colors:Array, alphas:Array, ratios:Array, matrix:Object):Void {
		this.updateKeyframes();
		this.currentkeyframe.addCommand("beginGradientFill", arguments);
	}
	/**
	* Drawing Command. Creates a moveTo command, adding it to the drawing.
	* @param ex x end point.
	* @param ey y end point.
	* @return nothing.
	* @see startAt
	* @see curveMoveTo
	* @see lineTo
	* @see curveTo
	*/
	public function moveTo(ex:Number, ey:Number):Void {
		this.updateKeyframes();
		this.currentkeyframe.addCommand("moveTo", arguments);
	}
	/**
	* Drawing Command. Creates a lineTo line, adding it to the drawing.
	* @param ex Line x end point.
	* @param ey Line y end point.
	* @return nothing.
	* @see moveTo
	* @see curveTo
	*/
	public function lineTo(ex:Number, ey:Number):Void {
		this.updateKeyframes();
		this.currentkeyframe.addCommand("lineTo", arguments);
	}
	/**
	* Drawing Command. Creates a curveTo curve, adding it to the drawing.
	* @param cx Curve x control point.
	* @param cy Curve y control point.
	* @param ex Curve x end point.
	* @param ey Curve y end point.
	* @return The ProgressiveDrawing instance.
	* @see moveTo
	* @see curveMoveTo
	* @see lineTo
	*/
	public function curveTo(cx:Number, cy:Number, ex:Number, ey:Number):Void {
		this.updateKeyframes();
		this.currentkeyframe.addCommand("curveTo", arguments);
	}
	/**
	* Drawing Command. Creates a endFill command, adding it to the drawing.
	* @return nothing.
	* @see lineStyle
	* @see beginFill
	* @see beginGradientFill
	*/
	public function endFill(Void):Void {
		this.updateKeyframes();
		this.currentkeyframe.addCommand("endFill", arguments);
	}
	/**
	* Drawing Command. Creates a clear command, adding it to the drawing.
	* @return nothing.
	* @see curveTo
	* @see lineTo
	*/
	public function clear(Void):Void {
		this.clearKeyframe(this.currentkeyframe.frame);
	}
	
	
	// PRIVATE METHODS
	// events
	private function onEnterFrame(Void):Void {
		this._currentframe++;
		this.wrapCurrentFrame();
		this.render();
	}
	
	// methods
	private function wrapCurrentFrame(Void):Void {
		if (this._currentframe > this._totalframes){
			this._currentframe = 1;
		}
	}
	
	private function containCurrentFrame(Void):Void {
		if (this._currentframe > this._totalframes){
			this._currentframe = this._totalframes;
		}else if (this._currentframe < 1) {
			this._currentframe = 1;
		}
	}
	
	private function addKeyframe(frame:Number, keyframe:ShapeTweenKeyframe):ShapeTweenKeyframe {
		this.isDirty = true;
		var match:Boolean = false;
		var pos:Number = 0;
		var n:Number = this.keyframes.length;
		if (n){
			pos = n;
			var i:Number;
			for (i=0; i<n; i++){
				if (this.keyframes[i].frame == frame){
					match = true;
					pos = i;
					break;
				}else if (this.keyframes[i].frame > frame){
					pos = i;
					break;
				}
			}
		}else this._currentframe = 1;
		if (!keyframe) keyframe = new ShapeTweenKeyframe(frame);
		this.keyframehash[frame] = keyframe;
		if (match) this.keyframes[pos] = keyframe;
		else this.keyframes.splice(pos, 0, keyframe);
		this._totalframes = this.keyframes[this.keyframes.length-1].frame;
		return keyframe;
	}
	
	private function updateKeyframes(Void):Void {
		this.isDirty = true;		
		if (!this.keyframes.length){
			this.setKeyframe(1);
		}
	}
	
	private function evaluateTweenKeyframes():Void {
		if (this.keyframehash[this._currentframe]){ // on a keyframe
			this.tweenKeyframes = [this.keyframehash[this._currentframe]];
			this.isDirty = true;
			return;
		}
		
		if (!this.isDirty) return;

		this.tweenKeyframes = null;
		var n:Number = this.keyframes.length;
		var i:Number;
		for (i=0; i<n; i++){
			if (this.keyframes[i].frame > this._currentframe){
				if (i){
					this.tweenKeyframes = [
						this.keyframes[i-1].createTween(this.keyframes[i]),
						this.keyframes[i-1],
						this.keyframes[i]
					];
					this.isDirty = false;
				}
				return;
			}
		}
	}
	
	private function tween(){
		if (this.tweenKeyframes.length == 3){
			var offset:Number = this._currentframe - this.tweenKeyframes[1].frame;
			var t:Number = offset/(this.tweenKeyframes[2].frame - this.tweenKeyframes[1].frame);
			t = this.tweenKeyframes[1].applyEase(t);
			this.tweenKeyframes[0].tween(t);
		}
	}
	
	private function render():Void {
		this.evaluateTweenKeyframes();
		if (this.tweenKeyframes){
			this.tween();
			this.target.clear();
			this.tweenKeyframes[0].drawIn(this.target);
		}
	}

	private static var OEFDependancy = mx.transitions.OnEnterFrameBeacon.init();
}