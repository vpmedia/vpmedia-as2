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

import vegas.core.HashCode;
import vegas.core.ICloneable;
import vegas.core.IFormattable;
import vegas.core.ISerializable;
import vegas.core.ITypeable;
import vegas.core.IValidator;
import vegas.data.iterator.ArrayIterator;
import vegas.data.iterator.Iterator;
import vegas.errors.IllegalArgumentError;
import vegas.errors.TypeMismatchError;
import vegas.util.serialize.Serializer;
import vegas.util.TypeUtil;

/**
 * {@code TypedArray} acts like a normal array but assures that only objects of a specific type are added to the array.
 * 
 * <p><b>Example :</b></p>
 * {@code
 * import vegas.data.array.TypedArray ;
 * 
 * var ta:TypedArray = new TypedArray(String, ["item1", "item2", "item3"]) ;
 * trace ("ta : " + ta) ; // output : ta : item1,item2,item3
 * ta.push(2) ; // [TypeMismatchError] TypedArray.validate('value':2) is mismatch
 * }
 * @author eKameleon 
 */
 class vegas.data.array.TypedArray extends Array implements ICloneable, IFormattable, ISerializable, ITypeable, IValidator 
 {

	/**
	 * Creates a new TypedArray instance.
	 * @param type the Type(Function) of all objects in this collection.
	 * @param ar the default array of values to fill this collection.
	 */
	public function TypedArray(type:Function, ar:Array) 
	{
		if (!type) 
		{
			throw new IllegalArgumentError("TypedArray constructor, argument 'type' must not be 'null' nor 'undefined'.") ;
		}
		_type = type ;
		var l:Number = ar.length ;
		if (l > 0) 
		{
			for (var i:Number = 0 ; i<l ; i++) 
			{
				var value = ar[i] ;
				if (supports(value)) 
				{
					this[i] = value ;
				}
			}
		}
	}
	
	
	/**
	 * Creates and returns a shallow copy of the object.
	 * @return a shallow copy of the object. 
	 */	
	public function clone() 
	{
		return new TypedArray(_type, this.slice()) ;
	}
	
	/**
	 * Concatenates the elements specified in the parameter list with the elements of this array and returns a new array containing these element.
	 * @return a new array that contains the elements of this array as well as the passed-in elements.
	 */
	public function concat():TypedArray 
	{
		var r:TypedArray = new TypedArray(_type) ;
		var j, k, l1, l2:Number ;
		var i:Number = this.length ;
		while(--i>-1) 
		{
			r[i] = this[i];
		}
		l1 = arguments.length ;
		j = -1 ;
		while(++j < l1) 
		{
			var cur = arguments[j] ;
			if (cur instanceof Array) 
			{
				l2 = cur.length ;
				k = -1 ;
				while (++k < l2) 
				{
					r.push(cur[k]);
				}
			}
			else 
			{
				r.push(cur);
			}
		}
		return r ;
	}

	/**
	 * Returns the type of the {@code ITypeable} object.
	 * @return the type of the {@code ITypeable} object.
	 */
	public function getType():Function 
	{
		return _type;
	}

	/**
	 * Returns a hashcode value for the object.
	 * @return a hashcode value for the object.
	 */
	public function hashCode():Number 
	{
		return null ;
	}

	/**
	 * Returns the iterator of the object.
	 * @return the iterator of the object.
	 */
	public function iterator():Iterator 
	{
		return new ArrayIterator(this) ;
	}
	
	/**
	 * Adds one or more elements to the end of this array and returns the new length of this array.
	 * @return the new length of this array
	 * @throws TypeMismatchError 
	 */
	/*override*/ public function push(value):Number 
	{
		if (arguments.length > 1) 
		{
			var l:Number = arguments.length;
			var i:Number = 0 ;
			while (++i < l) 
			{
				validate(arguments[i]) ;
			}
		} 
		else 
		{
			validate(value) ;
		}
		return Number(super.push.apply(this, arguments)) ;
	}

	/**
	 * Sets the type of the ITypeable object.
	 */
	public function setType(type:Function):Void 
	{
		_type = type ;
		length = 0 ;
	}

	/**
	 * Returns {@code true} if the {@code IValidator} object validate the value.
	 * @return {@code true} if the {@code IValidator} object validate the value.
	 */
	public function supports(value):Boolean 
	{
		return TypeUtil.typesMatch(value, _type) ;
	}

	/**
	 * Returns a eden string reprensation of the object.
	 * @return a eden string representing the source code of the object.
	 */
	public function toSource(indent:Number, indentor:String):String 
	{
		var sourceA:String = TypeUtil.toString(_type) ;
		var sourceB:String = Serializer.toSource([].concat(this)) ;
		return Serializer.getSourceOf(this, [sourceA, sourceB]) ;
	}

	/**
	 * Adds one or more elements to the beginning of this array and returns the new length of this array.
	 * @return the new length of this array
	 */
	public function unshift(value):Number 
	{
		if (arguments.length > 1) 
		{
			var l:Number = arguments.length ;
			var i:Number = -1 ;
			while (++i < l ) 
			{
				validate(arguments[i]);
			}
		}
		else 
		{
			validate(value) ;
		}
		return Number(super.unshift.apply(this, [].concat(arguments) )) ;
	}
	
	/**
	 * Evaluates the condition it checks and updates the IsValid property.
	 * @throws TypeMismatchError 
	 */
	public function validate(value):Void 
	{
		if (!supports(value)) 
		{
			throw new TypeMismatchError("TypedArray validate('value':" + value + ") is mismatch") ;
		}
	}
	
	static private var _initHashCode:Boolean = HashCode.initialize(TypedArray.prototype) ;
	
	private var _type:Function ;

}