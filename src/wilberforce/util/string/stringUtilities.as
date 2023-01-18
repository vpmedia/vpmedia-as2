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
 * @author Simon Oliver
 * @version 1.0
 */
 
/**
* String utility class for basic operations such as replacing text 
*/
class wilberforce.util.string.stringUtilities {
	
	/** Replace matching patterns in a passed string with a replacement pattern
	* @param tString The string to be modifed
	* @param tPat1 The search pattern
	* @param tPat2 The replacement pattern
	* @return The Modified string
	*/
	static public function replaceText(tString,tPat1,tPat2) {
		var tSplit=tString.split(tPat1)
		var tNewText="";
		for (var i=0;i<tSplit.length;i++) {
			tNewText+=tSplit[i];
			if (i<(tSplit.length-1)) {
				tNewText+=tPat2;
			}
		}
		return tNewText;
	}
}

