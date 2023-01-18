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
 
 // Classes delfiweb
import com.delfiweb.command.ICommand;


/**
 * todo : 
 * 			- revoir cette classe, elle n'est pas très fonctionnelle.
 * 
 */


/**
 * GetURLCommand is used to call some HTML page with all variables you wish (POST or GET).
 * 
 *	@usage

	var oVar:Object = new Object();
	oVar.come = "site";
	
	var oAppelURL = new GetURLCommand ("http://www.delfiweb.com","_blank", "GET", oVar);		
	oAppelURL.execute();


 * 
 * @author  Matthieu
 * @version 1.0
 * @see     ICommand	
 * @usage   
 * @since  01/12/2006
 */
class com.delfiweb.command.GetURLCommand implements ICommand 
{
	/* configuration */
	private var _sUrlCall:String; // adress of page to call
	private var _sWindow:String; // type of windows to call page (_self, _blank, _parent, _top)
	private var _sMethodSendVar:String; // method of send variables (GET ou POST)
	private var _oVar:Object;// Object contain all variables to send
	
	

	/**
	 * CONSTRUCTOR
	 * 
	 * @param   url  	: adress of page to call
	 * @param   win    	: type of windows (_self, _blank, _parent, _top)
	 * @param   method 	: method to send variable (GET or POST)
	 * @param   obj    	: contain all variable to be send
	 * @return  
	 */
	public function GetURLCommand (url:String, win:String, method:String, obj:Object)
	{
		this._sUrlCall = url;
		this._sWindow = win;
		this._sMethodSendVar = method;
		this._oVar = obj;
	}
	
	


	/**
	 * Execute the command, call the webpage.
	 * 
	 * @return  
	 */
	public function execute ():Void
	{
		var clip:MovieClip = _root.createEmptyMovieClip("createURL", -10000);
		
		// add the variables in the movieclip
		for(var i:String in _oVar)
		{
			clip[i] = _oVar[i];
		}
			
		clip.getURL(_sUrlCall, _sWindow, _sMethodSendVar);
	}
	
	
	
	/*----------------------------------------------------------*/
	/*-------------- Other -------------------------------------*/
	/*----------------------------------------------------------*/



	/**
	 * Return string representation under object.
	 * @return  la représentation de l'objet sous forme de chaîne.
	 */	
	public function toString ():String
	{
		return "[object GetURLCommand : "+_sUrlCall+", "+_sMethodSendVar+", "+_sWindow+"]";
	}
	
}