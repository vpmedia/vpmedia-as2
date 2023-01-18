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


import test_framework.env.reflect.ClassInfo;
import test_framework.test.speed.ConfigurableTestSuiteResult;
import test_framework.test.speed.layout.MethodLayout;
import test_framework.test.speed.MethodInvocation;
import test_framework.test.speed.SimpleTestSuiteResult;
import test_framework.test.speed.TestResultLayout;
import test_framework.test.speed.TestSuiteResult;

/**
 * {@code ClassLayout} lays test suite results out with classes as root elements of the
 * structure.
 * 
 * @author Simon Wacker
 */
class test_framework.test.speed.layout.ClassLayout implements TestResultLayout {
	
	/** The result of the lay-outing of the current test suite result. */
	private var result:ConfigurableTestSuiteResult;
	
	/** All method invocations of the test suite result to lay-out. */
	private var methodInvocations:Array;
	
	/**
	 * Constructs a new {@code ClassLayout} instance.
	 */
	public function ClassLayout(Void) {
	}
	
	/**
	 * Lays the passed-in {@code testSuiteResult} out with classes as root elements of
	 * the structure and returns a new lay-outed test suite result.
	 * 
	 * @param testSuiteResult the test suite result to lay-out
	 * @return the lay-outed test suite result
	 */
	public function layOut(testSuiteResult:TestSuiteResult):TestSuiteResult {
		this.result = new SimpleTestSuiteResult(testSuiteResult.getName());
		this.methodInvocations = testSuiteResult.getAllMethodInvocations();
		for (var i:Number = 0; i < this.methodInvocations.length; i++) {
			var methodInvocation:MethodInvocation = this.methodInvocations[i];
			i -= addMethodInvocations(ClassInfo(methodInvocation.getMethod().getDeclaringType()));
		}
		this.result.sort(SimpleTestSuiteResult.TIME, true);
		return this.result;
	}
	
	/**
	 * Adds all method invocations of methods of the passed-in {@code clazz} to the
	 * result and removes these invocations from the {@code methodInvocations} array.
	 * 
	 * @param clazz the class to add method invocations for
	 * @return the number of removed method invocations
	 */
	private function addMethodInvocations(clazz:ClassInfo):Number {
		var count:Number = 0;
		var classResult:ConfigurableTestSuiteResult = new SimpleTestSuiteResult(clazz.getFullName());
		for (var i:Number = 0; i < this.methodInvocations.length; i++) {
			var methodInvocation:MethodInvocation = this.methodInvocations[i];
			if (methodInvocation.getMethod().getDeclaringType() == clazz) {
				classResult.addTestResult(methodInvocation);
				this.methodInvocations.splice(i, 1);
				i--;
				count++;
			}
		}
		this.result.addTestResult((new MethodLayout()).layOut(classResult));
		return count;
	}
	
}