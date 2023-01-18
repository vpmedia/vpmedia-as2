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

class com.bourre.remoting.BasicFaultEvent extends BasicEvent 
{
	private var _sCode : String;
	private var _sLine : String;
	private var _sLevel : String;
	private var _sDetail : String;
	private var _sDescription : String;
	private var _sExceptionStack : String;

	private var _sServiceMethodName : ServiceMethod;
	
	/**
	 * @param	code
	 * @param	line
	 * @param	level
	 * @param	details
	 * @param	description
	 * @param	exceptionStack
	 */
	public function BasicFaultEvent( e : EventType, 
								code : String, 
								line : String, 
								level : String, 
								details : String, 
								description : String,
								exceptionStack : String,
								sServiceMethodName : ServiceMethod )
	{
		super( e );
		
		_sCode = code;
		_sLine = line;
		_sLevel = level;
		_sDetail = details;
		_sDescription = description;
		_sExceptionStack = exceptionStack;
		_sServiceMethodName = sServiceMethodName;
	}

	public function getCode() : String
	{
		return _sCode;
	}
	
	public function getLine() : String
	{
		return _sLine;
	}
	
	public function getLevel() : String
	{
		return _sLevel;
	}
	
	public function getDetail() : String
	{
		return _sDetail;
	}
	
	public function getDescription() : String
	{
		return _sDescription;
	}
	
	public function getExceptionStack() : String
	{
		return _sExceptionStack;
	}
	
	public function getServiceMethodName() : ServiceMethod
	{
		return _sServiceMethodName;
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