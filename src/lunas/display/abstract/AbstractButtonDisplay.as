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

import lunas.core.IButton;
import lunas.display.abstract.AbstractComponentDisplay;
import lunas.group.RadioButtonGroup;

import pegas.events.ButtonEvent;
import pegas.ui.DoubleClick;

import vegas.events.Delegate;
import vegas.events.EventListener;

/**
 * This class provides a skeletal implementation of the {@code IButton} interface, to minimize the effort required to implement this interface.
 * @author eKameleon
 */
class lunas.display.abstract.AbstractButtonDisplay extends AbstractComponentDisplay implements IButton 
{

	/**
	 * Creates a new AbstractButtonDisplay instance.
	 * @param sName:String the name of the display.
	 * @param target:MovieClip the DisplayObject instance control this target.
	 */	
	private function AbstractButtonDisplay( sName:String, target:MovieClip ) 
	{
		
		super ( sName, target ) ;
		
		initButtonEvent() ;
		registerView( view ) ;
		
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
	 * Specifies whether the object receives doubleClick events.
	 */
	public function get doubleClickEnabled():Boolean
	{
		return _doubleClickEnabled ;
	}
	
	/**
	 * Specifies whether the object receives doubleClick events.
	 */
	public function set doubleClickEnabled( b:Boolean ):Void
	{
		_doubleClickEnabled = b ;
		if (b)
		{
			DoubleClick.initialize() ;	
		}
	} 

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
	 * Returns the data value object to render or edit.
	 * @return the data value object to render or edit.
	 */
	public function getData()
	{
		return data ;	
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

		if ( hasEventListener(ButtonEvent.DOWN) )
		{
			removeEventListener(ButtonEvent.DOWN, RadioButtonGroup.getInstance()) ;	
		}
		
		if ( group == true ) 
		{
			addEventListener(ButtonEvent.DOWN, RadioButtonGroup.getInstance() ) ;
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
	 * Register the view in argument..
	 */
	public function registerView( scope:MovieClip ):Void
	{
		unregisterView() ;
		_scope = (scope == null) ? view : scope ;
		if(scope != null)
		{
			_scope.onRollOut        = Delegate.create(this, _onRollOut) ; 
			_scope.onRollOver       = Delegate.create(this, _onRollOver) ;
			_scope.onPress          = Delegate.create(this, _onPress) ;
			_scope.onRelease        = Delegate.create(this, _onRelease) ;
			_scope.onReleaseOutside = Delegate.create(this, _onRelease) ;
		}
	}

	/**
	 * Sets the data value object to render or edit.
	 */
	public function setData( value ):Void 
	{
		data = value ;	
	}

	/**
	 * Sets the text label for a button instance.
	 */
	public function setLabel(str:String):Void 
	{
		_label = str ; 
		viewLabelChanged() ;
		_fireButtonEvent(ButtonEvent.LABEL_CHANGE) ;
	}

	/**
	 * Sets a boolean value indicating whether the button is selected (true) or not (false). 
	 * The default value is false.
	 */
	public function setSelected (b:Boolean, noEvent:Boolean):Void 
	{
		_selected =  (_toggle)  ? b : null ;
		_fireButtonEvent (_selected ? ButtonEvent.DOWN : ButtonEvent.UP ) ;
		if (!noEvent) 
		{
			_fireButtonEvent (_selected ? ButtonEvent.SELECT : ButtonEvent.UNSELECT) ;
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
	 * Unregister the view of this button.
	 */
	public function unregisterView( scope:MovieClip ):Void
	{
		if (_scope != null) 
		{
			delete _scope.onRollOut ; 
			delete _scope.onRollOver       ;
			delete _scope.onPress          ;
			delete _scope.onRelease        ;
			delete _scope.onReleaseOutside ;
		}
		_scope = null ;
	}

	/**
	 * Invoqued when the enabled property of the component change.
	 */
	/*final*/ public function viewEnabled():Void 
	{
		var type:String ;
		if (enabled) 
		{
			type = (toggle && selected) ? ButtonEvent.DOWN : ButtonEvent.UP ;
		}
		else 
		{
			type = ButtonEvent.DISABLED ;
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

	private var _doubleClickEnabled:Boolean ;

	private var _eButton:ButtonEvent ;

	private var _label:String ;
	
	private var _listenerRadio:EventListener ;
	
	private var _scope:MovieClip ;	
	
	private var _toggle:Boolean = false ;

	private var _selected:Boolean = false ;
	
	private function _fireButtonEvent( eventType:String ):Void 
	{
		_eButton.setType( eventType ) ;
		_eButton.setTarget( this ) ;
		dispatchEvent( _eButton ) ;
	}

	private function _onPress():Void 
	{
		
		if (_toggle) 
		{
			setSelected (!_selected);
		}
		else 
		{
			_fireButtonEvent(ButtonEvent.DOWN) ;
		}
		
		_fireButtonEvent( (_doubleClickEnabled && DoubleClick.ISDOUBLE) ? ButtonEvent.DOUBLE_CLICK : ButtonEvent.CLICK  ) ;
		
		_fireButtonEvent(ButtonEvent.MOUSE_DOWN) ;
		
	}

	private function _onRelease():Void 
	{ 
		if ( !_toggle ) 
		{
			_fireButtonEvent(ButtonEvent.UP) ;
		}
		_fireButtonEvent(ButtonEvent.MOUSE_UP) ;
	}
	
	private function _onRollOut():Void 
	{
		if ( !_toggle || !_selected ) 
		{
			_fireButtonEvent(ButtonEvent.UP) ;
			_fireButtonEvent(ButtonEvent.OUT) ;
		}
		else if (_selected)
		{
			_fireButtonEvent(ButtonEvent.OUT_SELECTED) ;
		}
		_fireButtonEvent(ButtonEvent.ROLLOUT) ;
	}

	private function _onRollOver():Void 
	{
		if ( !_toggle || !_selected ) 
		{
			_fireButtonEvent(ButtonEvent.OVER) ;
		}
		else if (_selected) 
		{
			_fireButtonEvent(ButtonEvent.OVER_SELECTED) ;
		}
		_fireButtonEvent(ButtonEvent.ROLLOVER) ;
	}	
	
}
