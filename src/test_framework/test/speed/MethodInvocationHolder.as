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


import test_framework.test.speed.MethodInvocation;

/**
 * {@code MethodInvocationHolder} is a generic interface for tests that build upon
 * method invocations.
 * 
 * @author Simon Wacker
 */
interface test_framework.test.speed.MethodInvocationHolder  {
	
	/**
	 * Returns the held method invocation.
	 * 
	 * @return the held method invocation
	 */
	public function getMethodInvocation(Void):MethodInvocation;
	
}