/**
 * com.sekati.utils.ClassUtils
 * @version 2.2.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
import com.sekati.core.KeyFactory;

/**
 * Static class for wrapping various Class utilities. For example linking 'extend MovieClip' type 
 * classes to MovieClips thru attachMovie, createEmptyMovieClip or MovieClip Instances on stage.<br/><br/>
 * 
 * An initObject param is available in methods: {@link #createEmptyMovieClip}, {@link #attachMovie}
 * and {@link #attachClass}.  _depth is a custom initObject param which will set the clip to this depth 
 * regardless of method but *will not* store _depth as a MovieClip property; use getDepth if needed.
 *
 * {@code Example Class:
 * class com.sekati.Test extends MovieClip {
 * 	public function Test(){
 * 		trace("Test Class instantiated on: "+this._name);
 * 	}
 * }
 * }
 * 
 * @TODO Add an AS2 Class index getter for debugging purposes.
 */
class com.sekati.utils.ClassUtils {

	/**
	 * create a movieclip with linked class (various init options)
	 * @param classRef (Function) reference to class to attach
	 * @param target (MovieClip) target scope to create MovieClip
	 * @param instanceName (String) created MovieClip instance name
	 * @param initObject (Object) object of properties to create MovieClip with. Depth will automatically be created if none is specified
	 * @return MovieClip
	 * {@code Usage:
	 * var mc0:MovieClip = ClassUtils.createEmptyMovieClip (com.sekati.Test, this, "mc0");
	 * var mc0:MovieClip = ClassUtils.createEmptyMovieClip (com.sekati.Test, _root, "mc0", {_depth: 100, _x:25, _y:25});
	 * var mc0:MovieClip = ClassUtils.createEmptyMovieClip (com.sekati.Test, this, "mc0", {_x:25, _y:25});
	 * }
	 */
	public static function createEmptyMovieClip(classRef:Function, target:MovieClip, instanceName:String, initObject:Object):MovieClip {
		var depth:Number = (!initObject._depth) ? target.getNextHighestDepth( ) : initObject._depth;
		var mc:MovieClip = target.createEmptyMovieClip( instanceName, depth );
		mc.__proto__ = classRef.prototype;
		if (initObject) {
			for (var i in initObject) {
				if (i != "_depth") {
					mc[i] = initObject[i];
				}
			}
		}
		classRef.apply( mc );
		KeyFactory.inject( mc );
		return mc;
	}	

	/**
	 * attach a MovieClip from library and extend with class (various init options)
	 * @param classRef (Function) reference to class to attach
	 * @param target (MovieClip) target scope to create MovieClip
	 * @param idName (String) linkage id for exported MovieClip in library	
	 * @param instanceName (String) created MovieClip instance name
	 * @param initObject (Object) object of properties to create MovieClip with. Depth will automatically be created if none is specified
	 * @return MovieClip
	 * {@code Usage:
	 * var mc1:MovieClip = ClassUtils.attachMovie (com.sekati.Test, _root, "linkedMc", "mc1");
	 * var mc1:MovieClip = ClassUtils.attachMovie (com.sekati.Test, _root, "linkedMc", "mc1", {_x:50, _y:50});
	 * var mc1:MovieClip = ClassUtils.attachMovie (com.sekati.Test, _root, "linkedMc", "mc1", {_depth:200, _x:50, _y:50});
	 * }
	 */
	public static function attachMovie(classRef:Function, target:MovieClip, idName:String, instanceName:String, initObject:Object):MovieClip {
		var depth:Number = (!initObject._depth) ? target.getNextHighestDepth( ) : initObject._depth;
		var mc:MovieClip = target.attachMovie( idName, instanceName, depth, initObject );
		mc.__proto__ = classRef.prototype;
		if (mc._depth) {
			delete mc._depth;
		}
		classRef.apply( mc );
		KeyFactory.inject( mc );
		return mc;
	}

