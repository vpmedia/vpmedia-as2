import net.manaca.ui.awt.MxDrawingAPI;
/**
* The ProgressiveDrawing class creates a means by which you can progressively draw your 
* dynamically drawn Flash shapes over a period of multiple frames. The drawing API
* for this class matches with that of MovieClip, with the exception of a few additions,
* so conversion of existing drawings is simple and seemless.
* <p>
* Use a ProgressiveDrawing instance just as you would use a movie clip to draw lines and
* fills using Flash's drawing API on a movie clip.  The main difference is that when these
* commands are used  on a ProgressiveDrawing instance, they are not drawn right away. 
* They are only drawn when the draw command is used and over a period of time, not all at once.
*
* @usage
* <pre><code>import net.manaca.ui.awt.ProgressiveDrawing;
* // create a ProgressiveDrawing instance that draws in _root
* var myDrawing:ProgressiveDrawing = new ProgressiveDrawing(_root);
* // draw a square
* myDrawing.moveTo(50, 50);
* myDrawing.lineTo(100, 50);
* myDrawing.lineTo(100, 100);
* myDrawing.lineTo(50, 100);
* myDrawing.lineTo(50, 50);
* // draw square over a period of 50 frames
* myDrawing.draw(50);</code></pre>
*
* @author Trevor McCauley, senocular.com
* @version 0.9.6
*/

class net.manaca.ui.awt.ProgressiveDrawing implements MxDrawingAPI {
	
	// PUBLIC PROPERTIES
	/**
	* The movie clip to draw in.
	*/
	public var target:Object;
	/**
	* Contains x and y properties representing the position of the pen for the drawing
	* or the drawing's last position.
	*/
	public var pen:Object;
	/**
	* The current frame within drawing. This is between 1 and _totalframes.
	* @see _totalframes
	*/
	public var _currentframe:Number = 0;
	/**
	* The total number of frames in a drawing as specified in draw().
	* @see draw
	* @see _currentframe
	*/
	public var _totalframes:Number = 0;
	/**
	* The current drawing command being issued in the onStep event. This will represent
	* any of the drawing commands applied to the instance, "none" if not drawing.
	* Note that not all commands will be provided in an onStep, only that which is being
	* used at the current pen location when onStep is called.
	* @see onStep
	*/
	public var _currentcommand:String = "none";
	/**
	* Determines whether or not moveTo commands are tweened during drawing.
	* @see moveTo
	* @see curveMoveTo
	*/
	public var tweenMoveTo:Boolean = false;
	/**
	* Determines whether or not the class tweens a drawing itself when draw is called.
	* @see draw
	*/
	public var autoTween:Boolean = true;
	/**
	* Determines whether or not the drawing is being drawn in an autoTween.
	* @see autoTween
	* @see pause
	* @see resume
	*/
	public var isDrawing:Boolean = false;
	/**
	* Accuracy level for internally tetermining the length of curves created with curveTo.
	*/
	public var _curveaccuracy:Number = 6;
	/**
	* Allows you to add listeners to the ProgressiveDrawing instance to receive events.
	* @see removeListener
	* @see onStep
	* @see onComplete
	*/
	public var addListener:Function;
	/**
	* Allows you to remove listeners from the ProgressiveDrawing instance so that
	* they will no longer receive evnets.
	* @see addListener
	* @see onStep
	* @see onComplete
	*/
	public var removeListener:Function;
	// events
	/**
	* Event.  Called when ever a drawing steps, either when step() is called manually or
	* once a frame during a drawing tween.A single argument of the ProgressiveDrawing
	* instance is passed.
	* @param instance The ProgressiveDrawing instance sending the event
	* @see addListener
	* @see removeListener
	* @see onComplete
	*/
	public function onStep(instance:ProgressiveDrawing):Void {}
	/**
	* Event. Called when a drawing has completed drawing. A single argument of the
	* ProgressiveDrawing instance is passed.
	* @param instance The ProgressiveDrawing instance sending the event
	* @see addListener
	* @see removeListener
	* @see onStep
	*/
	public function onComplete(instance:ProgressiveDrawing):Void {};

