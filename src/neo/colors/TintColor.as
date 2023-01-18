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

/* ---------- TintColor

	AUTHOR
	
		Name : TintColor
		Package : neo.colors
		Version : 1.0.0.0
		Date :  2006-02-07
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	DESCRIPTION

		Gestion de la teinte d'un clip (MovieClip)

	METHOD SUMMARY
	
		- getTarget()
			renvoi l'instance de l'objet controlé par la couleur courante.
		
		- getTint()
			renvoi une teinte sous forme d'un objet contenant les propriétés r, g, b et percent .
		
		- getTint2()
			retourne la teinte d'un clip sous forme d'un objet ayant pour propriété :
				rgb : un nombre (0xFFFFFF)
				percent : le pourcentage de la teinte
			
		- getTintOffset()
			renvoi un objet ayant pour propriété : r, g et b entre -255 et 255
		
		- invert()
			inverse la couleur de l'objet
		
		- reset()
			réinitialise la couleur d'origine de l'objet
		
		- setTint(r, g, b, percent)
			gère la teinte d'un objet comme dans le panneau de propriété.
			paramètres : 
				r, g, b entre 0 et 255.
				percent entre 0 et 100.
			
		- setTint2(hex, percent)
			Teinte d'une couleur - approche alternative
			Paramètres : 
				hex : couleur entre 0 et 0xFFFFFF
				percent : alpha entre 0 et 100
			
		- setTintOffset(r, g, b)
			Teinte d'une couleur, en fonction des 3 composantes r, g et b
			Paramètres : r, g, b entre -255 et 255
	
	INHERIT 
	
		Color > BasicColor > TintColor
	
	
	THANKS
		© 2003 Robert Penner - Use freely, giving credit where possible.
		Classe basée sur le livre : Robert Penner's Programming Macromedia Flash MX
		http://www.robertpenner.com/profmx
		http://www.amazon.com/exec/obidos/ASIN/0072223561/robertpennerc-20

------------- */

import neo.colors.BasicColor;
import neo.colors.ColorRGB;

class neo.colors.TintColor extends BasicColor {

	// -----o Constructor

	public function TintColor (mc:MovieClip) { 
		super(mc) ;
	}

	// -----o Public Methods

	public function getTint():Object {
		var t:Object = getTransform();
		var percent:Number = 100 - t.ra ;
		var ratio:Number = 100 / percent;
		return { 
			percent: percent ,
			r : t.rb * ratio ,
			g : t.gb * ratio ,
			b : t.bb * ratio 
		};
	}

	public function setTint(r:Number, g:Number, b:Number, percent:Number):Void {
		var ratio:Number = percent / 100;
		var t:Object = { rb:r*ratio, gb:g*ratio, bb:b*ratio };
		t.ra = t.ga = t.ba = 100-percent ;
		setTransform (t);
	}

	public function getTint2():Object {
		var t:Object = getTransform();
		var percent:Number = 100 - t.ra ;
		var ratio:Number = 100 / percent ;
		return { 
			percent:percent ,
			rgb:ColorRGB.rgb2hex(t.rb*ratio, t.gb*ratio, t.bb*ratio) 
		};
	}
	
	public function setTint2(hex:Number, percent:Number):Void {
		var c:Object = ColorRGB.hex2rgb (hex) ;
		var ratio:Number = percent / 100 ;
		var t:Object = {rb:c.r*ratio, gb:c.g*ratio, bb:c.b*ratio};
		t.ra = t.ga = t.ba = 100-percent;
		setTransform (t);
	}


	public function setTintOffset(r:Number, g:Number, b:Number):Void {
		var t:Object = getTransform();
		t.rb = r ; 

		t.gb = g ; 

		t.bb = b ;
		setTransform (t);
	}

	public function getTintOffset():Object {
		var t:Object = getTransform() ;
		return {r:t.rb, g:t.gb, b:t.bb} ;
	}

}

