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

/* -------- ColorUtil

	AUTHOR

		Name : ColorUtil
		Package : neo.colors
		Version : 1.0.0.0
		Date :  2006-02-07
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	STATIC METHODS
		
		- ColorUtil.invert (c:Color) 
		
		- ColorUtil.reset(c:Color) 

----------------*/

class neo.colors.ColorUtil {
	
	// ----o Constructor
	
	private function ColorUtil() {
		//
	}

	//  ------o static public Methods
	
	static public function invert(c:Color):Void {
		var t:Object = c.getTransform();
		c.setTransform ( {
			ra : -t.ra , ga : -t.ga , ba : -t.ba ,
			rb : 255 - t.rb , gb : 255 - t.gb , bb : 255 - t.bb 
		} ) ;
	}

	static public function reset(c:Color):Void { 
		c.setTransform ({ra:100, ga:100, ba:100, rb:0, gb:0, bb:0}) ;
	}	
	
}