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
import com.delfiweb.ui.IContainer;
import com.delfiweb.ui.AbstractContainer;


//	Classes Debug
import com.bourre.log.Logger;
import com.bourre.log.LogLevel;



/**
 * Todo : 
 * 		- modifier son implémentation.
 * 		- elle ne sert seulement qu'à la différencier de la classe AbstractContainer.
 * 		- trouver une autre solution pour regrouper toutes les classes de type Form.
 * 		- rajouter le manage function pour la gestion des swf externes.
 * 
 * 		- ajouter une gestion plus poussée des noms d'instance de classe.
 * 
 */
 
 

/**
 * AbstractForm is used to build some specifique form (Square, Circle, Background)
 * 
 * 
 * @usage by extends class
 * 
	var oDisplay:AbstractForm = new AbstractForm("test");
	oDisplay.setDisplayObject(oDisplayObject);
	oDisplay.attach(_root, 10);
 * 
 * 
 * @author Matthieu DELOISON
 * @version 1.0
 * @since   05/11/2006
 */
class com.delfiweb.form.AbstractForm extends AbstractContainer implements IContainer
{	
	
	/**
	 * CONSTRUCTOR
	 * 
	 */
	private function AbstractForm(sName:String, x:Number, y:Number)
	{	
		super(sName, x, y);
	}
	
	
	
	
/* ***************************************************************************
 * PUBLIC FUNCTIONS
 ******************************************************************************/


	
	/**
	 * Return a copy of current object.
	 * 
	 * @usage   var oAbsForm:AbstractForm = this._oFormButton.clone();
	 * @return  Return a copy of current object.
	 */
	public function clone ():AbstractForm
	{
		return new AbstractForm (this._sName, this._nX, this._nY);
	}
	
	
	
/* ***************************************************************************
 * PRIVATE FUNCTIONS
 ******************************************************************************/


	
	/*----------------------------------------------------------*/
	/*------------------- EventManager -------------------------*/
	/*----------------------------------------------------------*/


	
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
		return "[object AbstractForm : "+_sName+"]";
	}
	
}// end of class