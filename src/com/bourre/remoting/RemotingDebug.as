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
 
import com.bourre.log.LogChannel;
import com.bourre.log.Logger;
import com.bourre.log.LogLevel;
import com.bourre.log.PixlibStringifier;
import com.bourre.utils.ClassUtils;

class com.bourre.remoting.RemotingDebug 
{
	public static var isOn : Boolean = true;
	public static var channel : LogChannel = new LogChannel( ClassUtils.getFullyQualifiedClassName( new RemotingDebug() ) );
	
	private function RemotingDebug() 
	{
		
	}
	
	public static function DEBUG( o ) : Void
	{
		if (RemotingDebug.isOn) Logger.LOG( o, LogLevel.DEBUG, RemotingDebug.channel );
	}
	
	public static function INFO( o ) : Void
	{
		if (RemotingDebug.isOn) Logger.LOG( o, LogLevel.INFO, RemotingDebug.channel );
	}
	
	public static function WARN( o ) : Void
	{
		if (RemotingDebug.isOn) Logger.LOG( o, LogLevel.WARN, RemotingDebug.channel );
	}
	
	public static function ERROR( o ) : Void
	{
		if (RemotingDebug.isOn) Logger.LOG( o, LogLevel.ERROR, RemotingDebug.channel );
	}
	
	public static function FATAL( o ) : Void
	{
		if (RemotingDebug.isOn) Logger.LOG( o, LogLevel.FATAL, RemotingDebug.channel );
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