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
 * {@code PropertyAccessor} proxies property accesses (getter/setter) for an instance.
 * 
 * <p>Use {@code String} access to define accessor process for a specific instance property.
 * 
 * <p>Implements {@link IAccessor} interface.
 * 
 * <p>Take a look at {@link MethodAccessor} to see another accessor implementation.
 * 
 * <p>See {@link AccessorFactory} for accessor automatic build process.
 * 
 * <p>Example
 * <code>
 *   var o : IAccessor = new PropertyAccessor( this, "__prop" );
 *   o.setValue( 100 );
 *   var n : Number = o.getValue();
 * </code>
 * 
 * @author Francis Bourre
 * @version 1.0
 */
 
import com.bourre.core.IAccessor;
import com.bourre.log.PixlibDebug;
import com.bourre.log.PixlibStringifier;
 
class com.bourre.core.PropertyAccessor
	implements IAccessor
{
	//-------------------------------------------------------------------------
	// Private implementation
	//-------------------------------------------------------------------------
	
	private var _t;
	private var _p:String;
	
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Constructs a new {@code PropertyAccessor} instance
	 * 
	 * <p>{@code p} property name must be defined in {@code t} instance context.
	 * 
	 * @param t Object where {@code f} function is applied
	 * @param p {@code String} property name 
	 */
	public function PropertyAccessor( t, p : String ) 
	{
		_t =t;
		_p = p;
		
		if (!p)
		{
			PixlibDebug.ERROR( this + " was used with invalid property for " + _t + ". Passed property must be a String." );
		}
	}
	
	/**
	 * Returns current value targeted by the accessor.
	 * 
	 * @return value
	 */
	public function getValue()
	{
		return _t[_p];
	}
	
	/**
	 * Sets passed-in value to object using setter property name defined 
	 * during instanciation.
	 * 
	 * @param value value to set
	 */
	public function setValue( value ) : Void 
	{
		_t[_p] = value;
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
	 * Returns property used by current getter to retrieve object value.
	 * 
	 * @return {@code String}
	 */
	public function getGetterHelper()
	{
		return _p;
	}
	
	/**
	 * Returns property used by current setter to modify object value.
	 * 
	 * @return {@code String}
	 */
	public function getSetterHelper()
	{
		return _p;
	}
	
	/**
	 * Returns property name.
	 * 
	 * @return {@code String}
	 */
	public function getProperty() : String
	{
		return _p;
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