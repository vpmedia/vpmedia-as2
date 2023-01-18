import com.bumpslide.util.*;

/**
 *  Class for Name test
 * 
 *  Compiles in FlashDevelop. No FLA necessary.  
 *  @mtasc -swf InstanceByStringTest.swf -cp \"../../../../\" -header 500:400:31:eeeeee -main -trace com.bumpslide.util.Debug.trace
 *  @author David Knape
 */

class com.bumpslide.example.applets.InstanceByStringTest extends MovieClip
{	
	// All applets must contain a custom version of this method
	// Just change 'SimpleApplet' to whatever your class name is
	static function main(root_mc:MovieClip) : Void {			
		ClassUtil.applyClassToObj( InstanceByStringTest, root_mc );	
		root_mc.init();
	}
	
	// on init
	private function init() {	
			
		// make sure we have an actual reference to the class
		// so that it gets compiled
		var doCompile = [
			com.bumpslide.example.applets.TestClass
		];
			
		// class name as string
		var className:String = "com.bumpslide.example.applets.TestClass";
		
		// class ref is now a reference to our class, type is function
		var classRef:Function = eval("_global." + className );
		
		// if the class were a movie clip class, we could 
		// create empty movie clip and use that in place of the object
		var instance:Object = new Object();
		instance.__proto__ = classRef.prototype;
		instance.__constructor__ = classRef;

		// lastly, we force a call to the constructor and pass in any arguments
		classRef.apply(instance, ["Constructor arguments", "go", "here."]);

		// here we have an instance of the class
		// and can call a function on it
		instance.test();
	}
	
}
