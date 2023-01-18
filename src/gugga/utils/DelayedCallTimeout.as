import mx.utils.Delegate;

class gugga.utils.DelayedCallTimeout {	
	private var interval:Number;
	private var args:Array;
	private var obj;
	
	public function DelayedCallTimeout (time:Number, objInst, func:Function) {	
		args = arguments.splice(3);
		interval = setInterval(Delegate.create(this, solve),time, func);
		obj = objInst;
	}
	
	private function solve (func:Function):Void {
		clear();
		func.apply(obj,args);
	}
	
	public function clear ():Void {
		clearInterval(interval);
	}
}