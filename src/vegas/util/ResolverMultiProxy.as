/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Vegas Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import vegas.core.CoreObject;
import vegas.data.Set;
import vegas.data.set.HashSet;

/**
 * Allow to link an object with multiple objets using {@code __resolve} method.
 * <p><b>Example :</b></p>
 * {@code
 * import vegas.util.ResolverMultiProxy ;
 * 
 * var o1:Object = {} ;
 * o1.prop1 = 1 ;
 * o1.toString = function() 
 * {
 *     return "object1" ;
 * } ;
 * o1.method1 = function( message:String )
 * {
 *    trace("method1 : " + message) ;
 * }
 * 
 * var o2:Object = {} ;
 * o2.toString = function() 
 * {
 *     return "object2" ;
 * } ;
 * o2.prop2 = 2 ;
 * o2.method2 = function( message:String )
 * {
 *     trace("method2 : " + message) ;
 * }
 * 
 * var proxy:ResolverMultiProxy = new ResolverMultiProxy() ;
 * proxy.addProxy( o1 ) ;
 * proxy.addProxy( o2 ) ;
 * 
 * trace("size : " + proxy.size()) ; // size : 2
 * 
 * trace(proxy.prop1) ; // 1
 * trace(proxy.prop2) ; // 2
 * 
 * proxy.method1("hello world 1") ; // method1 : hello world 1
 * proxy.method2("hello world 2") ; // method2 : hello world 2
 * }
 * @author eKameleon
 */
dynamic class vegas.util.ResolverMultiProxy extends CoreObject
{
	
	/**
	 * Creates a new ResolverMultiProxy instance.
	 */
	function ResolverMultiProxy ( p_proxy ) 
	{
		_set = new HashSet() ;
    }

	/**
	 * Adds a new proxy reference in the proxy model.
	 */
	public function addProxy( proxy ):Boolean 
	{
		return _set.insert(proxy) ;
	}

	/**
	 * Removes all proxy objects in this resolver.
	 */
	public function clear():Void
	{
		_set.clear() ;	
	}

	/**
	 * Returns {@code true} if the specified proxy reference is register.
	 * @return {@code true} if the specified proxy reference is register.
	 */
	public function containsProxy( proxy ):Boolean 
	{
		return _set.contains(proxy) ;
	}

	/**
	 * Returns the unique Set of all objects register in this ResolverMultiProxy instance.
	 * @return the unique Set of all objects register in this ResolverMultiProxy instance.
	 */
	public function getUniqueSet():Set
	{
		return _set.clone() ;	
	}

	/**
	 * Removes a proxy reference in the proxy model.
	 */
	public function removeProxy( proxy ):Boolean 
	{
		return _set.remove( proxy ) ;
	}
	
	/**
	 * Resolve the specified property name.
	 */
	public function __resolve( prop:String ) 
	{
		if ( _set.isEmpty() ) 
		{
			return ;
		}
		var ar:Array = _set.toArray() ;
		var len:Number = ar.length ;
		if (len > 0)
		{
			while (--len > -1) 
			{
				var proxy = ar[len] ;
				if( !proxy.hasOwnProperty(prop) ) 
				{
					// do nothing
				}
				else if( typeof(proxy[prop]) == "function" ) 
				{
					return function() 
					{
						return proxy[prop].apply( proxy, arguments );
					} ;
				} 
				else 
				{
					return proxy[prop] ;
				}
			}
    	}
	}
	
	/**
	 * Returns the number of object to delegate with this proxy.
	 * @return the number of object to delegate with this proxy.
	 */
	public function size():Number 
	{
		return _set.size() ;
	}
	
	private var _set:HashSet ;
	
}

