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

/* -------- Range

	AUTHOR

		Name : Range
		Package : neo.maths
		Version : 1.0.0.0
		Date :  2006-02-27
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net
	
	CONSTRUCTOR
	
		var r:Range = new Range(p_min:Number, p_max:Number) ;
	
	CONSTANT SUMMARY
	
		- PERCENT_RANGE : Range between 0 and 100
		
		- COLOR_RANGE : Range between -255 and 255
	
	PROPERTY SUMMARY
		
		- max:Number
			
		- min:Number

	METHOD SUMMARY

		- clamp(value:Number):Number
		
		- clone()
		
		- contains(value):Boolean
		
		- equals(o):Boolean
		
		- isOutOfRange(value:Number):Boolean
		
		- overlap(r:Range):Boolean
		
			test si les 2 objets de type Range se chevauchent.
		
		- toString():String

	IMPLEMENTS

		IFormattable
	
---------------*/

import neo.core.CoreObject;
import neo.util.MathsUtil;

class neo.maths.Range extends CoreObject {

	// ----o Constructor 
	
	public function Range(p_min:Number, p_max:Number) {
		if (p_max < p_min) throw new Error("ArgumentOutOfBoundsError : Range constructor : 'max' argument is < of 'min' argument") ;
		min = p_min ;
		max = p_max ;
	}

	// ----o Constant
	
	static public var PERCENT_RANGE:Range = new Range(0, 100) ;
	static public var COLOR_RANGE:Range = new Range(-255, 255) ;
	
	static private var __ASPF__ = _global.ASSetPropFlags(Range, null , 7, 7) ;
	
	// ----o Public Properties
	
	public var max:Number ;
	public var min:Number ;
		
	// ----o Public Methods
	
	public function clamp(value:Number):Number {
		return MathsUtil.clamp(value, min, max) ;
	}
	
	public function clone() {
		return new Range(min, max) ;
	}
	
	public function contains(value:Number):Boolean {
		return !isOutOfRange(value) ;
	}
	
	public function equals(o):Boolean {
		return o instanceof Range && o.min == min && o.max == o.max ;
	}
	
	public function isOutOfRange(value:Number):Boolean {
		return (value > max ) || (value < min) ;
	}
	
	public function overlap(r:Range):Boolean {
		return max > r.min && r.max > min ;
	}
	
	public function toString():String {
		return "[" + min + "," + max + "]";
	}
	
}