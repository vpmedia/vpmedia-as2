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
import vegas.util.Mixin;

/**
 * Allow to link an object with another objet using {@code __resolve} method.
 * <p>This is a 1 to 1 relationship.
 * <li>EventBroadcaster -> 1 to *    + unidirectional</li>
 * <li>ResolverProxy    -> 1 to 1    + unidirectional or bidirectional</li>
 * </p>
 * <p><b>Note :</b>This can be used to connect a "Model" object to a "View" object as an alternative to  "Model-View-Controller" or "visual proxy".</p>
 * <p><b>Example 1 :</b>
 * {@code
 * var myModel = new Model();
 * createView( "myView" ) ;
 * myView.proxy = myModel ;
 * myModel.proxy = myView;
 * }
 * </p>
 * <p><b>Example 2 :</b>
 * {@code
 * myModel = new Model();
 * createView( "myView" );
 * myView.link( myModel );
 * }
 * </p>
 * <p>The View and the Model share their methods and properties as they were only one object.</p>
 * @author eKameleon
 * @see Mixin
 */
class vegas.util.ResolverProxy extends CoreObject 
{
	
	/**
	 * Creates a new ResolverProxy instance.
	 */
	public function ResolverProxy ( proxy ) 
	{
		_proxy = proxy ;
    }
	
	/**
	 * Returns the proxy reference of this instance.
	 */
	public function get proxy()
	{
		return getProxy() ;	
	}

	/**
	 * Sets the proxy reference of this instance.
	 */
	public function set proxy( oTarget )
	{
		setProxy( oTarget ) ;	
	}

	/**
	 * Returns the proxy reference of this ResolverProxy.
	 */
	public function getProxy() 
	{
		return _proxy ;
    }

	/**
	 * Initialize a proxy on a specific target.
	 */
	static public function initialize( target )  
	{
		var attributes:Array = [ "linkProxy", "getProxy", "_proxy", "proxy", "__resolve", "setProxy" ] ;
		var mix:Mixin = new Mixin(ResolverProxy, target, attributes) ;
		mix.run() ;
    }


	/**
	 * Creates a link proxy between 2 proxy object.
	 */		
	public function linkProxy( linkedProxy ) 
	{
		linkedProxy.proxy = this ;
		_proxy = linkedProxy ;
    }

	/**
	 * Sets the proxy reference of this ResolverProxy.
	 */
	public function setProxy( o ) 
	{
		_proxy = o;
	}

	/**
	 * Resolve the specified property name.
	 */
	public function __resolve( name:String ) 
	{
		
		if ( _proxy == null ) 
		{
			return ;
		}
		
		if( !_proxy.hasOwnProperty( name ) ) 
		{
			if( _proxy.__proto__[name] == undefined ) return ;
        }
		
		if( typeof(_proxy[name]) == "function" ) 
		{
			var p = _proxy ; 
			return function() 
			{
				return p[name].apply( p, arguments );
			};
		} 
		else 
		{
			return _proxy[name] ;
		}
		
    }

	/**
	 * Internal proxy reference.
	 */	
	private var _proxy ;
	
}

