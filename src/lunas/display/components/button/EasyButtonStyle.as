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

/** EasyButtonStyle

	AUTHOR
	
		Name : EasyButtonStyle
		Package : lunas.display.components.button
		Version : 1.0.0.0
		Date :  2006-02-04
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : vegas@ekameleon.net

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
			
**/

import lunas.display.components.AbstractStyle;

class lunas.display.components.button.EasyButtonStyle extends AbstractStyle {

	// ----o Constructor 
	
	public function EasyButtonStyle( init:Object ) {
		super(init) ;
	}

	// ----o Constant
	
	static public var LABEL_STYLE_NAME:String = "EasyButtonLabel" ;

	// ----o Public Properties
	
	var thickness:Number = null ;
	var themeBorderColor:Number = null ;
	var themeBorderAlpha:Number = null ;
	
	var themeAlpha:Number = 100 ;	
	var themeColor:Number = 0xFFFFFF ;
	var themeRollOverColor:Number = 0x1D8D2B ;
	var themeSelectedColor:Number = 0x000000 ;
	var themeDisabledColor:Number = 0xCCCCCC ;
	
	var color:Number = 0x000000 ;
	var textRollOverColor:Number = 0xFFFFFF ;
	var textSelectedColor:Number = 0xFFFFFF ;
	var textDisabledColor:Number = 0x000000 ;
	
	var selectable:Boolean = false ;	
	var embedFonts:Boolean = false ;

	var paddingRight:Number = 4 ;
	var paddingLeft:Number = 4 ;
	
	// ----o Public Methods
	
	public function initialize():Void {
		var oS:Object = {
			fontFamily:'verdana' , 
			fontSize:"11px" ,
			fontWeight:"bold" ,
			textAlign : "center"
		};
		var css:TextField.StyleSheet = new TextField.StyleSheet() ;
		css.setStyle ( "." + LABEL_STYLE_NAME , oS ) ;
		setStyleSheet(css) ;
	}
	
}