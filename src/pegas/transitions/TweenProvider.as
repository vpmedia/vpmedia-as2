/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is PEGAS Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import pegas.transitions.TweenEntry;

import vegas.data.iterator.Iterable;
import vegas.data.iterator.Iterator;
import vegas.data.Map;
import vegas.data.map.HashMap;
import vegas.errors.IllegalArgumentError;
import vegas.events.ModelChangedEvent;
import vegas.events.ModelChangedEventType;
import vegas.util.mvc.AbstractModel;
import vegas.util.TypeUtil;

/**
 * The model of the Tween class.
 * @author eKameleon
 */
class pegas.transitions.TweenProvider extends AbstractModel implements Iterable 
{
	
	
	/**
	 * Creates a new TweenProvider instance.
	 * @param tweens an array of TweenEntry objects. 
	 */
	public function TweenProvider( tweens:Array ) {
		_map = new HashMap() ;
		var len:Number = tweens.length ;
		if (len > 0) 
		{
			for (var i:Number = 0 ; i<len ; i++) 
			{
				var t:TweenEntry = tweens[i].clone()  ;
				if (t instanceof TweenEntry) 
				{
					insert(t) ;
				}
			}
		}
	}
	
	/**
	 * Returns a shallow copy of this object.
	 * {@code  var clone:TweenProvier = tp.clone() ;}
	 * @return a shallow copy of this object.
	 */
	public function clone() 
	{
		var ar:Array = [] ;
		return new TweenProvider(toArray()) ;
	}
	
	public function clear():Void 
	{
		_map.clear() ;
		notifyChanged( new ModelChangedEvent(ModelChangedEventType.CLEAR_ITEMS, this) ) ;
	}
	
	public function get(prop:String):TweenEntry 
	{
		return _map.get(prop) ;
	}
	
	public function getProperties():Array 
	{
		return _map.getKeys() ;
	}
	
	public function insert( entry:TweenEntry ):Boolean 
	{
		var p:String = entry.prop ;
		if (p) 
		{
			var t:TweenEntry = _map.put(p, entry) ;
			notifyChanged( new ModelChangedEvent(ModelChangedEventType.ADD_ITEMS, this) ) ;
			return true ;
		}
		else 
		{
			return false ;
		}
	}
	
	public function iterator():Iterator 
	{
		return _map.iterator() ;
	}
	
	public function remove( entry:Object ):Boolean 
	{
		var p:String ;
		if (TypeUtil.typesMatch(entry, String)) p = String(entry) ;
		else if (TypeUtil.typesMatch(entry, TweenEntry)) p = entry.prop ;
		else throw new IllegalArgumentError ; 
		if (p) 
		{
			var t:TweenEntry = _map.remove(p) ;
			if (t != null) 
			{
				notifyChanged( new ModelChangedEvent(ModelChangedEventType.REMOVE_ITEMS, this) ) ;
				return true ;
			}
		} 
		else 
		{
			return false ;
		}
	}
	
	public function size():Number 
	{
		return _map.size() ;
	}
	
	public function toArray():Array 
	{
		return _map.getValues() ;
	}
	
	public function toMap():Map 
	{
		return _map.clone() ;		
	}

	public function toString():String 
	{
		return _map.toString() ;
	}
	
	private var _map:HashMap ;

}