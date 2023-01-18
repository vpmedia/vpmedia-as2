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
 * {@code AccessorFactory} offers accessor proxy with polymorphic approach. 
 * 
 * <p>Take a look at {@link com.bourre.core} to see available {@link IAccessor} implementations.
 * 
 * <p>{@code AccessorFactory} constructor is private and can't be instanciate; use only defined 
 * static methods.
 * 
 * <p>Example
 * <code>
 *   var o : IAccessor = AccessorFactory.getInstance( this, "_prop" );
 *   o.setValue( 100 );
 *   var n : Number = o.getValue();
 * </code>
 * 
 * @author Francis Bourre
 * @version 1.0
 */
 
import com.bourre.core.IAccessor;
import com.bourre.core.MethodAccessor;
import com.bourre.core.MultiAccessor;
import com.bourre.core.PropertyAccessor;
import com.bourre.log.PixlibStringifier;

class com.bourre.core.AccessorFactory 
{
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Returns {@link IAccessor} instance depending of passed-in {@code f} type.
	 * 
	 * @return {@link MultiAccessor} instance if type of {@code f} is {@code array} or 
	 * returns {@link MethodAccessor} instance if type of {@code f} is {@code function} or 
	 * returns {@link PropertyAccessor} instance.
	 */
	public static function getInstance( t, setter, getter ) : IAccessor
	{
		if ( setter instanceof Array && isNaN( setter[0] ) ) 
		{
			return new MultiAccessor( t, setter, getter );
			
		} else
		{
			return (typeof(setter) == "function") ? new MethodAccessor(t, setter, getter) : new PropertyAccessor(t, setter);
		}
	}
	
	// Private constructor
	private function AccessorFactory()
	{
		
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