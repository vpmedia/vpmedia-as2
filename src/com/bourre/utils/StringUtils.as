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
 * @author Francis Bourre
 * @version 1.0
 */

class com.bourre.utils.StringUtils 
{
	private function StringUtils() 
	{
		
	}
	
	public static function getFormattedTime( ms : Number ) : String
	{
		var h : Number = Math.floor(ms / 3600);
		var m : Number = Math.floor((ms - (h * 3600)) / 60);
		var s : Number = ms - ((h * 3600) + (m * 60));
		return (h<10?"0"+h:String(h)) + ":" + (m<10?"0"+m:String(m)) + ":" + (s<10?"0"+s:String(s));
	}
}