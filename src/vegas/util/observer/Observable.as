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
import vegas.data.iterator.Iterator;
import vegas.data.list.ArrayList;
import vegas.errors.NullPointerError;
import vegas.util.observer.IObserver;

/**
 * This class represents an observable object, or "data" in the model-view paradigm. It can be subclassed to represent an object that the application wants to have observed.
 * @author eKameleon
 */
class vegas.util.observer.Observable extends CoreObject
{

	/**
	 * Creates an Observable instance with zero Observers.
	 */
	public function Observable() 
	{
		_obs = new ArrayList() ;
	}

	/**
	 *  Adds an observer to the set of observers for this object, provided that it is not the same as some observer already in the set.
 	 */
	public function addObserver(o:IObserver):Boolean 
	{
		if (o == null) 
		{
			throw new NullPointerError(this + " the passed object in argument not must be 'null' or 'undefined'.") ;
		}
		if (!_obs.contains(o)) 
		{
			_obs.insert(o) ;
			return true ;
		}
		return false ;
	}

	/**
	 * Indicates that this object has no longer changed, or that it has already notified all of its observers of its most recent change, so that the hasChanged method will now return false.
	 */
	public function clearChanged():Void 
	{
		_changed = false ;
	}
	
	/**
	 * Tests if this object has changed.
	 */
	public function hasChanged():Boolean 
	{
		return _changed ;
	}

	/**
	 * If this object has changed, as indicated by the hasChanged method, then notify all of its observers and then call the clearChanged method to indicate that this object has no longer changed.
	 */
	public function notifyObservers( arg ):Void 
	{
		if (arg == undefined) 
		{
			arg = null ;
		}
		if (!_changed) 
		{
			return ;
		}
		clearChanged() ;
		var _obsMemory:ArrayList = _obs.clone() ;
		var it:Iterator = _obsMemory.iterator() ;
		while(it.hasNext()) 
		{
			IObserver(it.next()).update(this, arg) ;
		}
	}

	/**
	 * Removes an observer from the set of observers of this object.
	 */
	public function removeObservers(o:IObserver):Void 
	{
		if (o == undefined) 
		{
			_obs.clear() ;
		}
		else 
		{
			_obs.remove(o) ;
		}
	}
	
	/**
	 * Marks this Observable object as having been changed; the hasChanged method will now return true
	 */
	public function setChanged():Void 
	{
		_changed = true ;
	}

	/**
	 * Returns the number of observers of this Observable object.
	 * @return the number of observers of this Observable object.
	 */
	public function size():Number 
	{
		return _obs.size() ;
	}

	/**
	 * The internal ArrayList.
	 */		
	private var _obs:ArrayList ;
	
	/**
	 * The internal value to notify if this Observable object is changed or not.
	 */
	private var _changed:Boolean ;
	
}