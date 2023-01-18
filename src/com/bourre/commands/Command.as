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
 * {@code Command} is the basic interface to encapsulate a request as an object, 
 * thereby letting you parameterize clients with different requests, 
 * queue or log requests, and support undoable operations.
 * 
 * @example
 * // class example
 * import com.bourre.commands.*;
 * 
 * class DisplayDateCommand implements Command
 * {
 *  	private var _tViewHelper:TextField;
 *  	
 *  	public function DisplayDateCommand(tViewHelper:TextField)
 *  	{
 *   		_tViewHelper = tViewHelper;
 *   	}
 *  	
 *  	public function execute() : Void
 *  	{
 *   		_tViewHelper.text = String(new Date());
 *   	}
 * }
 * 
 * // usage:
 * import DisplayDateCommand;
 * 
 * this.createTextField("__txt", 1, 30, 30, 200, 20);
 * var ddc:DisplayDateCommand = new DisplayDateCommand( this.__txt );
 * ddc.execute();
 * 
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.events.IEvent;

interface com.bourre.commands.Command
{
	/**
	 * A concrete Command object always has execute() method that is called when an action occurs.
	 */
	public function execute( e: IEvent ) : Void;
}
