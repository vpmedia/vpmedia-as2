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
* Math utility class. Bit empty so far huh?
*/
class wilberforce.math.mathUtil
{
	static function between(n1:Number,n2:Number,nTest:Number){
		if (nTest>=Math.min(n1,n2) && nTest<=Math.max(n1,n2)) return true;
		return false;
	}
	
	static function randNum(n1:Number,n2:Number)
	{
		return n1+(n2-n1)*Math.random();
	}
}