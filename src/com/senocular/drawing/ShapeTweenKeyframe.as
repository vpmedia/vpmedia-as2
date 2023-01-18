import com.senocular.drawing.ShapeTweenCommand;
/**
* @author Trevor McCauley, senocular.com
* @version 0.9.2
*/
class com.senocular.drawing.ShapeTweenKeyframe {
	
	public var frame:Number;
	public var steps:Number = 0;
	public var commands:Array; // all commands, used for keyframes
	public var crossindexprehash:Object;
	public var crossindexposthash:Object;
	public var nodes:Array;
		
	private var lines:Array;
	private var fills:Array;
	private var ends:Array;
	private var easeMethod:Function = function(t){ return t; };
	private var easeMethodArgs:Array = new Array();
	
	function ShapeTweenKeyframe(frame:Number){
		this.frame = frame;
		this.commands = new Array();
		this.nodes = new Array();
		this.lines = new Array();
		this.fills = new Array();
		this.ends = new Array();
	}
	function toString(){
		return "ShapeTweenKeyframe {frame: "+this.frame+"}";
	}
	
	public function setEase(easeMethod:Function):Void {
		if (!easeMethod){
			delete this.easeMethod;
			delete this.easeMethodArgs;
		}else{
			this.easeMethod = easeMethod;
			this.easeMethodArgs = arguments;
		}
	}
	public function applyEase(t:Number):Number {
		var args:Array = new Array().concat(this.easeMethodArgs);
		args[0] = t;
		return this.easeMethod.apply(null, args);
	}
	public function tween(t:Number) {
		this.crossindexprehash = new Object();
		this.crossindexposthash = new Object();
		var n:Number;
		var i:Number;
		n = this.lines.length;
		for (i=0; i<n; i++){
			this.lines[i].tween(t);
			this.addCrossIndex(this.crossindexprehash, this.lines[i], t);
		}
		n = this.fills.length;
		for (i=0; i<n; i++){
			this.fills[i].tween(t);
			this.addCrossIndex(this.crossindexprehash, this.fills[i], t);
		}
		n = this.steps;
		for (i=0; i<n; i++) this.nodes[i].tween(t);
		n = this.ends.length;
		for (i=0; i<n; i++) this.addCrossIndex(this.crossindexposthash, this.ends[i], t);
	}
	private function addCrossIndex(hash:Object, command:ShapeTweenCommand, t:Number):Void {
		var index:Number = Math.round(this.steps*(command.tweenfrom.position + t*(command.tweento.position - command.tweenfrom.position))); // location in tween
		if (!hash[index]) hash[index] = new Array();
		hash[index].push(command);
	}

	public function createTween(nextkeyframe:ShapeTweenKeyframe):ShapeTweenKeyframe {
		var tweenframe = new ShapeTweenKeyframe(-1);
		tweenframe.defineTweenList(this, nextkeyframe, "nodes");
		tweenframe.steps = tweenframe.nodes.length;
		
		tweenframe.defineTweenList(this, nextkeyframe, "lines");
		tweenframe.defineTweenList(this, nextkeyframe, "fills");
		tweenframe.defineTweenList(this, nextkeyframe, "ends");

		return tweenframe;
	}

