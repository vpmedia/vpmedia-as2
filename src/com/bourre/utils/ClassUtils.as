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
 * @author Francis Bourre
 * @version 1.0
 */

class com.bourre.utils.ClassUtils 
{
	private function ClassUtils() 
	{
		
	}
	
	public static function getClassName( o ) : String 
	{
		var s : String = ClassUtils.getFullyQualifiedClassName( o );
		return s.substr( s.lastIndexOf(".")+1 );
	}
	
	public static function getFullyQualifiedClassName( o ) : String 
	{
		o = (typeof(o)=="function")? Function(o).prototype : o.__proto__;
		return ( ClassUtils._containsKey(o) ) ? ClassUtils._getFullyQualifiedClassName( o ) : ClassUtils._buildPath( "", _global, o );
	}
	
	private static function _buildPath( s : String, pack, o ) : String
	{
		for ( var p : String in pack ) 
		{
			var cProto : Function = pack[p];
			
			if ( cProto.__constructor__ === Object ) 
			{
				p = ClassUtils._buildPath( s + p + ".", cProto, o );
				if ( p ) return p;
				
			} else if ( cProto.prototype === o )
			{
				ClassUtils._setFullyQualifiedClassName( o, s+p );
				return s + p;
			}
		}
	}
	
	/*
	 * private implementation for cache
	 */
	private static function _containsKey( o ) : Boolean
	{
		return Boolean( o.__fullyQualifiedClassName.length > 0 );
	}
	
	private static function _getFullyQualifiedClassName( o ) : String
	{
		return o.__fullyQualifiedClassName;
	}
	
	private static function _setFullyQualifiedClassName( o, s : String ) : Void
	{
		o.__fullyQualifiedClassName = s;
		_global.ASSetPropFlags( o, ["__fullyQualifiedClassName"], 7, 1 );
	}
}