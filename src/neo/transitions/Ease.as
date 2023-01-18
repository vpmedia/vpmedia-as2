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

/* ------ Ease

	AUTHOR

		Name : Ease
		Package : neo.transitions
		Version : 1.0.0.0
		Date :  2006-02-07
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	CONSTANT SUMMARY
	
		EASE_IN : easeIn
		
		EASE_IN_OUT : easeInOut
		
		EASE_OUT : easeOut
		
	STATIC METHODS
	
		- easeIn (t:Number, b:Number, c:Number, d:Number):Number
		
		- easeOut (t:Number, b:Number, c:Number, d:Number):Number
		
		- easeInOut (t:Number, b:Number, c:Number, d:Number):Number
		
----------  */	

class neo.transitions.Ease {

	// ----o Constructor
	
	private function Ease() {
		//
	}


	// ----o Constant
	
	static public function get EASE_IN():String { return "easeIn"; }
	
	static public function get EASE_IN_OUT():String { return "easeInOut"; } ;
	
	static public function get EASE_OUT():String { return "easeOut"; } ;
	
	static private var __ASPF__ = _global.ASSetPropFlags(Ease, null , 7, 7) ;
	
	// ----o Static Methods
	
	static public function easeIn (t:Number, b:Number, c:Number, d:Number):Number {
		return null ;
	}
	
	static public function easeOut (t:Number, b:Number, c:Number, d:Number):Number {
		return null ;
	}
	
	static public function easeInOut (t:Number, b:Number, c:Number, d:Number):Number {
		return null ;
	}
	
	
}