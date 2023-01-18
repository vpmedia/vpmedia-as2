class com.senocular.drawing.RecordedDrawing implements com.senocular.drawing.MxDrawingAPI {
	
	public var target:Object;
	public var enabled:Boolean = true;
	public var history:Array;
		
	function RecordedDrawing(target:Object, enabled:Boolean){
		this.target = target;
		if (enabled != undefined) this.enabled = enabled;
		this.history = new Array();
	}
	
	public function clear(Void):Void {
		this.history = new Array();
	}
	public function lineStyle(thickness:Number, rgb:Number, alpha:Number):Void {
		this.record("lineStyle", arguments, this.enabled);
	}
	public function beginFill(rgb:Number,alpha:Number):Void {
		this.record("beginFill", arguments, this.enabled);
	}
	public function beginGradientFill(fillType:String, colors:Array, alphas:Array, ratios:Array, matrix:Object):Void {
		this.record("beginGradientFill", arguments, this.enabled);
	}
	public function moveTo(x:Number, y:Number):Void {
		this.record("moveTo", arguments, this.enabled);
	}
	public function lineTo(x:Number, y:Number):Void {
		this.record("lineTo", arguments, this.enabled);
	}
	public function curveTo(cx:Number, cy:Number, x:Number, y:Number):Void {
		this.record("curveTo", arguments, this.enabled);
	}
	public function endFill(Void):Void {
		this.record("endFill", arguments, this.enabled);
	}
	
	public function recall(target:Object):Void {
		if (!target) target = this.target;
		var n:Number = this.history.length;
		var i:Number;
		for (i=0; i<n; i++){
			this.enact(this.history[i], target);
		}
	}
	public function forget(steps:Number):RecordedDrawing {
		var forgotten:RecordedDrawing = new RecordedDrawing(this.target, this.enabled);
		var pos:Number = this.history.length - steps;
		if (pos <= 0){
			forgotten.history = this.history;
			this.history = new Array();
			return forgotten;
		}
		var past:Array = this.history.slice(pos);
		this.history.length = pos;
		forgotten.history = past;
		return forgotten;
	}
	
	private function record(method:String, args:Array, perform:Boolean):Void {
		var entry:Object = {method:method, args:args};
		this.history.push(entry);
		if (perform) this.enact(entry, this.target);
	}
	private function enact(entry:Object, target:Object){
		target[entry.method].apply(target, entry.args);
	}
}