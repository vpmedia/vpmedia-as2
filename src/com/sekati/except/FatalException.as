/**
 * com.sekati.except.FatalException
 * @version 1.0.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.except.Exception;

/**
 * Throwable Fatal {@link Exception} (logs with level type 'fatal').
 */
class com.sekati.except.FatalException extends Exception {

	private var name:String = "Fatal Exception Error";
	private var type:String = "fatal";

	/**
	 * FatalException Constructor
	 * @param thrower (Object) origin of the error
	 * @param message (String) error message to display
	 * @param stack (Array) thrower arguments stack
	 * @return Void
	 */
	public function FatalException(thrower:Object, message:String, stack:Array) {
		super( thrower, message, stack );
	}
}