	// PRIVATE PROPERTIES
	private var _penTo:Object;
	private var _commands:Array;
	private var _easeMethod:Function = function(t){ return t; };
	private var _easeMethodArgs:Array;
	private var broadcastMessage:Function;
	
	private static var prototype:Object;
	private static var OEFDependancy = mx.transitions.OnEnterFrameBeacon.init();
	private static var ASBDependancy = AsBroadcaster.initialize(prototype);
	
	// CONSTRUCTOR
	/**
	* Class constructor; creates a ProgressiveDrawing instance.
	* @param target The target movie clip to draw in.
	*/
	function ProgressiveDrawing(target:Object) {
		this.addListener(this);
		this.target = (target) ? target : _root;
		this._commands = new Array();
		this.clearDrawing(true);
	}
	
	// PUBLIC METHODS
	/**
	* Initiates the drawing of a collection of lines defined in the ProgressiveDrawing instance.
	* @param frames (Optional) The number of frames to use to draw. If not provided, the drawing
	* is immediately drawn in completion
	* @param target (Optional) The movie clip to draw in.  This will change the target reference
	* in the instance.
	* @return nothing.
	*/
	public function draw(frames:Number, target:Object):Void {
		this._totalframes = (frames == undefined) ? 0 : frames;
		this._currentframe = 0;
		if (target != undefined) this.target = target;
		this.evaluateStrokes();
		if (!this._totalframes) this.step();
		else if (this.autoTween){
			this.isDrawing = true;
			MovieClip.addListener(this);
		}
	}
	/**
	* Pauses the automatic drawing tween until resume is called.
	* @return nothing.
	* @see autoTween
	* @see resume
	*/
	public function pause(Void):Void {
		this.isDrawing = false;
		MovieClip.removeListener(this);
	}
	/**
	* Resumes the automatic drawing tween after it has been stoped as a result of pause.
	* @return nothing.
	* @see autoTween
	* @see pause
	*/
	public function resume(Void):Void {
		if (this._currentframe && this._currentframe < this._totalframes){
			this.isDrawing = true;
			MovieClip.addListener(this);
		}
	}
	/**
	* Forces the drawing to the next frame updating the drawing in the target movie clip.
	* Use this if autoTween is false, otherwise it will be called automatically every
	* frame after draw() is called. The onStep event is called after this is run.
	* If you use step to draw a drawing at your own rate, be sure to call draw first so
	* that you can specify the frames for that drawing and other setup operations can run.
	* @return nothing.
	* @see autoTween
	* @see draw
	*/
	public function step(Void):Void {
		if (this._totalframes == 0){
			this.render(true);
			this.broadcastMessage("onStep", this);
			this.renderComplete();
		}else{
			this._currentframe++;
			this.render();
			this.broadcastMessage("onStep", this);
			if (this._currentframe >= this._totalframes) this.renderComplete();
		}
	}
	/**
	* Removes all drawing commands from the instance reseting it to the state of a new instance
	* @param suppressClear (Optional) Determines whether or not the target movie clip is
	* cleared using clear() as well
	* @return nothing.
	* @see clear
	*/
	public function clearDrawing(suppressClear:Boolean):Void {
		this.pen = {x:0, y:0};
		this._penTo = {x:0, y:0};
		this._commands.length = 0;
		this._commands.totalLength = 0;
		this._currentframe = this._totalframes = 0;
		this._currentcommand = "none";
		if (!suppressClear) this.target.clear();
	}
	/**
	* Allows you to add an ease method to the drawing behavior of the drawing. Calling this method
	* with no arguments removes any previously added ease methods.
	* @param easeMethod The ease method to use to ease the motion of the drawing.
	* This method should accept at least one float between 0 and 1 that represents the current
	* position in the drawing and return an eased version of that value within the same range.
	* @param args (Optional) Any additional arguments to be used with the easeMethod.
	* @return nothing.
	* @see draw
	*/
	public function setEase(easeMethod:Function, args):Void {
		if (!easeMethod) delete this._easeMethod;
		else {
			this._easeMethod = easeMethod;
			this._easeMethodArgs = arguments;
		}
	}
	/**
	* Sets the drawings for the instance to be that of the drawing another instance passed.
	* @param drawing A ProgressiveDrawing instance to get a drawing from
	* @return nothing.
	* @see appendDrawing
	* @see prependDrawing
	*/
	public function setDrawing(drawing:ProgressiveDrawing):Void {
		var info = this.processCommands(drawing._commands);
		this._penTo.x = info.penEnd.x;
		this._penTo.y = info.penEnd.y;
		this._commands = info.commands;
	}
	/**
	* Appends the drawing from the instance passed to the drawing for this instance adding it
	* at the end of the of the drawing sequence.
	* @param drawing A ProgressiveDrawing instance to get a drawing from
	* @return nothing.
	* @see setDrawing
	* @see prependDrawing
	*/
	public function appendDrawing(drawing:ProgressiveDrawing):Void {
		this.combineCommands(this._commands, drawing._commands);
	}
	/**
	* Prepends the drawing from the instance passed to the drawing for this instance adding to
	* the beginning of the of the drawing sequence.
	* @param drawing A ProgressiveDrawing instance to get a drawing from
	* @return nothing.
	* @see setDrawing
	* @see appendDrawing
	*/
	public function prependDrawing(drawing:ProgressiveDrawing):Void {
		this.combineCommands(drawing._commands, this._commands);
	}
	
