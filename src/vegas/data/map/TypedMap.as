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

import vegas.core.ICloneable;
import vegas.core.IFormattable;
import vegas.data.iterator.Iterator;
import vegas.data.Map;
import vegas.errors.IllegalArgumentError;
import vegas.util.AbstractTypeable;
import vegas.util.serialize.Serializer;
import vegas.util.TypeUtil;

/**
 * TypedMap is a wrapper for Map instances that ensures that only values of a specific type can be added to the wrapped Map.
 * @author eKameleon
 */
class vegas.data.map.TypedMap extends AbstractTypeable implements ICloneable, Map, IFormattable 
{

	/**
	 * Creates a new TypedMap instance.
	 * @param fType the type of all values in this TypedMap.
	 * @param m the map to wrapp.
	 * @throws IllegalArgumentError if the specified map in argument is {@code null} or {@code undefined}.
	 */
	public function TypedMap( fType:Function , m:Map) 
	{
		
		super( fType ) ;
		if ( m == null) 
		{
			throw new IllegalArgumentError("TypedMap constructor failed, Argument 'map' must not be 'null' or 'undefined'.") ;
		}
		if ( m.size() > 0) 
		{
			var it = m.iterator() ;
			while ( it.hasNext() ) 
			{
				validate(it.next()) ;
			}
		}
		_map = m ;
		trace(_map) ;
	}

	/**
	 * Removes all mappings from this map (optional operation).
	 */
	public function clear():Void 
	{
		_map.clear() ;
	}

	/**
	 * Returns a shallow copy of the map.
	 * @return a shallow copy of the map.
	 */
	public function clone() 
	{
		return new TypedMap(_type, _map) ;
	}

	/**
	 * Returns {@code true} if this map contains a mapping for the specified key.
	 * @return {@code true} if this map contains a mapping for the specified key.
	 */
	public function containsKey(o):Boolean 
	{
		return _map.containsKey(o) ;
    }

	/**
	 * Returns {@code true} if this map maps one or more keys to the specified value.
	 * @return {@code true} if this map maps one or more keys to the specified value.
	 */
	public function containsValue(o):Boolean 
	{
		return _map.containsValue(o) ;
    }

	/**
	 * Returns the value to which this map maps the specified key.
	 * @return the value to which this map maps the specified key.
	 */
	public function get(key) 
	{
		return _map.get(key) ;
	}

	/**
	 * Returns an array of all the keys in the map.
	 * @return an array of all the keys in the map.
	 */
	public function getKeys():Array 
	{
		return _map.getKeys() ;
	}

	/**
	 * Returns an array of all the values in the map.
	 * @return an array of all the values in the map.
	 */
	public function getValues():Array 
	{
		return _map.getValues() ;
	}

	/**
	 * Returns {@code true} if this map contains no key-value mappings.
	 * @return {@code true} if this map contains no key-value mappings.
	 */
	public function isEmpty():Boolean 
	{
		return _map.isEmpty() ;
	}

	/**
	 * Returns the values iterator of this map.
	 * @return the values iterator of this map.
	 */
	public function iterator():Iterator 
	{
		return _map.iterator() ;
	}

	/**
	 * Returns the keys iterator of this map.
	 * @return the keys iterator of this map.
	 */
	public function keyIterator():Iterator 
	{
		return _map.keyIterator() ;
	}

	/**
	 * Associates the specified value with the specified key in this map (optional operation).
	 */
	public function put(key, value) 
	{
		validate(value) ;
		return _map.put(key, value) ;
	}

	/**
	 * Copies all of the mappings from the specified map to this map (optional operation).
	 */
	public function putAll(m:Map):Void 
	{
		var it:Iterator = m.iterator() ;
		while(it.hasNext()) {
			validate(it.next()) ;
		}
		_map.putAll(m) ;
	}

	/**
	 * Removes the mapping for this key from this map if it is present (optional operation).
	 */
    public function remove(key) 
    {
		return _map.remove(key) ;
    }

	/**
	 * Sets the type of the ITypeable object.
	 */
	/*override*/ public function setType(type:Function):Void 
	{
		super.setType(type) ;
		_map.clear() ;
	}

	/**
	 * Returns the number of key-value mappings in this map.
	 * @return the number of key-value mappings in this map.
	 */
	public function size():Number 
	{
		return _map.size() ;
	}

	/**
	 * Returns a Eden representation of the object.
	 * @return a string representing the source code of the object.
	 */
	public function toSource(indent:Number, indentor:String):String 
	{
		var sourceA:String = TypeUtil.toString(_type) ;
		var sourceB:String = Serializer.toSource(_map) ;
		return Serializer.getSourceOf(this, [sourceA, sourceB]) ;
	}

	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString():String 
	{
		return _map.toString() ;
	}

	private var _map:Map ;
	
}