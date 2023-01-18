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
 * This static enumeration class register all string constants to defined a date.
 * @author eKameleon
 */
class asgard.date.LocalDate 
{

	/**
	 * Fully written out string for january.
	 */
	static public var JANUARY:String = "January" ;
	
	/**
	 * Fully written out string for february.
	 */
	static public var FEBRUARY:String = "February" ;
	
	/**
	 * Fully written out string for march.
	 */
	static public var MARCH:String = "March" ;
	
	/**
	 * Fully written out string for april.
	 */
	static public var APRIL:String = "April" ;
	
	/**
	 * Fully written out string for may.
	 */
	static public var MAY:String = "May" ;
	
	/**
	 * Fully written out string for june.
	 */
	static public var JUNE:String = "June" ;
	
	/**
	 * Fully written out string for july.
	 */
	static public var JULY:String = "July" ;
	
	/**
	 * Fully written out string for august.
	 */
	static public var AUGUST:String = "August" ;
	
	/**
	 * Fully written out string for september.
	 */
	static public var SEPTEMBER:String = "September" ;
	
	/**
	 * Fully written out string for october.
	 */
	static public var OCTOBER:String = "October" ;
	
	/**
	 * Fully written out string for november.
	 */
	static public var NOVEMBER:String = "November" ;
	
	/**
	 * Fully written out string for december.
	 */
	static public var DECEMBER:String = "December" ;
	
	/**
	 * Fully written out string for monday.
	 */
	static public var MONDAY:String = "Monday" ;
	
	/**
	 * Fully written out string for tuesday.
	 */
	static public var TUESDAY:String = "Tuesday" ;

	/**
	 * Fully written out string for wednesday.
	 */
	static public var WEDNESDAY:String = "Wednesday" ;
	
	/**
	 * Fully written out string for thursday.
	 */
	static public var THURSDAY:String = "Thursday" ;
	
	/**
	 * Fully written out string for friday.
	 */
	static public var FRIDAY:String = "Friday" ;

	/**
	 * Fully written out string for saturday.
	 */
	static public var SATURDAY:String = "Saturday" ;
	
	/**
	 * Fully written out string for sunday.
	 */
	static public var SUNDAY:String = "Sunday" ;
	
	/**
	 * Returns an array representation of all days constants.
	 * @return an array representation of all days constants.
	 */
	static public function getDays():Array 
	{
		return [SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY] ;
	}
	
	/**
	 * Returns an array representation of all months constants.
	 * @return an array representation of all months constants.
	 */
	static public function getMonths():Array 
	{
		return [ JANUARY, FEBRUARY, MARCH, APRIL, MAY, JUNE, JULY, AUGUST, SEPTEMBER, OCTOBER, NOVEMBER, DECEMBER ] ;
	}

}