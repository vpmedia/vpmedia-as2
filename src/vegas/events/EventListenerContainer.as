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
import vegas.events.EventListener;

/**
 * Internal class in the {@code EventDispatcher} class to register in an {@code EventCollection} an {@code EventListener}.
 * @author eKameleon
 * @see EventListenerCollection
 * @see EventListenerComparator
 */
class vegas.events.EventListenerContainer extends CoreObject  
{

	/**
	 * Creates a new EventListenerContainer instance.
	 * @param listener an {@code EventListener}
	 */	
	public function EventListenerContainer( listener:EventListener ) {
		_listener = listener ;
	}

	/**
	 * Determinates if the listener use capture flow event or not.
	 */	
	public var useCapture:Boolean ;

	/**
	 * Enables the auto remove option in the EventListener.
	 * @param enable a boolean to indicated if the EventListener is autoRemove at the end of the event flow.
	 */
	public function enableAutoRemove(enable:Boolean):Void 
	{
        _autoRemove = enable;
    }

	/**
	 * Returns the priority of the {@code EventListener}. This priority is used in the {@code EventListenerComparator}.
	 * @return the priority of the {@code EventListener}. This priority is used in the {@code EventListenerComparator}.
	 * @see EventListenerComparator
	 */
	public function getPriority():Number 
	{
		return _priority || 0 ;
	}
    
    /**
     * Returns {@code true} if the {@code EventListener} is auto remove at the end of the event flow.
     * @return {@code true} if the {@code EventListener} is auto remove at the end of the event flow.
     */
    public function isAutoRemoveEnabled():Boolean 
    {
        return _autoRemove;
    }

	/**
	 * Returns the {@code EventListener} reference.
	 * @return the {@code EventListener} reference.
	 */
    public function getListener():EventListener 
    {
        return _listener ;
    }
    
    /**
     * Sets the priority of the {@code EventListener}.
     */
	public function setPriority(n:Number):Void 
	{
		_priority = (n>0) ? n : 0 ;
	}
	
	private var _autoRemove:Boolean = false ;

    private var _listener:EventListener = null ;

	private var _priority:Number ;
    
}