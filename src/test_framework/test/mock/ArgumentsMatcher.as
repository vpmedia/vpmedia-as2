/**
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
 * {@code ArgumentsMatcher} matches a list of expected arguments against a list of
 * actual arguments.
 * 
 * @author Simon Wacker
 */
interface test_framework.test.mock.ArgumentsMatcher  {
	
	/**
	 * Checks if the passed-in {@code expectedArguments} match the
	 * {@code actualArguments}.
	 * 
	 * @param expectedArguments the arguments that are expected
	 * @param actualArguments the actual arguments
	 * @return {@code true} if the arguments match else {@code false}
	 */
	public function matchArguments(expectedArguments:Array, actualArguments:Array):Boolean;
	
}