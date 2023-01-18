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

/* ---------- EasyButtonBuilder

	AUTHOR
		
		Name : EasyButtonBuilder
		Package : neo.display.components.button
		Version : 1.0.0.0
		Date :  2006-02-07
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	CONSTRUCTOR
	
		private

	PROPERTY SUMMARY
	
		- target:MovieClip

	METHOD SUMMARY
	
		- clear():Void
		
		- execute(e:IEvent):Void
		
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

-------------- */

import neo.display.components.AbstractBuilder;
import neo.display.components.button.EasyButton;
import neo.display.components.button.EasyButtonStyle;

class neo.display.components.button.EasyButtonBuilder extends AbstractBuilder {
	
	// ----o Constructor

	private function EasyButtonBuilder( mc:MovieClip ) {

		target = mc ;
	}

	// ----o Public Properties
	
	public var background:MovieClip ;
	public var field:TextField ;
	
	// ----o Public Methods

	public function clear():Void {
		if(background) background.removeMovieClip() ;
		if(field) field.removeMovieClip() ;
	}

	public function createBackground():Void {
		if (target.background == undefined) {
			background = target.createChild(EasyButton.BACKGROUND_RENDERER, "background", 1) ;

		}
	}
	
	public function createField():Void {
		target.createTextField ("field", 2, 0 , 0, target.w , target.h ) ;
		field = target.field ;

	}
	
	public function execute():Void {
		createBackground() ;

		createField() ;
	}

	public function refreshBackground():Void {
		var st:EasyButtonStyle = target.getStyle() ;
		background.setSize(target.w, target.h) ;
		background.refresh ( {
			fc : _getBackgroundColor() , 
			fa : st.themeAlpha ,
			ep : st.thickness,
			lc : st.themeBorderColor, 
			la : st.themeBorderAlpha
		}) ;
	}

	public function refreshField():Void {
		var st:EasyButtonStyle = target.getStyle() ;
		field._x = _getFieldPos ();

		field._y = 1 ;

		field.antiAliasType = "advanced" ;
		field._width = _getFieldWidth () ;

		field._height = target.h ;
		field.selectable = st.selectable ;
		field.embedFonts = st.embedFonts ;

		field.styleSheet = st.getStyleSheet() ;

		field.autoSize = st.autoSize ;

		field.html = true ;
		field.htmlText = _getFieldText() || "" ;

		field.textColor = _getFieldColor() ;
	}

	public function update():Void {
		refreshBackground() ;	
		refreshField() ;
	}

	// ----o Private Methods

	private function _getFieldPos():Number {
		return target.getStyle().paddingLeft ;
	}

	private function _getFieldWidth():Number {
		var s:EasyButtonStyle = target.getStyle() ;
		return (target.w - s.paddingLeft - s.paddingRight) ;
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
		var label:String = target.label ;
		var txt:String = "" ;

		if (label.length > 0) txt = "<span class='" + EasyButtonStyle.LABEL_STYLE_NAME + "'>" + label + "</span>" ;

		return txt ;
	}

}