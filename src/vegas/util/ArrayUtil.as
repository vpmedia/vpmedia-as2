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

import vegas.errors.ArgumentOutOfBoundsError;
import vegas.util.Copier;

/**
 * The {@code ArrayUtil} utility class is an all-static class with methods for working with array.
 * <p>You do not create instances of {@code ArrayUtil}, instead you call static methods.</p>
 * @author eKameleon
 */
class vegas.util.ArrayUtil 
{

    /**
     * Creates a shallow copy of the Array.
     * @return a shallow copy of the Array.
     */
	static public function clone(ar:Array):Array 
	{
		return ar.slice() ;
	}

    /**
     * Returns whether the Array contains a particular item.
     * @param ar the Array to check.
     * @param value the value to find in the array.
     */
	static public function contains( ar:Array , value:Object):Boolean 
	{
		return (indexOf(ar, value) > -1) ;
	}

    /**
     * Returns and creates a deep copy of the Array.
     * @param ar the Array to copy.
     * @return a deep copy of the specified Array passed in argument.
   	 */
	static public function copy(ar:Array):Array 
	{
		var a:Array = [] ;
		var i:Number ;
		var l:Number = ar.length ;
		for (i = 0 ; i < l ; i++) 
		{
			if( ar[i] === undefined ) 
			{
				a[i] = undefined ;
			}
			else if( ar[i] === null ) 
			{
				a[i] = null ;
            } 
            else 
            {
				a[i] = Copier.copy(ar[i]) ;
			}
		}
		return a ;
	}

	/**
	 * Returns {@code true} if every element in this array satisfies the provided testing function.
	 * <p>{@code every} executes the provided {@code callback} function once for each element present in the array until it finds one where callback returns a false value. If such an element is found, the every method immediately returns {@code false}.</p>
	 * <p>Otherwise, if {@code callback} returned a {@code true} value for all elements, every will return {@code true}.</p>
	 * <p>{@code callback} is invoked only for indexes of the array which have assigned values; it is not invoked for indexes which have been deleted or which have never been assigned values.</p>
	 * <p>{@code callback} is invoked with three arguments: the value of the element, the index of the element, and the Array object being traversed.</p>
	 * <p><b>Example :</b></p>
	 * {@code
	 * import vegas.util.ArrayUtil ;
	 * 
	 * function isBigEnough(element, index, array) 
	 * {
	 *     return (element >= 10);
	 * }
	 * var passed ;
	 * passed = ArrayUtil.every([12, 5, 8, 130, 44], isBigEnough) ; // passed is false
	 * passed = ArrayUtil.every([12, 54, 18, 130, 44], isBigEnough); // passed is true
	 * 
	 * }
	 * @param ar the array to transform.
	 * @param callback Function to test for each element.
	 * @param o Object to use as this when executing callback.
	 * @return {@code true} if every element in this array satisfies the provided testing function.
	 */
	static public function every(ar:Array, callback:Function, o:Object ):Boolean 
	{
		if(!o) o = _global ;
		var len:Number = ar.length ;
		for (var i:Number = 0 ; i<len ; i++) 
		{
			if( !callback.call( o, ar[i], i, ar ) ) 
			{
				return false ;
			}
        }
		return true ;
    }

