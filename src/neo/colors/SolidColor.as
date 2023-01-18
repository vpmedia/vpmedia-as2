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

/* ---------- SolidColor

	AUTHOR

		Name : SolidColor
		Package : neo.colors
		Version : 1.0.0.0
		Date :  2006-02-07
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	PROPERTY SUMMARY
		
		- red : transforme la composante rouge d'une couleur
		- green : transforme la composante verte d'une couleur
		- blue : transforme la composante bleue d'une couleur
		
		- redPercent : entre 0 et 100
		- greenPercent : entre 0 et 100
		- bluePercent : entre 0 et 100
		
		- redOffset : entre 0 et 255
		- greenOffset : entre 0 et 255
		- blueOffset : entre 0 et 255

	METHOD SUMMARY
		
		- getRGB2() 
			returns an object with r, g, and b properties
		
		- setRGB2(r, g, b)
			Défini la couleur d'un objet en fonction des composantes rouge, vert et bleu
			Paramètre : 
				r : red entre 0 et 255
				g : green entre 0 et 255
				b : blue entre 0 et 255
		
		- getRed() : renvoi la valeur de la composante red d'une couleur
		
		- setRed(amount) : défini la valeur de la composante red d'une couleur

		- getGreen() : renvoi la valeur de la composante green d'une couleur
		
		- setGreen(amount) : défini la valeur de la composante green d'une couleur
		
		- getBlue() : renvoi la valeur de la composante blue d'une couleur
		
		- setBlue(amount) : défini la valeur de la composante blue d'une couleur	
		
		- getRedPercent()
		
		- setRedPercent(percent:Number)
		
		- getGreenPercent()
		
		- setGreenPercent(percent)
		
		- getBluePercent()
		
		- setBluePercent(percent:Number)
		
		- getRedOffset()
		
		- setRedOffset(offset:Number)
		
		- getGreenOffset()
		
		- setGreenOffset(offset:Number)
		
		- getBlueOffset()
		
		- setBlueOffset(offset)
		
		- getTarget() : renvoie l'instance de l'objet controlé par la couleur courante (tks Lalex)
		
		- invert : inverse la couleur de l'objet
		
		- reset : réinitialise la couleur d'origine de l'objet


	INHERIT 
	
		Color > BasicColor > SolidColor
	
	THANKS
  
		Classe basée sur le livre : Robert Penner's Programming Macromedia Flash MX
		http://www.robertpenner.com/profmx
		http://www.amazon.com/exec/obidos/ASIN/0072223561/robertpennerc-20

------------- */

import neo.colors.BasicColor;
import neo.colors.ColorRGB;
import neo.util.factory.PropertyFactory;

class neo.colors.SolidColor extends BasicColor {

	// ----o Constructor

	public function SolidColor (mc:MovieClip) { 
		super(mc) ;
	}

	// ----o Public Properties
			
	public var blue:Number ; // (R/W]
	public var blueOffset:Number ; // (R/W]
	public var bluePercent:Number ; // (R/W]
	public var green:Number ; // (R/W]
	public var greenOffset:Number ; // (R/W]
	public var greenPercent:Number ; // (R/W]
	public var red:Number ; // (R/W]
	public var redOffset:Number ; // (R/W]
	public var redPercent:Number ; // (R/W]

	// ----o Public Methods

	public function getRGB2():Object {
		var t:Object = getTransform() ;
		return {r:t.rb, g:t.gb, b:t.bb} ;
	}
	
	public function setRGB2(r:Number, g:Number, b:Number):Void  { 
		setRGB (ColorRGB.rgb2hex(r,g,b)) ; 
	} 

	public function getRed():Number { return getTransform().rb; }
	public function setRed(amount:Number):Void{
		var t:Object = getTransform();
		setRGB (ColorRGB.rgb2hex(amount, t.gb, t.bb)) ;
	}

	public function getGreen():Number { return getTransform().gb; }
	public function setGreen(amount:Number) {
		var t:Object = getTransform();
		setRGB (ColorRGB.rgb2hex(t.rb, amount, t.bb)) ;
	}

	public function getBlue():Number { return getTransform().bb; }
	public function setBlue(amount:Number):Void {
		var t:Object = getTransform() ;
		setRGB (ColorRGB.rgb2hex(t.rb, t.gb, amount)) ;
	}

	public function getRedPercent():Number { return getTransform().ra; }
	public function setRedPercent(percent:Number):Void {
		var t:Object = getTransform();
		t.ra = percent ; setTransform (t) ; 
	}

	public function getGreenPercent():Number { return getTransform().ga; }
	public function setGreenPercent(percent:Number):Void {
		var t:Object = getTransform();
		t.ga = percent ; setTransform (t);
	}

	public function getBluePercent():Number { return getTransform().ba; }
	public function setBluePercent(percent:Number):Void {
		var t:Object = getTransform();
		t.ba = percent ; setTransform (t);
	}

	public function getRedOffset():Number { return getTransform().rb; }
	public function setRedOffset(offset:Number):Void {
		var t:Object = getTransform() ;
		t.rb = offset ; setTransform (t) ;
	}

	public function getGreenOffset():Number { return getTransform().gb; }
	public function setGreenOffset(offset:Number):Void {
		var t:Object = getTransform();
		t.gb = offset; setTransform (t);
	}

	public function getBlueOffset():Number { return getTransform().bb; }
	public function setBlueOffset(offset:Number):Void {
		var t:Object = getTransform() ;
		t.bb = offset ; setTransform (t);
	}

	// -----o Virtual Properties
	
	static private var __BLUE__:Boolean = PropertyFactory.create(SolidColor, "blue", true) ;
	static private var __BLUE_OFFSET__:Boolean = PropertyFactory.create(SolidColor, "blueOffset", true) ;
	static private var __BLUE_PERCENT__:Boolean = PropertyFactory.create(SolidColor, "bluePercent", true) ;
	static private var __GREEN__:Boolean = PropertyFactory.create(SolidColor, "green", true) ;
	static private var __GREEN_OFFSET__:Boolean = PropertyFactory.create(SolidColor, "greenOffset", true) ;
	static private var __GREEN_PERCENT__:Boolean = PropertyFactory.create(SolidColor, "greenPercent", true) ;
	static private var __RED__:Boolean = PropertyFactory.create(SolidColor, "red", true) ;
	static private var __RED_OFFSET__:Boolean = PropertyFactory.create(SolidColor, "redOffset", true) ;
	static private var __RED_PERCENT__:Boolean = PropertyFactory.create(SolidColor, "redPercent", true) ;
	
}