	// extended Drawing API:
	/**
	* Drawing Command. Sets a starting location for a drawing.  This works much like moveTo
	* only this will not be tweened when tweenMoveTo is true.
	* @param sx Start x location for a drawing.
	* @param sy Start y location for a drawing.
	* @return nothing.
	* @see tweenMoveTo
	* @see moveTo
	*/
	public function startAt(sx:Number, sy:Number):Void {
		this._commands.push({method:"startAt", arguments:arguments});
		this._penTo.x = sx;
		this._penTo.y = sy;
	}
	/**
	* Drawing Command. Creates a curved moveTo.  This works much like moveTo only in curveTo
	* form. Use this when tweenMoveTo is true to move in a curve without drawing one.
	* @param cx Curve x control point.
	* @param cy Curve y control point.
	* @param ex Curve x end point.
	* @param ey Curve y end point.
	* @return nothing.
	* @see tweenMoveTo
	* @see moveTo
	* @see curveTo
	*/
	public function curveMoveTo(cx:Number, cy:Number, ex:Number, ey:Number):Void {
		this._commands.push({method:"curveMoveTo", arguments:[this._penTo.x, this._penTo.y, cx, cy, ex, ey]});
		this._penTo.x = ex;
		this._penTo.y = ey;
	}
	/**
	* Drawing Command. Creates a pause command, adding it to the drawing. This lets you pause 
	* the drawing process
	* @param t Time to pause. Time is relative to the length of the full drawing and will vary based
	* on how many steps it takes to complete the drawing.
	* @return nothing.
	* @see moveTo
	* @see moveCurveTo
	*/
	public function pauseFor(t:Number):Void {
		this._commands.push({method:"pauseFor", arguments:arguments});
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
		this._commands.push({method:"lineStyle", arguments:arguments});
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
		this._commands.push({method:"beginFill", arguments:arguments});
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
		this._commands.push({method:"beginGradientFill", arguments:arguments});
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
		this._commands.push({method:"moveTo", arguments:[this._penTo.x, this._penTo.y, ex, ey]});
		this._penTo.x = ex;
		this._penTo.y = ey;
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
		this._commands.push({method:"lineTo", arguments:[this._penTo.x, this._penTo.y, ex, ey]});
		this._penTo.x = ex;
		this._penTo.y = ey;
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
		this._commands.push({method:"curveTo", arguments:[this._penTo.x, this._penTo.y, cx, cy, ex, ey]});
		this._penTo.x = ex;
		this._penTo.y = ey;
	}
	/**
	* Drawing Command. Creates a endFill command, adding it to the drawing.
	* @return nothing.
	* @see lineStyle
	* @see beginFill
	* @see beginGradientFill
	*/
	public function endFill(Void):Void {
		this._commands.push({method:"endFill", arguments:arguments});
	}
	/**
	* Drawing Command. Creates a clear command, adding it to the drawing.
	* @return nothing.
	* @see curveTo
	* @see lineTo
	*/
	public function clear(Void):Void {
		this._commands.push({method:"clear", arguments:arguments});
	}
	
