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

import test_framework.env.log.handler.AbstractLogHandler;
import test_framework.env.log.level.AbstractLogLevel;
import test_framework.env.log.LogHandler;
import test_framework.env.log.LogLevel;
import test_framework.env.log.LogMessage;
import test_framework.util.Stringifier;

/**
 * {@code FlashDebugToolHandler} the {@code org.actionstep.FDTDebugger.trace} method to log
 * messages.
 * 
 * @author Simon Wacker
 * @see env.log.logger.FlashDebugToolLogger
 * @see <a href="http://sourceforge.net/projects/flashdebugtool">Flash Debug Tool</a>
 */
class test_framework.env.log.handler.FlashDebugToolHandler extends AbstractLogHandler implements LogHandler {
	
	/** Holds a flash debug tool handler instance. */
	private static var flashDebugToolHandler:FlashDebugToolHandler;
	
	/**
	 * Returns an instance of this class.
	 *
	 * <p>This method always returns the same instance.
	 *
	 * <p>The {@code messageStringifier} argument is only recognized on first
	 * invocation of this method.
	 * 
	 * @param messageStringifier (optional) the log message stringifier to be used by
	 * the returned handler
	 * @return a flash debug tool handler
	 */
	public static function getInstance(messageStringifier:Stringifier):FlashDebugToolHandler {
		if (!flashDebugToolHandler) flashDebugToolHandler = new FlashDebugToolHandler(messageStringifier);
		return flashDebugToolHandler;
	}
	
	/**	
	 * Constructs a new {@code FlashDebugToolHandler} instance.
	 *
	 * <p>You can use one and the same instance for multiple loggers. So think about
	 * using the handler returned by the static {@link #getInstance} method. Using this
	 * instance prevents the instantiation of unnecessary trace handlers and saves
	 * storage.
	 * 
	 * @param messageStringifier (optional) the log message stringifier to use
	 */
	public function FlashDebugToolHandler(messageStringifier:Stringifier) {
		super (messageStringifier);
	}
	
	/**
	 * Writes the passed-in {@code message} using the {@code org.actionstep.FDTDebugger.trace}
	 * method.
	 *
	 * <p>The string representation of the {@code message} to log is obtained via
	 * the {@code convertMessage} method.
	 * 
	 * @param message the message to log
	 */
	public function write(message:LogMessage):Void {
		FDTDebugger.trace(convertMessage(message), convertLevel(message.getLevel()));
	}
	
	/**
	 * Converts the As2lib {@code LogLevel} into a Flash Debug Tool level number.
	 * 
	 * @param level the As2lib log level to convert
	 * @return the equivalent Flash Debug Tool level
	 */
	private function convertLevel(level:LogLevel):Number {
		switch (level) {
			case AbstractLogLevel.DEBUG:
				return FDTDebugger.DEBUG;
			case AbstractLogLevel.INFO:
				return FDTDebugger.INFO;
			case AbstractLogLevel.WARNING:
				return FDTDebugger.WARNING;
			case AbstractLogLevel.ERROR:
				return FDTDebugger.ERROR;
			case AbstractLogLevel.FATAL:
				return FDTDebugger.FATAL;
			default:
				return null;
		}
	}
	
}