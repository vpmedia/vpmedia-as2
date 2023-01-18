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
 * {@code LogListener} is used to actually log messages.
 * 
 * <p>If you want to add some new "tracer" for Logging API,
 * classes must implements this interface.
 * 
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.log.LogEvent;

interface com.bourre.log.LogListener
{
	/**
	 * Sends log message obtained from the passed-in {@code e} model to all
	 * registred {@code Logger} listeners.
	 *
	 * @param e A {@link LogEvent} instance
	 */
	public function onLog( e:LogEvent ) : Void;
}