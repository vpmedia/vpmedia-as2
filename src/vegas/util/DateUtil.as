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

/**
 * The {@code DateUtil} utility class is an all-static class with methods for working with dates.
 * @author eKameleon
 */
class vegas.util.DateUtil 
{

	/**
	 * Returns a shallow copy of the date object passed in argument.
	 * @return a shallow copy of the date object passed in argument.
	 */
	static public function clone(d:Date):Date 
	{
		return d ;
	}

	/**
	 * Returns a deep copy of the date object passed in argument.
	 * @return a deep copy of the date object passed in argument.
	 */
	static public function copy(d:Date):Date 
	{
		return new Date(d.valueOf()) ;
	}

	/**
	 * Compares the twno specified Date objects for equality.
	 * @return {@code true} if the the two specified Date object are equals.
	 */
	static public function equals( d1:Date, d2:Date ):Boolean 
	{
		if (!d2) return false ;
		return d1.getTime() == d2.getTime() ;
    }
	
}