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
 
 
 
// Classe Bourre
import com.bourre.commands.Delegate;

//Classe delfiweb
import com.delfiweb.ui.Button;



/**
 * Class LockedButton is used with a group of buttons (class).
 * Only pressed button is different than other.
 * 
 * 
 * 
 * @usage 

	var oMenuBtn = new Button(coordX, coordY, padding, txt, urlIcon, posIconeLeft, txtTooltip, oSquare, largeurW, hauteurH);
	oButton.attach(_root, 10);

	var oLockedButton:LockedButton = new LockedButton(); // déclare une liste de bouton
	oLockedButton.addButton(oMenuBtn);		
	oLockedButton.selectButton(0);

 */
class com.delfiweb.ui.utils.LockedButton
{
	
	/* options de LockedButton */
	private var _aButton:Array;// array who contain a group of buttons
	private var _oCurrentButton:Button;// instance of current pressed button
	
	
	
	/**
	 * CONSTRUCTOR
	 * 
	 */
	public function LockedButton()
	{
		_aButton = new Array();
	}
	
	

	
/* ***************************************************************************
* PUBLIC FUNCTIONS
******************************************************************************/

	
	
	/**
	 * Add a button to the group.
	 * LockedButton listen the added button.
	 * 
	 * @param  bt : an object Button
	 */
	
	public function addButton(bt:Button)
	{
		bt.addListener(this); // listen events diffused by object Button
		bt.addDefaultEffect(); // add default effect
		_aButton.push(bt);
	}
	

	
	
	/**
	 * Select the wished button.
	 * 
	 * @param  id : position of the button in the list
	 * @return  an object Button.
	 */
	public function selectButton(id:Number):Button
	{
		if(_aButton[id]!=undefined)
		{
			this._onReleaseBtn(_aButton[id]);
			return _aButton[id];
		}
		
		return null;
	}
	
	
	
	/**
	 * Return the current selected button.
	 * 
	 * @param  
	 * @return  an object Button.
	 */
	public function getCurrentButton():Button
	{
		return _oCurrentButton;	
	}
	
	
	
	
	/**
	 * Return list of all locked button.
	 * 
	 * @param  
	 * @return  an array with all Button.
	 */
	public function getAllButton():Array
	{
		return _aButton;
	}
	
	
	
	
	/**
	 * Destroy all ressources used by instance of class.
	 * 
	 * @return Boolean
	 */
	public function destruct()
	{
		
		for(var i in _aButton)
		{
			_aButton[i].removeListener(this);
			delete _aButton[i];
		}
		delete _oCurrentButton;
		
		delete this;// supprime l'objet lui-même
		super.destruct(); // suprime le DisplayObject associé
	}
	
	
	
/* ***************************************************************************
 * PRIVATE FUNCTIONS
 ******************************************************************************/
	
	
	/**
	 * Event dispatche by class Button. 
	 *  
	 */
	
	
	
	/**
	 * Call when a button is release
	 * Create an effect on the button.
	 * 
	 * 
	 * @param   bt : the current button pressed
	 * @return  
	 */
	private function _onReleaseBtn(bt:Button)
	{
		bt.enabled=false;// disabled the Button
		bt.onReleaseEffect(true);
		
		// delete effect on the old button
		if(_oCurrentButton!=bt)
		{
			_oCurrentButton.enabled=true; // enable the old Button
			_oCurrentButton.addDefaultEffect(); // add his default effect
		}
		
		_oCurrentButton = bt; // update the current button
	}
	
	
	
	
	/**
	 * Call when mouse isn't on the button
	 * 
	 * @param   bt : object button
	 * @return  
	 */
	private function _onRollOutBtn(bt:Button)
	{
		bt.addDefaultEffect();// ajout d'un effet par défaut
	}
	
	
	
	
	/*----------------------------------------------------------*/
	/*-------------- Other -------------------------------------*/
	/*----------------------------------------------------------*/
	

	/**
	 * Return string representation under object.
	 * 
 	 * @usage  trace(dO);
	 * @return String 
	 */
	public function toString ():String
	{
		return "[object LockeButton]";
	}
	
	
	
} // end of class

