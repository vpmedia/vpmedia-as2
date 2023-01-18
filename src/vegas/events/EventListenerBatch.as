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

import vegas.data.collections.SimpleCollection;
import vegas.data.collections.TypedCollection;
import vegas.data.iterator.Iterator;
import vegas.events.Event;
import vegas.events.EventListener;

/**
 * It handles several {@code EventListener} as one {@code EventListener}.
 * <p><b>Example : </b></p>
 * {@code
 * 	
 * import vegas.events.* ;
 * 
 * var EVENT_TYPE:String = "onTest" ;
 * 
 * var action1:Function = function (e:Event):Void 
 * {
 *    trace ("> action1 : " + e.getType()) ;
 * }
 * 
 * var action2:Function = function (e:Event):Void 
 * {
 *     trace ("> action2 : " + e.getType()) ;
 * }
 * 
 * var oListener1:EventListener = new Delegate(this, action1) ;
 * var oListener2:EventListener = new Delegate(this, action2) ;
 * 
 * var batch:EventListenerBatch = new EventListenerBatch() ;
 * batch.insert(oListener1) ;
 * batch.insert(oListener2) ;
 * 	
 * var e:Event = new BasicEvent( EVENT_TYPE , this ) ;
 * 	
 * EventDispatcher.getInstance().addEventListener(EVENT_TYPE, batch) ;
 * EventDispatcher.getInstance().dispatchEvent( e ) ;
 * }
 */
class vegas.events.EventListenerBatch extends TypedCollection implements EventListener 
{

	/**
	 * Creates a new EventListenerBatch instance.
	 */
 	public function EventListenerBatch() 
 	{
		super(EventListener, new SimpleCollection()) ;
  	}

	/**
	 * Returns a shallow copy of this instance.
	 * @return a shallow copy of this instance.
	 */	
	public function clone() 
	{
		var b:EventListenerBatch = new EventListenerBatch() ;
		var it:Iterator = iterator() ;
		while (it.hasNext()) 
		{
			b.insert(it.next()) ;
		}
		return b ;
	}
	
	/**
	 * Handles the event.
	 */
	public function handleEvent(e:Event) 
	{
		var ar:Array = toArray() ;
		var i:Number = -1 ;
		var l:Number = ar.length ;
		if (l>0) while (++i < l) 
		{ 
			ar[i].handleEvent.apply(ar[i], arguments) ; 
		}
  	}
	
}