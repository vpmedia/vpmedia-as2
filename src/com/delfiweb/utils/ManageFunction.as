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



/**
 * It's used to execute some function in a define order.
 * It's used when a class load some picture or swf. This class automaticaly
 * wait end of loading before to execute next functions.
 * 
 * 
 * La classe ManageFunction permet d'assurer un enchainement de fonctions dans un ordre chronologique.
 * Utilisée notamment lors du chargement d'une image et que l'on doit attendre la fin de son chargement 
 * avant de pouvoir enchainer les actions suivantes.
 * 
 * 
@usage


class Label
{
	private var _oManager:ManageFunction;// gestion d'une pile de fonctions à éxécuter
	
	
	public function Label()
	{
		this._oManager = new ManageFunction(this); // gestion des actions à effectuer
	}
	
	
	private function addContent()
	{
		// si on peut effectuer les actions suivantes
		if( _oManager.isReady( addContent.toString()+arguments.toString() ) )
		{
			// exécution des actions
			_oManager.setReady(); // la fonction est terminée
		}
		else // sinon ajout de la fonction à la pile
		{
			_oManager.addFunction(addContent, arguments); // on l'ajoute à la liste des actions à faire
		}
	}

_oManager.setReady(); La libération du ManageFunction peut s'éffectuer 
dans une autre fonction (cas du chargement d'une image).

 *
 * @author  Matthieu DELOISON
 * @version 0.1  
 * @since   01/12/2006
 */
class com.delfiweb.utils.ManageFunction
{
	
	private var _oObjectInstance	: Object; // instance of object who have some functions.

	private var _aFunctions			: Array; // list of functions to be execute.
	
	private var _bIsReady			: Boolean; // true if all functions are executed.

	private var _bStart				: Boolean; // start the list of functions.
	
	private var _sTicket			: String; // ticket of function
	
	
	
	

	/**
	 * CONSTRUCTOR
	 * 
	 * @param   oRef : instance of object who used class ManageFunction
	 * @return  
	 */
	public function ManageFunction(oRef:Object)
	{
		this._oObjectInstance = oRef;
		
		/* init of variables */
		this._aFunctions = new Array();
		this._bIsReady = false;
		this._bStart = false;
		this._sTicket = "defaultTicket";
	}
	



/* ***************************************************************************
 * PUBLIC FUNCTIONS
 ******************************************************************************/



	/**
	 * add a function into pile and execute it if possible.
	 * 
	 * @param   fCall	: function to be added
	 * @param   aArg	: arguments of the function
	 * @return  
	 */
	public function addFunction(fCall:Function, aArg:Array)
	{
		// create an object who contain informations of the function
		var oFunctContent:Object = new Object();
		oFunctContent.sFunction = fCall;
		oFunctContent.aArguments = aArg;
		oFunctContent.key = fCall.toString() + aArg.toString(); // create the ticket
		
		_aFunctions.push(oFunctContent); // save the function
	
		// if list is ready to start
		if( !_bStart)
		{
			_bStart = true;
			this.nextFunction();
		}
	}

	
	
	/**
	 * Call this function to know if the function can be executed.
	 * 
	 * We used the ticket of function for verify his execution.
	 * 
	 * @param  tic : ticket of function who would to be executed
	 * @return : true the function can be executed, else false
	 */
	public function isReady(tic:String):Boolean
	{
		if( tic == this._sTicket ) return true;
		else return false;
	}
	
	
	


	/**
	 * All functions are executed.
	 * The class can create a new pile of function
	 * 
	 * @return  
	 */
	public function setReady():Void
	{
		this._bIsReady = true;
		
		// si il reste des fonctions à éxécuter
		if( _aFunctions.length>0 )  this.nextFunction();
		else _bStart = false; // la pile est vide, toutes les actions ont été éxécutées
	}
	
	

/* ***************************************************************************
 * PRIVATE FUNCTIONS
 ******************************************************************************/

	
	/**
	 * start the next function in the pile
	 * 
	 * @return  
	 */
	private function nextFunction():Void
	{
		this._bIsReady = false;
		var oFunctContent:Object = _aFunctions.shift();// delete the first element of an array and return his.
		
		this._sTicket = oFunctContent.key;// update used ticket
		
		// call the function
		oFunctContent.sFunction.apply(_oObjectInstance, oFunctContent.aArguments);
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
		return "[object ManageFunction]";
	}

}