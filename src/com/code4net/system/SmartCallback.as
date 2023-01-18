class com.code4net.system.SmartCallback {
	private var scope:Object;
	private var method:Function;
	private var argArray:Array;
	
	function SmartCallback(sc:Object,m:Function,arg:Array) {
		argArray = new Array();
		scope = sc;
		method = m;
		if (arg != undefined) argArray = arg;
	}
	
	function run(arg:Object) {
		if (arg != undefined) argArray = argArray.concat(arg);
		method.apply(scope,argArray);
	}
}
