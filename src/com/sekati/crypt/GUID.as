/**
 * com.sekati.crypt.GUID
 * @version 1.0.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 * 
 * Sourced from ascrypt for dependencies only - version 2.0, author Mika Pamu
 */

import com.sekati.crypt.IHash;
import com.sekati.crypt.SHA1;

/**
 * Creates a new genuine unique identifier string.
 */
class com.sekati.crypt.GUID implements IHash {

	private static var counter:Number = 0;

	/**
	 * Creates a new Genuine Unique IDentifier.
	 * @return String
	 */
	public static function create():String {
		var id1:Number = new Date( ).getTime( );
		var id2:Number = Math.random( ) * Number.MAX_VALUE;
		var id3:String = System.capabilities.serverString;
		return SHA1.calculate( id1 + id3 + id2 + counter++ );
	}

	private function GUID() {
	}
}