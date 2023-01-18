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
 * {@code Compareable} represents a class that has the ability to compare different
 * instances if they are equal.
 * 
 * <p>The == and the === operators ignore the fact that different instances of
 * the same class with the same value are equal. 
 * 
 * <p>{@code Comparable} allows to implement your own strategy to compare the
 * current instance with a different instance.
 * 
 * @author Martin Heidegger
 * @version 1.0
 * @see util.ObjectUtil#compare
 */
interface test_framework.util.Comparable  {
	
	/**
	 * Compares the instance with the passed-in {@code object}.
	 * 
	 * <p>The implementation compares the passed-in {@code object} if it represents
	 * the same content as the current instance.
	 * 
	 * @return {@code true} if the passed-in {@code object} is equal to the instance.
	 */
	public function compare(object):Boolean;
}