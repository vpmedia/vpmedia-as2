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

/* ---------- ScrollPolicy
	
	AUTHOR
	
		Name : ScrollPolicy
		Package : neo.display
		Version : 1.0.0.0
		Date :  2006-02-22
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	CONSTANT SUMMARY
		
		- AUTO:Number
		
		- OFF:Number
		
		- ON:Number

	METHOD SUMMARY

		- static validate(o):Boolean
	
----------  */

class neo.display.ScrollPolicy {

	// ----o Constructor

    private function ScrollPolicy() {
		//
	}

	// ----o Constants

	static public var AUTO:Number = 2 ;

	static public var OFF:Number = 0 ;
	
	static public var ON:Number = 1 ;
	
	static private var __ASPF__ = _global.ASSetPropFlags(ScrollPolicy, null , 7, 7) ;

	// ----o Public Methods

	static public function validate(o):Boolean {
		return (o == ScrollPolicy.AUTO || o == ScrollPolicy.OFF || o == ScrollPolicy.ON) ;
	}

}