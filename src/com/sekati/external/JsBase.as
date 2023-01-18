/**
 * com.sekati.external.JsBase
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
/**
 * Javascript Utilities
 */
class com.sekati.external.JsBase {
	/**
	 * javascript resize window
	 */
	public static function resizeWindow(w:Number, h:Number):Void {
		getURL( "javascript:top.resizeTo(" + w + "," + h + ")" );
	}
	/**
	 * javascript shake window
	 */
	public static function shakeWindow(amount:Number):Void {
		getURL( "javascript:function shakewin(n){if(parent.moveBy){for(i = 10;i > 0;i--){for(j = n;j > 0;j--){parent.moveBy(0,i);parent.moveBy(i,0);parent.moveBy(0,-i);parent.moveBy(-i,0);}}}};shakewin(" + amount + ");void(0)" );
	}
	/**
	 * javascript change status message
	 */
	public static function status(msg:String):Void {
		getURL( "javascript:if(typeof(this.href) != 'undefined') window.status = '" + msg + "' + ' URL: ' + this.href;else return false;void(0)" );
	}
	/**
	 * javascript pop centered window
	 */
	public static function centerPop(wURL:String, wName:String, w:Number, h:Number, scr:Boolean):Void {
		var cx:Number = Math.round( (System.capabilities.screenResolutionX / 2) - (w / 2) );
		var cy:Number = Math.round( (System.capabilities.screenResolutionY / 2) - (h / 2) );
		getURL( "javascript:NewWindow=window.open('" + wURL + "','" + wName + "','width=" + w + ",height=" + h + ",left=" + cx + ",top=" + cy + ",screenX=" + cx + ",screenY=" + cy + ",toolbar=no,location=no,scrolling=" + scr + ",directories=no,scrollbars=" + scr + ",status=no,statusbar=no,resizable=no,fullscreen=no'); NewWindow.focus(); void(0);" );
	}
	private function JsBase() {
	}	
}