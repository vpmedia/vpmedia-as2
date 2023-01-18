/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is LunAS Library.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import lunas.core.IStyle;

import vegas.events.BasicEvent;
import vegas.events.EventPhase;
import vegas.util.ConstructorUtil;

/**
 * The {@code StyleEvent} to dispatch an event with an {@code IStyle} object.
 */
class lunas.events.StyleEvent extends BasicEvent 
{

	/**
	 * Creates a new IStyle instance.
	 * @param type the string type of the instance. 
	 * @param style the IStyle reference of this event.
	 * @param target the target of the event.
	 * @param context the optional context object of the event.
	 * @param bubbles indicates if the event is a bubbling event.
	 * @param eventPhase the current EventPhase of the event.
	 * @param time this parameter is used in the Eden deserialization.
	 * @param stop this parameter is used in the Eden deserialization.
	 */
	public function StyleEvent(type:String, style:IStyle, target, context, bubbles:Boolean, eventPhase:Number, time:Number, stop:Number) 
	{
		super(type, target, context, bubbles, eventPhase, time, stop) ;
		_style = style ;
	}
	
	/**
	 * The type event name of the StyleEvent when the style is changed in the component.
	 */
	static public var STYLE_CHANGED:String = "onStyleChanged" ;

	/**
	 * The type event name of the StyleEvent when the styleSheet in the IStyle is changed.
	 */
	static public var STYLE_SHEET_CHANGED:String = "onStyleSheetChanged" ;
	
	/**
	 * Returns a shallow copy of the object.
	 * @return a shallow copy of the object.
	 */
	public function clone() 
	{
		return new StyleEvent(getType(), getStyle()) ;
	}
	
	/**
	 * Returns the IStyle reference of this event.
	 * @return the IStyle reference of this event.
	 */
	public function getStyle():IStyle 
	{
		return _style ;
	}
	
	/**
	 * Sets the IStyle reference of this event.
	 */
	public function setStyle( style:IStyle ):Void 
	{
		_style = style ;
	}
	
	public function toString():String 
	{
		var phase:Number = getEventPhase() ;
		var name:String = ConstructorUtil.getName(this);
		var txt:String = "[" + name ;
		if (getType()) 
		{
			txt += " " + getType() ;
		}
		if (getStyle() != null)
		{
			txt += ", " + getStyle() ;			
		}
		switch (phase) 
		{
			case EventPhase.CAPTURING_PHASE :
			{
				txt += ", CAPTURING" ;
				break;
			}
			case EventPhase.AT_TARGET:
			{
				txt += ", AT TARGET" ;
				break ;
			}
			case EventPhase.BUBBLING_PHASE:
			{
				txt += ", BUBBLING" ;
				break ;
			}
			default :
			{
				txt += ", (inactive)" ;
				break;
			}
		}
		if (getBubbles() && phase != EventPhase.BUBBLING_PHASE) 
		{
			txt += ", bubbles" ;
		}
		if (isCancelled()) 
		{
			txt += ", can cancel" ;
		}
		txt += "]" ;
		return txt ;

	}
	
	private var _style:IStyle ;
	
}