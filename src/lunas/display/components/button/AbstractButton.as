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

import lunas.display.components.AbstractComponent;
import lunas.display.components.IButton;
import lunas.display.group.RadioButtonGroup;

import pegas.events.ButtonEvent;
import pegas.events.ButtonEventType;

import vegas.events.EventListener;

/**
 * This class provides a skeletal implementation of the {@code IButton interface, to minimize the effort required to implement this interface.
 * @author eKameleon
 */
class lunas.display.components.button.AbstractButton extends AbstractComponent implements IButton 
{

	/**
	 * Creates a new AbstractButton instance. Overrides this constructor.
	 */	
	private function AbstractButton () 
	{
		initButtonEvent() ; 
		_rg = RadioButtonGroup.getInstance()  ;
	}

	/**
	 * A data property used to keep an object in memory.
	 */
	public var data ;

	/**
	 * A number value to indicated the index of this IButton.
	 */
	public var index:Number ;

	/**
	 * Returns the text label for a button instance.
	 * @return the text label for a button instance.
	 */
	public function get label():String 
	{
		return getLabel() ;
	}

	/**
	 * Sets the text label for a button instance.
	 */
	public function set label(s:String):Void 
	{
		setLabel(s) ;	
	}
	
	/**
	 * Returns a Boolean value indicating whether the button is selected (true) or not (false). The default value is false.
	 * @return a Boolean value indicating whether the button is selected (true) or not (false)
	 */
	public function get selected():Boolean 
	{
		return getSelected() ;	
	}

	/**
	 * Sets a Boolean value indicating whether the button is selected (true) or not (false). The default value is false.
	 */
	public function set selected(b:Boolean):Void 
	{
		setSelected(b);	
	}	
	
	/**
	 * Returns a boolean value indicating whether the button behaves as a toggle switch (true) or not (false). 
	 * @return a boolean value indicating whether the button behaves as a toggle switch (true) or not (false).
	 */
	public function get toggle():Boolean 
	{
		return getToggle() ;	
	}

	/**
	 * Sets a boolean value indicating whether the button behaves as a toggle switch (true) or not (false). 
	 * The default value is false.
	 */
	public function set toggle(b:Boolean):Void 
	{
		setToggle(b);	
	}	
	
	/**
	 * Returns the text label for a button instance.
	 * @return the text label for a button instance.
	 */
	public function getLabel():String 
	{
		return _label || "" ;
	}

	/**
	 * Returns a Boolean value indicating whether the button is selected (true) or not (false). The default value is false.
	 * @return a Boolean value indicating whether the button is selected (true) or not (false)
	 */
	public function getSelected():Boolean 
	{
		return _selected ;
	}

	/**
	 * Returns a boolean value indicating whether the button behaves as a toggle switch (true) or not (false). 
	 * @return a boolean value indicating whether the button behaves as a toggle switch (true) or not (false).
	 */
	public function getToggle():Boolean 
	{
		return _toggle ;
	}
	
	/**
	 * Invoqued when the groupPolicy of the component change.
	 */
	public function groupPolicyChanged():Void 
	{
		_rg.setGroupName( _groupName, this ) ;
		if (group) 
		{
			_rg.addButton( this ) ;
			addEventListener(ButtonEventType.DOWN, _rg) ;
		}
		else 
		{
			_rg.removeButton( this ) ;
			removeEventListener(ButtonEventType.DOWN, _rg) ;
		}
	}
	
	/**
	 * Protected method to initialize the internal ButtonEvent of this instance.
	 */
	public function initButtonEvent():Void 
	{
		_eButton = new ButtonEvent() ;	
	}

	/**
	 * Sets the text label for a button instance.
	 */
	public function setLabel(str:String):Void 
	{
		_label = str ; 
		viewLabelChanged() ;
		_fireButtonEvent(ButtonEventType.LABEL_CHANGE) ;
	}

	/**
	 * Sets a boolean value indicating whether the button is selected (true) or not (false). 
	 * The default value is false.
	 */
	public function setSelected (b:Boolean, noEvent:Boolean):Void 
	{
		_selected =  (_toggle)  ? b : null ;
		_fireButtonEvent (_selected ? ButtonEventType.DOWN : ButtonEventType.UP ) ;
		if (!noEvent) 
		{
			_fireButtonEvent (_selected ? ButtonEventType.SELECT : ButtonEventType.UNSELECT) ;
		}
	}
	
	/**
	 * Sets a boolean value indicating whether the button behaves as a toggle switch (true) or not (false). 
	 * The default value is false.
	 */
	public function setToggle(b:Boolean):Void 
	{
		_toggle = b ;	
		setSelected (false, true) ;
	}

	/**
	 * Invoqued when the enabled property of the component change.
	 */
	/*final*/ public function viewEnabled():Void 
	{
		var type:String ;
		if (enabled) 
		{
			type = (toggle && selected) ? ButtonEventType.DOWN : ButtonEventType.UP ;
		}
		else 
		{
			type = ButtonEventType.DISABLED ;
		}
		_fireButtonEvent( type ) ;
	}

	/**
	 * Invoqued when the label property of the component change.
	 */
	public function viewLabelChanged():Void 
	{
		// override this method when label property change
	}

	private var _eButton:ButtonEvent ;

	private var _label:String ;

	private var _rgListener:EventListener ;

	private var _toggle:Boolean = false ;

	private var _rg:RadioButtonGroup ;

	private var _selected:Boolean = false ;
	
	private function _fireButtonEvent( eventType:String ):Void 
	{
		_eButton.setType(eventType) ;
		_eButton.setTarget(this) ;
		dispatchEvent( _eButton ) ;
	}

	private function onPress():Void 
	{
		if (_toggle) 
		{
			setSelected (!_selected);
		}
		else 
		{
			_fireButtonEvent(ButtonEventType.DOWN) ;
		}
		_fireButtonEvent(ButtonEventType.CLICK) ;
		_fireButtonEvent(ButtonEventType.MOUSE_DOWN) ;
	}

	private function onRelease():Void 
	{ 
		if ( !_toggle ) 
		{
			_fireButtonEvent(ButtonEventType.UP) ;
		}
		_fireButtonEvent(ButtonEventType.MOUSE_UP) ;
	}
	
	private var onReleaseOutside:Function = AbstractButton.prototype.onRelease ;
	
	private function onRollOut():Void 
	{
		if ( !_toggle || !_selected ) 
		{
			_fireButtonEvent(ButtonEventType.UP) ;
			_fireButtonEvent(ButtonEventType.OUT) ;
		}
		else if (_selected)
		{
			_fireButtonEvent(ButtonEventType.OUT_SELECTED) ;
		}
		_fireButtonEvent(ButtonEventType.ROLLOUT) ;
	}

	private function onRollOver():Void 
	{
		if ( !_toggle || !_selected ) 
		{
			_fireButtonEvent(ButtonEventType.OVER) ;
		}
		else if (_selected) 
		{
			_fireButtonEvent(ButtonEventType.OVER_SELECTED) ;
		}
		_fireButtonEvent(ButtonEventType.ROLLOVER) ;
	}	
	
}
