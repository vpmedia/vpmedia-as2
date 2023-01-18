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
import com.delfiweb.command.GetURLCommand;



//	Classes Debug
import com.bourre.log.Logger;
import com.bourre.log.LogLevel;



/**
 * Todo : 
 * 		- créer une classse permettant de personnaliser le menu contextuel de flash
 * 		- gestion automatique de liens du menus contextuel.
 * 		- ne pas en faire une classe statique.
 * 
 *		- à priori cette classe ne fonctionne pas correctement avec le flash player 9.
 * effectuer la correction.
 * 
 */

/**
* Modify contextuel menu of flash
* 
* 	@usage :
	Copyright.create(_root);
* 
* 
* @class Copyright
* @author DELOISON Matthieu
* @version 0.1
* @date 01/12/2006
*/
class com.delfiweb.utils.Copyright
{

	
	/**
	 * CONSTRUCTOR
	 * @usage   
	 * @return  
	 */
	private function Copyright()
	{
	}
	
	
	
	
	/**
	 * Personnalise le menu contextuel
	 * 
	 * @see     
	 * @param   mc : movieclip used to build the new menu
	 * @return  
	 */
	public static function create(mc:MovieClip)
	{	
		if( mc==undefined )
		{
			Logger.LOG("You must do specify a movieclip to use Copyright.");
		}
		else
		{
			Stage.showMenu = true;// montre le menu contextuel
			
			var oCMenu = new ContextMenu();
			
			var oCMenuItem1 = new ContextMenuItem("Made By DelfiWeb");
			oCMenuItem1.onSelect = Copyright.callWebsite; // l'action à effectuer
		   
			oCMenu.customItems.push(oCMenuItem1); // ajout de l'item dans le menu
			oCMenu.hideBuiltInItems(); // cache les items crée par défaut par le Player Flash
			
			mc.menu = oCMenu;// applique le nouveau menu	
		}	
	}
	

	/**
	 * Call an url
	 * 
	 * @see     
	 * @return  
	 */
	public static function callWebsite() 
	{
		var oAppelURL = new GetURLCommand ("http://www.delfiweb.com","_blank", "GET", {});		
		oAppelURL.execute();
	}



	/*----------------------------------------------------------*/
	/*------------- Divers -------------------------------------*/
	/*----------------------------------------------------------*/



	/**
	 * Return string representation under object.
	 * 
 	 * @usage  trace(dO);
	 * @return String 
	 */
	public function toString ():String
	{
		return "[object Copyright]";
	}
}