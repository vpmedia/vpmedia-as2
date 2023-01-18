//###########################################################
//#### MAKO FastProtoZoo Components #########################
//#### email marcosangalli@hotmail.com ######################
//###########################################################
class FastProtoZoo.FPlib.FP_XMLutil extends XML {
	//init vars
	private var parent:Object;
	private var callbackFunction, errorcallbackFunction:String;
	//constructor
	function FP_XMLutil(reference:Object, callback:String, errorcallback:String) {
		//set vars
		this.callbackFunction = callback;
		this.errorcallbackFunction = errorcallback;
		this.parent = reference;
		this.ignoreWhite = true;
	}
	//load xml calling the super class
	public function load(src:String):Void {
		super.load(src);
	}
	//onLoad event
	private function onLoad(success:Boolean):Void {
		//trace xml status
		//trace("XML::"+this.status);
		//
		if (success && this.status==0) {
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
		this.parent[this.errorcallbackFunction](this.status);
	}
}
