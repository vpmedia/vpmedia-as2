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

/* ---------- LightColor

	AUTHOR
	
		Name : LightColor
		Package : neo.colors
		Version : 1.0.0.0
		Date :  2006-02-07
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net


	PROPERTY SUMMARY

		- brightness
  			Luminosité, même effet que l'inspecteur de propriété 
			Pourcentage entre -100 and 100
			
		- brightOffset
			Luminosité, même effet que l'inspecteur de propriété 
			Offset entre -255 and 255
  		
		- contrast
			Ajuste le contraste 
			Pourcentage entre -100 and 100
  		
		- negative
			Transforme une image en son négatif
			Pourcentage entre -100 and 100
		
	PUBLIC METHODS

		- getBrightness()
		
		- getBrightOffset()
		
		- getContrast()
		
		- getNegative()
		
		- getTarget() 
		
			renvoi l'instance de l'objet controlé par la couleur courante
		
		- invert() 
		
			inverse la couleur de l'objet
		
		- reset()
		
			réinitialise la couleur d'origine de l'objet.
		
		- setBrightness(percent)
		
		- setBrightOffset(offset)
		
		- setContrast(percent)
		
		- setNegative(percent)


	INHERIT 
	
		Color > BasicColor > LightColor
		
	
	THANKS
	
		© 2003 Robert Penner - Use freely, giving credit where possible.
		code basée sur le livre : Robert Penner's Programming Macromedia Flash MX
		http://www.robertpenner.com/profmx
		http://www.amazon.com/exec/obidos/ASIN/0072223561/robertpennerc-20

------------- */

import neo.colors.BasicColor;
import neo.util.factory.PropertyFactory;


class neo.colors.LightColor extends BasicColor {

	// ----o Constructor

	public function LightColor (mc:MovieClip) { 

		super (mc) ;

	}

	

	// ----o Public Properties

	

	public var brightness:Number ; // [R/W]

	public var brightOffset:Number ; // [R/W]

	public var contrast:Number ; // [R/W]

	public var negative:Number ; // [R/W]

	
	// ----o Public Methods

	public function getBrightness():Number {
		var t:Object = getTransform();
		return t.rb ? 100-t.ra : t.ra-100;
	}

	public function setBrightness(percent:Number):Void {
		var t:Object = getTransform() ;
		t.ra = t.ga = t.ba = 100 - Math.abs (percent) ;
		t.rb = t.gb = t.bb = (percent > 0) ? (percent*2.56) : 0 ;
		setTransform (t);
	}

	public function getContrast():Number { 

		return getTransform().ra ; 

	}

	public function setContrast(percent:Number):Void {
		var t:Object = {};
		t.ra = t.ga = t.ba = percent;
		t.rb = t.gb = t.bb = 128 - (128/100 * percent);
		setTransform(t);
	}

	public function getBrightOffset():Number { 

		return getTransform().rb ; 

	}

	public function setBrightOffset(offset:Number):Void {
		var t:Object = getTransform();
		t.rb = t.gb = t.bb = offset ;
		setTransform (t);
	}

	public function getNegative():Number { 

		return getTransform().rb * 2.55 ; 

	}

	public function setNegative(percent:Number):Void {
		var t:Object = {} ;
		t.ra = t.ga = t.ba = 100 - 2 * percent;
		t.rb = t.gb = t.bb = percent * (2.55) ;
		setTransform (t);
	}

	

	// ----o Virtual Properties



	static private var __BRIGHTNESS__:Boolean = PropertyFactory.create(LightColor, "brightness", true) ;

	static private var __BRIGHTOFFSET__:Boolean = PropertyFactory.create(LightColor, "brightOffset", true) ;

	static private var __CONTRAST__:Boolean = PropertyFactory.create(LightColor, "contrast", true) ;

	static private var __NEGATIVE__:Boolean = PropertyFactory.create(LightColor, "negative", true) ;



}

