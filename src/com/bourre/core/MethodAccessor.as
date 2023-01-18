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
 * {@code MethodAccessor} proxies property accesses (getter/setter) for an instance 
 * with two provided methods.
 * 
 * <p>Use {@code Function} access to define getter and setter processes for a specific instance property.
 * 
 * <p>Implements {@link IAccessor} interface.
 * 
 * <p>Take a look at {@link PropertyAccessor} to see another setter implementation.
 * 
 * <p>See {@link AccessorFactory} for accessor automatic build process.
 * 
 * <p>Example
 * <code>
 *   var o : IAccessor = new MethodAccessor( this, setMyProp, getMyProp );
 *   o.setValue( 100 );
 *   var n : Number = o.getValue();
 * </code>
 * 
 * @author Francis Bourre
 * @version 1.0
 */
 
import com.bourre.core.IAccessor;
import com.bourre.log.PixlibStringifier;

class com.bourre.core.MethodAccessor
	implements IAccessor
{
	//-------------------------------------------------------------------------
	// Private properties
	//-------------------------------------------------------------------------
	
	private var _t;
	private var _fSet : Function;	private var _fGet : Function;
	private var _value;
	
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Constructs a new {@code MethodAccessor} instance
	 * 
	 * <p>{@code fSet} and {@code fGet} methods must be defined in {@code t} instance context.
	 * 
	 * @param t Object where {@code f} function is applied
	 * @param fSet {@code t} setter {@code Function} 	 * @param fGet {@code t} getter {@code Function} 
	 */
	public function MethodAccessor( t, fSet : Function, fGet : Function ) 
	{
		_t = t;
		_fSet = fSet;		_fGet = fGet;
	}
	
	/**
	 * Returns current value targeted by the accessor.
	 * 
	 * @return value
	 */
	public function getValue()
	{
		return _fGet? _fGet.call() : _value;
	}
	
	/**
	 * Sets passed-in value to object using setter function defined 
	 * during instanciation.
	 * 
	 * @param value value to set
	 */
	public function setValue( value ) : Void 
	{
		if (!_fGet) _value = value;
		_fSet.call( _t, value );
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
	 * Returns setter method reference.
	 * 
	 * @return {@code Function}
	 */
	public function getMethod() : Function
	{
		return _fSet;
	}
	
	/**
	 * Returns method used by current getter to retrieve object value.
	 * 
	 * @return {@code Function}
	 */
	public function getGetterHelper()
	{
		return _fGet;
	}
	
	/**
	 * Returns method used by current setter to modify object value.
	 * 
	 * @return {@code Function}
	 */
	public function getSetterHelper()
	{
		return _fSet;
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