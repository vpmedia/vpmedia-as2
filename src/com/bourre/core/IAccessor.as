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
 * {@code IAccessor} defines basic rules for {@code setter} implementation.
 * 
 * <p>Take a look at {@link com.bourre.core} package to see {@code IAccessor} 
 * implementations.
 * 
 * @author Francis Bourre
 * @version 1.0 
 */

interface com.bourre.core.IAccessor 
{
	/**
	 * Returns current value targeted by the setter.
	 * 
	 * @return value
	 */
	public function getValue();
	
	/**
	 * Sets passed-in value to object using setter function defined 
	 * during concrete instanciation.
	 * 
	 * @param value value to set
	 */
	public function setValue( value ) : Void;
	
	/**
	 * Returns object targeted by current setter.
	 * 
	 * @return instance
	 */
	public function getTarget();
	
	/**
	 * Returns method or property used by current getter to retrieve object value.
	 * 
	 * @return {@code String} property or {@code Function}
	 */
	public function getGetterHelper();
	
	/**
	 * Returns method or property used by current setter to modify object value.
	 * 
	 * @return {@code String} property or {@code Function}
	 */
	public function getSetterHelper();
}