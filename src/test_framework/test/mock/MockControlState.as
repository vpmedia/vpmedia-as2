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


import test_framework.test.mock.ArgumentsMatcher;
import test_framework.test.mock.MethodCall;
import test_framework.test.mock.MethodCallRange;
import test_framework.test.mock.MethodResponse;

/**
 * {@code MockControlState} determines most of the actual behavior of the
 * {@link MockControl} class.
 * 
 * <p>The actual behavior of the specific methods of this class depends largely on
 * the implementing class. Thus refer to these implementation classes.
 * 
 * @author Simon Wacker
 * @see test.mock.support.ReplayState
 * @see test.mock.support.RecordState
 */
interface test_framework.test.mock.MockControlState  {
	
	/**
	 * Is called when a method is called on the mock proxy.
	 *
	 * @param call contains all information about the method call
	 * @return the return value of the method invocation in replay state
	 * @throws * if the method is set up to throw a throwable in replay state
	 */
	public function invokeMethod(call:MethodCall);
	
	/**
	 * Sets a new method response.
	 *
	 * <dl>
	 *   <dt>Record State</dt>
	 *   <dd>Records that the mock object will expect the last method call the
	 *       specified number of times, and will react by either returning the
	 *       return value, throwing an exception or just doing nothing.</dd>
	 *   <dt>Replay State</dt>
	 *   <dd>Throws an {@code IllegalStateException}.</dd>
	 * </dl>
	 *
	 * @param methodResponse handles incoming requests appropriately
	 * @param methodCallRange stores the minimum and maximum quantity of method calls
	 * @throws env.except.IllegalArgumentException when in replay state
	 */ 
	public function setMethodResponse(methodResponse:MethodResponse, methodCallRange:MethodCallRange):Void;
	
	/**
	 * Sets a new arguments matcher.
	 *
	 * <dl>
	 *   <dt>Record State</dt>
	 *   <dd>Sets the arguments matcher that will be used for the last method specified
	 *       by a method call.</dd>
	 *   <dt>Replay State</dt>
	 *   <dd>Throws an {@code IllegalStateException}.</dd>
	 * </dl>
	 *
	 * @param argumentsMatcher the arguments matcher to use for the specific method
	 * @throws env.except.IllegalArgumentException when in replay state
	 */
	public function setArgumentsMatcher(argumentsMatcher:ArgumentsMatcher):Void;

	/**
	 * Verifies the beahvior.
	 *
	 * <dl>
	 *   <dt>Replay State</dt>
	 *   <dd>Verifies that all expectations have been met.</dd>
	 *   <dt>Record State</dt>
	 *   <dd>Throws an {@code IllegalStateException}.</dd>
	 *
	 * @throws test.mock.AssertionFailedError if any expectation has not
	 * been met in replay state
	 * @throws env.except.IllegalArgumentException when in record state
	 */
	public function verify(Void):Void;
	
}