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
 * {@code PixlibDebug} defines specific channel filter for logging API.
 * 
 * <p>{@code PixlibDebug} is used for Pixlib internal messages.
 * 
 * <p>If you want to retreive all Pixlib messages, you have to register a
 * {@link LogListener} for {@code PixlibDebug.channel} channel.
 * 
 * <p>Example
 * <code>
 *   Logger.getInstance().addLogListener( SosTracer.getInstance(), PixlibDebug.channel );
 * </code>
 * 
 * @author Francis Bourre
 * @version 1.0
 */
 
import com.bourre.log.LogChannel;
import com.bourre.log.Logger;
import com.bourre.log.LogLevel;
import com.bourre.log.PixlibStringifier;
import com.bourre.utils.ClassUtils;

class com.bourre.log.PixlibDebug
{
	public static var isOn : Boolean = true;
	public static var channel : LogChannel = new LogChannel( ClassUtils.getFullyQualifiedClassName( new PixlibDebug() ) );
	
	private function PixlibDebug() 
	{
		
	}
	
	public static function DEBUG( o ) : Void
	{
		if (PixlibDebug.isOn) Logger.LOG( o, LogLevel.DEBUG, PixlibDebug.channel );
	}
	
	public static function INFO( o ) : Void
	{
		if (PixlibDebug.isOn) Logger.LOG( o, LogLevel.INFO, PixlibDebug.channel );
	}
	
	public static function WARN( o ) : Void
	{
		if (PixlibDebug.isOn) Logger.LOG( o, LogLevel.WARN, PixlibDebug.channel );
	}
	
	public static function ERROR( o ) : Void
	{
		if (PixlibDebug.isOn) Logger.LOG( o, LogLevel.ERROR, PixlibDebug.channel );
	}
	
	public static function FATAL( o ) : Void
	{
		if (PixlibDebug.isOn) Logger.LOG( o, LogLevel.FATAL, PixlibDebug.channel );
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