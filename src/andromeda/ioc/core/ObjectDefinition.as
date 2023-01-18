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

import vegas.core.CoreObject;
import vegas.data.Map;
import vegas.errors.IllegalArgumentError;

/**
 * The concrete implementation of the IObjectDefinition interface.
 * @author eKameleon
 */
class andromeda.ioc.core.ObjectDefinition extends CoreObject implements IObjectDefinition 
{

	/**
	 * Creates a new Definition instance.
	 * @param type the type of the {@code ObjectDefinition} object.
	 * @param singleton the boolean flag to indicate if the object is a sigleton or not.
	 */	
	public function ObjectDefinition( type:String , singleton:Boolean ) 
	{
		if (type == null || type.length == 0)
		{
			throw new IllegalArgumentError( this + " constructor failed, the string 'type' passed in argument not must be empty or 'null' or 'undefined'.") ;	
		}
		_type = type ;
		_singleton = singleton ;
	}

	/**
	 * Returns the constructor arguments values of this object in a Array list.
	 * @return the constructor arguments values of this object in a Array list.
	 */	
	public function getConstructorArguments():Array 
	{
		return _constructorArguments ;
	}

	/**
	 * Returns the name of the method invoqued when the object is destroyed.
	 * @return the name of the method invoqued when the object is destroyed.
	 */	
	public function getDestroyMethodName():String 
	{
		return _destroyMethodName;
	}

	/**
	 * Returns the name of the method call when the object is instanciate.
	 * @return the name of the method call when the object is instanciate.
	 */	
	public function getInitMethodName():String 
	{
		return _initMethodName;
	}

	/**
	 * Returns the Map of all properties of this Definition.
	 * @return the Map of all properties of this Definition.
	 */	
	public function getProperties():Map 
	{
		return _properties ;
	}

	/**
	 * Returns the type of the object (the class name).
	 * @return the type of the object (the class name).
	 */	
	public function getType():String 
	{
		return _type ;
	}

	/**
	 * Returns {@code true} if the object in a Sigleton else the object is a prototype.
	 * @return {@code true} if the object in a Sigleton else the object is a prototype.
	 */		
	public function isSingleton():Boolean 
	{
		return _singleton;
	}

	/**
	 * Sets the constructor arguments values of this object.
	 * @param value the array representation of all arguments in the constructor of the object instance.
	 */	
	public function setConstructorArguments( value:Array ):Void 
	{
		_constructorArguments = value ;
	}

	/**
	 * Sets the name of the method invoqued when the object is destroyed.
	 * @param value the name of the destroy method of the object.
	 */	
	public function setDestroyMethodName( value:String ):Void 
	{
		_destroyMethodName = value;
	}

	/**
	 * Init the name of the method.
	 * @param value the string 'init method' name.
	 */		
	public function setInitMethodName( value:String ):Void 
	{
		_initMethodName = value;
	}

	/**
	 * Sets the map of all properties of this Definition.
	 * @param value the Map of all properties of the object.
	 */	
	public function setProperties( value:Map ):Void 
	{
		_properties = value ;
	}

	/**
	 * Sets the type of the object (the class name).
	 * @param value the string representation of the type object.
	 */	
	public function setType( value:String ):Void 
	{
		_type = value ;
	}

	/**
	 * The internal Map of all arguments use in the constructor of the object.
	 */
	private var _constructorArguments:Array ;
	
	/**
	 * The name of the destroy method of the object.
	 */
	private var _destroyMethodName:String;

	/**
	 * The name of the init method of the object.
	 */
	private var _initMethodName:String;

	/**
	 * The internal Map of all properties of the object.
	 */
	private var _properties:Map ;
	
	/**
	 * The internal Map of all singletons.
	 */
	private var _singleton:Boolean ;
	
	/**
	 * The type of the IDefinition object.
	 */
	private var _type : String;

}