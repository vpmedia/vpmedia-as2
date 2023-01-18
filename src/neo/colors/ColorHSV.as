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


/* ---------------- ColorHSV



	AUTHOR



		Name : ColorHSV

		Package : neo.colors

		Version : 1.0.0.0

		Date :  2006-02-07

		Author : ekameleon

		URL : http://www.ekameleon.net

		Mail : contact@ekameleon.net



	Static Methods

	

		- ColorHSV.rgb2hsv(r:Number, g:Number, b:Number):Object
		

		- ColorHSV.hsv2rgb ( oColor, s:Number, v:Number):Object
	

	THANKS

	

		Espaces colorimétriques - Damien

	

----------------*/

class neo.colors.ColorHSV {
	
	// ----o Constructor

	

	private function ColorHSV() {

		//

	}

	

	//  ------o static public Methods


	static public function hsv2rgb ( oColor, s:Number, v:Number) :Object {

		var tmp:Array = ["r:"+oColor.r,"g:"+oColor.g,"b:"+oColor.b].sort(_fsort) ;

		var order:Array = [ tmp[0].split(':')[0] , tmp[1].split(':')[0] , tmp[2].split(':')[0] ];

		var o:Object = { r:oColor.r , g:oColor.g , b:oColor.b } ;

		o[order[2]] += ( 100 - s ) * 2.55 ;

		o[order[1]] += ( 255 - o[order[1]] ) * ( 100 - s ) / 100 ;

		o[order[0]] *= v / 100 ; 

		o[order[1]] *= v / 100 ; 

		o[order[2]] *= v / 100 ;

		return o ;

	}

	
	static public function rgb2hsv ( r:Number, g:Number ,b:Number):Object {

		var temp:Array = ["r:" + r,"g:" + g,"b:"+b].sort(_fsort);

		var order:Array =[ temp[0].split(':')[0] , temp[1].split(':')[0] , temp[2].split(':')[0] ];

		var o:Object= {r:r,g:g,b:b} ;

		var v:Number = o[order[0]] * 100 /255 ;

		o.r *= 100 / v ;

		o.g *= 100 / v ;

		o.b *= 100 / v ;

		var s:Number =  (255 - o[order[2]]) * 100 / 255 ; // saturation

		o[order[1]] = Math.round ( 255* (1 - (255-o[order[1]])/(255-o[order[2]]) ));

		o[order[0]]= 255 ; o[order[2]] = 0 ;

		return( { h:o , s:s<<0 ,v:v<<0} ) ;

	}

	

	//  ------o static private Methods

	

	static private function _fsort ( a:String , b:String ) :Number {

		var val1:Number = Number(a.split(':')[1]);

		var val2:Number = Number(b.split(':')[1]);

		if (val1 > val2) return -1;

		else if (val1 < val2) return 1;

		else return 0;

	}

	
}