/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Vegas Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import vegas.core.CoreObject;
import vegas.core.ITypeable;
import vegas.core.IValidator;
import vegas.errors.IllegalArgumentError;
import vegas.errors.TypeMismatchError;
import vegas.util.ConstructorUtil;
import vegas.util.TypeUtil;

/**
 * This abstract class is used to create concrete {@code ITypeable} implementations.
 * @author eKameleon
 * @see ITypeable
 * @see IValidator
 */
class vegas.util.AbstractTypeable extends CoreObject implements ITypeable, IValidator 
{

	/**
	 * Creates a new ITypeable instance if you extend this class.
	 * @param type the Type of this ITypeable object.
	 */
	private function AbstractTypeable(type:Function) 
	{
		
		if (type == null) 
		{
			throw new IllegalArgumentError( ConstructorUtil.getName(this) + " constructor failed, the argument 'type' must not be 'null' or 'undefined'.") ;
		}
		_type = type ;
		
	}

	/**
	 * Returns the type of the ITypeable object.
	 * @return the type of the ITypeable object.
	 */
	public function getType():Function 
	{
		return _type ;
	}

	/**
	 * Sets the type of the ITypeable object.
	 */
	public function setType(type:Function):Void 
	{
		_type = type ;
	}

	/**
	 * Returns {@code true} if the IValidator object validate the value.
	 * @return {@code true} is this specific value is valid.
	 */
	public function supports( value ):Boolean 
	{
		return TypeUtil.typesMatch(value, _type) ;
	}

	/**
	 * Evaluates the condition it checks and updates the IsValid property.
	 */
	public function validate( value ):Void 
	{
		if (!supports(value)) 
		{
			throw new TypeMismatchError( this + " validate('value' : " + value + ") is mismatch.") ;
		}
	}
	
	/**
	 * The internal type function.
	 */
	private var _type:Function ;

}