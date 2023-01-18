/**
 * com.sekati.crypt.RUID
 * @version 1.0.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.crypt.IHash;

/**
 * Runtime Unique ID's for runtime Object management and identification.
 */
class com.sekati.crypt.RUID implements IHash {

	private static var _key:String = "__RUID";
	private static var _id:Number = 0;

	/**
	 * Generate a runtime unique id
	 * @return (Number) RUID
	 */
	public static function create():Number {
		return _id++;
	}

	/**
	 * Return the current RUID id
	 * @return Number
	 */
	public static function getCurrentId():Number {
		return _id;	
	}

	private function RUID() {
	}
}