	// PRIVATE METHODS
	// events
	private function onEnterFrame(Void):Void{
		this.step();
	}
	// methods
	private function evaluateStrokes(Void):Void{
		var total:Number = 0;
		var n:Number = this._commands.length;
		for (var i:Number = 0; i<n; i++){
			this._commands[i].start = total;
			total += this._commands[i].length = this.strokeLength(this._commands[i]);
			this._commands[i].end = total;
		}
		this._commands.totalLength = total;
	}
	private function render(full:Boolean):Void{
		this.target.clear();
		if (full){
			var n:Number = this._commands.length;
			for (var i:Number = 0; i<n; i++) this.renderCommand(this._commands[i], 1);
		}else{
			var args = new Array().concat(this._easeMethodArgs);
			args[0] = this._currentframe/this._totalframes;
			var t = this._easeMethod.apply(null, args);
			var drawto = t*this._commands.totalLength;
			var n:Number = this._commands.length;
			for (var i:Number = 0; i<n; i++){
				if (drawto > this._commands[i].end){
					this.renderCommand(this._commands[i], 1);
				}else{
					t = (drawto - this._commands[i].start)/(this._commands[i].end - this._commands[i].start);
					this.renderCommand(this._commands[i], t);
					break;
				}
			}
		}
		this.target.endFill();
	}
	private function renderCommand(command:Object, t:Number):Void {
		switch (command.method){
			case "startAt":
				this.target.moveTo.apply(this.target, command.arguments);
				break;
			case "moveTo":
				this.renderMoveTo.apply(this, command.arguments.concat(t));
				break;
			case "curveMoveTo":
				this.renderCurveMoveTo.apply(this, command.arguments.concat(t));
				break;
			case "lineTo":
				this.renderLineTo.apply(this, command.arguments.concat(t));
				break;
			case "curveTo":
				this.renderCurveTo.apply(this, command.arguments.concat(t));
				break;
			case "pauseFor":
				break;
			default:
				this.target[command.method].apply(this.target, command.arguments);
		}
		this._currentcommand = command.method;
	}
	private function renderMoveTo(sx:Number, sy:Number, ex:Number, ey:Number, t:Number):Void {
		if (t == undefined) t = 1;
		if (t != 1) {
			ex = sx + (ex-sx)*t;
			ey = sy + (ey-sy)*t;
		}
		this.target.moveTo(ex, ey);
		this.pen.x = ex;
		this.pen.y = ey;
	}
	private function renderCurveMoveTo(sx:Number, sy:Number, cx:Number, cy:Number, ex:Number, ey:Number, t:Number):Void {
		if (t == undefined) t = 1;
		if (t != 1) {
			var it:Number = 1-t;
			var a:Number = it*it;
			var b:Number = 2*t*it;
			var c:Number = t*t;
			ex = a*sx + b*cx + c*ex;
			ey = a*sy + b*cy + c*ey;
		}
		this.target.moveTo(ex, ey);
		this.pen.x = ex;
		this.pen.y = ey;
	}
	private function renderLineTo(sx:Number, sy:Number, ex:Number, ey:Number, t:Number):Void {
		if (t == undefined) t = 1;
		if (t != 1) {
			ex = sx + (ex-sx)*t;
			ey = sy + (ey-sy)*t;
		}
		this.target.lineTo(ex, ey);
		this.pen.x = ex;
		this.pen.y = ey;
	}
	private function renderCurveTo(sx:Number, sy:Number, cx:Number, cy:Number, ex:Number, ey:Number, t:Number):Void {
		if (t == undefined) t = 1;
		if (t != 1) {
			var midx:Number = cx + (ex-cx)*t;
			var midy:Number = cy + (ey-cy)*t;
			cx = sx + (cx-sx)*t;
			cy = sy + (cy-sy)*t;
			ex = cx + (midx-cx)*t;
			ey = cy + (midy-cy)*t;
		}
		this.target.curveTo(cx, cy, ex, ey);
		this.pen.x = ex;
		this.pen.y = ey;
	}
	private function renderComplete(Void):Void {
		this._currentframe = this._totalframes;
		this._currentcommand = "none";
		this.isDrawing = false;
		MovieClip.removeListener(this);
		this.broadcastMessage("onComplete", this);
	}
	private function strokeLength(command:Object, start:Object):Number {
		switch (command.method){
			case "moveTo":
				return (this.tweenMoveTo) ? this.lineLength.apply(this, command.arguments) : 0;
			case "curveMoveTo":
				return (this.tweenMoveTo) ? this.curveLength.apply(this, command.arguments) : 0;
			case "lineTo":
				return this.lineLength.apply(this, command.arguments);
			case "curveTo":
				return this.curveLength.apply(this, command.arguments);
			case "pauseFor":
				return command.arguments[0];
			default:
				return 0;
		}
	}
	private function lineLength(sx:Number, sy:Number, ex:Number, ey:Number):Number {
		var dx = ex - sx;
		var dy = ey - sy;
		return Math.sqrt(dx*dx + dy*dy);
	}
	private function curveLength(sx:Number, sy:Number, cx:Number, cy:Number, ex:Number, ey:Number, accuracy:Number):Number {
		var total:Number = 0;
		var tx:Number = sx;
		var ty:Number = sy;
		var px:Number, py:Number, t:Number, it:Number, a:Number, b:Number, c:Number;
		var n:Number = (accuracy) ? accuracy : this._curveaccuracy;
		for (var i:Number = 1; i<=n; i++){
			t = i/n;
			it = 1-t;
			a = it*it; b = 2*t*it; c = t*t;
			px = a*sx + b*cx + c*ex;
			py = a*sy + b*cy + c*ey;
			total += this.lineLength(tx, ty, px, py);
			tx = px;
			ty = py;
		}
		return total;
	}
	private function processCommands(commands:Array):Object {
		var info:Object = new Object();
		info.commands = new Array();
		var len:Number;
		var n:Number = commands.length;
		for (var i:Number = 0; i<n; i++){
			info.commands[i] = {method:commands[i].method, arguments:commands[i].arguments.slice()};
			switch(commands[i].method){
				case "startAt":
				case "moveTo":
				case "lineTo":
				case "curveMoveTo":
				case "curveTo":
					if (!info.penStart) info.penStart = {x:commands[i].arguments[0], y:commands[i].arguments[1], command:info.commands[i]};
					len = commands[i].arguments.length;
					info.penEnd = {x:commands[i].arguments[len-2], y:commands[i].arguments[len-1], command:info.commands[i]};
					break;
			}
		}
		return info;
	}
	private function combineCommands(commandsA:Array, commandsB:Array):Void {
		var infoA:Object = processCommands(commandsA);
		var infoB:Object = processCommands(commandsB);
		this._commands = infoA.commands.concat(infoB.commands);
		if (infoB.penStart && infoA.penEnd){
			infoB.penStart.command.arguments[0] = infoA.penEnd.x;
			infoB.penStart.command.arguments[1] = infoA.penEnd.y;
		}
		if (infoB.penEnd){
			this._penTo.x = infoB.penEnd.x;
			this._penTo.y = infoB.penEnd.y;
		}else if (infoA.penEnd){
			this._penTo.x = infoA.penEnd.x;
			this._penTo.y = infoA.penEnd.y;
		}
	}
}