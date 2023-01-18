/**
 * com.sekati.except.IllegalStateException
 * @version 1.0.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.except.Exception;

/**
 * Throwable Illegal State {@link Exception} Error.
 * A method has been invoked at an illegal or inappropriate time or state.
 */
class com.sekati.except.IllegalStateException extends Exception {

	private var name:String = "Illegal State Exception Error";

	/**
	 * IllegalStateException Constructor
	 * @param thrower (Object) origin of the error
	 * @param message (String) error message to display
	 * @param stack (Array) thrower arguments stack
	 * @return Void
	 */
	public function IllegalStateException(thrower:Object, message:String, stack:Array) {
		super( thrower, message, stack );	
	}
}