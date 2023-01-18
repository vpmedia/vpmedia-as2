/**
 *  Copyright (c) 2006, David Knape and contributing authors
 *
 *  Permission is hereby granted, free of charge, to any person 
 *  obtaining a copy of this software and associated documentation 
 *  files (the "Software"), to deal in the Software without 
 *  restriction, including without limitation the rights to use, 
 *  copy, modify, merge, publish, distribute, sublicense, and/or 
 *  sell copies of the Software, and to permit persons to whom the 
 *  Software is furnished to do so, subject to the following 
 *  conditions:
 *  
 *  The above copyright notice and this permission notice shall be 
 *  included in all copies or substantial portions of the Software.
 * 
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
 *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
 *  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
 *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
 *  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
 *  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
 *  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR 
 *  OTHER DEALINGS IN THE SOFTWARE.
 */

 
 /**
  *  Simplified Map implementation inspired by AS2Lib (Map/AbstractMap/PrimitiveTypeMap)
  * 
  *  2006-07-12 - Modified by David Knape
  *  - removed all the as2lib dependencies
  *  - removed support for iterators
  *  - combined AbstractMap with PrimitiveTypeMap
  * 
  */
 
//import com.bumpslide.util.Debug;
  
class com.bumpslide.data.Map
{

	/** Contains the mappings. */
	private var mMap:Object;
	
	/** The key-index pairs. */
	private var mIndexMap:Object;
	
	/** The keys stored in an array. */
	private var mKeys:Array;
	
	/** The values stored in an array. */
	private var mValues:Array;
	
	/**
	 * Constructs a new {@code Map} instance.
	 *
	 * <p>This map iterates over the passed-in {@code source} with the for..in loop and
	 * uses the variables' names as key and their values as value. Variables that are
	 * hidden from for..in loops will not be added to this map.
	 * 
	 * @param source (optional) an object that contains key-value pairs to populate this
	 * map with
	 */
	public function Map ( inObject:Object ) {
		//Debug.trace( 'Map CTOR');
		mMap = new Object();
		mIndexMap = new Object();
		mIndexMap.__proto__ = undefined;
		mKeys = new Array();
		mValues = new Array();
		populate( inObject );
	}
	
	
	/**
	 * Populates the map with the content of the passed-in {@code source}.
	 * 
	 * <p>Iterates over the passed-in source with the for..in loop and uses the variables'
	 * names as key and their values as value. Variables that are hidden from for..in
	 * loops will not be added to this map.
	 * 
	 * <p>This method uses the {@code put} method to add the key-value pairs.
	 * 
	 * @param source an object that contains key-value pairs to populate this map with
	 */
	private function populate ( inObject:Object ):Void {

		if ( inObject ) {
			for ( var prop:String in inObject ) {
				this["put"]( prop, inObject[prop] );
			}
		}
	}
	
	public function toObject () : Object {
		return mMap;
	}


	/**
	 * Checks if the passed-in {@code key} exists.
	 *
	 * <p>That means whether a value has been mapped to it.
	 *
	 * @param key the key to be checked for availability
	 * @return {@code true} if the {@code key} exists else {@code false}
	 */
	public function containsKey ( inKey:String ) : Boolean {
		return ( mMap[inKey]!=undefined );
	}
	
	/**
	 * Checks if the passed-in {@code value} is mapped to a key.
	 *
	 * @param value the value to be checked for availability
	 * @return {@code true} if the {@code value} is mapped to a key else {@code false}
	 */
	public function containsValue ( inValue ) : Boolean {

		var i:Number = mKeys.length;
		while (--i-(-1)) {
			if ( mValues[i]==inValue ) {
				return true;
			}
		}
		return false;
	}

	/**
	 * Checks if the passed-in {@code key} exists.
	 *
	 * <p>That means whether a value has been mapped to it.
	 *
	 * @param key the key to be checked for availability
	 * @return {@code true} if the {@code key} exists else {@code false}
	 */
	public function getValue ( inKey:String ) : Object {
		return mMap[ inKey ];
	}
	
	/**
	 * Checks if the passed-in {@code value} is mapped to a key.
	 *
	 * @param value the value to be checked for availability
	 * @return {@code true} if the {@code value} is mapped to a key else {@code false}
	 */
	public function getKey ( inValue ) : String {
		
		var i:Number = mKeys.length;
		for ( var k:String in mMap ) {
			if ( mMap[k] == inValue ) {
				return k;
			}
		}
		return undefined;
	}
	
	/**
	 * Returns an array that contains all keys that have a value mapped to it.
	 * 
	 * @return an array that contains all keys
	 */
	public function getKeys () : Array {
		return mKeys.slice(); //concat();
	}
	
	/**
	 * Returns an array that contains all values that are mapped to a key.
	 *
	 * @return an array that contains all mapped values
	 */
	public function getValues () : Array {
		return mValues.slice(); //concat();
	}
	
	/**
	 * Returns the value that is mapped to the passed-in {@code key}.
	 *
	 * @param key the key to return the corresponding value for
	 * @return the value corresponding to the passed-in {@code key}
	 */
	public function get ( inKey:String ) {
		//Debug.trace('[Map] GET '+key);
		return mMap[inKey];
	}
	
	/**
	 * Maps the given {@code key} to the {@code value}.
	 *
	 * <p>{@code null} and {@code undefined} values are allowed.
	 *
	 * @param key the key used as identifier for the {@code value}
	 * @param value the value to map to the {@code key}
	 * @return the value that was originally mapped to the {@code key} or {@code undefined}
	 */
	public function put ( inKey:String, inValue ) {
//		Debug.trace( '[Map] PUT '+inKey+', '+inValue );
		var result;
		var i:Number = mIndexMap[ inKey ];
		if ( i==undefined ) {
			mIndexMap[ inKey ] = mKeys.push( inKey )-1;
			mValues.push( inValue );
		} else {
			result = mValues[i];
			mValues[i] = inValue;
		}
		mMap[ inKey ] = inValue;
		return result;
	}
	
		
	/**
	 * Removes the mapping from the given {@code key} to the value.
	 *
	 * @param key the key identifying the mapping to remove
	 * @return the value that was originally mapped to the {@code key}
	 */
	public function remove ( inKey:String ) {
		var result;
		var i:Number = mIndexMap[ inKey ];
		if ( i!=undefined ) {
			result = mValues[i];
			mMap[ inKey] = undefined;
			mIndexMap[ inKey] = undefined;
			mKeys.splice(i, 1);
			mValues.splice(i, 1);
			// restore indexes in indexMap
			for ( var k:Number=i; k < mKeys.length; k++) {
				mIndexMap[ mKeys[k] ]--;
			}
		}
		return result;
	}
	
	/**
	 * Clears all mappings.
	 */
	public function clear () : Void {
		mMap = new Object();
		mIndexMap = new Object();
		mIndexMap.__proto__ = undefined;
		mKeys = new Array();
		mValues = new Array();
	}

	/**
	 * Returns the amount of mappings.
	 *
	 * @return the amount of mappings
	 */
	public function size () : Number {
		return mKeys.length;
	}
	
	/**
	 * Returns whether this map contains any mappings.
	 *
	 * @return {@code true} if this map contains no mappings else {@code false}
	 */
	public function isEmpty () : Boolean {
		return (size() < 1);
	}
	
}