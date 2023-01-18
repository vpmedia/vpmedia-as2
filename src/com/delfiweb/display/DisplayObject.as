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
import com.delfiweb.display.IDisplayObject;
import com.delfiweb.events.EventManager;


// classe Bourre
import com.bourre.commands.Delegate;


//	Classes Debug
import com.bourre.log.Logger;
import com.bourre.log.LogLevel;



/**
 * DisplayObject is used to build a graphic object under scene (an empty movieclip).
 * Other class can extends this class.
 * 
 * 
 * @usage 
 * 
	var oDisplay:DisplayObject = new DisplayObject();
	oDisplay.attach(_root, 0);
 * 
 * 
 * @author Matthieu DELOISON
 * @version 1.0
 * @since   05/11/2006
 */
class com.delfiweb.display.DisplayObject implements IDisplayObject
{
	/* utile pour les classes filles */
	private var _mcBase:MovieClip; // instance of graphic object.
	private var _oEventManager:EventManager; // instance of EventManager.
	
	
	/* ****************************************************************************
	* CONSTRUCTOR
	**************************************************************************** */
	
	private function DisplayObject ()
	{		
		// create an event manager
		this._oEventManager = new EventManager();
		
	}
	
	
	

/* ***************************************************************************
 * PUBLIC FUNCTIONS
 ******************************************************************************/

	/**
	 * It's used to attach mc at a movieclip put in parameter.
	 * Depth is optionnal, if is the depth is undefined, mc is build at the top depth of parent clip.
	 * 
	 * 
	 * @param   mc 			: movieclip used to build graphic object
	 * @param   d 			: depth of the MovieClip  
	 * @return  MovieClip	: a reference to created movieclip.
	 */
	public function attach (mc:MovieClip, d:Number):MovieClip
	{
		if (!mc)
		{
			Logger.LOG("You must do specify a movieclip for method attach of class DisplayObject.");
		}
		else
		{
			// si pas de profondeur on prend la plus haute de la cible
			if(d == undefined) d=mc.getNextHighestDepth();
			
			if(this._mcBase) this.remove(); // si le clip existe déja on le supprime
			
			this._mcBase = mc.createEmptyMovieClip ("__DisplayObject__"+d, d);
		
			var oInfo:Object = new Object();
			oInfo.drawing = true;
			oInfo.mcBase = this._mcBase;
			_onDisplayComplete(oInfo);
			
			return this._mcBase;
		}
		
	}	
	
	
	
	
	public function addListener(oInst:Object):Boolean
	{
		return _oEventManager.addListener(oInst);
	}
	
	public function removeListener(oInst:Object):Boolean
	{
		return _oEventManager.removeListener( oInst );
	}
	
	

	/**
	 * Remove only movieclip.
	 * 
	 * @return  Boolean	true -> movieclip is removed
	 */
	public function remove():Boolean
	{
		// si le clip existe on le supprime.
		if(this._mcBase)
		{
			this._mcBase.removeMovieClip();
			this._mcBase = undefined;
			return true;
		}
		else
		{
			return false;
		}
	}	
	


	/**
	 * Destroy all ressources used by instance of class.
	 * 
	 * @return Boolean
	 */
	public function destruct():Boolean
	{
		this.remove();
		this._oEventManager.destruct();
		delete this;
		return true;
	}
	
	
	
/* ***************************************************************************
 * PRIVATE FUNCTIONS
 ******************************************************************************/

	
	/*----------------------------------------------------------*/
	/*------------------- EventManager -------------------------*/
	/*----------------------------------------------------------*/



	/**
	 * Event diffused when DisplayObject is ready
	 * 
	 * @usage   
	 * @return  
	 */
	private function _onDisplayComplete(oInfo:Object)
	{
		this._oEventManager.broadcastEvent("_onDisplayObjectBuild", oInfo);
	}
	
		
	/*----------------------------------------------------------*/
	/*-------------- Other -------------------------------------*/
	/*----------------------------------------------------------*/
	
	
	/**
	 * Returns the string representation of this instance.
	 * 
	 * @return the string representation of this instance
	 */
	public function toString():String
	{
		return "[object DisplayObject]";
	}
	
}// end of class