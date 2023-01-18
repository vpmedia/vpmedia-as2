/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Andromeda Framework based on VEGAS.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import andromeda.controller.AbstractController;
import andromeda.core.Command;

/**
 * This event contains a Command object.
 * @author eKameleon
 */
class andromeda.events.CommandEvent extends AbstractController 
{
	
	/**
	 * Creates a new CommandEvent instance.
	 */
	public function CommandEvent( type:String, co:Command ) 
	{
		super(type) ;
		setCommand(co) ;
	}
	
	/**
	 * The name of the event invoqued to run a command.
	 */
	static public var RUN_COMMAND:String = "onRunCommand" ;
	
	/**
	 * Returns the Command reference.
	 * @return the Command reference.
	 */
	public function getCommand():Command
	{
		return _co ;
	}
	
	/**
	 * Sets the Command reference.
	 */
	public function setCommand( co:Command ):Void
	{
		_co = co ;
	}
		
	private var _co:Command ;

}