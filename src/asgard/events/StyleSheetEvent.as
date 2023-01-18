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

import asgard.text.StyleSheet;

import vegas.events.BasicEvent;
import vegas.events.EventType;

/**
 * This event contains a StyleSheet reference.
 * @author eKameleon
 */
class asgard.events.StyleSheetEvent extends BasicEvent 
{
	
	/**
	 * Creates a new StyleSheetEvent instance.
	 * @param type the string type of the instance.
	 * @param css the {@code StyleSheet} reference of this event. 
	 * @param target the target of the event.
	 * @param context the optional context object of the event.
	 * @param bubbles indicates if the event is a bubbling event.
	 * @param eventPhase the current EventPhase of the event.
	 * @param time this parameter is used in the Eden deserialization.
	 * @param stop this parameter is used in the Eden deserialization.
	 */	
	public function StyleSheetEvent( type:String , css:StyleSheet , target, context, bubbles:Boolean, eventPhase:Number, time:Number, stop:Number) 
	{
		super(type, target, context, bubbles, eventPhase, time, stop);
		if (css != null)
		{
			setStyleSheet(css) ;
		}
	}

	/**
	 * The event type name of this event when a StyleSheet change. 
	 */
	static public var CHANGE:String = EventType.CHANGE ;

	/**
	 * Returns a shallow copy of the event.
	 * @return a shallow copy of the event.
	 */
	public function clone() 
	{
		return new StyleSheetEvent(getType(), getStyleSheet(), getTarget(), getContext()) ;
	}

	/**
	 * Returns the styleSheet reference of this event.
	 * @return the styleSheet reference of this event.
	 */
	public function getStyleSheet():StyleSheet
	{
		return _styleSheet ;	
	}
	
	/**
	 * Sets the styleSheet reference of this event.
	 */
	public function setStyleSheet( css:StyleSheet ):Void
	{
		_styleSheet = css ;	
	}

	/**
	 * The internal styleSheet reference of this event.
	 */
	private var _styleSheet:StyleSheet ;
}