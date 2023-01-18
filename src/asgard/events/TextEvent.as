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

import vegas.events.DynamicEvent;
import vegas.util.serialize.Serializer;

/**
 * The {@code TextEvent} to dispatch an event when a user enters text in a text field or clicks a hyperlink in an HTML-enabled text field. 
 * There are two types of text events : {@code TextEvent.LINK} and {@code TextEvent.TEXT_INPUT}.
 * @author eKameleon
 */
class asgard.events.TextEvent extends DynamicEvent 
{

	/**
	 * Creates an Event object that contains information about error events. 
	 * Event objects are passed as parameters to event listeners.
	 * @param type The type of the event. Event listeners can access this information through the inherited type property. There is only one type of error event: ErrorEvent.ERROR.
	 * @param type Text to be displayed as an error message. Event listeners can access this information through the text property.
	 * @param target the target of the event.
	 * @param context the optional context object of the event.
	 * @param bubbles indicates if the event is a bubbling event.
	 * @param eventPhase the current EventPhase of the event.
	 * @param time this parameter is used in the Eden deserialization.
	 * @param stop this parameter is used in the Eden deserialization.
	 */
	public function TextEvent(type:String, text:String, target, context, bubbles:Boolean, eventPhase:Number, time:Number, stop:Number)
	{
		super(type, target, context, bubbles, eventPhase, time, stop) ;
		this.text = text ;
	}

	/**
	 * The string text reference.
	 */
	public var text:String ;

	/**
	 * Returns the shallow copy of this event.
	 * @return the shallow copy of this event.
	 */
	public function clone() 
	{
		return new TextEvent(getType(), text, getTarget(), getContext()) ;
	}

	/*protected*/ private function _getParams():Array 
	{
		var ar:Array = super._getParams() ;
		ar.splice(1, null, Serializer.toSource(text)) ;
		return ar ;
	}


}
