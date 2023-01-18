//###########################################################
//#### MAKO FastProtoZoo Components #########################
//#### email marcosangalli@hotmail.com ######################
//###########################################################
class FastProtoZoo.FPlib.FP_CSSutil extends TextField.StyleSheet {
	//init vars
	private var parent:Object;
	private var callbackFunction, errorcallbackFunction:String;
	private var src:String="";
	//constructor
	function FP_CSSutil(reference:Object, callback:String, errorcallback:String) {
		//set vars
		this.callbackFunction = callback;
		errorcallbackFunction = errorcallback;
		this.parent = reference;
	}
	//load xml calling the super class
	public function load(src:String):Void {
		super.load(src);
		this.src=src;
	}
	//onLoad event
	public function onLoad(success:Boolean):Void {
		//trace(">>>"+this.getStyleNames());
		if (success) {
			this.executeCallback();
		} else {
			this.executeerrorCallback();
		}
	}
	//execute callback
	private function executeCallback():Void{
		this.parent[this.callbackFunction](this);
	}
	//execute error callback
	private function executeerrorCallback():Void{
		this.parent[this.errorcallbackFunction](this.src);
	}
}
