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

import com.bourre.data.collections.Map;
import com.bourre.log.PixlibDebug;
import com.bourre.log.PixlibStringifier;

class com.bourre.data.collections.AbstractFactory
{
	private var _a:Map;
	
	private function AbstractFactory() 
	{
		_a = new Map();
	}
	
	/**
	 * Build instance.<br><br>
	 * <strong>Usage :</strong> <em>f.buildInstance(name, arg0, arg1, argN);</em>
	 * @param name String associated with class reference.
	 */
	private function _buildInstance()
	{
		var sName:String = arguments[0];
		
		if (_a.containsKey( sName ))
		{
			var f:Function = _a.get(sName);
			var o = {__constructor__:f, __proto__:f.prototype};
			arguments.splice(0, 1);
			f.apply(o, arguments );
			return o;
			
		} else
		{
			PixlibDebug.ERROR( "'" + sName + "' class is not available in " + this );
			return null;
		}
	}
	
	public function push( sKey : String, clazz : Function ) : Void
	{
		_a.put( sKey, clazz );
	}
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this );
	}
}