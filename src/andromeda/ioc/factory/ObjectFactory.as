/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Andromeda Framework based on VEGAS.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import andromeda.ioc.core.IObjectDefinition;
import andromeda.ioc.core.ObjectDefinitionContainer;
import andromeda.ioc.factory.IObjectFactory;

import vegas.data.iterator.Iterator;
import vegas.data.Map;
import vegas.data.map.HashMap;
import vegas.errors.NullPointerError;
import vegas.util.ConstructorUtil;

/**
 * The factory of all objects define with a IObjectDefinition reference.
 * @author eKameleon
 */
class andromeda.ioc.factory.ObjectFactory extends ObjectDefinitionContainer implements IObjectFactory
{
	
	/**
	 * Creates a new ObjectFactory instance.
	 */
	function ObjectFactory() 
	{
		singletons = new HashMap();
	}
	
	/**
	 * The maps of all objects in the container.
	 */
	public var singletons:HashMap ;

	/**
	 * Returns {@code true} if the LightContainer contains the specified name.
	 * @param name the name of the object in the container.
	 * @return {@code true} if the LightContainer contains the specified name.
	 */		
	public function containsObject(name:String):Boolean 
	{
		return containsObjectDefinition(name);
	}

	/**
	 * This method returns an object with the specified name in argument.
	 * @param name The name of the object.
	 * @return the instance of the object with the name passed in argument.
	 */		
	public function getObject( name:String ) 
	{
		var instance = _findInCache( name ) ;		
		if ( instance == null )
		{
			var definition:IObjectDefinition = getObjectDefinition( name ) ;
			if ( definition == null )
			{
				throw new NullPointerError( this +  " get( " + name + " ) method failed, the object isn't register in the container.") ; 
			}
			if ( definition.isSingleton())
			{
				instance = _createAndCacheSingletonInstance( name , definition ) ;
			}
			else
			{
				instance = _createObject( definition.getType() , definition ) ;
			}
		}
		return instance || null ;
	}

	/**
	 * This method defined if the object is a singleton or a prototype.
	 * @param name The name of the object to find in the singleton map.
	 * @return {@code true} if the object is a singleton or else if the object is a prototype. 
	 */	
	public function isSingleton( name:String):Boolean 
	{
		return singletons.containsKey( name ) ;
	}

	/**
	 * Removes and destroy a singleton in the container. 
	 * Invoke the 'destroy' method of this object is it's define in the IObjectDefinition of this singleton.
	 * @param name The name of the singleton to remove.
	 */
	public function removeSingleton( name:String ):Void
	{
		if ( isSingleton(name) )
		{
			_invokeDestroyMethod( singletons.get(name), getObjectDefinition(name) ) ;
			singletons.remove( name ) ;	
		}
	}
	
	/**
	 * Creates the arguments Array representation of the specified definition.
	 * @return the arguments Array representation of the specified definition.
	 */
	private function _createArguments( argList:Array ):Array
	{
		var len:Number = argList.length ;
		if ( len > 0 )
		{
			var stack:Array = [] ;
			var item:Object ;
			for (var i:Number = 0 ; i<len ; i++)
			{
				item = argList[i] ;
				if (item.ref != null)
				{
					stack.push( getObject( item.ref) ) ;	
				}
				else if (item.value != null)
				{
					stack.push( item.value ) ;	
				}
				else
				{
					stack.push(null) ;
				}
			}
			return stack ;		
		}
		else
		{
			return null ;
		}
	} 

	/**
	 * Creates and cache the singleton instance define with the specified name and IDefinition.
	 * @param name the name of the class object.
	 * @param definition the IDefinition to apply over the new instance.
	 */
	private function _createAndCacheSingletonInstance( name:String, definition:IObjectDefinition )
	{
		var instance = singletons[name] ;
		if(!instance) 
		{
			instance = _createObject( definition.getType() , definition ) ;
			singletons.put( name, instance ) ;
		}
		return instance;
	}

	/**
	 * Creates a new Object with the specified name and the specified IObjectDefinition in argument.
	 * @return a new Object with the specified name and the specified IObjectDefinition in argument.
	 */
	private function _createObject( name:String, definition:IObjectDefinition ) 
	{
		var c:Function = eval( "_global." + name ) ;
		var instance = ConstructorUtil.createInstance( c , _createArguments( definition.getConstructorArguments() ) ) ;
		_populateProperties( instance, definition.getProperties() );	
		_invokeInitMethod( instance, definition ) ;
		return instance ;
	}

	/**
	 * Invoque the destroy method of the specified object, if the init method is define in the IDefinition object.
	 */
	private function _invokeDestroyMethod( o , definition:IObjectDefinition ):Void
	{
		if( definition.getDestroyMethodName() ) 
		{
			o[ definition.getDestroyMethodName() ]() ;
		}
	}
	
	/**
	 * Invoque the init method of the specified object, if the init method is define in the IDefinition object.
	 */
	private function _invokeInitMethod( o , definition:IObjectDefinition ):Void
	{
		if( definition.getInitMethodName() ) 
		{
			o[ definition.getInitMethodName() ]() ;
		}
	}

	/**
	 * Populates all properties in the Map passed in argument.
	 */
	private function _populateProperties( o, properties:Map ):Void 
	{
		if (properties != null && properties.size() > 0)
		{
			var it:Iterator = properties.iterator() ;
			while(it.hasNext())
			{
				var value = it.next() ;
				var key   = it.key()  ;
				if (value instanceof Array) // method
				{
					o[key].apply(o, value) ;
				}
				else // property
				{
					if( containsObject( value ) ) 
					{
						value = getObject( value ) ;
        				properties.put( key , value ) ;
    				}
    				o[key] = value ;
				}
			}
		} 
	}

	/**
	 * Returns the object register in cache in this container.
	 * @param the name of the object.
	 * @return the object register in cache in this container.
	 */
	private function _findInCache( name:String ) 
	{
		return singletons.get(name) || null ;
	}

}