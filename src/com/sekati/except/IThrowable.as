/**
 * com.sekati.except.IThrowable
 * @version 1.0.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * Interface describing all {@link com.sekati.except.Throwable}'s.
 */
interface com.sekati.except.IThrowable {

	public function getErrorCode():String;

	public function getThrower():Object;

	public function getStack():Array;

	public function getType():String;

	public function getName():String;
}