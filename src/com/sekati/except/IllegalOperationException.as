/**
 * com.sekati.except.IllegalOperationException
 * @version 1.0.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.except.Exception;

/**
 * Throwable Illegal Operation {@link Exception} Error.
 * An illegal operation has occurred that is not supported by the thower.
 */
class com.sekati.except.IllegalOperationException extends Exception {

	private var name:String = "Illegal Operation Exception Error";

	/**
	 * IllegalOperationException Constructor
	 * @param thrower (Object) origin of the error
	 * @param message (String) error message to display
	 * @param stack (Array) thrower arguments stack
	 * @return Void
	 */
	public function IllegalOperationException(thrower:Object, message:String, stack:Array) {
		super( thrower, message, stack );	
	}
}