/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Neo Library.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <contact@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2005
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

/* -------- AbstractButton

	AUTHOR

		Name : AbstractButton
		Package : neo.display.components.button
		Version : 1.0.0.0
		Date :  2006-02-07
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	PROPERTY SUMMARY

		- index:Number
		
		- data:Object
		
		- label:String [R/W]
		
		- selected:Boolean [R/W]
		
		- toggle:Boolean [R/W]
			
	METHOD SUMMARY
		
		- getLabel():String
		
		- getSelected():Boolean
		
		- getToggle():Boolean
		
		- setLabel(str:String):Void
		
		- setSelected(b:Boolean, noEvent:Boolean):Void
		
		- setToggle(b:Boolean):Void
		
		- final viewEnabled():Void
		
		- viewLabelChanged():Void
		
			override this method !

	EVENT SUMMARY

		ButtonEvent

		- CLICK:MouseEventType

		- UP:ButtonEventType

		- DISABLED:ButtonEventType

		- DOUBLE_CLICK:MouseEventType

		- DOWN:ButtonEventType

		- ICON_CHANGE:ButtonEventType

		- LABEL_CHANGE:ButtonEventType

		- MOUSE_UP:MouseEventType

		- MOUSE_DOWN:MouseEventType

		- OUT:ButtonEventType

		- OUT_SELECTED:ButtonEventType

		- OVER:ButtonEventType

		- OVER_SELECTED:ButtonEventType

		- ROLLOUT:MouseEventType

		- ROLLOVER:MouseEventType

		- SELECT:ButtonEventType

		- UNSELECT:ButtonEventType

		- UP:ButtonEventType

	IMPLEMENTS 
	
		IButton, IEventTarget

	INHERIT 
	
		MovieClip
			|
			AbstractComponent
				|
				AbstractButton

	SEE ALSO
	
		IBuilder, IStyle
	

----------------*/

import com.bourre.events.EventType;
import com.bourre.medias.sound.SoundFactoryManager;

import neo.display.components.AbstractComponent;
import neo.display.components.IButton;
import neo.display.group.RadioButtonGroup;
import neo.events.ButtonEvent;
import neo.events.ButtonEventType;
import neo.util.factory.PropertyFactory;

class neo.display.components.button.AbstractButton extends AbstractComponent implements IButton {

	// ----o Constructor

	private function AbstractButton () { 
		_rg = RadioButtonGroup.getInstance()  ;
		_eMouseDown = new ButtonEvent(ButtonEventType.MOUSE_DOWN) ;
		_eMouseUp = new ButtonEvent(ButtonEventType.MOUSE_UP) ;
	}

	// ----o Public Properties
	

	public var label:String ; // [R/W]

	public var data ;

	public var index:Number ;

	public var selected:Boolean ; // [R/W]

	public var toggle:Boolean ; // [R/W]

	
	// ----o Public Methods
	
	public function getLabel():String {
		return _label || "" ;

	}
		
	public function getSelected():Boolean {
		return _selected ;
	}
	
	public function getToggle():Boolean {
		return _toggle ;
	}
	
	public function groupPolicyChanged():Void {
		_rg.setGroupName( _groupName, this ) ;
		if (group) {
			addEventListener(ButtonEventType.DOWN, _rg, _rg.update) ;
		} else {
			removeEventListener(ButtonEventType.DOWN, _rg, _rg.update) ;
		}
	}

	public function setLabel(str:String):Void {
		_label = str ; 
		viewLabelChanged() ;
		broadcastEvent(new ButtonEvent( ButtonEventType.LABEL_CHANGE )) ;
	}

	public function setSelected (b:Boolean, noEvent:Boolean):Void {
		_selected =  (_toggle)  ? b : null ;
		broadcastEvent(new ButtonEvent( _selected ? ButtonEventType.DOWN : ButtonEventType.UP )) ;
		if (!noEvent) broadcastEvent(new ButtonEvent( _selected ? ButtonEventType.SELECT : ButtonEventType.UNSELECT )) ;
	}
	
	public function setToggle(b:Boolean):Void {
		_toggle = b ;	
		setSelected (false, true) ;
	}

	/*
	public function viewChanged():Void {

		// Permet de mettre à jour l'affichage une fois que le composant est réinitialisé

	}

	public function viewDestroyed():Void {

		// changer le composant quand le style change

	}	

	*/

	/*final*/ public function viewEnabled():Void {
		var type:EventType ;
		if (enabled) {
			type = (toggle && selected) ? ButtonEventType.DOWN : ButtonEventType.UP ;
		} else {
			type = ButtonEventType.DISABLED ;
		}
		broadcastEvent (new ButtonEvent(type)) ;
	}

	public function viewLabelChanged():Void {

		// override this method when label property change

	}

	/*

	public function viewStyleChanged():Void {
		// changer le composant quand le style change.
	}

	public function viewStyleSheetChanged():Void {
		// changer le composant quand sa feuille de style change.
	}

	*/
	
	// ----o Virtual Properties
	
	static private var __LABEL__:Boolean = PropertyFactory.create(AbstractButton, "label", true) ;
	static private var __SELECTED__:Boolean = PropertyFactory.create(AbstractButton, "selected", true) ;
	static private var __TOGGLE__:Boolean = PropertyFactory.create(AbstractButton, "toggle", true) ;
	
	// ----o Private Properties
	
	private var _eMouseUp : ButtonEvent;
	private var _eMouseDown:ButtonEvent ;
	
	private var _label:String ;
	private var _toggle:Boolean ;
	private var _rg:RadioButtonGroup ;
	private var _selected:Boolean ;
	
	// ----o Private Methods

	private function onPress():Void {
		if (_toggle) {
			setSelected (!_selected);
		} else {
			broadcastEvent(new ButtonEvent(ButtonEventType.DOWN)) ;
		}
		broadcastEvent ( new ButtonEvent(ButtonEventType.CLICK, this) ) ;
		broadcastEvent(_eMouseDown) ;
		
		// sound
		SoundFactoryManager.getInstance().getSound("bip").start();
	}

	private function onRelease():Void { 
		if ( !_toggle ) broadcastEvent(new ButtonEvent(ButtonEventType.UP)) ;
		broadcastEvent(_eMouseUp) ;
	}

	private var onReleaseOutside:Function = onRelease ;

	private function onRollOut():Void {

		if ( !_toggle || !_selected ) {

			broadcastEvent(new ButtonEvent(ButtonEventType.UP)) ;
			broadcastEvent(new ButtonEvent(ButtonEventType.OUT)) ;

		} else if (_selected) {
			
			broadcastEvent(new ButtonEvent(ButtonEventType.OUT_SELECTED));
			
		}

		broadcastEvent(new ButtonEvent(ButtonEventType.ROLLOUT)) ;

	}

	private function onRollOver():Void {

		if ( !_toggle || !_selected ) broadcastEvent(new ButtonEvent(ButtonEventType.OVER)) ;

		else if (_selected) broadcastEvent(new ButtonEvent(ButtonEventType.OVER_SELECTED)) ;

		broadcastEvent(new ButtonEvent(ButtonEventType.ROLLOVER)) ;
		
		// sound
		SoundFactoryManager.getInstance().getSound("roll").start();

	}	

	
}

