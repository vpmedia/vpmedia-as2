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

/* ------- 	CoreObject

	AUTHOR
	
		Name : CoreObject
		Package : neo.core
		Version : 1.0.0.0
		Date :  2006-02-04
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	METHOD SUMMARY
			
		- toString():String

	IMPLEMENT
	
		IFormattable

----------  */

import com.bourre.core.HashCodeFactory;

import neo.core.IFormattable;
import neo.util.ConstructorUtil;

dynamic class neo.core.CoreObject implements IFormattable {

	// ----o Construtor
	
	public function CoreObject() {
		//
	}
	
	// ----o Public Methods
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
		
	public function toString():String {
		return "[" + ConstructorUtil.getName(this) + HashCodeFactory.getKey( this ) + "]" ;
	}
	
}