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
 
import com.bourre.events.BasicEvent;
import com.bourre.events.EventType;
import com.bourre.log.PixlibStringifier;
import com.bourre.remoting.ServiceMethod;

class com.bourre.remoting.BasicResultEvent 
	extends BasicEvent
{
	private var _oResult;
	private var _oServiceMethod : ServiceMethod;
	
	public function BasicResultEvent( e : EventType, result, sServiceMethodName : ServiceMethod ) 
	{
		super( e );
		
		_oResult = result;
		_oServiceMethod = sServiceMethodName;
	}
	
	public function getResult()
	{
		return _oResult;
	}
	
	public function redirectType() : Void
	{
		if (_oServiceMethod instanceof ServiceMethod) setType( _oServiceMethod );
	}
	
	public function getServiceMethodName() : ServiceMethod
	{
		return _oServiceMethod;
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