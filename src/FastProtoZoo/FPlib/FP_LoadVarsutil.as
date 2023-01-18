//###########################################################
//#### MAKO FastProtoZoo Components #########################
//#### email marcosangalli@hotmail.com ######################
//###########################################################
class FastProtoZoo.FPlib.FP_LoadVarsutil extends LoadVars{
	//init vars
	private var parent:Object;
	private var callbackFunction, errorcallbackFunction:String;
	//constructor
	function FP_LoadVarsutil(reference:Object, callback:String, errorcallback:String) {
		//set vars
		this.callbackFunction = callback;
		this.errorcallbackFunction = errorcallback;
		this.parent = reference;
	}
	//load xml calling the super class
	public function load(src:String):Void {
		super.load(src);
	}
	//onLoad event
	private function onLoad(success:Boolean):Void {
		if (success) {
			this.executeCallback();
		} else {
			this.executeerrorCallback();
		}
	}
	//execute callback
	private function executeCallback():Void {
		this.parent[this.callbackFunction](this);
	}
	//execute error callback
	private function executeerrorCallback():Void {
		this.parent[this.errorcallbackFunction](this);
	}
}
