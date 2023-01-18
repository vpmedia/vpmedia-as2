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

/* ------ AbstractStyle

	AUTHOR
	
		Name : AbstractStyle
		Package : neo.display.components
		Version : 1.0.0.0
		Date :  2004-11-22
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	PROPERTY SUMMARY
	
		- styleSheet:TextField.StyleSheet [R/W]
			
			Feuille de style des textes contenus dans le widget ou composant.

	METHOD SUMMARY
	
		- addEventListener(e:EventType, oL, f:Function):Void
		
		- getStyle (prop:String) 
			renvoie la valeur d'une propriété de style si elle existe.
		
		- getStyleSheet () 
			Renvoi la feuille de style du composant
		
		- removeEventListener(e:EventType, oL):Void
		
		- setStyle (props:Object) ou ( prop:String , value ) 
			
			Définir une ou plusieurs propriétés du style
		
		- setStyleSheet (ss)
			
			Permet de définir une feuille de style pour le composant
		
		- update():Void

	
	PROTECTED METHOD SUMMARY
	
		- initialize() 
			
			Méthode interne invoquée à la création de l'instance de style, peut être surchargée en cas de besoin pour initialiser les propriétés par défaut
			de la feuille de style.

		- styleChanged()
			
			Méthode interne pouvant être surchargée si nécessaire dans certaines feuilles de style.

		- styleSheetChanged()
			
			Méthore interne pouvant être surchargée si nécessaire dans certaines feuilles de style.
	
	EVENT SUMMARY
	
		- StyleEvent
		
			- StyleEventType.STYLE_CHANGED
			- StyleEventType.STYLE_SHEET_CHANGED

----------------*/

import com.bourre.events.EventBroadcaster;
import com.bourre.events.EventType;

import neo.core.CoreObject;
import neo.display.components.IStyle;
import neo.display.components.StyleEvent;
import neo.display.components.StyleEventType;
import neo.util.factory.PropertyFactory;
import neo.util.TypeUtil;

class neo.display.components.AbstractStyle extends CoreObject implements IStyle {


	// ----o Constructor 
	
	private function AbstractStyle ( init:Object ) {

		_oEB = new EventBroadcaster() ;

		for (var prop:String in init) {

			this[prop] = init[prop] ;

		}

		initialize() ;
		update() ;
	}
	
	// ----o Public Properties
	
	public var styleSheet:TextField.StyleSheet ; // [R/W]
	
	// ----o Public Methods
	
	public function addEventListener(e:EventType, oL, f:Function):Void {

		_oEB.addEventListener.apply(_oEB, arguments);
	}
		
	public function initialize():Void {
		// override
	} 
		
	public function getStyle(prop:String) { 
		return this[prop] || null ;
	}

	public function getStyleSheet():TextField.StyleSheet { 
		return _oS ;
	}

	public function removeEventListener(e:EventType, oL):Void {
		_oEB.removeEventListener(e, oL);
	}

	public function setStyle():Void {

		if (TypeUtil.typesMatch(arguments[0], String) && arguments.length > 1) {
			this[arguments[0]] = arguments[1] ;

		} else if (arguments[0] instanceof Object) {
			var prop = arguments[0] ;
			for (var i:String in prop) this[i] = prop[i] ;
		}

		var ev:StyleEvent = new StyleEvent(StyleEventType.STYLE_CHANGED, this) ;
		_oEB.broadcastEvent(ev) ;
	}
	
	public function setStyleSheet(ss:TextField.StyleSheet):Void {
		_oS = ss ;

		styleSheetChanged() ;
		_oEB.broadcastEvent(new StyleEvent(StyleEventType.STYLE_SHEET_CHANGED, this)) ;
	}

	public function styleChanged():Void {
		// override

	}

	public function styleSheetChanged():Void {
		// override

	}

	public function update():Void {
		// override with super !
		styleChanged() ;

	}

	// ----o Virtual Properties
	
	static private var __STYLESHEET_:Boolean = PropertyFactory.create(AbstractStyle, "styleSheet", true) ;
	

	// ----o Private Properties



	private var _oEB:EventBroadcaster;

	private var _oS:TextField.StyleSheet ;

	

}