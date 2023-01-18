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

import vegas.core.IFormattable;
import vegas.data.Collection;
import vegas.data.collections.SimpleCollection;
import vegas.data.iterator.ArrayIterator;
import vegas.data.iterator.Iterable;
import vegas.data.iterator.Iterator;
import vegas.data.Map;
import vegas.data.map.HashMap;
import vegas.data.map.MultiMapFormat;
import vegas.data.MultiMap;
import vegas.util.serialize.Serializer;

/**
 * The default implementation of the {@code MultiMap} interface.
 * <p><b>Example :</b></p>
 * {@code
 * import vegas.data.Collection ;
 * import vegas.data.iterator.Iterator ;
 * import vegas.data.map.HashMap ;
 * import vegas.data.Map ;
 * import vegas.data.MultiMap ;
 * import vegas.data.map.MultiHashMap ;
 * 
 * var map1:HashMap = new HashMap() ;
 * map1.put("key1", "valueD1") ;
 * map1.put("key2", "valueD2") ;
 * trace ("> map1 : " + map1) ;
 * trace ("> map1 containsKey 'key1' : " + map1.containsKey("key1")) ;
 * 
 * trace ("--- use a map argument in constructor") ;
 * 
 * var map:MultiHashMap = new MultiHashMap(map1) ;
 * map.put("key1", "valueA1") ;
 * map.put("key1", "valueA2") ;
 * map.put("key1", "valueA3") ;
 * map.put("key2", "valueA2") ;
 * map.put("key2", "valueB1") ;
 * map.put("key2", "valueB2") ;
 * map.put("key3", "valueC1") ;
 * map.put("key3", "valueC2") ;
 * 
 * trace ("init map : " + map) ;
 * trace ("\r--- toSource MultiMap") ;
 * 
 * trace("map toSource : " + map.toSource()) ;
 * 
 * trace ("\r--- put values in MultiMap") ;
 * 
 * trace ("key1 >> " + map.get("key1")) ;
 * 
 * trace ("key2 >> " + map.get("key2")) ;
 * 
 * trace ("key3 >> " + map.get("key3")) ;
 * 
 * trace ("\r--- toString MultiMap") ;
 * 
 * trace (map) ;
 * 
 * map.remove("key1", "valueA2") ;
 * 
 * trace ("\r--- remove a value in key1 >> " + map.get("key1")) ;
 * 
 * trace ("\r--- use iterator") ;
 * 
 * var it:Iterator = map.iterator() ;
 * while(it.hasNext()) 
 * {
 *     trace ("\t :: " + it.next()) ;
 * }
 * 
 * trace ("\r--- use a key iterator : key1") ;
 * var it:Iterator = map.iterator("key1") ;
 * while(it.hasNext()) 
 * {
 *     trace ("\t :: " + it.next()) ;
 * }
 * 
 * trace ("\r--- putCollection key2 in key1") ;
 * map.putCollection("key1", map.get("key2")) ;
 * trace ("key1 >> " + map.get("key1")) ;
 * 
 * trace ("\r--- different size") ;
 * trace ("map size : " + map.size()) ;
 * trace ("map totalSize : " + map.totalSize()) ;
 * 
 * trace ("\r--- clone MultiMap") ;
 * var clone:MultiMap = map.clone() ;
 * clone.remove("key1") ;
 * 
 * trace("clone : " + clone) ;
 * trace ("clone size : " + clone.totalSize()) ;
 * trace ("map size : " + map.totalSize()) ;
 * 
 * trace ("\r--- valueIterator") ;
 * var it:Iterator = map.valueIterator() ;
 * while(it.hasNext()) 
 * {
 *      trace("\t> " + it.next()) ;
 * }
 * 
 * } 
 * @author eKameleon
 * @see MultiMap
 */
class vegas.data.map.MultiHashMap extends HashMap implements Iterable, MultiMap, IFormattable 
{

	/**
	 * Creates a new MultiHashMap instance.
	 */
	public function MultiHashMap() 
	{
		_map = new HashMap() ;
		if (arguments[0] instanceof Map) 
		{
			var m:Map = arguments[0].clone() ;
			if (m) putAll(m) ;
		}
	}

	/**
	 * Removes all elements in this map.
	 */
	public function clear():Void 
	{
		_map.clear() ;
	}

	/**
	 * Creates a new instance of the map value Collection container.
	 * This method can be overridden to use your own collection type.
	 * @return a new instance of the map value Collection container.
	 */
	public function createCollection():Collection 
	{
		return new SimpleCollection() ;	
	}

	/**
	 * Returns a shallow copy of this object.
	 * @return a shallow copy of this object.
	 */
	public function clone() 
	{
		var m:MultiHashMap = new MultiHashMap() ;
		var vItr:Iterator = valueIterator() ;
		var kItr:Iterator = keyIterator() ;
		while (kItr.hasNext()) 
		{
			var key = kItr.next() ;
			var value = vItr.next() ;
			m.putCollection(key, value) ;
		}
		return m ;
	}

	/**
	 * Checks whether the map contains the key specified.
	 */
	public function containsKey( key ):Boolean 
	{
		return _map.containsKey( key ) ;
	}

