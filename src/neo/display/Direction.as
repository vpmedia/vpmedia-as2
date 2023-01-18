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

/* ---------- Direction
	
	AUTHOR
	
		Name : Direction
		Package : neo.display
		Version : 1.0.0.0
		Date :  2006-02-06
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	CONSTANT SUMMARY
		
		- HORIZONTAL:Number
		
		- VERTICAL:Number

	METHOD SUMMARY

		- static toNumber(str:String):Number
		
		- static toString(n:Number):String

----------  */

class neo.display.Direction {

	// ----o Constructor

    private function Direction() {
		//
	}

	// ----o Constants

	static public var HORIZONTAL:Number = 0 ;
	
	static public var VERTICAL:Number = 1 ;

	static private var __ASPF__ = _global.ASSetPropFlags(Direction, null , 7, 7) ;

	// ----o Public Methods

	static public function toNumber(str:String):Number {
		switch (str.toLowerCase()) {
			case "vertical" :
				return Direction.VERTICAL ;
			case "horizontal" : default :
				return Direction.HORIZONTAL ;
				break ;
		}
	}

	static public function toString(n:Number):String {
		if (n == Direction.HORIZONTAL) return "horizontal" ;
		else if (n == Direction.VERTICAL) return "vertical" ;
		else return "" ;
	}

}