	/**
	 * Calls a provided callback function once for each element in an array, and constructs a new array of all the values for which callback returns a true value.
	 * <p>{@code callback} is invoked only for indexes of the array which have assigned values;
	 * it is not invoked for indexes which have been deleted or which have never been assigned values.</p> 
	 * <p>Array elements which do not pass the callback test are simply skipped, and are not included in the new array.</p>
	 * <p>{@code callback} is invoked with three arguments: the value of the element, the index of the element, and the Array object being traversed.</p>
	 * <p>If a {@code thisObject} parameter is provided to filter, it will be used as the this for each invocation of the callback. If it is not provided, or is {@code null}, the global object associated with callback is used instead.</p>
	 * <p>filter does not mutate the array on which it is called.</p>
	 * <p>The range of elements processed by filter is set before the first invocation of {@code callback}. 
	 * Elements which are appended to the array after the call to filter begins will not be visited by {@code callback}. 
	 * If existing elements of the array are changed, or deleted, their value as passed to callback will be the value at the time filter visits them; elements that are deleted are not visited.</p>
	 * <p><b>Example :</b></p>
	 * {@code
	 * import vegas.util.ArrayUtil ;
	 * 
	 * function isBigEnough(element, index, array) 
	 * {
	 *     return (element >= 10) ;
	 * }
	 * var ar:Array = [12, 5, 8, 130, 44] ;
	 * var filtered:Array = ArrayUtil.filter(ar, isBigEnough);
	 * trace(ar + " : " + filtered) ;
	 * }
	 * @param ar the Array to filter.
	 * @param callback Function to test each element of the array.
	 * @param thisObject Object to use as this when executing callback.
	 * @return a new array of all the values for which callback returns a true value.
	 */
	static public function filter( ar:Array, callback:Function, thisObject ):Array
	{
		var arr:Array = [];
        if( thisObject == null ) 
        {
        	thisObject = _global ;
        }
		var len:Number = ar.length ;
		for( var i:Number = 0; i<len ; i++ )
		{
        	if( callback.call( thisObject, ar[i], i, ar ) )
	        {
				if( ar[i] === undefined )
				{
					arr.push( undefined );
					continue;
				}
				if( ar[i] === null )
	            {
                	arr.push( null );
                    continue;
				}
                	arr.push( Copier.copy(ar[i]) );
			}
                	
		}
        return arr;
	}

	/**
	 * Executes the provided function (callback) once for each element present in the array. callback is invoked only for indexes of the array which have assigned values; it is not invoked for indexes which have been deleted or which have never been assigned values.
	 * <p>{@code callback} is invoked with three arguments: the value of the element, the index of the element, and the Array object being traversed.</p>
	 * <p>If a {@code thisObject} parameter is provided to forEach, it will be used as the this for each invocation of the callback. If it is not provided, or is null, the global object associated with callback is used instead.</p>
	 * <p>forEach does not mutate the array on which it is called.</p>
	 * <p>The range of elements processed by forEach is set before the first invocation of callback. 
	 * Elements which are appended to the array after the call to forEach begins will not be visited by callback. If existing elements of the array are changed, or deleted, their value as passed to callback will be the value at the time forEach visits them; 
	 * elements that are deleted are not visited.</p>
	 * <p><b>Example :</b></p>
	 * {@code
	 * import vegas.util.ArrayUtil ;
	 * 
	 * var stack:Array = [] ;
	 * 
	 * var printElt:Function = function(element, index, array) 
	 * {
	 *     stack.push("[" + index + "] is " + element); // assumes print is already defined
	 * }
	 * 
	 * ArrayUtil.forEach([2, 5, 9], printElt);
	 * 
	 * trace(stack) ;
	 * }
	 * @param ar the array to transform.
	 * @param callback Executes a provided function once per array element.
	 * @param o Object to use as this when executing callback.
	 */
	static public function forEach(ar:Array, callback:Function, o):Void 
	{
        var len:Number = ar.length ; 
		var i:Number ;
        if( o == null ) o = _global ;
        for( i=0; i<len ; i++ ) 
        {
        	callback.call(o, ar[i], i, ar) ;
        }
    }

	/**
	 * Returns an new array from arguments in a function.
	 * @return an new array from arguments in a function.
	 */
	static public function fromArguments( ar:Array, args:Array ):Array 
	{
		return ar.concat(args) ;	
    }
    
