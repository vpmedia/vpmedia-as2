/**
 * com.sekati.core.CoreInterface
 * @version 1.0.7
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * The core interface in the SASAPI framework.
 */
interface com.sekati.core.CoreInterface {

	/**
	 * Clean and destroy object instance contents/self for garbage collection.
	 * Always call destroy() before deleting last object pointer.
	 * @return Void
	 */		
	function destroy():Void;

	/**
	 * Return the Fully Qualified Class Name string representation of
	 * the instance object via {@link com.sekati.reflect.Stringifier}.
	 * @return String
	 */		
	function toString():String;
}