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

/* -------- StageAlign

	AUTHOR

		Name : StageAlign
		Package : neo.display
		Version : 1.0.0.0
		Date :  2006-02-06

		Author : ekameleon

		URL : http://www.ekameleon.net

		Mail : contact@ekameleon.net


	CONSTRUCTOR

	

		Private

	
	CONSTANT SUMMARY
	
		- BOTTOM:String


			Specifies that the Stage is aligned at the bottom.
		
		- BOTTOM_LEFT:String
			

			Specifies that the Stage is aligned in the bottom-left corner.
			
		- BOTTOM_RIGHT:String
			

			Specifies that the Stage is aligned in the bottom-right corner.
		
		- CENTER:String
		
			Specifies that the Stage is aligned in the center.
		
		- LEFT:String
			

			Specifies that the Stage is aligned on the left.
		
		- RIGHT:String
			

			Specifies that the Stage is aligned to the right.
		
		- TOP:String
			

			Specifies that the Stage is aligned at the top.
		
		- TOP_LEFT:String
			

			Specifies that the Stage is aligned in the top-left corner.
		
		- TOP_RIGHT:String
			

			Specifies that the Stage is aligned in the top-right corner.
	

	METHOD SUMMARY

	

		- static getAlign(align:String, default_align:StageAlign):String

	

------------*/


import neo.util.StringUtil;



class neo.display.StageAlign {

	// ----o Constructor

    private function StageAlign() {

		//
	}

	// ----o Public Properties


	static public var BOTTOM:String = "B" ;
	static public var BOTTOM_LEFT:String = "BL" ;
	static public var BOTTOM_RIGHT:String = "BR" ;
	static public var CENTER:String = "" ;
	static public var LEFT:String = "L" ;
	static public var RIGHT:String = "R" ;
	static public var TOP:String = "T" ;
	static public var TOP_LEFT:String = "TL" ;
	static public var TOP_RIGHT:String = "TR" ;

	static private var __ASPF__ = _global.ASSetPropFlags(StageAlign, null , 7, 7) ;

	// ----o Public Methods
	
	static public function getAlign(align:String, default_align:String):String {
		var s:StringUtil = new StringUtil(align.toUpperCase()) ;
		var r:String = s.reverse() ;
		var aligns =  {
			B:BOTTOM, BL:BOTTOM_LEFT, BR:BOTTOM_RIGHT,
			L:LEFT, R:RIGHT, T:TOP, TL:TOP_LEFT, TR:TOP_RIGHT
		} ;
		if (aligns[s]) return aligns[s] ;
		else if (aligns[r]) return aligns[r] ;
		else return default_align || StageAlign.CENTER ;
	}

}
