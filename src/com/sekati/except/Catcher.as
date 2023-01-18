/**
 * com.sekati.except.Catcher
 * @version 1.1.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.except.Exception;
import com.sekati.log.Logger;
import com.sekati.reflect.Stringifier;
import com.sekati.validate.TypeValidation;

/**
 * Generic {@link Exception} catch handler.
 * {@code Usage:
 * 	function test(isOk:Boolean):Void {
 * 		try {
 * 			throw new Exception(this,"An unknown Error has occurred",arguments);
 * 		} catch (e:Exception) {
 * 			Catcher.handle(e);
 * 		}
 * 	}
 * }
 */
class com.sekati.except.Catcher {

	/**
	 * A generic Exception handler that returns string data about the Exception for logging or tracing.
	 * @param e (Exception)
	 * @return String
	 */
	public static function handle(e:Exception):String {
		var a:Array = e.getStack( );
		var tmp:String = "[ ";
		for(var i:Number = 0; i < a.length ; i++) tmp += a[i] + " (" + TypeValidation.getType( a[i] ).name + "), ";	
		var stack:String = tmp.slice( 0, tmp.length - 2 ) + " ]";
		var str:String = "%%% Catcher handling Exception:\nName: '" + e.getName( ) + "'\nType: '" + e.getType( ) + "'\nErrorCode: '" + e.getErrorCode( ) + "'\nThrower: " + e.getThrower( ) + "\nStack: " + stack + "\n\n";
		Logger.$.warn( toString( ), str );	
		return str;
	}

	/**
	 * Simple reflection for Static classes.
	 */
	public static function toString():String {
		return Stringifier.stringify( Catcher );
	}

	private function Catcher() {
	}
}