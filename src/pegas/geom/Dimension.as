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

import pegas.geom.Rectangle;

import vegas.core.CoreObject;
import vegas.core.ICloneable;
import vegas.core.ICopyable;
import vegas.core.IEquality;
import vegas.util.ConstructorUtil;
import vegas.util.serialize.Serializer;

/**
 * The Dimension class encapsulates the width and height of a componentin a single object.
 * @author eKameleon
 */
class pegas.geom.Dimension extends CoreObject implements IEquality, ICloneable, ICopyable
{
	
	/**
	 * Creates a new Dimension instance.
	 */
	function Dimension()
	{
		width  = 0 ;
		height = 0 ;
		var l:Number = arguments.length ;
		if (l > 0)
		{
			var arg1 = arguments[0] ;
			var arg2 = arguments[1] ;
			if ( l == 1 && arg1 instanceof Dimension )
			{
				width  = arg1.width  ;
				height = arg1.height ;
			}
			else if ( l == 2 )
			{
				width  = isNaN(arg1) ? 0 : arg1 ;
				height = isNaN(arg2) ? 0 : arg2 ;
			}
		}
	}
	
	/**
	 * Determinates the height value of this instance.
	 */
	public var height:Number ;
	
	/**
	 * Determinates the width value of this instance.
	 */
	public var width:Number ;

	/**
	 * Returns a shallow copy of this instance.
	 * @return a shallow copy of this instance.
	 */
	public function clone()
	{
		return new Dimension(width, height) ;	
	}

	/**
	 * Returns a deep copy of this instance.
	 * @return a deep copy of this instance.
	 */
	public function copy()
	{
		return new Dimension(width, height) ;	
	}

	/**
	 * Decreases the size by s and return its self(this).
	 * @param s an other Dimension reference to decreases the current Dimension.
	 * @return the current reference of this object.
	 */
	public function decreaseSize( s:Dimension ):Dimension
	{
		width  -= s.width ;
		height -= s.height ;
		return this ;	
	}

	/**
	 * Compares the specified object with this object for equality.
	 * @return {@code true} if the the specified object is equal with this object.
	 */
	public function equals( o ):Boolean
	{
		return (o instanceof Dimension) && (o.width = width) && (o.height == height) ; 
	}
	
	/**
	 * Returns a new bounds with this size with a pos.
	 * @return a new bounds with this size with a pos.
	 */
	public function getBounds(x:Number, y:Number):Rectangle
	{
		x = isNaN(x) ? 0 : x ;
		y = isNaN(y) ? 0 : y ;
		return new Rectangle(x, y, width, height) ;	
	}
	
	/**
	 * Increases the size by s and return its self(this).
	 * @param s an other Dimension reference to increase the current Dimension.
	 * @return the current reference of this object.
	 */
	public function increaseSize( s:Dimension ):Dimension
	{
		width  += s.width ;
		height += s.height ;
		return this ;	
	}
	
	/**
	 * Sets the size of this instance.
	 */
	public function setSize( w:Number, h:Number ):Void
	{
		width  = w ;
		height = h ;
	}
	
	/**
	 * Returns a Eden reprensation of the object.
	 * @return a string representing the source code of the object.
	 */
	public function toSource(indent : Number, indentor : String):String 
	{
		return Serializer.getSourceOf(this, [width, height]) ;
	}
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance.
	 */
	public function toString():String 
	{
		return "[" + ConstructorUtil.getName(this) + " width:" + width + ",height:" + height + "]" ;
	}
	
}