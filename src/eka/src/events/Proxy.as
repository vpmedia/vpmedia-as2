
class eka.src.events.Proxy {

  public static var className:String = "Proxy" ;
  public static var classPackage:String = "eka.src.events";
  public static var version:String = "1.0.0";
  public static var author:String = "ekameleon";
  public static var link:String = "http://www.ekameleon.net" ;

  public static function create(o, f:Function):Function {

	var a:Array = new Array() ;
	var n:Number = arguments.length ;
    
    for(var i:Number = 2 ; i < n ; i++) a[i - 2] = arguments[i] ;

    return function():Void {
		var aP = arguments.concat(a);
		f.apply(o, aP);
    }

  }

}