	/**
	 * Attach a movie from a DLL swf's library (loads dll then attaches requested movie).
	 * NOTE: you should insert a delay between your callback and methods calls in the shared library as it initializes.
	 * @param dll (Function) url of the dll.swf which contains exported assets in its library
	 * @param target (MovieClip) target scope to attachMovie within
	 * @param idName (String) linkage id for exported MovieClip in library	
	 * @param instanceName (String) created MovieClip instance name
	 * @param initObject (Object) object of properties to create MovieClip with. Depth will automatically be created if none is specified
	 * @param cb (Function) callback function to fire when dll has been loaded and clip attached
	 * @return MovieClip
	 * {@code Usage:
	 * var mc0:MovieClip = ClassUtils.attachDllMovie("dll.swf", _root, "myDllExportedItem", "mc0", {_x:50, _y:50, _depth:20}, myCallBackFn);
	 * }
	 */
	public static function attachDllMovie(dll:String, target:MovieClip, idName:String, instanceName:String, initObject:Object, cb:Function):MovieClip {
		var depth:Number = (!initObject._depth) ? target.getNextHighestDepth( ) : initObject._depth;
		var mc:MovieClip = target.createEmptyMovieClip( instanceName, depth );
		var mcLoader:MovieClipLoader = new MovieClipLoader( );
		var onDLLLoaded:Function = function():Void {
			mcLoader.removeListener( listener );
			if(cb) _global['setTimeout']( this, 'cb', 50 );
		};
		var listener:Object = new Object( );
		listener.onLoadInit = function(mc:MovieClip):Void {
			mc.attachMovie( idName, instanceName, mc.getNextHighestDepth( ) );
			target[instanceName] = target[instanceName][instanceName];
			if (initObject) {
				for (var i in initObject) {
					if (i != "_depth") mc[i] = initObject[i];
				}
			}				
			onDLLLoaded( );
		};
		mcLoader.addListener( listener );
		mcLoader.loadClip( dll, mc );
		return mc;
	}	

	/**
	 * extend a MovieClip instance (on stage) with class (various init options)
	 * @param classRef (Function) reference to class to attach
	 * @param target (MovieClip) target scope to create MovieClip
	 * @param initObject (Object) object of properties to create MovieClip with. Depth will automatically be created if none is specified
	 * @return MovieClip
	 * {@code Usage:
	 * var mc2:MovieClip = ClassUtils.attachClass (com.sekati.Test, mc2);
	 * var mc2:MovieClip = ClassUtils.attachClass (com.sekati.Test, _root.mc2, {_x:75, _y:75});
	 * var mc2:MovieClip = ClassUtils.attachClass (com.sekati.Test, mc2, {_depth:300, _x:75, _y:75});
	 * }
	 */
	public static function attachClass(classRef:Function, target:MovieClip, initObject:Object):MovieClip {
		var mc:MovieClip = target;
		mc.__proto__ = classRef.prototype;
		if (initObject) {
			for (var i in initObject) {
				if (i != "_depth") {
					mc[i] = initObject[i];
				} else {
					target.swapDepths( initObject[i] );
				}
			}
		}
		classRef.apply( mc );
		KeyFactory.inject( mc );
		return target;
	}

	/**
	 * Create and return a new instance of a defined class
	 * @param classRef (Function) reference to full class namespace
	 * @param args (Array) array of constructor arguments
	 * @return Object - instantiated class object
	 * {@code Usage:
	 * var o:Point = ClassUtils.createInstance (com.sekati.geom.Point, [15,50]);
	 * }
	 */
	public static function createInstance(classRef:Function, args:Array):Object {
		var o:Object = {__constructor__:classRef, __proto__:classRef.prototype};
		classRef.apply( o, args );
		KeyFactory.inject( o );
		return o;
	}

	/**
	 *  Create and return a new instance of a defined class without 
	 *  invoking its constructor
	 *  @param classRef (Function) reference to full class namespace
	 *  @return Object - class object
	 *  {@code Usage:
	 *  var scr:Scroll = ClassUtils.createCleanInstance(com.sekati.ui.Scroll);
	 *  }
	 */
	public static function createCleanInstance(classRef:Function):Object {
		var o:Object = new Object;
		o.__proto__ = classRef.prototype;
		o.__constructor__ = classRef;
		KeyFactory.inject( o );
		return o;	
	}

	/**
	 * Check if a subclass is extended by a superclass
	 * @param subclassRef (Function) reference to the full subclass namespace
	 * @param superclassRef (Function) reference to the full superclass namespace
	 * @return Boolean
	 * {@code Usage:
	 * 	trace(ClassUtils.isSubclassOf(com.sekati.display.AbstractClip, com.sekati.display.CoreClip)); // returns: true
	 * }
	 */
	public static function isSubclassOf(subclassRef:Function, superclassRef:Function):Boolean {
		var o:Object = subclassRef.prototype;
		while(o !== undefined) {
			o = o.__proto__;
			if(o === superclassRef.prototype) {
				return true;
			}	
		}
		return false;
	}

	/**
	 * Check if a class implements an interface
	 * @param classRef (Function) reference to the full class namespace
	 * @param interfaceRef (Function) reference to the full interface namespace
	 * @return Boolean
	 * {@code Usage:
	 * 	trace(ClassUtils.isImplementationOf(com.sekati.display.CoreClip, com.sekati.display.ICoreClip)); // returns: true
	 * }
	 */
	public static function isImplementationOf(classRef:Function, interfaceRef:Function):Boolean {
		// interface will not be in prototype chain
		if(isSubclassOf( classRef, interfaceRef )) {
			return false;	
		}
		// if an instance it is not extended, the class has to be an instance of it
		return (createCleanInstance( classRef ) instanceof interfaceRef);
	}

	private function ClassUtils() {
	}
}