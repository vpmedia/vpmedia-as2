/**
 * com.sekati.core.KeyInjector
 * @version 1.0.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.crypt.RUID;
/**
 * Give flash runtime objects a unique ID.
 * @see pixlib's HashCodeFactory
 * @see nectere's KeyInjector.
 */
class com.sekati.core.KeyFactory {
	private static var _key:String = "__RUID";
	/**
	 * Return the RUID key injected into an object - used as both getter and setter.
	 * @param o (Object) Object to inject RUID key in to
	 * @return (Number) Runtime Unique ID
	 */
	public static function inject(o:Object):Number {
		if (!o[_key]) {
			o[_key] = RUID.create( );
			_global["ASSetPropFlags"]( o, [ _key ], 7, 1 );
		}
		return o[_key];	
	}
	/**
	 * Injection wrapper to provide saner syntactical getter functionality.
	 */
	public static function getKey(o:Object):Number {
		return KeyFactory.inject( o );	
	}
	/**
	 * Returns next RUID as String to generate unique name
	 * for an object.
	 * @return String
	 */
	public static function getNextName():String {
		return String( KeyFactory.previewNextKey( ) );
	}
	/**
	 * Preview the next object RUID to be assigned.
	 * @return Number
	 */
	public static function previewNextKey():Number {
		return RUID.getCurrentId( ) + 1;
	}
	/**
	 * Debugging method to check if two objects are equal.
	 * @param a (Object)
	 * @param b (Object)
	 * @return Boolean
	 */
	public static function isSameObject(a:Object, b:Object):Boolean {
		return KeyFactory.getKey( a ) == KeyFactory.getKey( b );
	}
	private function KeyFactory() {
	}
}