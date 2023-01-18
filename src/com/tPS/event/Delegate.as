/**
 *
 * @author
 * @version
 **/
class com.tPS.event.Delegate {

	function Delegate(){
	}

	public static function create(_scope:Object,funct:Function):Function{
		var _parameters:Array = arguments.splice(2);

		return function (){
			var arg : Array = (_parameters == undefined) ? arguments : arguments.concat(_parameters);
			return funct.apply (_scope, arg);
		};
	}

}