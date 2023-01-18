﻿/*
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

import test_framework.data.holder.DataHolderException;

/**
 * {@code NoSuchElementException} is thrown if the element you tried to obtain does
 * not exist. This can be the case if you for example call the {@code next} method
 * on an iterator that has no elements left to iterate over.
 * 
 * @author Simon Wacker
 */
class  test_framework.data.holder.NoSuchElementException extends DataHolderException {
	
	/**
	 * Constructs a new {@code NoSuchElementException} instance.
	 *
	 * <p>All arguments are allowed to be {@code null} or {@code undefined}. But if one
	 * is, the string representation returned by the {@code toString} method will not
	 * be complete.
	 *
	 * <p>The {@code args} array should be the internal arguments array of the method
	 * that throws the throwable. The internal arguments array exists in every method
	 * and contains its parameters, the callee method and the caller method. You can
	 * refernce it in every method using the name {@code "arguments"}.
	 *
	 * @param message the message that describes the problem in detail
	 * @param thrower the object that declares the method that throws this exception
	 * @param args the arguments of the throwing method
	 */
	public function NoSuchElementException(message:String, thrower, args:Array) {
		super (message, thrower, args);
	}
	
}