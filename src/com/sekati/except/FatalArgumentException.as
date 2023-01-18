/**
 * com.sekati.except.FatalArgumentException
 * @version 1.0.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.except.FatalException;

/**
 * Throwable Fatal Argument {@link FatalException} Error.
 * A method has been invoked with an illegal or inappropriate argument.
 */
class com.sekati.except.FatalArgumentException extends FatalException {

	private var name:String = "Fatal Argument Exception Error";

	/**
	 * FatalArgumentException Constructor
	 * @param thrower (Object) origin of the error
	 * @param message (String) error message to display
	 * @param stack (Array) thrower arguments stack
	 * @return Void
	 */
	public function FatalArgumentException(thrower:Object, message:String, stack:Array) {
		super( thrower, message, stack );	
	}
}