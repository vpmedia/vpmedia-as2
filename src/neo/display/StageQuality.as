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

/* -------- StageQuality

	AUTHOR

		Name : StageQuality
		Package : neo.display
		Version : 1.0.0.0
		Date :  2006-02-06

		Author : ekameleon

		URL : http://www.ekameleon.net

		Mail : contact@ekameleon.net


	CONSTRUCTOR

	

		Private

	
	CONSTANT SUMMARY
	
		- BEST:String


			Specifies Very high rendering quality: graphics are anti-aliased using a 4 x 4 pixel grid and bitmaps are always smoothed.
		
		- HIGH:String
			

			Specifies high rendering quality: graphics are anti-aliased using a 4 x 4 pixel grid, and bitmaps are smoothed if the movie is static.
			
		- LOW:String
			

			Specifies low rendering quality: graphics are not anti-aliased, and bitmaps are not smoothed.
		
		- MEDIUM:String
		
			Specifies medium rendering quality: graphics are anti-aliased using a 2 x 2 pixel grid, but bitmaps are not smoothed.
		
	

------------*/


class neo.display.StageQuality {

	// ----o Constructor

    private function StageQuality() {

		//
	}



	// ----o Public Properties


	static public var BEST:String = "best" ;
	static public var HIGH:String = "high" ;
	static public var LOW:String = "low" ;
	static public var MEDIUM:String = "medium" ;
	

	static private var __ASPF__ = _global.ASSetPropFlags(StageQuality, null , 7, 7) ;



}
