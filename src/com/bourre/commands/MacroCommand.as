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
 * {@code MacroCommand} is the basic interface to handle several commands as one command.
 * @see com.bourre.commands.Batch
 * @author Francis Bourre
 * @version 1.0
 */
 
import com.bourre.commands.Command;

interface com.bourre.commands.MacroCommand extends Command
{
	/**
	 * Add command to MacroCommand instance.
	 * Usage :</strong> <em>mc.addCommand(myCommand);</em>
	 * @param oCommand Command instance to add.
	 */
 	public function addCommand(oCommand:Command) : Void;
	
	/**
	 * Remove command to MacroCommand instance.
	 * Usage :</strong> <em>mc.removeCommand(myCommand);</em>
	 * @param oCommand Command instance to remove.
	 */
	public function removeCommand(oCommand:Command) : Void;
}