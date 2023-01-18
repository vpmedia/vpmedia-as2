/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
/**
 * @author Francis Bourre
 * @version 1.0
 */
 
import com.bourre.core.AccessorFactory;
import com.bourre.core.IAccessor;
import com.bourre.log.PixlibStringifier;

class com.bourre.core.MultiAccessor 
	implements IAccessor
{
	private var _a : Array;
	private var _t;
	private var _aGet : Array;	private var _aSet : Array;
	
	/**
	 * Constructs a new {@code MultiAccessor} instance
	 * 
	 * <p>{@code p} property name or must be defined in {@code t} instance context.
	 * 
	 * @param t Object where {@code f} function is applied
	 * @param aSet {@code String} property name or {@code Function} method reference to proxy setter access.	 * @param aGet {@code Function} method reference to proxy getter access.
	 */
	public function MultiAccessor( t, aSet, aGet ) 
	{
		_a = new Array();
		_t = t;
		_aSet = aSet;		_aGet = aGet;
		
		var l : Number = aSet.length;
		var isMultiTarget : Boolean = (t instanceof Array);
		for ( var i : Number = 0; i < l; i++ ) _a.push( AccessorFactory.getInstance( isMultiTarget?_t[i]:t, _aSet[i], _aGet[i] ) );
	}
	
	/**
	 * Returns current values targeted by the accessor.
	 * 
	 * @return Array
	 */
	public function getValue()
	{
		var l : Number = _a.length;
		var a : Array = new Array();
		for ( var i : Number = 0; i < l; i++ ) a[i] = IAccessor( _a[i] ).getValue();
		return a;
	}

	/**
	 * Sets passed-in values to object using associated accessor
	 * during instanciation.
	 * 
	 * @param {@code Array} values to set
	 */
	public function setValue( value ) : Void 
	{
		var l : Number = _a.length;
		for ( var i : Number = 0; i < l; i++ ) IAccessor( _a[i] ).setValue( value[i] );
	}
	
	/**
	 * Returns object target.
	 * 
	 * <p>Where accessor is applied
	 * 
	 * @return object instance (relaxed type)
	 */
	public function getTarget() 
	{
		return _t;
	}
	
	/**
	 * Returns getters references array.
	 * 
	 * @return {@code Array}
	 */
	public function getGetterHelper()
	{
		return _aGet;
	}

	/**
	 * Returns setters references array.
	 * 
	 * @return {@code Array}
	 */
	public function getSetterHelper() 
	{
		return _aSet;
	}

	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this );
	}
}