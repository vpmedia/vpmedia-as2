/**
 * com.sekati.utils.Clipboard
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * Simple system clipboard management.
 */
class com.sekati.utils.Clipboard {

	private static var _str:String = "";

	/**
	 * Push content to the System clipboard
	 * @param content (Object)
	 * @return Void
	 */
	public static function push(content:Object):Void {
		var str:String = String( content );
		_str += str + "\r";
		System.setClipboard( _str );
	}

	/**
	 * Pop content out of the System clipboard and clear it.
	 * @return String
	 */
	public static function pop():String {
		return _str;
		_str = "";
		System.setClipboard( " " );
	}	

	private function Clipboard() {
	}
}