	/**
	 * Returns the index of the first occurrence of a value in a one-dimensional Array or in a portion of the Array.
	 * @param ar the array reference.
	 * @param value the value to search in the array.
	 * @param startIndex optionnal, allows to specify the starting index of the search.
	 * @param count	allows to limit the number of elements to search in the array.
	 * @return the index of the first occurrence of a value in a one-dimensional Array or in a portion of the Array.
	 */
	static public function indexOf( ar:Array, value:Object, startIndex:Number, count:Number):Number 
	{
		var l:Number = ar.length ;
		if(isNaN(startIndex) ) startIndex = 0 ;
        if(isNaN(count)) 
        {
        	count = ar.length  - startIndex ;
        }
		if (startIndex < 0 || startIndex > l) 
		{
			throw new ArgumentOutOfBoundsError("ArrayUtil.indexOf : 'startIndex' must be between 0 and " + l + ".");
		}
		if (count < 0 || count > (l - startIndex)) 
		{
			throw new ArgumentOutOfBoundsError("ArrayUtil.indexOf : 'count' must be between 'startIndex' and the array size -1.") ;
		}
		for (var i:Number = 0 ; startIndex < l ; startIndex++ , i++) 
		{
			if (ar[startIndex] == value) 
			{
				return startIndex ;
			} 
			if (i == count) 
			{
				break ;
			}
		}
		return -1 ;
	}

	/**
	 * Creates and Initializes an Array.
	 * @return a new Array fill by the specified value.
	 */
	static public function initialize(index:Number, value:Object):Array 
	{
		if( isNaN(index) ) 
		{
			index = 0 ;
		}
		if( value === undefined ) 
		{
			value = null ;
		}
        var ar:Array = [] ;
		for( var i:Number = 0 ; i<index ; i++ ) 
		{
			ar[i] = value ;
		}
		return ar ;
    }

	/**
	 * Returns the last (greatest) index of an element within the array equal to the specified value, or -1 if none is found.
	 * <p><b>Example :</b></p>
	 * {@code
	 * import vegas.util.ArrayUtil ;
	 * var ar:Array = [2, 3, 4, 2, 5] ;
	 * var index:Number = ArrayUtil.lastIndexOf(2) ; 
	 * trace(index) ; // 3
	 * }
	 * @return the last (greatest) index of an element within the array equal to the specified value, or -1 if none is found.
	 */
	static public function lastIndexOf( ar:Array, o ) :Number 
	{
		var l:Number = ar.length;
		while ( --l > -1 ) if (ar[l] == o) return l ; 
		return -1 ;
	}

	/**
	 * Creates a new array with the results of calling a provided function on every element in this array.
	 * <p>{@code map} calls a provided callback function once for each element in an array, in order, and constructs a new array from the results. 
	 * {@code callback} is invoked only for indexes of the array which have assigned values; it is not invoked for indexes which have been deleted or which have never been assigned values.</p>
	 * <p>{@code callback} is invoked with three arguments: the value of the element, the index of the element, and the Array object being traversed.</p>
	 * <p>If a {@code thisObject} parameter is provided to map, it will be used as the this for each invocation of the callback. If it is not provided, or is null, the global object associated with callback is used instead.</p>
	 * <p>{@code map} does not mutate the array on which it is called.</p>
	 * <p>The range of elements processed by map is set before the first invocation of {@code callback}. 
	 * Elements which are appended to the array after the call to map begins will not be visited by {@code callback}. 
	 * If existing elements of the array are changed, or deleted, their value as passed to callback will be the value at the time map visits them; elements that are deleted are not visited.</p>
	 * <p><b>Example :</b></p>
	 * {@code
	 * import vegas.util.ArrayUtil ;
	 * 
	 * var makeUpperCase:Function = function( element )
	 * {
	 *     return element.toUpperCase() ;
	 * }
	 * 
	 * var ar:Array = ["hello", "WorlD", "Yoo"] ;
	 * var uppers = ArrayUtil.map(ar, makeUpperCase) ;
	 * // uppers is now ["HELLO", "WORLD", "YOO"].
	 * // ar is unchanged.
	 * }
	 * @param ar the array to map.
	 * @param callback Function produce an element of the new Array from an element of the current one.
	 * @param thisObject Object to use as this when executing callback.
	 */
	static public function map( ar:Array, callback:Function, thisObject ):Array 
	{
        
		var arr:Array = [] ;
		var i:Number ;

		if( thisObject == null ) thisObject = _global;
		var l:Number = ar.length ;
        for(i=0 ; i<l ; i++ ) {
            arr[i] = callback.call( thisObject, ar[i], i, ar ) ;
        }
        
        return arr ;
    
    }
    
