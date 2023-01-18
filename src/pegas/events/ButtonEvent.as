/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Vegas Library.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import pegas.events.MouseEvent;

/**
 * The event invoqued in the button or thumbs of the applications.
 * @author eKameleon
 */
dynamic class pegas.events.ButtonEvent extends MouseEvent 
{

	/**
	 * Creates a new ButtonEvent instance.
	 * @param type the string type of the instance. 
	 * @param target the target of the event.
	 * @param context the optional context object of the event.
	 * @param bubbles indicates if the event is a bubbling event.
	 * @param eventPhase the current EventPhase of the event.
	 * @param time this parameter is used in the Eden deserialization.
	 * @param stop this parameter is used in the Eden deserialization.
	 */
	public function ButtonEvent
	(
		type:String, target, context, bubbles:Boolean, eventPhase:Number, time:Number, stop:Number
		, p_localX:Number, p_localY:Number, p_relatedObject:Number, p_ctrlKey:Boolean, p_altKey:Boolean
		, p_shiftKey:Boolean, p_buttonDown:Boolean, p_delta:Number
	) 
	{
			
		super(
			type, target, context, bubbles, eventPhase, time, stop
			, p_localX, p_localY, p_relatedObject, p_ctrlKey, p_altKey, p_shiftKey, p_buttonDown, p_delta
		) ;
	
	}

	/**
	 * Defines the value of the type property of a click event object.
	 */
	static public var CLICK:String = "click" ;
	
	/**
	 * Defines the value of the type property of a disabled button.
	 */
	static public var DISABLED:String = "disabled" ;
	
	/**
	 * Defines the value of the type property of a doubleClick event object.
	 */
	static public var DOUBLE_CLICK:String = "doubleClick" ;
	
	/**
	 * Defines the value of the type property of a down event object.
	 */
	static public var DOWN:String = "down" ;

	/**
	 * Defines the value of the type property of a drag event object.
	 */
	static public var DRAG:String = "drag" ;
	
	/**
	 * Defines the value of the type property of an icon change event object.
	 */
	static public var ICON_CHANGE:String = "onIconChanged" ;
	
	/**
	 * Defines the value of the type property of a label change event object.
	 */
	static public var LABEL_CHANGE:String = "onLabelChanged" ;
	
	/**
	 * Defines the value of the type property of a mouseDown event object.
	 */
	static public var MOUSE_DOWN:String = "mouseDown" ;
	
	/**
	 * Defines the value of the type property of a mouseMove event object.
	 */
	static public var MOUSE_MOVE:String = "mouseMove" ;
	
	/**
	 * Defines the value of the type property of a mouseOut event object.
	 */
	static public var MOUSE_OUT:String = "mouseOut" ;
	
	/**
	 * Defines the value of the type property of a mouseOver event object.
	 */
	static public var MOUSE_OVER:String = "mouseOver" ;
	
	/**
	 * Defines the value of the type property of a mouseUp event object.
	 */
	static public var MOUSE_UP:String = "mouseUp" ;
	
	/**
	 * Defines the value of the type property of an out event object.
	 */
	static public var OUT:String = "out" ;
	
	/**
	 * Defines the value of the type property of an out selected event object.
	 */
	static public var OUT_SELECTED:String = "outSelected" ;
	
	/**
	 * Defines the value of the type property of an over event object.
	 */
	static public var OVER:String = "over" ;
	
	/**
	 * Defines the value of the type property of a over selected event object.
	 */
	static public var OVER_SELECTED:String = "overSelected" ;

	/**
	 * Defines the value of the type property of a rollOut event object.
	 */	
	static public var ROLLOUT:String = "rollOut";

	/**
	 * Defines the value of the type property of a rollOver event object.
	 */
	static public var ROLLOVER:String = "rollOver" ;

	/**
	 * Defines the value of the type property of a select event object.
	 */
	static public var SELECT:String = "select" ;
	
	/**
	 * Defines the value of the type property of a start drag event object.
	 */
	static public var START_DRAG:String = "startDrag" ;

	/**
	 * Defines the value of the type property of a stop drag event object.
	 */
	static public var STOP_DRAG:String = "stopDrag" ;
	
	/**
	 * Defines the value of the type property of an unselect event object.
	 */
	static public var UNSELECT:String = "unselect" ;
	
	/**
	 * Defines the value of the type property of an 'up' event object.
	 */
	static public var UP:String = "up" ;

	/**
	 * Returns a shallow copy of this objet.
	 * @return a shallow copy of this objet.
	 */
	public function clone() 
	{
		var prop:String ;
		var props:Array = ["localX", "localY", "relatedObject", "ctrlKey", "altKey", "shiftKey", "buttonDown", "delta"] ;
		var be:ButtonEvent = new ButtonEvent(_type, _target) ;
		var l:Number = props.length ;
		while(--l > -1) 
		{
			prop = props[l] ;
			be[prop] = this[prop] ;
		}
		return be ;
	}
	
}
