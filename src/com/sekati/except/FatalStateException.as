/**
 * com.sekati.except.FatalStateException
 * @version 1.0.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.except.FatalException;

/**
 * Throwable Fatal State {@link FatalException} Error.
 * A method has been invoked at an illegal or inappropriate time or state.
 */
class com.sekati.except.FatalStateException extends FatalException {

	private var name:String = "Fatal State Exception Error";

	/**
	 * FatalStateException Constructor
	 * @param thrower (Object) origin of the error
	 * @param message (String) error message to display
	 * @param stack (Array) thrower arguments stack
	 * @return Void
	 */
	public function FatalStateException(thrower:Object, message:String, stack:Array) {
		super( thrower, message, stack );	
	}
}