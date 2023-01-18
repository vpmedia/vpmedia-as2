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

/* -------- EasyButton

	AUTHOR

		Name : EasyButton
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
					|
					AbstractIconButton
						|
						EasyButton

	SEE ALSO
	
		IBuilder, IStyle
	
	NB : il est possible de définir la largeur et la hauteur par défaut du bouton en passant directement
	par les propriétés privées _h et _w définies dans les Private Properties de la classe.
	
----------------*/

import neo.display.components.button.AbstractButton;
import neo.display.components.button.EasyButtonBuilder;
import neo.display.components.button.EasyButtonStyle;
import neo.display.components.shape.RectangleComponent;
import neo.events.ButtonEventType;

class neo.display.components.button.EasyButton extends AbstractButton {

	// ----o Constructor

	public function EasyButton () { 
		addEventListener(ButtonEventType.DISABLED, this) ;
		addEventListener(ButtonEventType.DOWN, this) ;
		addEventListener(ButtonEventType.OUT, this) ;
		addEventListener(ButtonEventType.OVER, this) ;
		addEventListener(ButtonEventType.UP, this) ;
	}

	// ----o Constant
	
	static public var BACKGROUND_RENDERER:Function = RectangleComponent ;
	
	// ----o Public Properties
	
	public var background:MovieClip ;
	public var field:TextField ;

	// ----o Public Methods
	
	public function getBuilderRenderer():Function {
		return EasyButtonBuilder ;
	}
	
	public function getStyleRenderer():Function {
		return EasyButtonStyle ;
	}
	
	public function viewLabelChanged():Void {
		update() ;
	}

	// ----o Private Methods
	
	public function up():Void {
		background.refresh ( { fc : _style.themeColor  } ) ;
		field.textColor = _style.color ;
	}
	
	public function down(): Void {
		background.refresh ( { fc : _style.themeSelectedColor } ) ;
		field.textColor = _style.textSelectedColor ;
	}
		
	public function over():Void {
		background.refresh ( { fc : _style.themeRollOverColor } ) ;
		field.textColor = _style.textRollOverColor ;
	}
	
	public function disabled(): Void {
		background.refresh ( { fc:_style.themeDisabledColor } ) ;
		field.textColor = _style.textDisabledColor ;
	}	
	
	// ----o Private properties
	
	private var _builder:EasyButtonBuilder ;
	private var _style:EasyButtonStyle ;
		
	private var _h:Number = 20 ;
	private var _w:Number = 150 ;

}
