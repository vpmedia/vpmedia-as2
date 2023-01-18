/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * {@code HashCodeFactory} is the corner stone of Pixlib framework.
 * 
 * <p>{@code HashCodeFactory} constructor is private and can't be used.
 * Use only available static methods.
 * 
 * <p>Gives to all Flash player objects an {@code unique} key.
 * 
 * <p>Example
 * <code>
 *   var nKey : Number = HashCodeFactory.getKey(this);
 *   var nNextAvailableKey : Number = HashCodeFactory.getNextKEY();
 *   var sNextAutoName : String = HashCodeFactory.getNextName();
 * </code>
 * 
 * <p>Use {@link #buildInstance} to build proper instance using class namespace 
 * instead of class constructors.
 * 
 * <p>Example
 * <code>
 *   var o : Point = HashCodeFactory.buildInstance( "com.bourre.structures.Point", [10,2] );
 * </code>
 * 
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.log.PixlibDebug;

class com.bourre.core.HashCodeFactory
{
	//-------------------------------------------------------------------------
	// Private properties
	//-------------------------------------------------------------------------
	
	private static var _nKEY:Number = 0;

	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Returns new unique key.
	 * 
	 * <p>Example
	 * <code>
	 *   var nNewKey : Number = HashCodeFactory.getNextKEY();
	 * </code>
	 * 
	 * @return {@code Number} key
	 */
	public static function getNextKEY() : Number
	{
		return HashCodeFactory._nKEY++;
	}
	
	/**
	 * Returns next available object's name.
	 * 
	 * <p>Use for building a default name for an object.
	 * 
	 * <p>Example
	 * <code>
	 *   var sNextAutoName : String = HashCodeFactory.getNextName();
	 * </code>
	 * 
	 * @return {@code Number} key
	 */
	public static function getNextName() : String
	{
		return String( HashCodeFactory._nKEY + 1 );
	}
	
	/**
	 * Returns passed-in {@code o} object key.
	 * 
	 * @return {@code Number} 
	 */
	public static function getKey(o) : Number
	{
		if (o.__KEY == null)
		{
			o.__KEY = HashCodeFactory.getNextKEY();
			_global.ASSetPropFlags(o, ["__KEY"], 7, 1);
		}
		return o.__KEY;
	}
	
	/**
	 * Builds and returns new instance defined by passed-in {@code sPackage} class 
	 * namespace and {@code aArgs} constructor arguments.
	 * 
	 *  <p>Example
	 * <code>
	 *   var o : Point = HashCodeFactory.buildInstance( "com.bourre.structures.Point", [10,2] );
	 * </code>
	 * 
	 * @return new {@code sPackage} instance 
	 */
	public static function buildInstance( sPackage : String, aArgs : Array, factoryMethod : String, singletonAccess : String )
	{
		var clazz : Function = eval( "_global." + sPackage );
		if ( !clazz ) 
		{
			PixlibDebug.FATAL( "'_global." + sPackage + "' class is not available in the current swf" );
			return null;
		}
		
		var o;

		if ( factoryMethod )
		{
			if ( singletonAccess )
			{
				var i = clazz[ singletonAccess ].call();
				if ( !i ) 
				{
					PixlibDebug.FATAL( "'_global." + sPackage + "." + singletonAccess + "()' singleton access failed." );
					return null;
				}
				
				o = i[factoryMethod].apply( i, aArgs );

				if ( !o ) 
				{
					PixlibDebug.FATAL( "'_global." + sPackage + "." + singletonAccess + "()." + factoryMethod + "()' factory method call failed." );
					return null;
				}
				
			} else
			{
				o = clazz[factoryMethod].apply( clazz, aArgs );
				
				if ( !o ) 
				{
					PixlibDebug.FATAL( "'_global." + sPackage + "." + factoryMethod + "()' factory method call failed." );
					return null;
				}
			}
		} else
		{
			o = {__constructor__:clazz, __proto__:clazz.prototype};
			clazz.apply(o, aArgs);
		}
		
		return o;
	}
	
	/**
	 * Indicates if 2 passed-in object are equals or not.
	 * 
	 * <p>This method is just for debugging purpose
	 * 
	 * <p>Use === (strict equality), if you need to compare two objects.
	 * 
	 * @return {@code true} if 2 passed-in objects are equal, either {@code false}
	 */
	public static function isSameObject(a, b) : Boolean
	{
		return HashCodeFactory.getKey(a) == HashCodeFactory.getKey(b);
	}
	
	
	//-------------------------------------------------------------------------
	// Private implementation
	//-------------------------------------------------------------------------
	
	private function HashCodeFactory()
	{
		//
	}
}