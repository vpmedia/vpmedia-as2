/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is PEGAS Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import pegas.events.ActionEvent;
import pegas.process.Action;

import vegas.events.AbstractCoreEventDispatcher;

/**
 * A simple representation of the {@code Action} interface.
 * @author eKameleon
 */
class pegas.process.SimpleAction extends AbstractCoreEventDispatcher implements Action
{
	
	/**
	 * Creates a new SimpleAction instance.
	 * @param bGlobal the flag to use a global event flow or a local event flow.
	 * @param sChannel the name of the global event flow if the {@code bGlobal} argument is {@code true}.
	 */
	function SimpleAction( bGlobal:Boolean, sChannel:String ) 
	{
		super(bGlobal, sChannel);		
		_eFinish = new ActionEvent(ActionEvent.FINISH, this) ;
		_eStart = new ActionEvent(ActionEvent.START, this) ;
	}

	/**
	 * (read-only) Returns {@code true} if the process is in progress.
	 * @return {@code true} if the process is in progress.
	 */
	public function get running():Boolean 
	{
		return getRunning() ;	
	}
	
	/**
	 * Returns a shallow copy of this object.
	 * @return a shallow copy of this object.
	 */
	public function clone() 
	{
		return new SimpleAction() ;
	}

	/**
	 * Returns {@code true} if the process is in progress.
	 * @return {@code true} if the process is in progress.
	 */
	public function getRunning():Boolean 
	{
		return _isRunning ;	
	}

	/**
	 * Notify an ActionEvent when the process is finished.
	 */
	public function notifyFinished():Void 
	{
		dispatchEvent(_eFinish) ;
	}

	/**
	 * Notify an ActionEvent when the process is started.
	 */
	public function notifyStarted():Void 
	{
		dispatchEvent(_eStart) ;
	}
	
	/**
	 * Run the process.
	 */
	public function run():Void 
	{
		// 
	}

	private var _eFinish:ActionEvent ;
	private var _eStart:ActionEvent ;
	private var _isRunning:Boolean ;

	/**
	 * This protected method is an internal method to change the _isRunning value.
	 */
	/*protected*/ private function _setRunning(b:Boolean):Void 
	{
		_isRunning = b ;	
	}
	
}
	