/**
 * com.sekati.except.Throwable
 * @version 1.1.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.except.IThrowable;
import com.sekati.log.Logger;
import com.sekati.reflect.Stringifier;

/**
 * Abstract Throwable mixin class for {@link com.sekati.except.Exception} classes.
 */
class com.sekati.except.Throwable extends Error implements IThrowable {

	private var type:String = "error";
	private var name:String = "Throwable Error";
	private var message:String;
	private var _errorCode:String;
	private var _stack:Array;
	private var _thrower:Object;	

	/**
	 * Throwable Private Constructor
	 * @param errorCode (String)
	 * @param thrower (Object)
	 * @param stack (Array)
	 * @return Void
	 */
	private function Throwable(thrower:Object, errorCode:String, stack:Array) {
		message = "@@@ " + name + " ['" + thrower + "']: " + errorCode;
		Logger.$[type]( Stringifier.stringify( this ), this );	
		_errorCode = errorCode;
		_thrower = thrower;
		_stack = stack;
	}

	/**
	 * Return the localized error code message.
	 * @return String
	 */
	public function getErrorCode():String {
		return _errorCode;	
	}	

	/**
	 * Return the error thrower.
	 * @return Object
	 */
	public function getThrower():Object {
		return _thrower;	
	}

	/**
	 * Return the thrower argument stack
	 * that generated the error.
	 * @return Array
	 */
	public function getStack():Array {
		return _stack;
	}

	/**
	 * Return the {@link com.sekati.log.Logger} level type.
	 * @return String
	 */
	public function getType():String {
		return type;	
	}

	/**
	 * Return the Throwable Exception name.
	 * @return String
	 */
	public function getName():String {
		return name;	
	}
}