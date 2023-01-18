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


/* --------- TransformColor



	AUTHOR

	

		Name : TransformColor

		Package : neo.colors

		Version : 1.0.0.0

		Date :  2006-02-07

		Author : ekameleon

		URL : http://www.ekameleon.net

		Mail : contact@ekameleon.net

	

	METHODS

	

		- addition (n:Number)

		

		- colorDodge (n:Number)	

		

		- difference (n:Number)

		

		- divide(n:Number)

		

		- getTarget()

			renvoi l'instance de l'objet controlé par la couleur courante.

		

		- invert

			inverse la couleur de l'objet.

		

		- linearBurn (n:Number)

		

		- linearDodge (n:Number)

		

		- multiply(n:Number)

		

		- negative (n:Number)
		

		- reset

			réinitialise la couleur d'origine de l'objet.

		

		- screen (n:Number)

		
		- substraction (n:Number)
		
	

	INHERIT 

	

		Color > BasicColor > TransformColor

	

	THANKS

		Espaces colorimétriques - Damien


----------------*/


import neo.colors.BasicColor;
import neo.colors.ColorRGB;

class neo.colors.TransformColor extends BasicColor {
	
	//  ------o Constructor
	
	public function TransformColor (mc:MovieClip) { 

		super (mc) ;

	}
	
	//  ------o Public Methods

	public function negative (n:Number):Void {
		setTransform ({ ra:-100, ga:-100, ba:-100, rb:255, gb:255, bb:255 });
	}

	public function addition(n:Number):Void {
		var o:Object = ColorRGB.hex2rgb(n);
		setTransform ( { rb:o.r , gb:o.g , bb:o.b });
	}
	
	public function substraction (n:Number):Void {
		var o:Object = ColorRGB.hex2rgb(n);
		setTransform ({ ra:-100, ga:-100, ba:-100, rb:o.r, gb:o.g, bb:o.b } );
	}
	
	public function difference (n:Number):Void {
		var o:Object = ColorRGB.hex2rgb(n) ;
		setTransform ( { rb:-o.r , gb:-o.g , bb:-o.b });
	}
	
	public function divide(n:Number):Void {
		var o:Object = ColorRGB.hex2rgb(n);
		setTransform ({ ra:_div(o.r) , ga:_div(o.g) , ba:_div(o.b) } );
	}
	
	public function multiply(n:Number):Void {
		var o:Object = ColorRGB.hex2rgb(n);
		setTransform ({ ra:o.r/2.55 , ga:o.g/2.55 , ba:o.b/2.55 });
	}
	
	public function linearDodge (n:Number):Void {
		var o:Object = ColorRGB.hex2rgb(n) ;
		setTransform ({ rb:o.r , gb:o.g, bb:o.b });
        }
	
	public function linearBurn (n:Number):Void {
		var o:Object = ColorRGB.hex2rgb(n) ;
		setTransform ({ rb:o.r-255 , gb:o.g-255, bb:o.b-255 });
	}
	
	public function colorDodge (n:Number):Void {
		var o:Object = ColorRGB.hex2rgb(n) ;
		setTransform ({ ra:_dodge(o.r) , ga:_dodge(o.g) , ba:_dodge(o.b) } );
	}
	
	public function screen (n:Number):Void {
		var o:Object = ColorRGB.hex2rgb(n);
		setTransform ({ ra:_scr(o.r), ga:_scr(o.g), ba:_scr(o.b), rb:o.r, gb:o.g, bb:o.b } );
	}
	
	//  ------o Private Methods
	
	private function _div(n:Number):Number {
		return 100/((n + 1)/256);
	}

	private function _dodge(n:Number):Number {
		return 100 / ((258 - n) / 256);
	}
	
	private function _scr(n:Number):Number {
		return 100 * (255 - n) / 255;
	}
	
}
