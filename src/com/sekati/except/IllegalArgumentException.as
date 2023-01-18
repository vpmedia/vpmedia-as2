/**
 * com.sekati.except.IllegalArgumentException
 * @version 1.0.7
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.except.Exception;

/**
 * Throwable Illegal Argument {@link Exception} Error.
 * A method has been invoked with an illegal or inappropriate argument.
 */
class com.sekati.except.IllegalArgumentException extends Exception {

	private var name:String = "Illegal Argument Exception Error";

	/**
	 * IllegalArgumentException Constructor
	 * @param thrower (Object) origin of the error
	 * @param message (String) error message to display
	 * @param stack (Array) thrower arguments stack
	 * @return Void
	 */
	public function IllegalArgumentException(thrower:Object, message:String, stack:Array) {
		super( thrower, message, stack );	
	}
}