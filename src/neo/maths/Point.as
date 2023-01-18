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

/* -------- Point

	AUTHOR

		Name : Point
		Package : neo.maths
		Version : 1.0.0.0
		Date :  2006-03-06
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net
	
	CONSTRUCTOR
	
		var p:Point = new Point(x,y)
	
---------------*/

class neo.maths.Point extends com.bourre.structures.Point {

	// ----o Constructor 
	
	public function Point(x:Number, y:Number) {
		super(x, y) ;
	}

	// ----o Public Methods
	
	public function angleBetween(p:Point):Number {
		var dp:Number = dot(p) ;
		var l:Number = getLength() ;
		var a:Number = dp / (l * l) ;
		return Math.acos(a) * (180 / Math.PI) ;
	}

	public function dot(p:Point):Number {
		return (x * p.x) + (y * p.y) ;
	}

	public function getAngle():Number {
		return Math.atan2(y, x) * (180 / Math.PI)  ;
	}

	public function getLength():Number {
		return Math.sqrt(x * x + y * y) ;
	}
	
}