	private function defineTweenList(currkeyframe:ShapeTweenKeyframe, nextkeyframe:ShapeTweenKeyframe, list:String):Void {
		var min:Array, max:Array, minfirst:Boolean;
		var nminlen:Number, nmaxlen:Number;
		
		var positioned:Boolean = (list != "nodes");
		if (currkeyframe[list].length <= nextkeyframe[list].length){
			min = currkeyframe[list];
			max = nextkeyframe[list];
			minfirst = true;
			if (positioned){
				nminlen = currkeyframe.nodes.length;
				nmaxlen = nextkeyframe.nodes.length;
			}
		}else{
			min = nextkeyframe[list];
			max = currkeyframe[list];
			minfirst = false;
			if (positioned){
				nminlen = nextkeyframe.nodes.length;
				nmaxlen = currkeyframe.nodes.length;
			}
		}
		var minlen:Number = min.length;
		var maxlen:Number = max.length;
		
		// tween with relations
		var tweenmin:ShapeTweenCommand, tweenmax:ShapeTweenCommand, lasttween:ShapeTweenCommand;
		var minpos:Number;
		var method:String;
		var args:Array;
		var condense:Boolean;
		var gradsmin:Number;
		var gradsmax:Number;
		var n:Number = maxlen;
		var i:Number;
		for (i=0; i<n; i++){
			tweenmax = max[i];
			if (minlen){
				minpos = (maxlen > 1) ? Math.round((minlen-1)*i/(maxlen-1)) : 0;
				tweenmin = min[minpos];
			}else tweenmin = tweenmax.invisibleCopy();
				
			condense = (lasttween == tweenmin);
			lasttween = tweenmin;
			if (tweenmin.method == "curveTo" || tweenmax.method == "curveTo") {
				method = "curveTo";
				// if curveTo follows another curveTo heading for the same endpoint, force currkeyframe
				// curveTo's contol point to tween to that endpoint to prevent misguided control points
				if (condense){
					args = tweenmin.args.slice();
					args[0] = args[2];
					args[1] = args[3];
					tweenmin = new ShapeTweenCommand(method, args, tweenmin.index);
				}
			}else if (tweenmin.method == "beginGradientFill" || tweenmax.method == "beginGradientFill") {
				method = "beginGradientFill";
				// make sure gradient fills arguments match up
				// and solid fills tween to gradient fills
				if (tweenmin.method == "beginGradientFill" && tweenmax.method == "beginGradientFill"){
					// assume all args lists of equal length
					gradsmin = tweenmin.args[1].length;
					gradsmax = tweenmax.args[1].length;
					if (gradsmin < gradsmax){
						tweenmin = tweenmin.addGradientArgs(tweenmax.args);
					}else if (gradsmin > gradsmax){
						tweenmax = tweenmax.addGradientArgs(tweenmin.args);
					}
				}else if (tweenmin.method == "beginGradientFill"){
					tweenmax = tweenmin.asSolidFill(tweenmax.args[0], tweenmax.args[1]);
				}else{ // tweenmax.method == "beginGradientFill"
					tweenmin = tweenmax.asSolidFill(tweenmin.args[0], tweenmin.args[1]);
				}
			}else method = tweenmax.method;
			if (positioned){
				tweenmax.position = tweenmax.index/nmaxlen;
				if (minlen) tweenmin.position = tweenmin.index/nminlen;
				else tweenmin.position = tweenmax.position;
			}
			
			if (minfirst) this[list][i] = new ShapeTweenCommand(method, tweenmax.argsCopy(), i, tweenmin, tweenmax);
			else this[list][i] = new ShapeTweenCommand(method, tweenmax.argsCopy(), i, tweenmax, tweenmin);
		}
	}
	public function addCommand(method:String, args:Array):Void {
		var command:ShapeTweenCommand = new ShapeTweenCommand(method, args, this.nodes.length, null, null);
		this.commands.push(command);
		if (command.isNode) this.nodes.push(command);
		else{
			switch(command.method){
				case "lineStyle":
					this.lines.push(command);
					break;
				case "beginFill":
				case "beginGradientFill":
					this.fills.push(command);
					break;
				case "endFill":
					this.ends.push(command);
					break;
			}
		}
	}
	public function drawIn(target:Object):Void {
		if (this.frame < 0) {
			this.drawTweenIn(target);
			return;
		}
		var n:Number = this.commands.length;	
		var i:Number;
		for (i=0; i<n; i++) this.commands[i].callIn(target);
	}
	
	private function drawTweenIn(target:Object):Void {
		var n:Number = this.nodes.length;
		var i:Number;
		var cn:Number;
		var ci:Number;
		for (i=0; i<=n; i++){ // = n for hash's based off node length and therefore be in an array pos greater than those of nodes
			if (this.crossindexprehash[i] && i != n){
				cn = this.crossindexprehash[i].length;
				for (ci=0; ci<cn; ci++){
					this.crossindexprehash[i][ci].callIn(target);
				}
			}
			if (this.nodes[i]) this.nodes[i].callIn(target);
			if (this.crossindexposthash[i]){
				cn = this.crossindexposthash[i].length;
				for (ci=0; ci<cn; ci++){
					this.crossindexposthash[i][ci].callIn(target);
				}
			}
		}
	}
}