	/**
	 * Splices an array (removes an element) and returns either the entire array or the removed element.
	 * <p>{@code
	 * import vegas.util.ArrayUtil ;
	 * var ar = new Array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9);
	 * trace("+ " + ar);
	 * ArrayUtil.pierce( ar, 1 ) ;
	 * trace("+ " + ar) ;
	 * }
	 * </p>
	 * @param ar the array.
	 * @param index the index of the array element to remove from the array.
	 * @param flag a boolean {@code true} to return a new spliced array of false to return the removed element.
	 * @return The newly spliced array or the removed element in function of the flag parameter.
	 */
	static public function pierce(ar:Array, index:Number, flag:Boolean ) 
	{
 		var item = ar[index] ;
 		ar.splice(index, 1) ;
  		return (flag) ? ar : item ;
	}

	/**
	 * Tests whether some element in the array passes the test implemented by the provided function.
	 * <p>{@code some} executes the {@code callback} function once for each element present in the array until it finds one where callback returns a {@code true} value. 
	 * If such an element is found, some immediately returns {@code true}. Otherwise, some returns false. {@code callback} is invoked only for indexes of the array which have assigned values; it is not invoked for indexes which have been deleted or which have never been assigned values.</p>
	 * <p>{@code callback} is invoked with three arguments: the value of the element, the index of the element, and the Array object being traversed.</p>
	 * <p>If a {@code thisObject} parameter is provided to some, it will be used as the this for each invocation of the callback. If it is not provided, or is null, the global object associated with callback is used instead.</p>
	 * <p>{@code some} does not mutate the array on which it is called.</p>
	 * <p>The range of elements processed by some is set before the first invocation of callback. Elements that are appended to the array after the call to some begins will not be visited by callback. If an existing, unvisited element of the array is changed by callback, its value passed to the visiting callback will be the value at the time that some visits that element's index; elements that are deleted are not visited.</p>
	 * <p><b>Example :</b></p>
	 * The following example tests whether some element in the array is bigger than 10.
	 * {@code
	 * import vegas.util.ArrayUtil ;
	 * function isBigEnough(element, index, array) 
	 * {
	 *     return (element >= 10);
	 * }
	 * var passed:Boolean ;
	 * passed = ArrayUtil.some([2, 5, 8, 1, 4], isBigEnough)  ; // passed is false
	 * passed = ArrayUtil.some([12, 5, 8, 1, 4], isBigEnough) ; // passed is true
	 * }
	 * @param ar The array to some.
	 * @param callback Function to test for each element.
	 * @param thisObject Object to use as this when executing callback.
	 */
	static public function some( ar:Array, callback:Function, thisObject):Boolean 
	{
        
        var len:Number = ar.length ;
        var i:Number = 0 ;
        
        if( thisObject == null ) thisObject = _global ;
       
        for( i=0; i<len; i++ ) 
        {
            if( callback.call( thisObject, ar[i], i, ar ) ) 
            {
            	return true ;
            }
		}
        
        return false;
   
    }

	/**
	 * Shuffles an array.
	 * <p>{@code
	 * import vegas.util.ArrayUtil ;
	 * var ar = new Array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9);
	 * trace("+ " + ar);
	 * ArrayUtil.shuffle(ar);
	 * trace("+ " + ar) ;
	 * }
	 * </p>
	 * @return the shuffled array.
	 * @see ArrayUtil {@code pierce()} method.
	 */
	static public function shuffle( ar:Array) 
	{
 		var tmp:Array = [] ;
 		var len = ar.length;
 		var index = len - 1 ;
 		for (var i:Number = 0; i < len; i++) 
 		{
  			tmp.push( ArrayUtil.pierce( ar, Math.round(Math.random() * index), false) );
  			index-- ;
 		}
 		while(--len > -1) 
 		{
  			ar[len] = tmp[len] ;
 		}
 		return ar ;
	}

	/**
	 * Returns a string representing the specified array and its elements.
	 * @return a string representing the specified array and its elements.
	 */
	static public function toString(ar:Array, strJoin:String ):String 
	{
		return ar.join( strJoin || "," ) ;
	}
	
}