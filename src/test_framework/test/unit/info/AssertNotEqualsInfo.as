﻿/**
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

import test_framework.test.unit.AbstractAssertInfo;
import test_framework.util.ObjectUtil;
import test_framework.util.StringUtil;

/**
 * Information holder and examiner of a assertNotEquals call.
 * 
 * @author Martin Heidegger.
 */
class test_framework.test.unit.info.AssertNotEqualsInfo extends AbstractAssertInfo {
	
	/** Internal holder of the variable value. */
	private var val;
	
	/** Internal holder of the value to compare. */
	private var compareTo;
	
	/**
	 * Constructs a new AssertNotEmptyInfo.
	 * 
	 * @param message Message if the assertion fails.
	 * @param val Value to be compared.
	 * @param compareTo Value to be compared with.
	 */
	public function AssertNotEqualsInfo(message:String, val, compareTo) {
		super(message);
		this.val = val;
		this.compareTo = compareTo;
	}
	
	/**
	 * Overriding of @see AbstractAssertInfo#execute
	 * 
	 * @return True if the execution fails.
	 */
	public function execute(Void):Boolean {
		return ObjectUtil.compare(val,compareTo);
	}
	
	/**
	 * Implementation of @see AbstractAssertInfo#getFailureMessage
	 * 
	 * @return Message on failure
	 */
	private function getFailureMessage(Void):String {
		var result:String = "assertNotEquals failed";
		if(hasMessage()) {
			result += " with message: "+message;
		}
		var valStr:String;
		try {
			valStr = val.toString();
		} catch (e) {
			valStr = "[object Object]";
		}
		var compareToStr:String; 
		try {
			compareToStr = compareTo.toString();
		} catch (e) {
			compareToStr = "[object Object]";
		}
		result += "!\n"+StringUtil.addSpaceIndent(valStr+" == "+compareToStr, 2);
		return result;
	}
	
	/**
	 * Implementation of @see AbstractAssertInfo#getSuccessMessage
	 * 
	 * @return Message on success
	 */
	private function getSuccessMessage(Void):String {
		return ("assertNotEquals executed. "+val+" != "+compareTo+".");
	}
}