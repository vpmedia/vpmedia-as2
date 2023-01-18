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

import vegas.util.TypeUtil;

/**
 * The {@code ErrorUtil} utility class is an all-static class with methods for working with Error.
 * @author eKameleon
 */
class vegas.util.ErrorUtil 
{

	/**
	 * Returns a shallow copy by reference of this specified error.
	 * @return a shallow copy by reference of this specified error.
	 */
	static public function clone(e:Error):Error 
	{
		return new Error(e.message) ;
	}

	/**
	 * Returns a deep copy by value of this specified error.
	 * @return a deep copy by value of this specified error.
	 */
	static public function copy(e:Error):Error 
	{
		return new Error( (e.message).valueOf() ) ;
	}

	/**
	 * Compare if two Errors are equal by reference.
	 * @return {@code true} if the two Errors are equal by reference.
 	 */
	static public function equals( e1:Error, e2:Error ):Boolean 
	{
    	if(e1 == null || !TypeUtil.typesMatch(e1, Error))
        {
        	return false ;
        }
    	if(e2 == null || !TypeUtil.typesMatch(e2, Error))
        {
        	return false ;
        }
		return e1.toString() == e2.toString() ;
    }

	/**
	 * Returns a string representing the source code of the object.
	 * @return a string representing the source code of the object.
 	 */
	static public function toSource( e:Error ):String 
	{
		return 'new Error("' + e.message + '")'  ;
	}
	
}