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
 * {@code SharedObjectUtils} gives tools to load/save
 * data in a {@code SharedObject} structure.
 * 
 * <p>2 static methods are available : {@link #loadLocal} and
 * {@link saveLocal}.
 * 
 * @author Francis Bourre
 * @version 1.0
 */
 
class com.bourre.utils.SharedObjectUtils
{
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Loads shared object data.
	 * 
	 * @param sCookieName {@code SharedObject}'s name
	 * @param sObjectName data's name to retreive.
	 * 
	 * @return {@code sObjectName} value in {@code sCookieName} SharedObject
	 */
	public static function loadLocal(sCookieName:String, sObjectName:String) 
	{	
		var save = SharedObject.getLocal(sCookieName, "/");
		return save.data[sObjectName];
	}
	
	/**
	 * Saves shared object data.
	 * 
	 * @param sCookieName {@code SharedObject}'s name
	 * @param sObjectName data's name to save.
	 * @param refValue data's value
	 */
	public static function saveLocal(sCookieName:String, sObjectName:String, refValue)
	{
		var save = SharedObject.getLocal(sCookieName, "/");
		save.data[sObjectName] = refValue;
		save.flush();
	}
	
	
	//-------------------------------------------------------------------------
	// Private implementation
	//-------------------------------------------------------------------------
	
	/**
	 * Constructs a new {@code SharedObjectUtils} instance.
	 */
	private function SharedObjectUtils()
	{
		//
	}
	
}