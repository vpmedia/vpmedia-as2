/**
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
 * 
 * 
 * The Initial Developer of the Original Code is
 * DELOISON Matthieu -- www.delfiweb.com.
 * Portions created by the Initial Developer are Copyright (C) 2006-2007
 * the Initial Developer. All Rights Reserved.
 * 
 * Contributor(s) :
 * 
 */
 
 
// Classes Delfiweb
import com.delfiweb.events.IEventManager;



/**
 * Todo :
 * 		- diffusion d'évènements par nom d'évènements aux écouteurs concernés.
 * 
 */


/**
 * It's used to dispatch some events to all listeners.
 * 
 * 
 * 
 * @author Matthieu DELOISON
 * @version 1.0
 * @since   05/12/2006
 */
class com.delfiweb.events.EventManager implements IEventManager
{
	private var _aListeners:Array; // array of all listeners
	

	
	
/*****************************************************************************
* PUBLIC FUNCTIONS
******************************************************************************/

	
	/**
	 * CONSTRUCTOR
	 * 
	 * @usage   
	 * @return  
	 */
	public function EventManager()
	{
		this._aListeners = new Array();
	}
	
	
	
	
	/**
	* Add passed-in {@code oInst} listener for receiving all events.
	* 
	* @param	oInst : Listener object
	* @return Listener object is registred ?
	*/
	public function addListener (oInst:Object):Boolean
	{
		for(var i in _aListeners)
		{
			if(oInst == _aListeners[i])
			{
				return false;
			}
		}
		
		_aListeners.push(oInst);
		return true;
	}
	
	
	
	/**
	 * Remove passed-in {@code oInst} listener of list object.
	 * 
	 * @param   oInst : Listener object
	 * @return  Listener object is remove ?
	 */
	public function removeListener (oInst:Object):Boolean
	{
		
		for(var i in _aListeners)
		{
			if(oInst == _aListeners[i])
			{
				_aListeners.splice(Number(i),1);
				return true;
			}
		}
		return false;
	}
	
	
	/**
	 * Remove all registred listeners
	 * 
	 * @return  
	 */
	public function removeAllListeners():Boolean
	{
		this._aListeners = new Array();
		return true;
	}
	
	
	
	/**
	 * Broadcasts event to suscribed listeners.
	 * 
	 * @usage   broadcastEvent ("onEvent", eventObj);
	 * @param   sEvent	: name of event.
	 * @param   oObj	: object diffuse by event.
	 * @return  Void
	 */
	public function broadcastEvent (sEvent:String, oObj:Object):Void
	{
		for(var i in _aListeners)
		{
			if(_aListeners[i][sEvent])
			{
				_aListeners[i][sEvent](oObj);
			}
		}
		return;
	}
	
	
	
	/**
	 * Destroy all ressources used by class. 
	 * 
	 * @return Boolean
	 */
	public function destruct()
	{
		this.removeAllListeners();
		delete this;
	}
	
	
	
	
	/*----------------------------------------------------------*/
	/*-------------- Other -------------------------------------*/
	/*----------------------------------------------------------*/
	
	
	/**
	 * Return string representation under object.
	 * 
	 * @return String 
	 */
	public function toString():String
	{
		return "[object EventManager]";
	}
}
	