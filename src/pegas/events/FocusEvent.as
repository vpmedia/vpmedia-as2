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

import vegas.events.DynamicEvent;
import vegas.util.serialize.Serializer;

/**
 * The FocusEvent class.
 * @author eKameleon
 */
class pegas.events.FocusEvent extends DynamicEvent 
{

	/**
	 * Creates a new FocusEvent instance.
	 */
	public function FocusEvent( type:String, target, p_keyCode:Number, p_relatedObject, p_shiftKey:Boolean, context, bubbles:Boolean, eventPhase:Number, time:Number, stop:Number )
	{
		super(type, target, context, bubbles, eventPhase, time, stop) ;
		keyCode = isNaN(p_keyCode) ? null : p_keyCode ;
		relatedObject = p_relatedObject || null  ;
		shiftKey = p_shiftKey || null  ;
	}

	/**
	 * [static] Dispatched after a display object gains focus.
	 */
	static public var FOCUS_IN:String = "focusIn" ;
	
	/**
	 * [static] Dispatched after a display object loses focus.
	 */
	static public var FOCUS_OUT:String = "focusOut" ;

	/**
	 * [static] Dispatched when the user attempts to change focus using keyboard navigation.
	 */
	static public var KEY_FOCUS_CHANGE:String = "keyFocusChange" ;
	
	/**
	 * [static] Dispatched when the user attempts to change focus by using a pointer device.
	 */
	static public var MOUSE_FOCUS_CHANGE:String = "MouseFocusChange" ;

	static private var __ASPF__ = _global.ASSetPropFlags(FocusEvent, null , 7, 7) ;

	/**
	 * The key code value of the key pressed to trigger a keyFocusChange event.
	 */
	public var keyCode:Number = null ;

	/**
	 * A reference to the complementary InteractiveObject instance that is affected by the change in focus.
	 */	
	public var relatedObject = null ;
	
	/**
	 * Indicates whether the Shift key modifier is activated, in which case the value is true.
	 */
	public var shiftKey:Boolean = null ;
		
	/**
	 * Returns a shallow copy of the object.
	 */
	public function clone() 
	{
		return new FocusEvent(getType(), getTarget()) ;
	}

	/**
	 * This protected method is used by the toSource method.
	 */
	/*protected*/ private function _getParams():Array {
		var ar:Array = super._getParams() ;
		ar.splice(2, null, Serializer.toSource(keyCode)) ;
		ar.splice(3, null, Serializer.toSource(relatedObject)) ;
		ar.splice(4, null, Serializer.toSource(shiftKey)) ;
		return ar ;
	}

}
