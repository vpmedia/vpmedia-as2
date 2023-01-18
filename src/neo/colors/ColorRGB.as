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


/* -------- ColorRGB



	AUTHOR



		Name : ColorRGB

		Package : neo.colors

		Version : 1.0.0.0

		Date :  2006-02-07

		Author : ekameleon

		URL : http://www.ekameleon.net

		Mail : contact@ekameleon.net



	STATIC METHODS

	

		- ColorRGB.rgb2hex(r:Number, g:Number, b:Number) :Number

		
		- ColorRGB.hex2rgb(hex:Number):Object


----------------*/

class neo.colors.ColorRGB {
	

	// ----o Constructor

	

	private function ColorRGB() {

		//

	}

	
	//  ------o static public Methods
	

	static public function getRGBStr(c:Color):String {

		var str:String = c.getRGB().toString(16);

		var toFill:Number = 6 - str.length;

		while (toFill--) str = "0" + str ;

		return str.toUpperCase();

	}

	
	static public function hex2rgb(hex:Number):Object {
		var r,g,b,gb:Number ;
		r = hex>>16 ;
		gb = hex ^ r << 16 ;
		g = gb>>8 ;
		b = gb^g<<8 ;
		return {r:r,g:g,b:b} ;
	}

	

	static public function rgb2hex(r:Number, g:Number, b:Number):Number  {

		return ((r << 16) | (g << 8) | b);

	}

	

	static public function setRGBStr(c:Color, str:String) : Void {

		c.setRGB (parseInt (str.substr (-6, 6), 16));

	}



	

}