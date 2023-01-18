class com.vpmedia.events.Timeout {
	private function Timeout () {
	}
	// This function is Pseudo overloaded with two functions
	//set(functionReference:Function, interval:Number, [param1:Object, param2, ..., paramN]) : Number
	//set(objectReference:Object, methodName:Function, interval:Number, [param1:Object, param2, ..., paramN]) : Number
	public static function set (o1:Object, o2:Object, o3:Object):Number {
		var a:Array = new Array ();
		if (o1 instanceof Function) {
			for (var i:Number = 2; i < arguments.length; i++) {
				a.push (arguments[i]);
			}
			var n:Number = setInterval (function ():Void {
				o1.apply (null, a);
				clearInterval (n);
			}, o2);
		}
		else if (o1 instanceof Object) {
			for (var i:Number = 3; i < arguments.length; i++) {
				a.push (arguments[i]);
			}
			var n:Number = setInterval (function ():Void {
				o2.apply (o1, a);
				clearInterval (n);
			}, o3);
		}
		return n;
	}
	// This function is a simpler version but it does the same.
	// The difference is that here there is no overloading
	// You have to send an object reference to the function.
	// Also it's easier to understand whats going on in the code.
	// Example: Timeout.sets(this, trace, 500, "strin to trace");
	//sets(objectReference:Object, methodName:Function, interval:Number, [param1:Object, param2, ..., paramN]) : Number
	public static function sets (o:Object, func:Function, ms:Number):Number {
		var a:Array = new Array ();
		for (var i:Number = 3; i < arguments.length; i++) {
			a.push (arguments[i]);
		}
		var n:Number = setInterval (function ():Void {
			func.apply (o, a);
			clearInterval (n);
		}, ms);
		return n;
	}
	//clears the Timeout if it hasen't been called yet
	//clear(param:Number) : Void
	public static function clear (n:Number):Void {
		clearInterval (n);
	}
}
