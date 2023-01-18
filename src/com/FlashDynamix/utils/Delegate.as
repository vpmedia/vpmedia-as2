class com.FlashDynamix.utils.Delegate {
	static function create(scope, func:Function, origion, args:Array):Function {
		var f = function () {
			var c:Function = arguments.callee;
			c.func.origion = origion;
			var a:Array = (c.args!=undefined)?c.args:arguments
			return c.func.apply(c.scope, a);
		};
		//
		f.scope = scope;
		f.func = func;
		f.args = args;
		f.origion = origion;
		return f;
	}
	static function delay(time:Number, scope, func:Function, args:Array):Number {
		var f:Function = function (obj, func, args) {
			var c:Function = arguments.callee;
			clearInterval(c.ID);
			return c.func.apply(c.scope, arguments);
		};
		f.scope = scope;
		f.func = func;
		f.ID = setInterval.apply(null, new Array(f, time).concat(args));
		return f.ID;
	}
}
