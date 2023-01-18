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

/* ------- 	AbstractTypeable

	AUTHOR

		Name : AbstractTypeable
		Package : neo.util
		Version : 1.0.0.0
		Date :  2006-02-09
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net

	CONSTRUCTOR
	
		private

	METHODS
	
		- getType()
				
			return the type.
			
		- setType(type:Function)
			
			the type to set.
		
		- supports(value):Boolean
		
		- validate(value)
		
	IMPLEMENTS 

		Typeable, Validator

----------  */

import neo.core.CoreObject;
import neo.core.ITypeable;
import neo.core.IValidator;
import neo.util.TypeUtil;

class neo.util.AbstractTypeable extends CoreObject implements ITypeable, IValidator {

	// ----o Construtor
	
	private function AbstractTypeable(type:Function) {
		if (type == null) {
			throw new Error("IllegalArgumentError ::Argument 'type' must not be 'null' or 'undefined'.") ;
		}
		_type = type ;
	}

	// ----o Public Methods	

	public function getType():Function {
		return _type ;
	}

	public function setType(type:Function):Void {
		if (type == null) {
			throw new Error("IllegalArgumentError ::Argument 'type' must not be 'null' or 'undefined'.") ;
		}
		_type = type ;
	}

	public function supports(value):Boolean {
		return TypeUtil.typesMatch(value, _type) ;
	}
	
	public function validate(value):Void {
		if (!supports(value)) throw new Error("TypeMismatchError :: validate('value' : " + value + ") is mismatch") ;
	}
	
	// -----o Private Properties
	
	private var _type:Function ;

}