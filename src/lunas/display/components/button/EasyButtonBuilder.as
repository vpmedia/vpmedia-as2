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

/** EasyButtonBuilder

	AUTHOR
		
		Name : EasyButtonBuilder
		Package : lunas.display.components.button
		Version : 1.0.0.0
		Date :  2006-02-07
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : vegas@ekameleon.net

	CONSTRUCTOR
	
		private

	PROPERTY SUMMARY
	
		- target:MovieClip

	METHOD SUMMARY
	
		- clear():Void
		
		- run():Void
		
		- toString():String
		
		- update():Void

	INHERIT
	
		Object
			|
			CoreObject
				|
				AbstractBuilder
					|
					EasyButtonBuilder

**/

import lunas.display.components.AbstractBuilder;
import lunas.display.components.button.EasyButtonStyle;

import pegas.draw.RectanglePen;
import pegas.events.ButtonEventType;

import vegas.events.Delegate;

class lunas.display.components.button.EasyButtonBuilder extends AbstractBuilder {
	
	// ----o Constructor

	private function EasyButtonBuilder( mc:MovieClip ) {
		super(mc) ;
		target.addEventListener(ButtonEventType.DISABLED, new Delegate(this, disabled)) ;
		target.addEventListener(ButtonEventType.DOWN, new Delegate(this, down)) ;
		target.addEventListener(ButtonEventType.OVER, new Delegate(this, over)) ;
		target.addEventListener(ButtonEventType.UP, new Delegate(this, up)) ;
	}

	// ----o Public Properties
	
	public var background:MovieClip ;
	public var field:TextField  ;
	
	// ----o Public Methods

	public function clear():Void {
		if(background) background.removeMovieClip() ;
		if(field) field.removeMovieClip() ;
	}

	public function disabled(): Void {
		var s:EasyButtonStyle = target.getStyle() ;
		_drawBackground( s.themeDisabledColor ) ;
		field.textColor = s.textDisabledColor ;
	}	

	public function down(): Void {
		var s:EasyButtonStyle = target.getStyle() ;
		_drawBackground( s.themeSelectedColor ) ;
		field.textColor = s.textSelectedColor ;
	}
		
	public function over():Void {
		var s:EasyButtonStyle = target.getStyle() ;
		_drawBackground( s.themeRollOverColor ) ;
		field.textColor = s.textRollOverColor ;
	}
	
	public function run():Void {
		_createBackground() ;
		_createField() ;
	}
	
	public function up():Void {
		var s:EasyButtonStyle = target.getStyle() ;
		_drawBackground( s.themeColor) ;
		field.textColor = s.color ;
	}
	
	public function update():Void {
		_refreshBackground() ;	
		_refreshField() ;
	}

	// ----o Private Properties
	
	private var _penBackground:RectanglePen ;

	// ----o Private Methods

	public function _createBackground():Void {
		background = target.createEmptyMovieClip("background", 1) ;
		_penBackground = new RectanglePen(background) ;
	}
	
	public function _createField():Void {
		target.createTextField ("field", 2, 0 , 0, target.w , target.h ) ;
		field = target.field ;
	}
	
	private function _drawBackground( color:Number ):Void {
		var s:EasyButtonStyle = target.getStyle() ;
		_penBackground.clear() ;
		_penBackground.beginFill( color , s.themeAlpha) ;
		_penBackground.lineStyle( s.thickness, s.themeBorderColor, s.themeBorderAlpha ) ;
		_penBackground.draw(target.getW(), target.getH()) ;	
	}

	private function _getFieldPos():Number {
		return target.getStyle().paddingLeft ;
	}

	private function _getFieldWidth():Number {
		var s:EasyButtonStyle = target.getStyle() ;
		return  (target.getW() - s.paddingLeft - s.paddingRight) ;
	}

	private function _getFieldColor():Number {
		var s:EasyButtonStyle = target.getStyle() ;
		if (!target.enabled) return s.textDisabledColor ;
		else if (target.selected) return s.textSelectedColor ;
		else return s.color ;
	}
	
	private function _getBackgroundColor():Number {
		var s:EasyButtonStyle = target.getStyle() ;
		if (!target.enabled) return s.themeDisabledColor ;
		else if (target.selected) return s.themeSelectedColor ;
		else return s.themeColor ;
	}
	

	private function _getFieldText():String {
		var s:EasyButtonStyle = target.getStyle() ;
		var label:String = target.getLabel() ;
		var txt:String = "" ;
		if (label.length > 0) txt = "<span class='" + EasyButtonStyle.LABEL_STYLE_NAME + "'>" + label + "</span>" ;
		return txt ;
	}

	public function _refreshBackground():Void {
		var s:EasyButtonStyle = target.getStyle() ;
		_drawBackground( s.themeColor ) ;
	}

	public function _refreshField():Void {
		var s:EasyButtonStyle = target.getStyle() ;
		field._x = _getFieldPos ();
		field._y = 1 ;
		field.antiAliasType = "advanced" ;
		field._width = _getFieldWidth () ;
		field._height = target.getH() ;
		field.selectable = s.selectable ;
		field.embedFonts = s.embedFonts ;
		field.styleSheet = s.getStyleSheet() ;
		field.html = true ;
		if (field.html) {
			field.htmlText = _getFieldText() ;
		} else {
			field.text = _getFieldText() ;
		}
		field.textColor = _getFieldColor() ;
	}

}