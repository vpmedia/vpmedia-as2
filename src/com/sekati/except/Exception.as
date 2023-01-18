/**
 * com.sekati.except.Exception
 * @version 1.0.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.except.Throwable;

/**
 * Core {@link Throwable} Exception error to be subclassed for error specificity and logging.
 * {@code Usage:
 * 	function test():Void {
 * 		try {
 * 			throw new Exception(this, "Test exception ErrorCode message", arguments);
 * 		} catch (e:Exception) {
 * 			Catcher.handle(e);
 * 		}
 * 	}
 * 	test("hello world!", false, 13);
 * }
 * 
 * @see {@link com.sekati.except.Catcher}
 */
class com.sekati.except.Exception extends Throwable {

	private var name:String = "Exception Error";
	private var type:String = "error";

	/**
	 * Exception Constructor
	 * @param thrower (Object) origin of the error
	 * @param message (String) error message to display
	 * @param stack (Array) thrower arguments stack
	 * @return Void
	 */
	public function Exception(thrower:Object, message:String, stack:Array) {
		super( thrower, message, stack );	
	}
}