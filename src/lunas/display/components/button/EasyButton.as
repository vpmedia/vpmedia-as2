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

/** EasyButton

	AUTHOR

		Name : EasyButton
		Package : lunas.display.components.button
		Version : 1.0.0.0
		Date :  2006-02-07
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : vegas@ekameleon.net

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
	
		IButton, EventTarget

	INHERIT 
	
		MovieClip → AbstractComponent → AbstractButton → AbstractIconButton → EasyButton

	SEE ALSO
	
		IBuilder, IButton, IStyle
	
	NB : il est possible de définir la largeur et la hauteur par défaut du bouton en passant directement
	par les propriétés privées _h et _w définies dans les Private Properties de la classe.
	
**/

import lunas.display.components.button.AbstractButton;
import lunas.display.components.button.EasyButtonBuilder;
import lunas.display.components.button.EasyButtonStyle;

class lunas.display.components.button.EasyButton extends AbstractButton 
{

	/**
	 * Creates a new EasyButton instance.
	 */
	public function EasyButton () 
	{ 
		super() ;
	}
	
	public var background:MovieClip ;

	public var field:TextField ;

	public function getBuilderRenderer():Function 
	{
		return EasyButtonBuilder ;
	}
	
	public function getStyleRenderer():Function 
	{
		return EasyButtonStyle ;
	}
	
	public function viewLabelChanged():Void 
	{
		update() ;
	}

	private var _h:Number = 20 ;
	private var _w:Number = 150 ;

}
