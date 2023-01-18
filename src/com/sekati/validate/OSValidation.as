/**
 * com.sekati.validate.OSValidation
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 * 
 * Sourced/adapted from nectere fw for dependencies only
 */
 
/**
 * Operating System Validation
 */
class com.sekati.validate.OSValidation {

	/**
	 * is client a PC?
	 * @return Boolean
	 */
	public static function isPC():Boolean {
		var v:String = String(_root.$version).toLowerCase();
		return (v.indexOf("win") > -1);
	}

	/**
	 * is client a Mac?
	 * @return Boolean
	 */
	public static function isMac():Boolean {
		var v:String = String(_root.$version).toLowerCase();
		return (v.indexOf("mac") > -1);
	}
	
	private function OSValidation(){
	}
}