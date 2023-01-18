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
 * {@code ListenerArray} defines data structure, based on {@code Array}, to store 
 * listeners list used by {@link IeventDispatcher} instances.
 * 
 * <p>See {@link EventBroadcaster} for {@code ListenerArray} example.
 * 
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.log.PixlibStringifier;

class com.bourre.events.ListenerArray extends Array
{
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Constructs a new {@code ListenerArray} instance.
	 * 
	 * <p>Can use {@code Array} instanciation way to build a new 
	 * {@code ListenerArray}'one like :
	 * <code>
	 *   var a : new ListenerArray( myListenerArray1, myListenerArray2, ...); 
	 * </code>
	 * 
	 * <p>Example
	 * <code>
	 *   var a : ListenerArray = new ListenerArray();
	 * </code>
	 * 
	 * @see com.bourre.events.EventBroadcaster
	 */
	public function ListenerArray()
	{
		splice.apply(this, [0, 0].concat(arguments));
	}
	
	/**
	 * Returns index {@code Number} of passed-in {@code oL} listener.
	 * 
	 * <p>Example
	 * <code>
	 *   var oEB : EventBroadcaster = new EventBroadcaster( this );
	 *   oEB.addListener( myListener );
	 *    
	 *   var n : Number = a.getIndex( myListener );
	 * </code>
	 * 
	 * @param oL Listener to check.
	 * 
	 * @return {@code Number} index of listener or {@code -1} if listener not exist.
	 */
	public function getIndex(oL) : Number 
	{
		if (typeof( oL ) == "function") oL = oL.t;

		var l:Number = this.length;
		while ( --l > -1 )
		{
			var o = this[l];
			if (o == oL) 
			{
				return l;
			} else if ( typeof( o ) == "function" )
			{
				if (o.t == oL) return l;
			}
		}
		return -1;
	}
	
	/**
	 * Indicates if passed-in {@code oL} listener is referenced in structure.
	 * 
	 * <p>Example
	 * <code>
	 *   var b : Boolean = a.listenerExists( myListener ); //return true
	 * </code>
	 * 
	 * @param oL Listener to check.
	 * @return {@code true} is listener exist, either {@code false}
	 */
	public function listenerExists(oL) : Boolean 
	{
		return (getIndex(oL) != -1);
	}
	
	/**
	 * Adds passed-in {@code oL} listener into structure.
	 * 
	 * <p>Internally used by {@link IEventDispatcher} to register new listeners.
	 * 
	 * <p>Example
	 * <code>
	 *   a.push( myListener );
	 * </code>
	 * 
	 * @param oL Listener to add.
	 * 
	 * @return {@code true} if listener has been successfully added, either {@code false} 
	 * (if already exist)
	 */
	public function insert(oL) : Boolean
	{
		if (!listenerExists(oL))
		{
			push(oL);
			return true;
		} else return false;
	}

	/**
	 * Removes passed-in {@code oL} listener from structure.
	 * 
	 * <p>Internally used by {@link IEventDispatcher} to unsubscribe listeners.
	 * 
	 * <p>Example
	 * <code>
	 *   a.remove( myListener );
	 * </code>
	 * 
	 * @param oL Listener to remove.
	 * @return {@code true} if listener has been found and removed, either {@code false}
	 */
	public function remove(oL) : Boolean 
	{
		var i:Number = getIndex(oL);
		if (i != -1) 
		{
			splice(i, 1);
			return true;
		} else return false;
	}
	
	/**
	 * Indicates if strucutre is empty.
	 * 
	 * <p>Example
	 * <code>
	 *   var b : Boolean = a.isEmpty( myListener );
	 * </code>
	 * 
	 * @return {@code true} if structure contains no listeners, either {@code false}
	 */
	public function isEmpty() : Boolean
	{
		return this.length < 1;
	}
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this );
	}
}