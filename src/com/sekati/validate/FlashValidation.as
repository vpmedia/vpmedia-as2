/**
 * com.sekati.validate.FlashValidation
 * @version 1.0.2
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * Flash Player Validation
 */
class com.sekati.validate.FlashValidation {

	/**
	 * check if client flashplayer matches min version passed
	 * @param minVersion (Number) >= minimum player version
	 * @return Boolean
	 */
	public static function isMinVersion(minVersion:Number):Boolean  {
		if (Number (getVersion ().split (" ")[1].split (",")[0]) >= minVersion) {
			return true;
		}
		return false;
	}
	
	/**
	 * check if client flashplayer supports fullscreen mode:
	 * player version must be >= 9.0.28
	 * @return Boolean
	 */
	public static function hasFullscreenMode():Boolean {
		var v:Array = getVersion().split (" ")[1].split (",");
		var major:Number = Number(v[0]);
		var minor:Number = Number(v[1]);
		var sub:Number = Number(v[2]);
		if (major > 9) { 
			return true;
		} else if (major < 9) {
			return false;	
		}
		if ((minor == 0 && sub >= 28) || minor > 0) {
			return true;	
		} else {
			return false;
		}
	}	
	
	/**
	 * Check is the swf is being previewed externally.
	 * @return Boolean
	 */
	public static function isMoviePreview():Boolean {
		return (System.capabilities.playerType == "External") && System.capabilities.isDebugger;
	}	
	
	private function FlashValidation(){
	}
}