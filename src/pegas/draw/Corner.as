/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is PEGAS Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import vegas.core.CoreObject;
import vegas.core.ICloneable;
import vegas.util.ConstructorUtil;
import vegas.util.serialize.Serializer;

/**
 * Determinates the corner parameters in a CornerRectanglePen (Bevel, Rounded...)
 * @author eKameleon
 */
class pegas.draw.Corner extends CoreObject implements ICloneable 
{
	
	/**
	 * Creates a new Corner instance.
	 */
	public function Corner(tl:Boolean , tr:Boolean, br:Boolean, bl:Boolean) {
		super() ;
		if (tl != null) _tl = tl ;
		if (br!= null) _br = br ;
		if (tr!= null) _tr = tr ;
		if (bl!= null) _bl = bl ;
	}
	
	public function get bl():Boolean 
	{
		return getBl() ;	
	}
	
	public function get br():Boolean 
	{
		return getBr() ;	
	}

	public function get tl():Boolean 
	{
		return getTl() ;	
	}
	
	public function get tr():Boolean 
	{
		return getTr() ;	
	}
	
	public function clone() 
	{
		return new Corner(getTl() , getTr(), getBr(), getBl()) ;	
	}

	public function getBl():Boolean 
	{
		return _bl ;
	}

	public function getBr():Boolean 
	{
		return _br ;
	}
	
	public function getTl():Boolean 
	{
		return _tl ;
	}

	public function getTr():Boolean 
	{
		return _tr ;
	}

	/**
	 * Returns a Eden reprensation of the object.
	 * @return a string representing the source code of the object.
	 */
	public function toSource():String 
	{
		return Serializer.getSourceOf(this, [getTl(), getTr(), getBr(), getBl()] )  ;
	}
	
	/**
	 * Returns the string representation of this object.
	 * @return the string representation of this object.
	 */
	public function toString():String 
	{
		return "[" + ConstructorUtil.getName(this) + " tl:" + _tl + ", br:" + _br + ", tr:" + _tr + ", bl:" + _bl + "]" ;
	}

	private var _tl:Boolean = true ;
	private var _tr:Boolean = true ;
	private var _bl:Boolean = true ;
	private var _br:Boolean = true ;
	
}