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

/* ------ PropertyFactory

	AUTHOR

		Name : PropertyFactory
		Package : neo.util.factory
		Version : 1.0.0.0
		Date :  2006-01-08
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : vegas@ekameleon.net
	
	DESCRIPTION
		
		Fabrique pour créer des propriétés virtuelles sur un constructeur donné.

	METHOD SUMMARY
	
		- static create(c:Function, propName:String, isPrototype:Boolean, isReadOnly:Boolean):Boolean		
	
			- PARAMS
				- o : an object
				- propName:String
				- isPrototype:Boolean

				- isReadOnly:Boolean
	
	NOTE : penser à déclarer en AS2 la propriété virtuelle en public
	
---------------*/

import neo.util.StringUtil;

class neo.util.factory.PropertyFactory {

	// ----o Constructor
	
	private function PropertyFactory() {
		//
	}


	// ----o Public Methods
	
	static public function create(o, propName:String, isPrototype:Boolean, isReadOnly:Boolean):Boolean {
		if (isPrototype) o = o["prototype"] ;
		var suffix:String = (new StringUtil(propName)).ucFirst() ;

		var g:Function = o["get"+suffix] ;

		var s:Function = isReadOnly ? null: o["set"+suffix] ;
		return o.addProperty(propName, g, s) ;
	}
	
}