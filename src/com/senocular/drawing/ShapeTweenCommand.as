/**
* @author Trevor McCauley, senocular.com
* @version 0.9.2
*/
class com.senocular.drawing.ShapeTweenCommand {
	
	public var method:String;
	public var args:Array;
	public var index:Number;
	public var tweenfrom:ShapeTweenCommand;
	public var tweento:ShapeTweenCommand;
	public var isNode:Boolean = false;
	public var position:Number = 0; // float, % position in nodes list

	function ShapeTweenCommand(method:String, args:Array, index:Number, tweenfrom:ShapeTweenCommand, tweento:ShapeTweenCommand){
		this.method = method;
		this.args = args;
		this.index = index;
		this.tweenfrom = tweenfrom;
		this.tweento = tweento;
		this.isNode = false;
		switch(method){
			case "moveTo":
			case "lineTo":
				args[2] = args[0];
				args[3] = args[1];
			case "curveTo":
				this.isNode = true;
				break;
			case "lineStyle":
				if (isNaN(this.args[2])) this.args[2] = 100;
				break;
			case "beginFill":
				if (isNaN(this.args[1])) this.args[1] = 100;
				break;
		}
	}
	function toString(){
		return "ShapeTweenCommand {method: "+this.method+"}";
	}
	
	public function tween(t:Number):Void {
		switch(this.method){
			case "lineStyle":
				this.args[0] = Math.round(this.tweenfrom.args[0] + t*(this.tweento.args[0] - this.tweenfrom.args[0])); // thickness
				this.args[1] = blendRGB(this.tweenfrom.args[1], this.tweento.args[1], t); // color
				this.args[2] = this.tweenfrom.args[2] + t*(this.tweento.args[2] - this.tweenfrom.args[2]); // alpha
				break;
			case "beginFill":
				this.args[0] = blendRGB(this.tweenfrom.args[0], this.tweento.args[0], t); // color
				this.args[1] = this.tweenfrom.args[1] + t*(this.tweento.args[1] - this.tweenfrom.args[1]); // alpha
				break;
			case "beginGradientFill":
				var n:Number = this.args[1].length;
				var i:Number;
				for (i=0; i<n; i++){
					this.args[1][i] = blendRGB(this.tweenfrom.args[1][i], this.tweento.args[1][i], t); // colors
					this.args[2][i] = this.tweenfrom.args[2][i] + t*(this.tweento.args[2][i] - this.tweenfrom.args[2][i]); // alphas
					this.args[3][i] = this.tweenfrom.args[3][i] + t*(this.tweento.args[3][i] - this.tweenfrom.args[3][i]); // ratios
				}
				break;
			case "moveTo":
			case "lineTo":
				this.args[0] = this.tweenfrom.args[0] + t*(this.tweento.args[0] - this.tweenfrom.args[0]); // end pt
				this.args[1] = this.tweenfrom.args[1] + t*(this.tweento.args[1] - this.tweenfrom.args[1]); // end pt
				break;
			case "curveTo":
				this.args[0] = this.tweenfrom.args[0] + t*(this.tweento.args[0] - this.tweenfrom.args[0]); // control pt
				this.args[1] = this.tweenfrom.args[1] + t*(this.tweento.args[1] - this.tweenfrom.args[1]); // control pt
				this.args[2] = this.tweenfrom.args[2] + t*(this.tweento.args[2] - this.tweenfrom.args[2]); // end pt
				this.args[3] = this.tweenfrom.args[3] + t*(this.tweento.args[3] - this.tweenfrom.args[3]); // end pt
				break;
			// endFill, no arguments, no tweening
		}
	}
	public function invisibleCopy():ShapeTweenCommand {
		if (this.isNode) return this;
		var args:Array = this.argsCopy();
		switch(this.method) {
			case "lineStyle":
				args[2] = 0; // alpha
				break;
			case "beginFill":
				args[1] = 0; // alpha
				break;
			case "beginGradientFill":
				var n:Number = this.args[2].length;
				var i:Number;
				for (i=0; i<n; i++) args[2][i] = 0; // alpha
				break;
		}
		return new ShapeTweenCommand(this.method, args, this.index);
	}
	public function asSolidFill(col:Number, alpha:Number):ShapeTweenCommand {
		if (this.method != "beginGradientFill") return this;
		var args:Array = this.argsCopy();
		// NOTE: same matrix object referenced
		var n:Number = args[1].length;
		var i:Number;
		for (i=0; i<n; i++){
			args[1][i] = col;
			args[2][i] = alpha;
		}
		return new ShapeTweenCommand("beginGradientFill", args, this.index);
	}
	public function addGradientArgs(gargs:Array):ShapeTweenCommand {
		if (this.method != "beginGradientFill") return this;
		var args:Array = this.argsCopy();
		// NOTE: same matrix object referenced
		var n:Number = gargs[1].length;
		var i:Number;
		for (i=args.length; i<n; i++){
			args[1][i] = gargs[1][i];
			args[2][i] = gargs[2][i];
			args[2][i] = gargs[2][i];
		}
		return new ShapeTweenCommand("beginGradientFill", args, this.index);
	}
	public function argsCopy(Void):Array {
		switch(this.method){
			case "beginGradientFill":
				return [this.args[0], this.args[1].slice(),this.args[2].slice(),this.args[3].slice(), this.args[4]];
			default:
				return this.args.slice();
		}
	}
	public function callIn(target:Object):Void {
		//~ trace(this.method+"("+this.args+");");
		target[this.method].apply(target, this.args);
	}
	
	
	private static function HEXtoRGB(hex){
		return {r:hex >> 16, g:(hex >> 8) & 0xff, b:hex & 0xff};
	}
	private static function blendRGB(c1, c2, t){
		c1 = HEXtoRGB(c1);
		c2 = HEXtoRGB(c2);
		return (c1.r + t*(c2.r-c1.r)) << 16 | (c1.g + t*(c2.g-c1.g)) << 8 | (c1.b + t*(c2.b-c1.b));
	}
}