	/**
	 * Checks whether the map contains the value specified or at the specified key contains the value.
	 * <p><b>Example :</b></p>
	 * {@code
	 * var b:Boolean = map.containsValue(key, value) ;
	 * var b:Boolean = map.containsValue(value) ;
	 * }
	 * @return {@code true} if the map contains the specified value. 
	 */
	public function containsValue( value ):Boolean 
	{
		var len:Number = arguments.length ;
		if (len == 1) 
		{
			var it:Iterator = _map.iterator() ;
			while (it.hasNext()) 
			{
				var cur = it.next() ;
				if (cur.contains(value)) return true;
			}
		} 
		else if (len == 2) 
		{
			return ( get(arguments[0] ).contains(arguments[1]) == true);
		}
		return false ;
	}

	/**
	 * Gets the collection mapped to the specified key. This method is a convenience method to typecast the result of get(key).
	 * @return the collection mapped to the specified key
	 */
	public function get( key ) /*Collection*/ 
	{
		return _map.get(key) || null ;
	}

	/**
	 * Checks whether the map contains the key specified .
	 */
	public function getKeys():Array 
	{
		return _map.getKeys() ;
	}
	
	/**
	 * This returns an array containing the combination of values from all keys.
	 * @return returns an array containing the combination of values from all keys.
	 */
	public function getValues():Array 
	{
		var result:Array = [] ;
		var values = this._map.getValues() ;
		var l:Number = values.length ;
		for (var i:Number = 0 ; i<l ; i++) 
		{
			result = result.concat( values[i].toArray() ) ;
		}
		return result ;
	}

	/**
	 * Returns whether this MultiHashSet contains any mappings.
	 * @return {@code true} if this MultiHashMap contains any mappings else {@code false}
	 */
	public function isEmpty():Boolean 
	{
		return _map.isEmpty() ;
	}
	
	/**
	 * Gets an iterator for the collection mapped to the specified key.
	 */
	public function iterator( /*key*/ ):Iterator 
	{
		var key = arguments[0] ;
		if (key) 
		{
			return _map.get(key).iterator() ;
		}
		else 
		{
			return _map.iterator() ;
		}
	}

	/**
	 * Gets an iterator for the map to iterate keys.
	 */
	public function keyIterator():Iterator 
	{
		return _map.keyIterator() ;
	}

	/**
	 * Adds the value to the collection associated with the specified key.
	 */
	public function put(key, value) 
	{
		if (!containsKey(key)) 
		{
			_map.put(key , createCollection()) ;
		}
		var b:Boolean = _map.get(key).insert(value) ;
		return b ? value : null ;
	}

	/**
	 * Override superclass to ensure that MultiMap instances are correctly handled.
	 */
	public function putAll(map:Map):Void 
	{
		var it:Iterator = map.iterator() ;
		while (it.hasNext()) 
		{
			var value = it.next() ;
			var key = it.key() ;
			if (value instanceof Collection) 
			{
				putCollection(key, value) ;
			}
			else 
			{
				put(key, value) ;
			}
		}
	}
	
	/**
	 * Adds a collection of values to the collection associated with the specified key.
	 */
	public function putCollection(key, c:Collection):Void 
	{
		if (!containsKey(key)) 
		{
			_map.put(key , createCollection()) ;
		}
		_map.get(key).insertAll(c) ;
	}
	
	/**
	 * Removes a specific value from map.
	 * @param key the key to remove in the map
	 * @param value (optional) if this value is defined removes a specific value from map else removes all values associated with the specified key.
	 * @return the removed value.
	 */
	public function remove(key /*, value*/ ) 
	{
		var value = arguments[1] ;
		if (key && value) 
		{
			var c:Collection = Collection( this.get(key)) ;
			if (c != null)
			{
				var b:Boolean = c.remove(value) ;
				if (c.isEmpty())
				{
					_map.remove(key) ;	
				}
				return (b) ? value : null ;
			}
			else
			{
				return null ;	
			}
		}
		else 
		{
			return _map.remove(key) ;
		}
	}
	
	/**
	 * Returns the size of the collection mapped to the specified key.
	 * @return the size of the collection mapped to the specified key.
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
		var sourceA:String = Serializer.toSource(_map) ;
		return Serializer.getSourceOf(this, [sourceA]) ;
	}

	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString():String 
	{
		return (new MultiMapFormat()).formatToString(this) ;
	}

	/**
	 * Gets the total size of the map by counting all the values.
	 */
	public function totalSize():Number 
	{
		var result:Number = 0 ;
		var it:Iterator = _map.iterator() ;
		while (it.hasNext()) 
		{
			result += (it.next().size() || 0) ;
		}
		return result ;
	}

	/**
	 * Returns a Collection of all values in the MultiHashMap.
	 * @return a Collection of all values in the MultiHashMap.
	 */
	public function values():Collection 
	{
		var ar:Array = getValues() ;
		return new SimpleCollection(ar) ;
	}

	/**
	 * Returns the iterator of all values in the MultiHashMap.
	 * @return the iterator of all values in the MultiHashMap.
	 */
	public function valueIterator():Iterator 
	{
		return new ArrayIterator(_map.getValues()) ;
	}

	/**
	 * The internal HashMap.
	 */
	private var _map:HashMap ;
	
}