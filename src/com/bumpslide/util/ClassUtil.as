/**
 *  Class utilities
 * 
 *  @author David Knape
 *  @version 1.0
 */
 
//import com.bumpslide.util.Debug;
import com.bumpslide.util.ObjectUtil;

class com.bumpslide.util.ClassUtil {

	// private constructor (just static methods here)
	private function ClassUtil() {}
	
	/**
	 * Turns an Object into an instance of a class
	 * 
	 * Any extra arguments will be passed to class constructor.
	 * 
	 * @usage   ClassUtil.applyClassToObject( _global.com.something.MyApp, _root );
	 * @param   classRef 
	 * @param   mc       
	 */
	static function applyClassToObj( classRef:Function, obj:Object )  {
		obj.__proto__ = classRef.prototype;
		//obj.__constructor__ = classRef;
		classRef.apply( obj, arguments.slice(2) );	
		return obj;
	}
	
	/**
	 * Creates a new instance of the passed-in class
	 * 
	 * args will be passed to class constructor.
	 * 
	 * @param classRef 
	 * @param args
	 * @return instance of class
	 */
	public static function createInstance(classRef:Function, args:Array) {
		if (!classRef) return null;
		var result:Object = new Object();
		result.__proto__ = classRef.prototype;
		result.__constructor__ = classRef;
		classRef.apply(result, args);
		return result;
	}
	
	/**
	* Creates instance of a movie clip class 
	* 
	* @param	instance_name
	* @param	timeline_mc
	* @param	classRef
	* @return
	*/
	public static function createMovieClip( instance_name:String, timeline_mc:MovieClip, classRef:Function ) : MovieClip {
		var mc:MovieClip = timeline_mc.createEmptyMovieClip(instance_name, timeline_mc.getNextHighestDepth());
		ClassUtil.applyClassToObj( classRef, mc );
		return mc;
	}
	
	/**
	* Following methods are borrowed from Pixlib classUtils...
	* @author Francis Bourre
	*/
	
	public static function getClassName( o ) : String {	
		var s : String = ClassUtil.getFullyQualifiedClassName( o );
		return s.substr( s.lastIndexOf(".")+1 );
	}
	
	public static function getFullyQualifiedClassName( o ) : String {	
		o = (typeof(o)=="function") ? Function(o).prototype : o.__proto__;
		var oKey = ObjectUtil.getKey(o);		
		if(ClassUtil._NAME_CACHE[oKey]!=undefined) {
			return ClassUtil._NAME_CACHE[oKey];
		} else {
			return ClassUtil._buildPath( "", _global, o )
		}		
	}
	
	// class name cache
	private static var _NAME_CACHE : Array = new Array();
	
	private static function _buildPath( s : String, pack, o ) : String
	{
		for ( var p : String in pack ) {
			var cProto : Function = pack[p];			
			if ( cProto.__constructor__ === Object ) {
				p = ClassUtil._buildPath( s + p + ".", cProto, o );
				if ( p ) return p;
			} else if ( cProto.prototype === o ) {
				//Debug.info('[ClassUtil] Caching Class Name '+s+p);
				ClassUtil._NAME_CACHE[ObjectUtil.getKey(o)] = s+p;
				return s + p;
			}
		}
	}


	
	
	
	
	
	
	
}