/**
 * com.sekati.utils.Delegate
 * @version 1.0.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * The Delegate class creates a function wrapper to let you run a function in the context of
 * the original object, rather than in the context of the second object, when you pass a
 * function from one object to another<br/><br/>
 *   
 * This customized version allows for function arguments & is repurposed for the framework
 * based on bigspaceships version of adobe/mm'd mx.utils.Delegate. 
 * 
 * {@code Usage:
 * myMovieClip.onEnterFrame = Delegate.create(this,_onEnterFrame,"hello world");
 * function _onEnterFrame($str:String):Void { trace($str); };
 * }
 */
class com.sekati.utils.Delegate extends Object {

	private var func:Function;

	/**
	 * Constructor
	 * @param f (Function)
	 * @return Void
	 */
	function Delegate(f:Function) {
		func = f;
	}

	/**
	 * Creates a functions wrapper for the original function so that it runs in the provided context.
	 * @param obj (Object) Context in which to run the function.
	 * @param func (Function) Function to run.
	 * @return Function
	 */
	static function create(obj:Object, func:Function):Function {
		var f:Function = function():Function {
			var target:Object = arguments.callee.target;
			var func:Function = arguments.callee.func;
			var args:Array = arguments.callee.args;
			return func.apply( target, args.concat( arguments ) );
		};
		f.target = arguments.shift( );
		f.func = arguments.shift( );
		f.args = arguments;
		return f;
	}

	/**
	 * create wrapper
	 * @param obj (Object) Context in which to run the function.
	 * @return Function
	 */
	function createDelegate(obj:Object):Function {
		return create( obj, func );
	}
}