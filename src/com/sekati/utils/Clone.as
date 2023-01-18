/**
 * com.sekati.utils.ObjectUtils
 * @version 1.0.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * Object cloning utility.
 */
class com.sekati.utils.Clone {

	/**
	 * Create a cloned object thru recursively coping of contents
	 * @param o (Object) to be cloned
	 * @return Object
	 */
	public static function create(o:Object):Object {
		var obj:Object = new Object( );
		var itype:Object;
		for(var i in o) {
			itype = typeof(o[i]);
			obj[i] = (itype == 'object' || itype == 'array') ? Clone.create( o[i] ) : o[i];
		}
		return obj;
	}	

	private function Clone() {
	}
}